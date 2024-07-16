/* SPDX-License-Identifier: GPL-2.0 */

#define _GNU_SOURCE

#include <assert.h>
#include <errno.h>
#include <getopt.h>
#include <locale.h>
#include <poll.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sched.h> 

#include <sys/resource.h>

#include <bpf/bpf.h>
#include <xdp/xsk.h>
#include <xdp/libxdp.h>

#include <arpa/inet.h>
#include <net/if.h>
#include <linux/if_link.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
//#include <linux/icmp.h>
#include <linux/tcp.h>

#include "../common/common_params.h"
#include "../common/common_user_bpf_xdp.h"
#include "../common/common_libbpf.h"

#include "common_def.h"
#include "req_queue.h"

#define NUM_FRAMES         	4096
#define FRAME_SIZE         	XSK_UMEM__DEFAULT_FRAME_SIZE
#define RX_BATCH_SIZE     	64
#define INVALID_UMEM_FRAME 	UINT64_MAX

static const char *default_filename = "kernel_xdp.o";

static const char *default_progname = "rx_module";

static struct xdp_program *prog;
int xsk_map_fd;
bool custom_xsk = false;

//struct req_queue *cpu_req_queues;
struct req_queue_v2 cpu_req_queues_v2[MAX_NUMBER_CORES];

struct config cfg = {
	.ifindex   = -1,
	.do_unload = false,
};

struct xsk_umem_info {
	struct xsk_ring_prod fq;
	struct xsk_ring_cons cq;
	struct xsk_umem *umem;
	void *buffer;
};
struct stats_record {
	uint64_t timestamp;
	uint64_t rx_packets;
	uint64_t rx_bytes;
	uint64_t tx_packets;
	uint64_t tx_bytes;
};
struct xsk_socket_info {
	struct xsk_ring_cons rx;
	struct xsk_ring_prod tx;
	struct xsk_umem_info *umem;
	struct xsk_socket *xsk;

	uint64_t umem_frame_addr[NUM_FRAMES];
	uint32_t umem_frame_free;

	uint32_t outstanding_tx;

	uint32_t cpu_id;

	struct stats_record stats;
	struct stats_record prev_stats;
};

struct argument {
	struct config *cfg;
	struct xsk_socket_info *xsk_socket;
	int prod_map_fd;
	int tail_map_fd;
};

static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
{
	r->cached_cons = *r->consumer + r->size;
	return r->cached_cons - r->cached_prod;
}

static const char *__doc__ = "AF_XDP kernel bypass example\n";

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

static bool global_exit;


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

/*
 * Function that initializes a memory buffer to serve as
 * the AF_XDP UMEM
 */
static struct xsk_umem_info *configure_xsk_umem(void *buffer, uint64_t size)
{
	struct xsk_umem_info *umem;
	int ret;

	umem = calloc(1, sizeof(*umem));
	if (!umem)
		return NULL;

	/*struct xsk_umem_config xsk_umem_cfg = {
//		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS * 2,
		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
		.frame_headroom = 256,
		//.frame_headroom = 0,
		.flags = 0
	};*/

	/* Sets a UMEM by taking the buffer, its size, and the fill and completion queues */
	ret = xsk_umem__create(&umem->umem, buffer, size, &umem->fq, &umem->cq,
			       NULL/*&xsk_umem_cfg*/);
	if (ret) {
		errno = -ret;
		return NULL;
	}

	umem->buffer = buffer;
	return umem;
}

static uint64_t xsk_alloc_umem_frame(struct xsk_socket_info *xsk)
{
	uint64_t frame;
	if (xsk->umem_frame_free == 0)
		return INVALID_UMEM_FRAME;

	frame = xsk->umem_frame_addr[--xsk->umem_frame_free];
	xsk->umem_frame_addr[xsk->umem_frame_free] = INVALID_UMEM_FRAME;
	return frame;
}

static void xsk_free_umem_frame(struct xsk_socket_info *xsk, uint64_t frame)
{
	assert(xsk->umem_frame_free < NUM_FRAMES);

	xsk->umem_frame_addr[xsk->umem_frame_free++] = frame;
}

static uint64_t xsk_umem_free_frames(struct xsk_socket_info *xsk)
{
	return xsk->umem_frame_free;
}


/* Function that initializes an XSK socket (used by AF_XDP). Takes
 * the configuration of the XDP program and the UMEM
 */
static struct xsk_socket_info *xsk_configure_socket(struct config *cfg,
						    struct xsk_umem_info *umem)
{
	struct xsk_socket_config xsk_cfg;
	struct xsk_socket_info *xsk_info;
	uint32_t idx;
	int i;
	int ret;
	uint32_t prog_id;

	xsk_info = calloc(1, sizeof(*xsk_info));
	if (!xsk_info)
		return NULL;

	xsk_info->umem = umem;
	xsk_cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
	xsk_cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
	xsk_cfg.xdp_flags = cfg->xdp_flags;
	//cfg->xsk_bind_flags &= ~XDP_ZEROCOPY;
	//cfg->xsk_bind_flags |= XDP_COPY;
	xsk_cfg.bind_flags = cfg->xsk_bind_flags;
	xsk_cfg.libbpf_flags = (custom_xsk) ? XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD: 0;
	/* Creates socket, storing its address in xsk_info->xsk */

	//printf("\n\nQueue id %d\n\n", cfg->xsk_if_queue);
	ret = xsk_socket__create(&xsk_info->xsk, cfg->ifname,
				 cfg->xsk_if_queue, umem->umem, &xsk_info->rx,
				 &xsk_info->tx, &xsk_cfg);
	if (ret)
		goto error_exit;

	if (custom_xsk) {
		/* Updates XSK map with this new XSK socket */
		ret = xsk_socket__update_xskmap(xsk_info->xsk, xsk_map_fd);
		if (ret)
			goto error_exit;
	} else {
		/* Getting the program ID must be after the xdp_socket__create() call */
		if (bpf_xdp_query_id(cfg->ifindex, cfg->xdp_flags, &prog_id))
			goto error_exit;
	}

	/* Initialize umem frame allocation */
	for (i = 0; i < NUM_FRAMES; i++)
		xsk_info->umem_frame_addr[i] = i * FRAME_SIZE;

	xsk_info->umem_frame_free = NUM_FRAMES;

	/* Stuff the receive path with buffers, we assume we have enough */
	/* This function reserves space in the fill queue of UMEM */
	ret = xsk_ring_prod__reserve(&xsk_info->umem->fq,
				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
				     &idx);

	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
		goto error_exit;

	/* For each one of the reserved spaces, we allocate a UMEM frame */
	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
		*xsk_ring_prod__fill_addr(&xsk_info->umem->fq, idx++) =
			xsk_alloc_umem_frame(xsk_info);

	/* After the frames are properly reserved and allocated, the application
	 * submits them, which indicates to the kernel they are ready to be used
	 */
	xsk_ring_prod__submit(&xsk_info->umem->fq,
			      XSK_RING_PROD__DEFAULT_NUM_DESCS);

	return xsk_info;

error_exit:
	errno = -ret;
	return NULL;
}

static void complete_tx(struct xsk_socket_info *xsk)
{
	unsigned int completed;
	uint32_t idx_cq;

	if (!xsk->outstanding_tx)
		return;

	sendto(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, 0);

	/* Collect/free completed TX buffers */
	completed = xsk_ring_cons__peek(&xsk->umem->cq,
					XSK_RING_CONS__DEFAULT_NUM_DESCS,
					&idx_cq);

	if (completed > 0) {
		for (int i = 0; i < completed; i++)
			xsk_free_umem_frame(xsk,
					    *xsk_ring_cons__comp_addr(&xsk->umem->cq,
								      idx_cq++));

		xsk_ring_cons__release(&xsk->umem->cq, completed);
		xsk->outstanding_tx -= completed < xsk->outstanding_tx ?
			completed : xsk->outstanding_tx;
	}
}

static inline __sum16 csum16_add(__sum16 csum, __be16 addend)
{
	uint16_t res = (uint16_t)csum;

	res += (__u16)addend;
	return (__sum16)(res + (res < (__u16)addend));
}

static inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
{
	return csum16_add(csum, ~addend);
}

static inline void csum_replace2(__sum16 *sum, __be16 old, __be16 new)
{
	*sum = ~csum16_add(csum16_sub(~(*sum), old), new);
}

static bool process_packet(struct xsk_socket_info *xsk,
			   uint64_t addr, uint32_t len)
{
	uint8_t *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);

	if (pkt) {
		int ret;
		uint32_t tx_idx = 0;
		uint8_t tmp_mac[ETH_ALEN];
		struct in6_addr tmp_ip;
		struct ethhdr *eth = (struct ethhdr *) pkt;
		struct iphdr *ip = (struct iphdr *) (eth + 1);
		//struct icmphdr *icmp = (struct icmphdr *) (ip + 1);
		struct tcphdr *tcp = (struct tcphdr *) (ip + 1);

		printf("Destination port: %d\n", ntohs(tcp->dest));

		/*if (ntohs(eth->h_proto) != ETH_P_IPV6 ||
		    len < (sizeof(*eth) + sizeof(*ip) + sizeof(*icmp)) ||
		    ip->protocol != IPPROTO_ICMP ||
		    icmp->type != ICMP_ECHO)
			return false;*/

		if (ntohs(eth->h_proto) != ETH_P_IP ||
		    len < (sizeof(*eth) + sizeof(*ip) + sizeof(*tcp)) ||
		    ip->protocol != IPPROTO_TCP)
			return false;

		memcpy(tmp_mac, eth->h_dest, ETH_ALEN);
		memcpy(eth->h_dest, eth->h_source, ETH_ALEN);
		memcpy(eth->h_source, tmp_mac, ETH_ALEN);

		memcpy(&tmp_ip, &ip->saddr, sizeof(tmp_ip));
		memcpy(&ip->saddr, &ip->daddr, sizeof(tmp_ip));
		memcpy(&ip->daddr, &tmp_ip, sizeof(tmp_ip));

		/*icmp->type = ICMP_ECHOREPLY;

		csum_replace2(&icmp->checksum,
			      htons(ICMP_ECHO << 8),
			      htons(ICMP_ECHOREPLY << 8));*/
		

		/* Here we sent the packet out of the receive port. Note that
		 * we allocate one entry and schedule it. Your design would be
		 * faster if you do batch processing/transmission */

		ret = xsk_ring_prod__reserve(&xsk->tx, 1, &tx_idx);
		if (ret != 1) {
			/* No more transmit slots, drop the packet */
			return false;
		}

		xsk_ring_prod__tx_desc(&xsk->tx, tx_idx)->addr = addr;
		xsk_ring_prod__tx_desc(&xsk->tx, tx_idx)->len = len;
		xsk_ring_prod__submit(&xsk->tx, 1);
		xsk->outstanding_tx++;

		xsk->stats.tx_bytes += len;
		xsk->stats.tx_packets++;
		return true;
	}

	return false;
}

static void handle_receive_packets(struct xsk_socket_info *xsk)
{
	unsigned int rcvd, stock_frames, i;
	uint32_t idx_rx = 0, idx_fq = 0;
	int ret;

	/* Checks the number of packets arriving in RX ring.
	 * With RX_BATCH_SIZE being the largest possible value
	 */
	rcvd = xsk_ring_cons__peek(&xsk->rx, RX_BATCH_SIZE, &idx_rx);

	if (!rcvd)
		return;

	//printf("TEST\n");

	/* Stuff the ring with as much frames as possible */
	/* Gets the number of available entries in fill ring*/
	stock_frames = xsk_prod_nb_free(&xsk->umem->fq,
					xsk_umem_free_frames(xsk));

	if (stock_frames > 0) {
		/* Reserves a number of entries in fill ring */
		ret = xsk_ring_prod__reserve(&xsk->umem->fq, stock_frames,
					     &idx_fq);

		/* This should not happen, but just in case */
		while (ret != stock_frames)
			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
						     &idx_fq);

		/* For each one of the reserved entries of fill ring
		 * we allocate a UMEM frame and sets its address to fill ring
		 */
		for (i = 0; i < stock_frames; i++)
			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
				xsk_alloc_umem_frame(xsk);

		/* After everything has been written to fill ring,
		 * indicates to the kernel that the application can submit
		 * these entries
		 */
		xsk_ring_prod__submit(&xsk->umem->fq, stock_frames);
	}

	/* Process received packets */
	for (i = 0; i < rcvd; i++) {
		/* Gets information about an entry of the RX ring */
		uint64_t addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
		uint32_t len = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;

		if (!process_packet(xsk, addr, len))
			xsk_free_umem_frame(xsk, addr);

		xsk->stats.rx_bytes += len;
	}

	xsk_ring_cons__release(&xsk->rx, rcvd);
	xsk->stats.rx_packets += rcvd;

	/* Do we need to wake up the kernel for transmission */
	complete_tx(xsk);
}

void produce_app_events(int cpu_id, int outer_map_fd, int tail_map_fd, int *inner_index, atomic_uint * last_head) {
	int inner_id, inner_fd, err;
	
	struct app_event old_entry;

	// This function is working properly, since it also enqueues based on the occupied bit.
	// So, even if two CPUs receive requests to the same flow, one of them will be blocked
	// unless they are currently in the same head position

	//struct app_event* new_entry = read_first_req(cpu_req_queues, cpu_id);
	atomic_uint curr_head;
	struct app_event* new_entry = read_first_req_v2(&cpu_req_queues_v2[cpu_id], &curr_head);
	if(new_entry == NULL/* || curr_head == *last_head*/)
		return;
	*last_head = curr_head;

	//printf("%d\n", cpu_id);

	err = bpf_map_lookup_elem(outer_map_fd, &(new_entry->ev_flow_id), &inner_id);
	if(err < 0) {
		printf("Couldn't find entry of outer map\n");
		return;
	}
	//printf("%d %d %d %d", new_entry->ev_flow_id.src_ip, new_entry->ev_flow_id.dest_ip, new_entry->ev_flow_id.src_port, new_entry->ev_flow_id.dest_port);

	inner_fd = bpf_map_get_fd_by_id(inner_id);

	err = bpf_map_lookup_elem(inner_fd, inner_index, &old_entry);
	if(err < 0) {
		printf("Couldn't find entry of inner map\n");
		close(inner_fd);
		return;
	}

	int next_index;
	if(*inner_index < MAX_EVENT_QUEUE_LEN - 1)
		next_index = *inner_index + 1;
	else
		next_index = 0;
	
	// This allows us to always have head and tail with different values
	// and makes app queue behave like a regular circular queue
	struct app_event next_entry;
	err = bpf_map_lookup_elem(inner_fd, &next_index, &next_entry);
	if(err < 0) {
		printf("Couldn't find entry of inner map\n");
		close(inner_fd);
		return;
	}
	//printf("Next %d occupied? %lld\n", next_index, next_entry.occupied);

	//printf("Old entry CPU %d: %lld %lld\n", cpu_id, old_entry.occupied, old_entry.value);

	if(!old_entry.occupied && !next_entry.occupied) {
		err = bpf_map_update_elem(inner_fd, inner_index, new_entry, BPF_ANY);
		if(err < 0) {
			printf("Couldn't update entry of inner map\n");
			close(inner_fd);
			return;
		}
		*inner_index = next_index;
		
		err = bpf_map_update_elem(tail_map_fd, &(new_entry->ev_flow_id), inner_index, BPF_ANY);
		if(err < 0) {
			printf("Couldn't update entry of tail map\n");
			close(inner_fd);
			return;
		}
		/*int teste;
		bpf_map_lookup_elem(tail_map_fd, &(new_entry->ev_flow_id), &teste);

		printf("Inner index %d\n", teste);*/
		
		//req_dequeue(cpu_req_queues, cpu_id);
		req_dequeue_v2(&cpu_req_queues_v2[cpu_id]);
	}
	// VERY IMPORTANT (bpf_map_get_fd_by_id keep returning an increasing value if not used)
	close(inner_fd);
}

void * producer_and_afxdp(void *arg) {
	struct argument *info = (struct argument *) arg;
	struct config *cfg = info->cfg;
	struct xsk_socket_info *xsk_socket = info->xsk_socket;
	int prod_map_fd = info->prod_map_fd;
	int tail_map_fd = info->tail_map_fd;

	struct pollfd fds[2];
	int ret, nfds = 1;

	memset(fds, 0, sizeof(fds));
	/* Gets file descriptor of XSK socket */
	fds[0].fd = xsk_socket__fd(xsk_socket->xsk);
	fds[0].events = POLLIN;

	int inner_index = 0;

	// Busy loop doing:
	// BPF_PROG_RUN for the first event
	// Producing new app events
	// AF_XDP packet handling

	/*unsigned char data[1500];
	char buf[1500];
	struct test teste;
	teste.value = xsk_socket->cpu_id;
	memcpy(data, &teste, sizeof(teste));

	LIBBPF_OPTS(bpf_test_run_opts, opts);
	opts.data_in = data;
	//opts.data_out = buf;
	opts.data_size_in = 1500;
	//opts.data_size_out = 1500;
	opts.flags = (1U << 1);

	int err = xdp_program__test_run(prog, &opts, 0);
	if (err != 0) {
		printf("[error]: bpf test run failed: %d\n", err);
	}

	struct test retorno;
	memcpy(&retorno, buf, sizeof(retorno));*/
	//printf("%d\n", retorno.value);
	
	atomic_uint last_head = 99999999;
	while(!global_exit) {
	
		produce_app_events(xsk_socket->cpu_id, prod_map_fd, tail_map_fd, &inner_index, &last_head);

		if (cfg->xsk_poll_mode) {
			ret = poll(fds, nfds, -1);
			if (ret <= 0 || ret > 1)
				continue;
		}
		handle_receive_packets(xsk_socket);
	}
	free(info);
	pthread_exit(NULL);
}

#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
/*static uint64_t gettime(void)
{
	struct timespec t;
	int res;

	res = clock_gettime(CLOCK_MONOTONIC, &t);
	if (res < 0) {
		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
		exit(EXIT_FAIL);
	}
	return (uint64_t) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
}

static double calc_period(struct stats_record *r, struct stats_record *p)
{
	double period_ = 0;
	__u64 period = 0;

	period = r->timestamp - p->timestamp;
	if (period > 0)
		period_ = ((double) period / NANOSEC_PER_SEC);

	return period_;
}*/

/*static void stats_print(struct stats_record *stats_rec,
			struct stats_record *stats_prev,
			int cpu_id)
{
	uint64_t packets, bytes;
	double period;
	double pps;
	double bps;

	char *fmt = "%-12s %'11lld pkts (%'10.0f pps)"
		" %'11lld Kbytes (%'6.0f Mbits/s)"
		" period:%f\n";

	period = calc_period(stats_rec, stats_prev);
	if (period == 0)
		period = 1;

	packets = stats_rec->rx_packets - stats_prev->rx_packets;
	pps     = packets / period;

	bytes   = stats_rec->rx_bytes   - stats_prev->rx_bytes;
	bps     = (bytes * 8) / period / 1000000;

	printf(fmt, "AF_XDP RX:", stats_rec->rx_packets, pps,
	       stats_rec->rx_bytes / 1000 , bps,
	       period);

	packets = stats_rec->tx_packets - stats_prev->tx_packets;
	pps     = packets / period;

	bytes   = stats_rec->tx_bytes   - stats_prev->tx_bytes;
	bps     = (bytes * 8) / period / 1000000;

	printf(fmt, "       TX:", stats_rec->tx_packets, pps,
	       stats_rec->tx_bytes / 1000 , bps,
	       period);

	printf("\n");
	printf("CPU %d\nRX: %lu\tTX:%lu\n\n", cpu_id, stats_rec->rx_packets, stats_rec->tx_packets);
}*/

/*static void *stats_poll(void *arg)
{
	unsigned int interval = 2;
	struct xsk_socket_info *xsk = arg;
	static struct stats_record previous_stats = { 0 };

	//previous_stats.timestamp = gettime();

	// Trick to pretty printf with thousands separators use %'
	setlocale(LC_NUMERIC, "en_US");

	while (!global_exit) {
		sleep(interval);
		//xsk->stats.timestamp = gettime();
		stats_print(&xsk->stats, &previous_stats, xsk->cpu_id);
		previous_stats = xsk->stats;
	}
	return NULL;
}*/

void distribute_requests() {
	//cpu_req_queues = create_queue();
	init_queue_v2(cpu_req_queues_v2);
	struct app_event event = {SEND, {0, 0, 0, 0}, 1, 0};
	int cpu_to_send = 0;
	while(1) {
		if(!scanf("%d", &cpu_to_send))
			return;
		if(cpu_to_send < 0 || cpu_to_send >= MAX_NUMBER_CORES)
			break;

		//req_enqueue(cpu_req_queues, event, cpu_to_send);
		req_enqueue_v2(&cpu_req_queues_v2[cpu_to_send], event);
		//print_queue(cpu_req_queues);
		print_queue_v2(cpu_req_queues_v2);
	}
	//free_queue(cpu_req_queues);
}

static void exit_application(int signal)
{
	int err;

	cfg.unload_all = true;
	err = do_unload(&cfg);
	if (err) {
		fprintf(stderr, "Couldn't detach XDP program on iface '%s' : (%d)\n",
			cfg.ifname, err);
	}

	signal = signal;
	global_exit = true;
}

int main(int argc, char **argv)
{
	//int ret;
	void *packet_buffer[MAX_NUMBER_CORES];
	uint64_t packet_buffer_size;
	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
	DECLARE_LIBXDP_OPTS(xdp_program_opts, xdp_opts, 0);
	struct rlimit rlim = {RLIM_INFINITY, RLIM_INFINITY};
	struct xsk_umem_info *umem[MAX_NUMBER_CORES];
	struct xsk_socket_info *xsk_socket[MAX_NUMBER_CORES];
	//pthread_t stats_poll_thread[MAX_NUMBER_CORES];
	int err;
	char errmsg[1024];

	/* Global shutdown handler */
	signal(SIGINT, exit_application);

	/* Set default BPF-ELF object file and BPF program name */
	strncpy(cfg.filename, default_filename, sizeof(cfg.filename));
	strncpy(cfg.progname,  default_progname,  sizeof(cfg.progname));

	/* Cmdline options can change progname */
	parse_cmdline_args(argc, argv, long_options, &cfg, __doc__);

	/* Required option */
	if (cfg.ifindex == -1) {
		fprintf(stderr, "ERROR: Required option --dev missing\n\n");
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

	/* Load custom program if configured */
	/* Everything here can be sumarized by load_bpf_and_xdp_attach in common,
	*  except the xsk map part
	*/
	if (cfg.filename[0] != 0) {
		custom_xsk = true;
		xdp_opts.open_filename = cfg.filename;
		xdp_opts.prog_name = cfg.progname;
		xdp_opts.opts = &opts;

		/* Load XDP program */
		if (cfg.progname[0] != 0) {
			xdp_opts.open_filename = cfg.filename;
			xdp_opts.prog_name = cfg.progname;
			xdp_opts.opts = &opts;

			prog = xdp_program__create(&xdp_opts);
		} else {
			prog = xdp_program__open_file(cfg.filename,
						  NULL, &opts);
		}
		err = libxdp_get_error(prog);
		if (err) {
			libxdp_strerror(err, errmsg, sizeof(errmsg));
			fprintf(stderr, "ERR: loading program: %s\n", errmsg);
			return err;
		}

		/* At this point: BPF-progs are (only) loaded by the kernel, and prog_fd
		 * is file-descriptor handle. Next step is attaching this FD
		 * to a kernel hook point, in this case XDP net_device link-level hook.
		 */
		err = xdp_program__attach(prog, cfg.ifindex, cfg.attach_mode, 0);
		if (err) {
			libxdp_strerror(err, errmsg, sizeof(errmsg));
			fprintf(stderr, "Couldn't attach XDP program on iface '%s' : %s (%d)\n",
				cfg.ifname, errmsg, err);
			return err;
		}

		/* We also need to load the xsks_map */
		xsk_map_fd = find_map_fd(xdp_program__bpf_obj(prog), "xsks_map");
        if (xsk_map_fd < 0) {
            exit(EXIT_FAIL_BPF);
        }

	}

	/* Allow unlimited locking of memory, so all memory needed for packet
	 * buffers can be locked in memory (doesn't go to secondary memory due to paging)
	 */
	if (setrlimit(RLIMIT_MEMLOCK, &rlim)) {
		fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}

	/* Allocate memory for NUM_FRAMES of the default XDP frame size */
	packet_buffer_size = NUM_FRAMES * FRAME_SIZE;

	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		if (posix_memalign(&packet_buffer[i],
				getpagesize(), /* PAGE_SIZE aligned */
				packet_buffer_size)) {
			fprintf(stderr, "ERROR: Can't allocate buffer memory \"%s\"\n",
				strerror(errno));
			exit(EXIT_FAILURE);
		}

		/* Initializes the memory buffer allocated above to 
		* use it for the AF_XDP UMEM.
		*/
		umem[i] = configure_xsk_umem(packet_buffer[i], packet_buffer_size);
		if (umem[i] == NULL) {
			fprintf(stderr, "ERROR: Can't create umem \"%s\"\n",
				strerror(errno));
			exit(EXIT_FAILURE);
		}

		/* Open and configure the AF_XDP (xsk) socket */
		cfg.xsk_if_queue = i;
		xsk_socket[i] = xsk_configure_socket(&cfg, umem[i]);
		xsk_socket[i]->cpu_id = i;
		if (xsk_socket[i] == NULL) {
			fprintf(stderr, "ERROR: Can't setup AF_XDP socket \"%s\"\n",
				strerror(errno));
			exit(EXIT_FAILURE);
		}

		/* Start thread to do statistics display */
		/*if (verbose) {
			ret = pthread_create(&stats_poll_thread[i], NULL, stats_poll,
						xsk_socket[i]);
			if (ret) {
				fprintf(stderr, "ERROR: Failed creating statistics thread "
					"\"%s\"\n", strerror(errno));
				exit(EXIT_FAILURE);
			}
		}*/
	}

	int prod_map_fd = find_map_fd(xdp_program__bpf_obj(prog), "outer_app_hash");
	if (prod_map_fd < 0) {
		exit(EXIT_FAIL_BPF);
	}

	int tail_map_fd = find_map_fd(xdp_program__bpf_obj(prog), "tail_app_hash");
	if (tail_map_fd < 0) {
		exit(EXIT_FAIL_BPF);
	}

	pthread_t threads[MAX_NUMBER_CORES];
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		struct argument *arg = malloc(sizeof(struct argument));
		arg->cfg = &cfg;
		arg->xsk_socket = xsk_socket[i];
		arg->prod_map_fd = prod_map_fd;
		arg->tail_map_fd = tail_map_fd;
		CPU_SET(i, &cpuset);
		/* Receive and count packets than drop them */
		pthread_create(&threads[i], NULL, producer_and_afxdp, (void *) arg);
		pthread_setaffinity_np(threads[i], sizeof(cpu_set_t), &cpuset);
		//rx_and_process(&cfg, xsk_socket[0]);
		CPU_ZERO(&cpuset);
	}

	distribute_requests();

	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		pthread_join(threads[i], NULL);
	}

	/* Cleanup */
	for(int i = 0; i < MAX_NUMBER_CORES; i++) {
		xsk_socket__delete(xsk_socket[i]->xsk);
		xsk_umem__delete(umem[i]->umem);
	}

	return EXIT_OK;
}