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

#define RX_RING_SIZE 2048
#define TX_RING_SIZE 1024

#define NUM_MBUFS 8191 //16383
#define MBUF_CACHE_SIZE 250
#define BURST_SIZE 32

#define TOTAL_RCV_CPU 20

#define MAX_RECV_CPU 20

#define LIMIT_PACKETS 100000000
#define PKT_LENGTH 1500

struct packet_recv_args {
    int cpu_id;
    struct rte_mempool* mbuf_pool;
    uint16_t port_id;
};

uint64_t counter_pkts[20] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
uint64_t previous_counter[20] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

uint64_t sum_latency[20] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
uint64_t previous_latency[20] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
bool stop_flag = 0;
int start_print = 0;

uint8_t rss_key[52] = {
    0x6d, 0x5a, 0x56, 0xfa, 0x27, 0x65, 0x5b, 0xd8, 0x2b, 0x09,
    0x7d, 0x5a, 0x44, 0xfa, 0x22, 0x65, 0x4b, 0xd8, 0x1b, 0x09,
    0x2d, 0x5b, 0x36, 0xea, 0x21, 0x55, 0x5a, 0xc8, 0x3a, 0x19,
    0x3d, 0x4a, 0x56, 0xda, 0x12, 0x75, 0x5a, 0xd9, 0x2a, 0x09,
    0x3d, 0x4a, 0x56, 0xda, 0x12, 0x75, 0x5a, 0xd9, 0x2a, 0x09,
    0x6d, 0x5a
};

static const struct rte_eth_conf port_conf_default = {
    .rxmode = {
        .mq_mode = RTE_ETH_MQ_RX_RSS,
        .max_lro_pkt_size = RTE_ETHER_MAX_LEN,
    },
    .rx_adv_conf = {
    .rss_conf = {
        .rss_key = rss_key,
        .rss_key_len = 52,
        .rss_hf = RTE_ETH_RSS_IPV4 | RTE_ETH_RSS_NONFRAG_IPV4_TCP,
        },
    },
};

/* Main functional part of port initialization. 8< */
static inline int
port_init(uint16_t port, struct rte_mempool **mbuf_pool)
{
    struct rte_eth_conf port_conf = port_conf_default;
    const uint16_t rx_rings = rte_lcore_count();
    const uint16_t tx_rings = 1;
    uint16_t nb_rxd = RX_RING_SIZE;
    uint16_t nb_txd = TX_RING_SIZE;
    int retval;
    uint16_t q;
    struct rte_eth_dev_info dev_info;
    struct rte_eth_txconf txconf;

    if (!rte_eth_dev_is_valid_port(port))
        return -1;

    //memset(&port_conf, 0, sizeof(struct rte_eth_conf));

    retval = rte_eth_dev_info_get(port, &dev_info);
    if (retval != 0) {
        printf("Error during getting device (port %u) info: %s\n",
                port, strerror(-retval));
        return retval;
    }

    /*if (dev_info.tx_offload_capa & RTE_ETH_TX_OFFLOAD_MBUF_FAST_FREE)
        port_conf.txmode.offloads |= RTE_ETH_TX_OFFLOAD_MBUF_FAST_FREE;*/

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
                    rte_eth_dev_socket_id(port), NULL, mbuf_pool[q]);
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

int check_stop(int prev_counter) {
    uint64_t pkt_total = 0;
    for(int i = 0; i < MAX_RECV_CPU; i++) {
        pkt_total += counter_pkts[i];
    }
    if(pkt_total >= LIMIT_PACKETS)
        stop_flag = 1;
}

/*
 * Prints the rate of pkt/s and counter of each core
 */
uint64_t rate_printer(uint64_t prev_time, double * rate_sum, int * iter_counter, double * latency_average_sum) {
    uint64_t curr_time = rte_get_timer_cycles();
    double time = (curr_time - prev_time) / rte_get_timer_hz();

    uint64_t pkts_sum = 0;
    double total_pkt_ps = 0;

    if(!start_print) {
        for(int i = 0; i < MAX_RECV_CPU; i++)
            pkts_sum += counter_pkts[i];
        if(pkts_sum > 0)
            start_print = 1;
        else
            return prev_time;
    }

    pkts_sum = 0;

    // If 1 second passed
    if(time >= 1) {
        double average_latency = 0;
        int counter = 0;
        for(int i = 0; i < MAX_RECV_CPU; i++) {
            // Note: we may need a lock when reading/writing from/to these arrays to get a more precise latency
            uint64_t curr_pkt = counter_pkts[i];
            uint64_t curr_sum_latency = sum_latency[i];
            uint64_t diff_pkts = curr_pkt - previous_counter[i];
            double pkt_per_sec = diff_pkts / time;

            uint64_t diff_latency = curr_sum_latency - previous_latency[i];


            if(diff_pkts == 0 && start_print > 1 && curr_pkt > 0) {
                stop_flag = 1;
                return curr_time;
            }

            double latency = 0;
            if(diff_pkts != 0) {
                latency = diff_latency / diff_pkts;
                counter++;
            }

            printf("CPU %d\tRate: %.02f\tCounter: %lu\tLatency: %.02fns\n", i, pkt_per_sec, curr_pkt, latency);
            previous_counter[i] = curr_pkt;
            previous_latency[i] = curr_sum_latency;

            total_pkt_ps += pkt_per_sec;
            average_latency += latency;
        }
        double gbps_rate = total_pkt_ps * PKT_LENGTH * 8 / 1000000000;

        if(counter > 0)
            average_latency /= counter;
        printf("\nTotal\t%.02fpkt/s\t%.02fGbps\nAverage Latency\t%.02fns", total_pkt_ps, gbps_rate, average_latenc>
        printf("\n\n");

        if(start_print > 1) {
            *rate_sum += gbps_rate;
            *iter_counter += 1;
            *latency_average_sum += average_latency;
        }

        return curr_time;
    }

    start_print++;

    return prev_time;
}

void recv_tcp_packet(int port_id, int cpu_id) {
    struct rte_mbuf *bufs[BURST_SIZE];
    uint16_t nb_rx = rte_eth_rx_burst(port_id, cpu_id, bufs, BURST_SIZE);
    //printf("CPU %d received %u packets", cpu_id, nb_rx);
    uint64_t cycles;
    uint64_t hz;
    uint64_t start, end;

    for(int i = 0; i < nb_rx; i++)
        rte_pktmbuf_free(bufs[i]);

    counter_pkts[cpu_id] += nb_rx;

    cycles = rte_get_timer_cycles();
    hz = rte_get_timer_hz();
    start = (cycles * 1e9) / hz;

    cycles = rte_get_timer_cycles();
    hz = rte_get_timer_hz();
    end = (cycles * 1e9) / hz;

    sum_latency[cpu_id] += (end - start);
}


int packet_recv(void *arg) {
    struct packet_recv_args *arguments = (struct packet_recv_args *) arg;
    int cpu_id = arguments->cpu_id;
    //struct rte_mempool* mbuf_pool = arguments->mbuf_pool;
    uint16_t port_id = arguments->port_id;
    recv_tcp_packet(port_id, cpu_id);
    for(;;) {
        if(stop_flag)
            break;
        recv_tcp_packet(port_id, cpu_id);
    }

    return 0;
}

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
        mbuf_pool[lcore_id] = rte_pktmbuf_pool_create(pool_name, NUM_MBUFS, MBUF_CACHE_SIZE, 0, RTE_MBUF_DEFAULT_B>
        if (mbuf_pool[lcore_id] == NULL) {
            rte_exit(EXIT_FAILURE, "Error creating mempool for lcore %u\n", lcore_id);
        }
    }

    /* Initializing all ports. 8< */
    //RTE_ETH_FOREACH_DEV(portid)
    if (port_init(portid, mbuf_pool) != 0)
            rte_exit(EXIT_FAILURE, "Cannot init port %"PRIu16 "\n",
                                    portid);
    /* >8 End of initializing all ports. */

    int iter_counter = 0;
    double rate_sum = 0;
    double latency_average_sum = 0;

    uint64_t time = rte_get_timer_cycles();
    int num_cpu;
    //printf("Number of CPUs on the rcv side: ");
    //if (scanf("%d", &num_cpu) > 0) {
            /* Initializes execution of threads that generate packets in other cores */
    RTE_LCORE_FOREACH(lcore_id) {
        struct packet_recv_args args = {lcore_id, mbuf_pool[lcore_id], portid};
        if(lcore_id != 0 && rte_eal_remote_launch(packet_recv, &args, lcore_id) < 0)
                printf("Failed to launch worker thread %d\n", lcore_id);
    }
    /* The main thread prints the rate and generates packets */
    if(rte_lcore_id() == 0) {
        //struct rte_mbuf *pkt[BURST_SIZE];
        //int num_pkt_create = BURST_SIZE;
        //int src_port_counter = 0;
        int prev_counter;
        for(;;) {
            prev_counter = check_stop(prev_counter);
            if(stop_flag)
                break;
            time = rate_printer(time, &rate_sum, &iter_counter, &latency_average_sum);
            recv_tcp_packet(portid, 0);
            //num_pkt_create = send_tcp_packet(portid, num_cpu, num_pkt_create, mbuf_pool[0], pkt, &sr>
        }
    }

    rte_eal_mp_wait_lcore();

    if(rte_eth_dev_stop(portid))
        printf("Failed while stopping device %d\n", portid);

    if(rte_eth_dev_close(portid))
        printf("Failed while closing device %d\n", portid);

    uint64_t sum_packets;
    for(int i = 0; i < MAX_RECV_CPU; i++)
        sum_packets += counter_pkts[i];
    printf("\nTotal # of packets: %lu\tAverage rate: %.02f Gbps\nAverage latency: %.02fns\n\n",
        sum_packets, rate_sum / (double) iter_counter, latency_average_sum / (double) iter_counter);

    /* clean up the EAL */
    rte_eal_cleanup();

    return 0;
}