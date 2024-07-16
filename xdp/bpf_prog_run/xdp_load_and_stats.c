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

#include <linux/unistd.h> /* to include __NR_bpf (found in /usr/include/asm-generic) */

#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/tcp.h>

#include <arpa/inet.h>  // For htons() and inet_addr()

#include "../common/common_params.h"
#include "../common/common_user_bpf_xdp.h"

#define MAX_NUMBER_CORES 8
#define MAX_NUMBER_PKTS 100000000

static const char *default_filename = "xdp_prog_kern.o";

static const char *default_progname = "simply_drop";

int counter_percore[8];
struct bpf_object *obj;


bool stop = false;

struct config cfg = {
		.ifindex   = -1,
		.do_unload = false,
};

struct Argument {
	int prog_fd;
	unsigned char * data;  // Ensure the buffer is large enough
    size_t data_len;
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

void create_eth_header(struct ethhdr *eth_hdr) {
    memset(eth_hdr, 0, sizeof(struct ethhdr));
    eth_hdr->h_proto = htons(ETH_P_IP);  // IP Ethertype
    // Set source and destination MAC addresses if needed
}

void create_ip_header(struct iphdr *ip_hdr) {
    memset(ip_hdr, 0, sizeof(struct iphdr));
    ip_hdr->version = 4;
    ip_hdr->ihl = 5;
    ip_hdr->tot_len = htons(sizeof(struct iphdr) + sizeof(struct tcphdr));  // Adjust if more data is added
    ip_hdr->protocol = IPPROTO_TCP;
    ip_hdr->saddr = inet_addr("10.7.0.7");
    ip_hdr->daddr = inet_addr("10.7.0.6");
}

void create_tcp_header(struct tcphdr *tcp_hdr) {
	memset(tcp_hdr, 0, sizeof(struct tcphdr));
	tcp_hdr->source = htonl(1);
	tcp_hdr->dest = htonl(123);
	//tcp_hdr->seq = htonl(0);
	//tcp_hdr->ack_seq = htonl(0);
}

void create_packet(unsigned char *data/*, size_t *data_len*/) {
    struct ethhdr eth_hdr;
    struct iphdr ip_hdr;
    struct tcphdr tcp_hdr;
    
    create_eth_header(&eth_hdr);
    create_ip_header(&ip_hdr);
    create_tcp_header(&tcp_hdr);

    size_t offset = 0;
    memcpy(data + offset, &eth_hdr, sizeof(eth_hdr));
    offset += sizeof(eth_hdr);
    memcpy(data + offset, &ip_hdr, sizeof(ip_hdr));
    offset += sizeof(ip_hdr);
    memcpy(data + offset, &tcp_hdr, sizeof(tcp_hdr));
    offset += sizeof(tcp_hdr);

    //*data_len = offset;
}

void print_counter_map(int map_fd) {
	__u64 sum = 0;
	__u64 value;
	for(int key = 0; key < MAX_NUMBER_CORES; key++) {
		bpf_map_lookup_elem(map_fd, &key, &value);
		printf("Counter of CPU %d: %llu\n", key, value);
		sum += value;
	}
	printf("Total: %llu\n\n", sum);
}

void *thread_exec(void *arg) {
	//int teste = sched_getcpu();
	//printf("\nCPU core running loader program: %d\n\n", teste);

	struct Argument *info = (struct Argument *) arg;

	/*struct bpf_test_run_opts opts = {
		.sz = sizeof(struct bpf_test_run_opts),
		.data_in = info->data,
		.data_out = info->data,
		.data_size_in = info->data_len,
		.data_size_out = info->data_len,
		.repeat = 1,
		.retval = 0,
	};*/
	/*LIBBPF_OPTS(bpf_test_run_opts, opts);
	opts.data_in = info->data;
	opts.data_out = info->data;
	opts.data_size_in = info->data_len;
	opts.data_size_out = info->data_len;

	while(!stop) {
		int err = bpf_prog_test_run_opts(info->prog_fd, &opts);
		if (err != 0) {
			printf("[error]: bpf test run failed: %d\n", err);
		}
	}*/

	union bpf_attr run_attr = {
        .test = {
            .prog_fd = info->prog_fd,
            .retval = 0,  // Initialized to 0; will be set after execution
            .data_size_in = info->data_len,
            .data_size_out = info->data_len,  // Same as input if you're not expecting modification
            .data_in = (unsigned long)info->data,
            .data_out = (unsigned long)info->data,  // Can be the same as data_in
            .repeat = 1,  // Run once unless you're benchmarking
            .duration = 0,  // Will be set after execution
        },
    };

	int cpu_id = info->cpu_id;

	while(!stop) {
		int ret = syscall(__NR_bpf, BPF_PROG_TEST_RUN, &run_attr, sizeof(run_attr));
		if (ret < 0) {
			fprintf(stderr, "BPF_PROG_TEST_RUN failed: %s\n", strerror(errno));
			break;
		}
		counter_percore[cpu_id] += 1;
	}
	
	free(info);
	pthread_exit(NULL);
}

void print_queues(int outer_map_fd) {
	__u32 value;
	int inner_fd;
	int inner_id;

	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		int last_value = -1;

		bpf_map_lookup_elem(outer_map_fd, &i, &inner_id);
		inner_fd = bpf_map_get_fd_by_id(inner_id);
		value = -1;
		printf("\n\nQueue of CPU %d: ", i);

		for(int i = 0; i < 1248; i++) {
			bpf_map_lookup_and_delete_elem(inner_fd, NULL, &value);
			if(i > 0 && (last_value + 2 != value)) {
				if(last_value != 8 && last_value != 9)
					printf("**(** ");
				else if((last_value == 8 || last_value == 9) && (value != 0 && value != 1))
					printf("**)** ");
			}
			printf("%d ", value);
			last_value = value;
		}
	}
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

struct bpf_program *load_attach_without_xdp_dispatcher(struct config *cfg)
{
	obj = bpf_object__open_file(cfg->filename, NULL);
	if (libbpf_get_error(obj)) {
        fprintf(stderr, "ERROR: opening BPF object file failed\n");
        return NULL;
    }

	int err = bpf_object__load(obj);
	if(err) {
		fprintf(stderr, "ERROR: loading BPF object file failed\n");
        bpf_object__close(obj);
        return NULL;
	}

	// Note: if there are more than one XDP program in the kernel code,
	// we should change to bpf_object__find_program_by_name, probably
	struct bpf_program *prog = bpf_object__next_program(obj, NULL);
	int prog_fd = bpf_program__fd(prog);
    if (prog_fd < 0) {
        fprintf(stderr, "ERROR: getting BPF program file descriptor failed\n");
        bpf_object__close(obj);
        return NULL;
    }

	int ifindex = cfg->ifindex;
    if (ifindex == 0) {
        perror("if_nametoindex");
        bpf_object__close(obj);
        return NULL;
    }

	err = bpf_xdp_attach(ifindex, prog_fd, 0, NULL);
    if (err < 0) {
        fprintf(stderr, "ERROR: attaching XDP program to interface failed: %s\n", strerror(-err));
        bpf_object__close(obj);
        return NULL;
    }

	return prog;
}

int main(int argc, char **argv)
{
	struct bpf_program *program;
	char errmsg[1024];
	int err;

	/* Global shutdown handler */
	signal(SIGINT, exit_application);

	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		counter_percore[i] = 0;
	}

	
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

	//program = load_bpf_and_xdp_attach(&cfg);
	program = load_attach_without_xdp_dispatcher(&cfg);
	if (!program)
		return EXIT_FAIL_BPF;

	if (verbose) {
		printf("Success: Loaded BPF-object(%s) and used section(%s)\n",
		       cfg.filename, cfg.progname);
		printf(" - XDP prog attached on device:%s(ifindex:%d)\n", cfg.ifname, cfg.ifindex);
	}

	int prog_fd = bpf_program__fd(program);

	if (prog_fd < 0) {
		printf("Error: xdp_program__fd failed\n\n");
		return EXIT_FAIL_BPF;
	}else
		printf("File descriptor: %d\n\n", bpf_program__fd(program));


	unsigned char data[1500];  // Ensure the buffer is large enough
    size_t data_len = 1499;
    
    create_packet(data/*, &data_len*/);

	int map_fd = find_map_fd(obj, "counter_array");
	if (map_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	int outer_map_fd = find_map_fd(obj, "outer_map_queue");
	if (outer_map_fd < 0) {
		return EXIT_FAIL_BPF;
	}


	pthread_t threads[MAX_NUMBER_CORES];
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		struct Argument *arg = malloc(sizeof(struct Argument));
		arg->prog_fd = prog_fd;
		arg->data_len = data_len;
		arg->data = data;
		arg->cpu_id = i;
		CPU_SET(i, &cpuset);
		pthread_create(&threads[i], NULL, thread_exec, (void *) arg);
		pthread_setaffinity_np(threads[i], sizeof(cpu_set_t), &cpuset);
		CPU_ZERO(&cpuset);
	}

	long int sum;
	while(!stop) {
		print_counter_map(map_fd);
		for(int i = 0; i < MAX_NUMBER_CORES; i++)
			sum += counter_percore[i];
		if(sum > MAX_NUMBER_PKTS) {
			stop = true;
			break;
		}
		sum = 0;
		sleep(1);
	}

	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		pthread_join(threads[i], NULL);
	}


	sum = 0;
	for(int i = 0; i < MAX_NUMBER_CORES; i++)
		sum += counter_percore[i];

	print_counter_map(map_fd);

	printf("Total number of packets sent by userspace program: %ld\n\n", sum);

	print_queues(outer_map_fd);

	printf("\n\n");


	bpf_object__close(obj);
    return 0;
}
