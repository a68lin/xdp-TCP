/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2010-2015 Intel Corporation
 */

#include <stdint.h>
#include <stdlib.h>
#include <inttypes.h>
#include <rte_eal.h>
#include <rte_ethdev.h>
#include <rte_cycles.h>
#include <rte_lcore.h>
#include <rte_mbuf.h>
#include <rte_malloc.h>

#include <rte_ether.h>
#include <rte_ip.h>
#include <rte_tcp.h>

#define RX_RING_SIZE 1024
#define TX_RING_SIZE 2048

#define NUM_MBUFS 8191 //16383
#define MBUF_CACHE_SIZE 250
#define BURST_SIZE 32

#define TOTAL_RCV_CPU 20
#define SRC_PORT_LIST {8, 20, 12, 16, 10, 2, 14, 35, 28, 11, 5, 42, 3, 22, 7, 4, 1, 9, 43, 6}

#define MAX_SEND_CPU 8

#define LIMIT_PACKETS 100000000
#define PKT_LENGTH 1500

struct packet_gen_args {
	int num_rcv_cpus;
	struct rte_mempool* mbuf_pool;
	uint16_t port_id;
};

uint64_t counter_pkts[8] = {0, 0, 0, 0, 0, 0, 0, 0};
uint64_t previous_counter[8] = {0, 0, 0, 0, 0, 0, 0, 0};
bool stop_flag = 0;

/* Main functional part of port initialization. 8< */
static inline int
port_init(uint16_t port, struct rte_mempool *mbuf_pool)
{
	struct rte_eth_conf port_conf;
	const uint16_t rx_rings = 1;
	const uint16_t tx_rings = rte_lcore_count();
	uint16_t nb_rxd = RX_RING_SIZE;
	uint16_t nb_txd = TX_RING_SIZE;
	int retval;
	uint16_t q;
	struct rte_eth_dev_info dev_info;
	struct rte_eth_txconf txconf;

	if (!rte_eth_dev_is_valid_port(port))
		return -1;

	memset(&port_conf, 0, sizeof(struct rte_eth_conf));

	retval = rte_eth_dev_info_get(port, &dev_info);
	if (retval != 0) {
		printf("Error during getting device (port %u) info: %s\n",
				port, strerror(-retval));
		return retval;
	}

	if (dev_info.tx_offload_capa & RTE_ETH_TX_OFFLOAD_MBUF_FAST_FREE)
		port_conf.txmode.offloads |=
			RTE_ETH_TX_OFFLOAD_MBUF_FAST_FREE;

	/* Configure the Ethernet device. */
	retval = rte_eth_dev_configure(port, rx_rings, tx_rings, &port_conf);
	if (retval != 0)
		return retval;

	retval = rte_eth_dev_adjust_nb_rx_tx_desc(port, &nb_rxd, &nb_txd);
	if (retval != 0)
		return retval;


	/* Allocate and set up 1 RX queue per Ethernet port. */
	for (q = 0; q < rx_rings; q++) {
		retval = rte_eth_rx_queue_setup(port, q, nb_rxd,
				rte_eth_dev_socket_id(port), NULL, mbuf_pool);
		if (retval < 0)
			return retval;
	}

	txconf = dev_info.default_txconf;
	txconf.offloads = port_conf.txmode.offloads;
	/* Allocate and set up 1 TX queue per Ethernet port. */
	for (q = 0; q < tx_rings; q++) {
		retval = rte_eth_tx_queue_setup(port, q, nb_txd,
				rte_eth_dev_socket_id(port), &txconf);
		if (retval < 0)
			return retval;
	}

	/* Starting Ethernet port. 8< */
	retval = rte_eth_dev_start(port);

	/* >8 End of starting of ethernet port. */
	if (retval < 0)
		return retval;

	/* Display the port MAC address. */
	struct rte_ether_addr addr;
	retval = rte_eth_macaddr_get(port, &addr);
	if (retval != 0)
		return retval;

	printf("Port %u MAC: %02" PRIx8 " %02" PRIx8 " %02" PRIx8
			   " %02" PRIx8 " %02" PRIx8 " %02" PRIx8 "\n",
			port, RTE_ETHER_ADDR_BYTES(&addr));

	/* Enable RX in promiscuous mode for the Ethernet device. */
	retval = rte_eth_promiscuous_enable(port);
	/* End of setting RX port in promiscuous mode. */
	if (retval != 0)
		return retval;
	return 0;
}
/* >8 End of main functional part of port initialization. */

void test_rx(int port) {
	//for(;;) {
		//rte_delay_us_sleep(1000000);
		struct rte_mbuf *bufs[BURST_SIZE];
               	const uint16_t nb_rx = rte_eth_rx_burst(port, 0,
               		bufs, BURST_SIZE);
		printf("%d", nb_rx);
	//}
}


void check_stop() {
	uint64_t pkt_total = 0;
	for(int i = 0; i < MAX_SEND_CPU; i++) {
		pkt_total += counter_pkts[i];
	}
	if(pkt_total >= LIMIT_PACKETS)
		stop_flag = 1;
}

/*
 * Prints the rate of pkt/s and counter of each core
 */
uint64_t rate_printer(uint64_t prev_time, double * rate_sum, int * iter_counter) {
	uint64_t curr_time = rte_get_timer_cycles();
	double time = (curr_time - prev_time) / rte_get_timer_hz();

	uint64_t pkts_sum = 0;
	double total_pkt_ps = 0;
	// If 1 second passed
	if(time >= 1) {
		for(int i = 0; i < MAX_SEND_CPU; i++) {
			uint64_t curr_pkt = counter_pkts[i];
			uint64_t diff_pkts = curr_pkt - previous_counter[i];
			double pkt_per_sec = diff_pkts / time;
			printf("CPU %d\tRate: %.02f\tCounter: %lu\n", i, pkt_per_sec, curr_pkt);
			previous_counter[i] = curr_pkt;

			total_pkt_ps += pkt_per_sec;
		}
		double gbps_rate = total_pkt_ps * PKT_LENGTH * 8 / 1000000000;
		printf("\nTotal\t%.02fpkt/s\t%.02fGbps\n", total_pkt_ps, gbps_rate);
		printf("\n\n");

		*rate_sum += gbps_rate;
		*iter_counter += 1;

		return curr_time;
	}

	return prev_time;
}

// Based on https://github.com/thewhoo/dpdk-tcp-generator/blob/master/conn.c#L103

void fill_eth_header(struct rte_ether_hdr *eth, int port_id) {
	// Retrives MAC address of the Ethernet Device to be the source addr
        rte_eth_macaddr_get(port_id, &eth->src_addr);

	// With the destination address in string format, we convert to an ether_addr and we copy it to d_addr
        const char *dest_mac = "e4:1d:2d:13:9e:c0";
        struct rte_ether_addr mac_addr;
        if(rte_ether_unformat_addr(dest_mac, &mac_addr) < 0) {
                printf("Incorrect destination address format\n");
                return;
        }
        rte_ether_addr_copy(&mac_addr, &eth->dst_addr);

	// Set type of the next header (IPv4)
	eth->ether_type = rte_cpu_to_be_16(RTE_ETHER_TYPE_IPV4);
}

void fill_ip_header(struct rte_ipv4_hdr *ip, uint16_t length) {
	ip->version_ihl = 0x45;
	ip->type_of_service = 0;
	ip->total_length = rte_cpu_to_be_16(length);
	ip->packet_id = 0;
	ip->fragment_offset = rte_cpu_to_be_16(0x4000);
	ip->time_to_live = 64;
	// Set type of the next header (TCP)
	ip->next_proto_id = IPPROTO_TCP;
	ip->hdr_checksum = 0;
	// Set src and dst addresses
	ip->src_addr = rte_cpu_to_be_32(RTE_IPV4(10, 7, 0, 7));
	ip->dst_addr = rte_cpu_to_be_32(RTE_IPV4(10, 7, 0, 6));
	ip->hdr_checksum = rte_ipv4_cksum(ip);
}

void fill_tcp_header(struct rte_tcp_hdr *tcp, int source_port, struct rte_ipv4_hdr *ip) {
	// Set src and dst ports
	tcp->src_port = rte_cpu_to_be_16(source_port);
	tcp->dst_port = rte_cpu_to_be_16(123);
	tcp->sent_seq = 0;
	tcp->recv_ack = 0;
	tcp->data_off = 0x50;
	tcp->tcp_flags = 0x02;
	tcp->rx_win = rte_cpu_to_be_16(0xfaf0);
	tcp->tcp_urp = 0;
    	tcp->cksum = 0;
    	tcp->cksum = rte_ipv4_udptcp_cksum(ip, tcp);
}

/*
 * Function responsible for creating and sending the packets
 * Returns the number of packets that should be allocated in the next call
 */

int send_tcp_packet(int port_id, int num_rcv_cpus, int num_pkts_create, struct rte_mempool *mbuf_pool, struct rte_mbuf **pkt, int *src_port_counter) {

	int src_port_list[TOTAL_RCV_CPU] = SRC_PORT_LIST;
	int src_port;

	int ether_hdr_len = sizeof(struct rte_ether_hdr);
	int ipv4_ether_hdr_len = sizeof(struct rte_ether_hdr) + sizeof(struct rte_ipv4_hdr);
	int total_header_len = sizeof(struct rte_ether_hdr) + sizeof(struct rte_ipv4_hdr) + sizeof(struct rte_tcp_hdr);

	int lcore_id = rte_lcore_id();

	int i;
	for(i = 0; i < num_pkts_create; i++) {
		// Allocates a buffer for a packet
		pkt[i] = rte_pktmbuf_alloc(mbuf_pool);
		if(pkt[i] == NULL) {
			printf("Failed to allocate memory buffer for packet\n");
			break;
		}

		pkt[i]->pkt_len = PKT_LENGTH;
		pkt[i]->data_len = PKT_LENGTH;

		// Sets pointer for the regions of the buffer where the headers are located
		struct rte_ether_hdr *eth_hdr = rte_pktmbuf_mtod(pkt[i], struct rte_ether_hdr *);
		struct rte_ipv4_hdr *ip_hdr = rte_pktmbuf_mtod_offset(pkt[i], struct rte_ipv4_hdr *, ether_hdr_len);
		struct rte_tcp_hdr *tcp_hdr = rte_pktmbuf_mtod_offset(pkt[i], struct rte_tcp_hdr *, ipv4_ether_hdr_len);

		*src_port_counter = *src_port_counter % num_rcv_cpus;
		src_port = src_port_list[*src_port_counter];

		// Fills each one of the headers
		fill_eth_header(eth_hdr, port_id);
		fill_ip_header(ip_hdr, total_header_len - ether_hdr_len);
		fill_tcp_header(tcp_hdr, src_port, ip_hdr);

		*src_port_counter += 1;
	}

	// Pushes the array of packets to the transmission queue, returning the number of pushed packets
	int num_pkts = rte_eth_tx_burst(port_id, lcore_id, pkt, BURST_SIZE);

	//printf("%d ", num_pkts);

	counter_pkts[lcore_id] += num_pkts;

	// Alternative solution. We free the packets that weren't sent
	/*if(unlikely(num_pkts < i)) {
		while(num_pkts < i) {
			rte_pktmbuf_free(pkt[num_pkts]);
			num_pkts++;
		}
	}*/

	// Returns the number of packets that should be allocated in the next call, so we don't need to free the unsent
	return num_pkts;
}

/*
 * This function is called for each one of the helper threads
 * It sets the arguments for the send_tcp_packet function call and loops
 */
int packet_gen(void *arg) {
	struct packet_gen_args *arguments = (struct packet_gen_args *) arg;
	int num_cpu = arguments->num_rcv_cpus;
	struct rte_mempool* mbuf_pool = arguments->mbuf_pool;
	uint16_t port_id = arguments->port_id;
	int num_pkt_create = BURST_SIZE;
	int src_port_counter = 0;

	struct rte_mbuf *pkt[BURST_SIZE];
	for (;;) {
		if(stop_flag)
			break;
		num_pkt_create = send_tcp_packet(port_id, num_cpu, num_pkt_create, mbuf_pool, pkt, &src_port_counter);
        }

	return 0;
}

/* >8 End Basic forwarding application lcore. */

/*
 * The main function, which does initialization and calls the per-lcore
 * functions.
 */
int
main(int argc, char *argv[])
{
	//struct rte_mempool *mbuf_pool;
	unsigned nb_ports;
	uint16_t portid;

	/* Initializion the Environment Abstraction Layer (EAL). 8< */
	int ret = rte_eal_init(argc, argv);
	if (ret < 0)
		rte_exit(EXIT_FAILURE, "Error with EAL initialization\n");
	/* >8 End of initialization the Environment Abstraction Layer (EAL). */

	argc -= ret;
	argv += ret;

	/* Check the number of ports to send on. */
	nb_ports = rte_eth_dev_count_avail();
	printf("Number of ports available: %d\n", nb_ports);

	/* Creates a new mempool in memory to hold the mbufs. */

	/* Allocates mempool to hold the mbufs for each one of the cores. 8< */

	int lcore_id;
	struct rte_mempool *mbuf_pool[rte_lcore_count()];
	RTE_LCORE_FOREACH(lcore_id) {
		char pool_name[32];
		snprintf(pool_name, sizeof(pool_name), "mempool_%u", lcore_id);
		mbuf_pool[lcore_id] = rte_pktmbuf_pool_create(pool_name, NUM_MBUFS, MBUF_CACHE_SIZE, 0, RTE_MBUF_DEFAULT_BUF_SIZE, rte_socket_id());
		if (mbuf_pool[lcore_id] == NULL) {
			rte_exit(EXIT_FAILURE, "Error creating mempool for lcore %u\n", lcore_id);
		}
	}

	/* Initializing all ports. 8< */
	//RTE_ETH_FOREACH_DEV(portid)
	if (port_init(portid, mbuf_pool[0]) != 0)
		rte_exit(EXIT_FAILURE, "Cannot init port %"PRIu16 "\n",
					portid);
	/* >8 End of initializing all ports. */

	int iter_counter = 0;
	double rate_sum = 0;

	uint64_t time = rte_get_timer_cycles();
	int num_cpu;
    printf("Number of CPUs on the rcv side: ");
    if (scanf("%d", &num_cpu) > 0) {
		/* Initializes execution of threads that generate packets in other cores */
		RTE_LCORE_FOREACH(lcore_id) {
			struct packet_gen_args args = {num_cpu, mbuf_pool[lcore_id], portid};
			if(lcore_id != 0 && rte_eal_remote_launch(packet_gen, &args, lcore_id) < 0)
				printf("Failed to launch worker thread %d\n", lcore_id);
		}
		/* The main thread prints the rate and generates packets */
		if(rte_lcore_id() == 0) {
			struct rte_mbuf *pkt[BURST_SIZE];
			int num_pkt_create = BURST_SIZE;
			int src_port_counter = 0;
			for(;;) {
				check_stop();
				if(stop_flag)
					break;
				time = rate_printer(time, &rate_sum, &iter_counter);
				num_pkt_create = send_tcp_packet(portid, num_cpu, num_pkt_create, mbuf_pool[0], pkt, &src_port_counter);
			}
		}
	}
	//test_rx(portid);

	rte_eal_mp_wait_lcore();

	if(rte_eth_dev_stop(portid))
		printf("Failed while stopping device %d\n", portid);

	if(rte_eth_dev_close(portid))
		printf("Failed while closing device %d\n", portid);

	uint64_t sum_packets;
	for(int i = 0; i < MAX_SEND_CPU; i++)
		sum_packets += counter_pkts[i];
	printf("\nTotal # of packets: %lu\tAverage rate: %.02f Gbps\n\n", sum_packets, rate_sum / (double) iter_counter);

	/* clean up the EAL */
	rte_eal_cleanup();

	return 0;
}
