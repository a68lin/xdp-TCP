/* SPDX-License-Identifier: GPL-2.0 */
static const char *__doc__ = "XDP loader and stats program\n"
	" - Allows selecting BPF --progname name to XDP-attach to --dev\n";

#define _GNU_SOURCE /* needed to the the CPU id */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <getopt.h>
#include <signal.h>

#include <locale.h>
#include <unistd.h>
#include <time.h>
#include <sched.h> /* needed to the the CPU id */
#include <pthread.h>

#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <xdp/libxdp.h>

#include <net/if.h>
#include <linux/if_link.h> /* depend on kernel-headers installed */
#include <linux/bpf.h>

#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/tcp.h>

#include <arpa/inet.h>  // For htons() and inet_addr()

#include "../common/common_params.h"
#include "../common/common_user_bpf_xdp.h"

#define MAX_NUMBER_CORES 8
#define MAX_QUEUE_LEN 15
#define NUMBER_UPDATES 50

static const char *default_filename = "prod_cons_kern.o";

static const char *default_progname = "testing_prod_cons";

bool stop = false;

struct config cfg = {
		.ifindex   = -1,
		.do_unload = false,
};

struct map_elem {
    __u64 occupied;
    __u64 value;
};

struct hash_key {
    int cpu;
};

struct Argument {
	int map_fd;
	int cpu_id;
};

static const struct option_wrapper long_options[] = {
	{{"help",        no_argument,		NULL, 'h' },
	 "Show help", false},

	{{"dev",         required_argument,	NULL, 'd' },
	 "Operate on device <ifname>", "<ifname>", true},

	{{"skb-mode",    no_argument,		NULL, 'S' },
	 "Install XDP program in SKB (AKA generic) mode"},

	{{"native-mode", no_argument,		NULL, 'N' },
	 "Install XDP program in native mode"},

	{{"auto-mode",   no_argument,		NULL, 'A' },
	 "Auto-detect SKB or native mode"},

	{{"unload",      required_argument,	NULL, 'U' },
	 "Unload XDP program <id> instead of loading", "<id>"},

	{{"unload-all",  no_argument,           NULL,  4  },
	 "Unload all XDP programs on device"},

	{{"quiet",       no_argument,		NULL, 'q' },
	 "Quiet mode (no output)"},

	{{"filename",    required_argument,	NULL,  1  },
	 "Load program from <file>", "<file>"},

	{{"progname",    required_argument,	NULL,  2  },
	 "Load program from function <name> in the ELF file", "<name>"},

	{{0, 0, NULL,  0 }}
};

int find_map_fd(struct bpf_object *bpf_obj, const char *mapname)
{
	struct bpf_map *map;
	int map_fd = -1;

	/* Lesson#3: bpf_object to bpf_map */
	map = bpf_object__find_map_by_name(bpf_obj, mapname);
        if (!map) {
		fprintf(stderr, "ERR: cannot find map by name: %s\n", mapname);
		goto out;
	}

	map_fd = bpf_map__fd(map);
 out:
	return map_fd;
}

static void exit_application(int signal)
{
	stop = true;
	int err;

	cfg.unload_all = true;
	err = do_unload(&cfg);
	if (err) {
		fprintf(stderr, "Couldn't detach XDP program on iface '%s' : (%d)\n",
			cfg.ifname, err);
	}
}

void *thread_exec(void *arg) {
	struct Argument *info = (struct Argument *) arg;

	int cpu_id = info->cpu_id;
	// Note: the flow_id (in this case cpu_id) is being passed as an
	// argument of the function started with this thread. In the future,
	// we'll probably need other threads that will keep sending new requests
	// to this thread, which will include the flow_id
	int map_fd = info->map_fd;

	int inner_id;
	int inner_fd;
	int ret;

	struct hash_key key = {cpu_id};
	struct map_elem old_entry;
	struct map_elem new_entry = {1, 0};

	int i = 0;
	// Note: here I'm using a single integer to represent the next index
	// to be changed in the queue. But we'll need data structures as threads are
	// responsible for more than one flow
	int index = 0;
	while(i < NUMBER_UPDATES) {
		new_entry.value = cpu_id * i;

		//printf("CPU %d index %d\n", cpu_id, index);
		ret = bpf_map_lookup_elem(map_fd, &key, &inner_id);
		if(ret < 0) {
			printf("Couldn't find entry of outer map\n");
			break;
		}
		inner_fd = bpf_map_get_fd_by_id(inner_id);

		ret = bpf_map_lookup_elem(inner_fd, &index, &old_entry);
		if(ret < 0) {
			printf("Couldn't find entry of inner map\n");
			break;
		}

		printf("Old entry CPU %d: %lld %lld\n", cpu_id, old_entry.occupied, old_entry.value);

		if(!old_entry.occupied) {
			ret = bpf_map_update_elem(inner_fd, &index, &new_entry, BPF_ANY);
			if(ret < 0) {
				printf("Couldn't update entry of inner map\n");
				break;
			}
			if(index < MAX_QUEUE_LEN - 1)
				index++;
			else
				index = 0;
		} else {
			printf("Entry of CPU %d and index %d is already occupied\n", cpu_id, index);
		}

		i++;
		sleep(rand() % 3 + 1);
	}

	free(info);
	pthread_exit(NULL);
}

int main(int argc, char **argv)
{
	struct xdp_program *program;
	char errmsg[1024];
	int err;

	/* Global shutdown handler */
	signal(SIGINT, exit_application);
	
	/* Set default BPF-ELF object file and BPF program name */
	strncpy(cfg.filename, default_filename, sizeof(cfg.filename));
	strncpy(cfg.progname,  default_progname,  sizeof(cfg.progname));
	/* Cmdline options can change progname */
	parse_cmdline_args(argc, argv, long_options, &cfg, __doc__);

	/* Required option */
	if (cfg.ifindex == -1) {
		fprintf(stderr, "ERR: required option --dev missing\n");
		usage(argv[0], __doc__, long_options, (argc == 1));
		return EXIT_FAIL_OPTION;
	}

        /* Unload a program by prog_id, or
         * unload all programs on net device
         */
	if (cfg.do_unload || cfg.unload_all) {
		err = do_unload(&cfg);
		if (err) {
			libxdp_strerror(err, errmsg, sizeof(errmsg));
			fprintf(stderr, "Couldn't unload XDP program %d: %s\n",
				cfg.prog_id, errmsg);
			return err;
		}

		printf("Success: Unloading XDP prog name: %s\n", cfg.progname);
		return EXIT_OK;
	}

	program = load_bpf_and_xdp_attach(&cfg);
	if (!program)
		return EXIT_FAIL_BPF;

	if (verbose) {
		printf("Success: Loaded BPF-object(%s) and used section(%s)\n",
		       cfg.filename, cfg.progname);
		printf(" - XDP prog id:%d attached on device:%s(ifindex:%d)\n",
		       xdp_program__id(program), cfg.ifname, cfg.ifindex);
	}

	int prog_fd = xdp_program__fd(program);

	if (prog_fd < 0)
		printf("Error: xdp_program__fd failed\n\n");
	else
		printf("File descriptor: %d\n\n", xdp_program__fd(program));

	int map_fd = find_map_fd(xdp_program__bpf_obj(program), "outer_hash");
	if (map_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	srand(time(NULL));

	pthread_t threads[MAX_NUMBER_CORES];
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		struct Argument *arg = malloc(sizeof(struct Argument));
		arg->map_fd = map_fd;
		arg->cpu_id = i;
		CPU_SET(i, &cpuset);
		pthread_create(&threads[i], NULL, thread_exec, (void *) arg);
		pthread_setaffinity_np(threads[i], sizeof(cpu_set_t), &cpuset);
		CPU_ZERO(&cpuset);
	}

	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		pthread_join(threads[i], NULL);
	}

	cfg.unload_all = true;
	err = do_unload(&cfg);
	if (err) {
		fprintf(stderr, "Couldn't detach XDP program on iface '%s' : (%d)\n",
			cfg.ifname, err);
	}

    return 0;
}
