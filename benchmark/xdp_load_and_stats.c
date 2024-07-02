/* SPDX-License-Identifier: GPL-2.0 */
static const char *__doc__ = "XDP loader and stats program\n"
	" - Allows selecting BPF --progname name to XDP-attach to --dev\n";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <getopt.h>

#include <locale.h>
#include <unistd.h>
#include <time.h>

#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <xdp/libxdp.h>

#include <net/if.h>
#include <linux/if_link.h> /* depend on kernel-headers installed */
#include <linux/bpf.h>

#include "../common/common_params.h"
#include "../common/common_user_bpf_xdp.h"

#define MAX_NUMBER_CORES 16

struct map_locked_value {
    __u64 value;
    struct bpf_spin_lock lock;
};

struct map_elem {
    __u64 value;
};

struct hash_key {
    int cpu;
};

static const char *default_filename = "xdp_prog_kern.o";

// "map_of_maps_hash"
// "common_hash_map"
// "lock_map"
// "gets_cpu_id"
// "map_of_maps_array"
// "map_of_maps_queue"
// "common_array_lookup_diff_keys"
// "percpu_array_lookup"
// "common_array_lookup_same_keys"
// "simply_drop"
static const char *default_progname = "common_hash_map";


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


#define NANOSEC_PER_SEC 1000000000 /* 10^9 */


static int __check_map_fd_info(int map_fd, struct bpf_map_info *info,
			       struct bpf_map_info *exp)
{
	__u32 info_len = sizeof(*info);
	int err;

	if (map_fd < 0)
		return EXIT_FAIL;

        /* BPF-info via bpf-syscall */
	err = bpf_obj_get_info_by_fd(map_fd, info, &info_len);
	if (err) {
		fprintf(stderr, "ERR: %s() can't get info - %s\n",
			__func__,  strerror(errno));
		return EXIT_FAIL_BPF;
	}

	if (exp->key_size && exp->key_size != info->key_size) {
		fprintf(stderr, "ERR: %s() "
			"Map key size(%d) mismatch expected size(%d)\n",
			__func__, info->key_size, exp->key_size);
		return EXIT_FAIL;
	}
	if (exp->value_size && exp->value_size != info->value_size) {
		fprintf(stderr, "ERR: %s() "
			"Map value size(%d) mismatch expected size(%d)\n",
			__func__, info->value_size, exp->value_size);
		return EXIT_FAIL;
	}
	if (exp->max_entries && exp->max_entries != info->max_entries) {
		fprintf(stderr, "ERR: %s() "
			"Map max_entries(%d) mismatch expected size(%d)\n",
			__func__, info->max_entries, exp->max_entries);
		return EXIT_FAIL;
	}
	if (exp->type && exp->type  != info->type) {
		fprintf(stderr, "ERR: %s() "
			"Map type(%d) mismatch expected type(%d)\n",
			__func__, info->type, exp->type);
		return EXIT_FAIL;
	}

	return 0;
}

void map_rate_printer(int counter_map_fd, int time_map_fd) {
	__u64 diff_latency;
	double curr_latency;
	__u64 last_latency[MAX_NUMBER_CORES] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

	__u64 curr_number_pkts = 0;
	__u64 last_number_pkts[MAX_NUMBER_CORES] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	__u64 diff_packets = 0;

	int div_counter = 0;
	double sum_times;
	double total_latency = 0;

	double curr_throughput = 0;
	double sum_throughput;
	double total_throughput = 0;

	int stop_flag = 0;

	for(;;) {
		for(int key = 0; key < MAX_NUMBER_CORES; key++) {
			bpf_map_lookup_elem(counter_map_fd, &key, &curr_number_pkts);
			if(curr_number_pkts > 0) {
				stop_flag = 1;
				break;
			}
		}
		if(stop_flag)
			break;
	}
	stop_flag = 0;

	sleep(1);

	int first_iter_flag = 1;
	int active_cpu = 0;

	for(;;) {
		__u64 total_pkts = 0;
		sum_throughput = 0;
		sum_times = 0;
		for(int key = 0; key < MAX_NUMBER_CORES; key++) {
			bpf_map_lookup_elem(counter_map_fd, &key, &curr_number_pkts);
			bpf_map_lookup_elem(time_map_fd, &key, &diff_latency);

			if(first_iter_flag && curr_number_pkts > 0)
				active_cpu++;

			diff_packets = curr_number_pkts - last_number_pkts[key];
			if(diff_packets == 0 && curr_number_pkts != 0) {
				stop_flag = 1;
				break;
			}

			if(curr_number_pkts == 0) {
				curr_latency = 0;
				curr_throughput = 0;
			} else {
				if(last_latency[key] == 0) {
					curr_latency = ((double) diff_latency) / curr_number_pkts;
					curr_throughput = ((double) curr_number_pkts) * 1500 * 8 / 1000000000;
				} else {
					curr_latency = (((double) diff_latency) - ((double)last_latency[key])) / diff_packets;
					curr_throughput = ((double) diff_packets) * 1500 * 8 / 1000000000;
				}
				div_counter++;
			}
			last_latency[key] = diff_latency;
			last_number_pkts[key] = curr_number_pkts;

			printf("CPU %d\t# packets: %llu\tRate: %.02lf Gbps\tLatency: %.02f ns\n", key, curr_number_pkts, curr_throughput, curr_latency);
			total_pkts += curr_number_pkts;
			sum_times += curr_latency;
			sum_throughput += curr_throughput;
		}

		if(stop_flag)
			break;

		double average_latency = sum_times / active_cpu;

		printf("\nTotal packets: %llu\tRate: %.02lf Gbps\tLatency: %.02lf ns\n\n", total_pkts, sum_throughput, average_latency);

		total_throughput += sum_throughput;
		total_latency += average_latency;

		first_iter_flag = 0;
		sleep(1);
	}

	__u64 total_sum_pkts = 0;
	for(int key = 0; key < MAX_NUMBER_CORES; key++) {
		bpf_map_lookup_elem(counter_map_fd, &key, &curr_number_pkts);
		total_sum_pkts += curr_number_pkts;
	}

	int iter_with_packets = div_counter / active_cpu;

	printf("\n\n# of packets: %llu\tAverage rate: %.02lf Gbps\tAverage Latency: %.02lf ns\n\n", total_sum_pkts, total_throughput / iter_with_packets, total_latency / iter_with_packets);
}

void check_queues(/*int map_of_maps_fd, */struct xdp_program *program) {
	__u64 value;
	int inner_fd;

	for(int key = 0; key < MAX_NUMBER_CORES; key++) {
		value = 0;
		char inner_map_name[32];
		snprintf(inner_map_name, sizeof(inner_map_name), "inner_map_queue%u", key);
		//bpf_map_lookup_elem(map_of_maps_fd, &key, &inner_fd);
		printf("\nQueue of CPU %d: ", key);
		for(int i = 0; i < 32; i++) {
			inner_fd = find_map_fd(xdp_program__bpf_obj(program), inner_map_name);
			bpf_map_lookup_and_delete_elem(inner_fd, NULL, &value);
			printf("%llu ", value);
		}
	}
}

void check_arrays(struct xdp_program *program, int map_of_maps_fd) {
	__u64 value;
	int inner_id;
	int inner_fd;
	int key = 0;

	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		bpf_map_lookup_elem(map_of_maps_fd, &i, &inner_id);
		inner_fd = bpf_map_get_fd_by_id(inner_id);
		value = 0;
		/*char inner_map_name[32];
		snprintf(inner_map_name, sizeof(inner_map_name), "inner_map_array%u", i);
		inner_fd = find_map_fd(xdp_program__bpf_obj(program), inner_map_name);*/
		bpf_map_lookup_elem(inner_fd, &key, &value);
		printf("Counter of CPU %d: %llu\n", i, value);
	}
}

void check_hash_MoM(int hash_map_of_maps_fd) {
	struct map_elem elem;
	int inner_id;
	int inner_fd;
	struct hash_key key;
	__u64 sum = 0;
	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		key.cpu = i;
		bpf_map_lookup_elem(hash_map_of_maps_fd, &key, &inner_id);
		inner_fd = bpf_map_get_fd_by_id(inner_id);
		if(bpf_map_lookup_elem(inner_fd, &i, &elem) < 0)
			elem.value = 0;
		printf("Counter of CPU %d: %llu\n", key.cpu, elem.value);
		sum += elem.value;
	}
	printf("Total: %llu\n\n", sum);
}

void print_hash_maps(int map_fd) {
	struct map_elem elem;
	__u64 sum = 0;
	struct hash_key key;
	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		key.cpu = i;
		if(bpf_map_lookup_elem(map_fd, &key, &elem) < 0)
			elem.value = 0;
		printf("Counter of CPU %d: %llu\n", key.cpu, elem.value);
		sum += elem.value;
	}
	printf("Total: %llu\n\n", sum);
}

void print_lock_maps(int map_fd) {
	struct map_locked_value locked_value;
	int key = 0;
	bpf_map_lookup_elem(map_fd, &key, &locked_value);
	printf("Total: %llu\n\n", locked_value.value);
}

void print_percpu_maps(int map_fd) {
	__u64 values[/*libbpf_num_possible_cpus()*/MAX_NUMBER_CORES];
	int key = 0;
	__u64 sum = 0;
	bpf_map_lookup_elem(map_fd, &key, values);
	for(int i = 0; i < /*libbpf_num_possible_cpus()*/MAX_NUMBER_CORES; i++) {
		printf("Counter of CPU %d: %llu\n", i, values[i]);
		sum += values[i];
	}
	printf("Total: %llu\n\n", sum);
}

void print_common_maps(int map_fd, int diff) {
	__u64 value;
	if(diff) {
		__u64 sum = 0;
		for(int key = 0; key < MAX_NUMBER_CORES; key++) {
			bpf_map_lookup_elem(map_fd, &key, &value);
			printf("Counter of CPU %d: %llu\n", key, value);
			sum += value;
		}
		printf("Total: %llu\n\n", sum);
	} else {
		int key = 0;
		bpf_map_lookup_elem(map_fd, &key, &value);
		printf("Total: %llu\n\n", value);
	}
}

void userspace_map_access(int mom_array_fd, int mom_queue_fd, int percpu_map_fd, struct xdp_program *program) {
	clock_t start, finish;
	double runtime;

	int key = 0;
	__u32 inner_fd, inner_id;
	__u64 value;

	start = clock();

	if(bpf_map_lookup_elem(mom_array_fd, &key, &inner_id) < 0)
		printf("Problem while reading outer map\n");

	inner_fd = bpf_map_get_fd_by_id(inner_id);

	if(bpf_map_lookup_elem(inner_fd, &key, &value) < 0)
		printf("Problem while reading inner map\n");

	finish = clock();

	runtime = ((double) (finish - start)) / CLOCKS_PER_SEC * 1e9;

	printf("Runtime to read from map of maps: %.02lf\n", runtime);
}

int main(int argc, char **argv)
{
	struct bpf_map_info map_expect = { 0 };
	struct bpf_map_info info = { 0 };
	struct xdp_program *program;
	int hash_map_fd;
	int map_of_maps_hash_fd;
	int lock_map_fd;
	int map_of_maps_array_fd;
	int map_of_maps_queue_fd;
	int common_map_fd;
	int percpu_map_fd;
	int counter_map_fd;
	int time_map_fd;
	char errmsg[1024];
	int err;

	struct config cfg = {
		.ifindex   = -1,
		.do_unload = false,
	};
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

	/* Lesson#3: Locate map file descriptor */
	hash_map_fd = find_map_fd(xdp_program__bpf_obj(program), "common_hash");
	if (hash_map_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	map_of_maps_hash_fd = find_map_fd(xdp_program__bpf_obj(program), "outer_map_hash");
	if (map_of_maps_hash_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	lock_map_fd = find_map_fd(xdp_program__bpf_obj(program), "lock_array");
	if (lock_map_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	map_of_maps_array_fd = find_map_fd(xdp_program__bpf_obj(program), "outer_map_array");
	if (map_of_maps_array_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	map_of_maps_queue_fd = find_map_fd(xdp_program__bpf_obj(program), "outer_map_queue");
	if (map_of_maps_queue_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	common_map_fd = find_map_fd(xdp_program__bpf_obj(program), "common_array");
	if (common_map_fd < 0) {
		/* xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0); */
		return EXIT_FAIL_BPF;
	}

	percpu_map_fd = find_map_fd(xdp_program__bpf_obj(program), "percpu_array");
	if (percpu_map_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	counter_map_fd = find_map_fd(xdp_program__bpf_obj(program), "counter_array");
	if (counter_map_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	time_map_fd = find_map_fd(xdp_program__bpf_obj(program), "time_array");
	if (counter_map_fd < 0) {
		return EXIT_FAIL_BPF;
	}

	__u64 value = 0;
	/*unsigned int values_array[libbpf_num_possible_cpus()];
	for(int i = 0; i < libbpf_num_possible_cpus(); i++) {
		values_array[i] = 0;
	}*/
	for(int key = 0; key < MAX_NUMBER_CORES; key++) {
		bpf_map_update_elem(common_map_fd, &key, &value, BPF_ANY);
		//bpf_map_update_elem(percpu_map_fd, &key, &value, BPF_ANY);
		bpf_map_update_elem(counter_map_fd, &key, &value, BPF_ANY);
		bpf_map_update_elem(time_map_fd, &key, &value, BPF_ANY);
	}
	/*for(int key = 0; key < MAX_NUMBER_CORES; key++) {
		bpf_map_update_elem(percpu_map_fd, &key, &values_array, BPF_ANY);
	}*/

	/* Lesson#4: check map info, e.g. datarec is expected size */
	map_expect.key_size    = sizeof(__u32);
	map_expect.value_size  = sizeof(__u64);
	map_expect.max_entries = MAX_NUMBER_CORES;
	err = __check_map_fd_info(common_map_fd, &info, &map_expect);
	if (err) {
		fprintf(stderr, "ERR: map via FD not compatible\n");
		return err;
	}
	if (verbose) {
		printf("\nCollecting stats from BPF map\n");
		printf(" - BPF map (bpf_map_type:%d) id:%d name:%s"
		       " key_size:%d value_size:%d max_entries:%d\n",
		       info.type, info.id, info.name,
		       info.key_size, info.value_size, info.max_entries
		       );
	}

	userspace_map_access(map_of_maps_array_fd, map_of_maps_queue_fd, percpu_map_fd, program);

	map_rate_printer(counter_map_fd, time_map_fd);

	if(!strcmp(default_progname, "map_of_maps_hash"))
		check_hash_MoM(map_of_maps_hash_fd);
	else if(!strcmp(default_progname, "common_hash_map"))
		print_hash_maps(hash_map_fd);
	else if(!strcmp(default_progname, "map_of_maps_queue"))
		check_queues(program);
	else if(!strcmp(default_progname, "percpu_array_lookup"))
		print_percpu_maps(percpu_map_fd);
	else if(!strcmp(default_progname, "common_array_lookup_same_keys"))
		print_common_maps(common_map_fd, 0);
	else if(!strcmp(default_progname, "common_array_lookup_diff_keys"))
		print_common_maps(common_map_fd, 1);
	else if(!strcmp(default_progname, "map_of_maps_array"))
		check_arrays(program, map_of_maps_array_fd);
	else if(!strcmp(default_progname, "lock_map"))
		print_lock_maps(lock_map_fd);

	cfg.unload_all = true;
	err = do_unload(&cfg);
	if (err) {
		fprintf(stderr, "Couldn't detach XDP program on iface '%s' : (%d)\n",
			cfg.ifname, err);
	}

	return EXIT_OK;
}
