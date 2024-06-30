/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <linux/in.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

#include "../common/parsing_helpers.h"
#include "common.h"

#define MAX_NUMBER_CORES 8

enum event_type {
    APP_EVENT,
    PACKET_EVENT,
};

struct app_event {
    __u8 type;
    struct flow_id fid;
    void *data;
    __u32 size;
};

struct net_event {
    __u8 type;
    struct flow_id fid;
    __u8 ack;
    void *data;
    __u32 size;
};

struct packet_event {
    __u8 type;
    struct flow_id fid;
    int seq_num;
    void *data;
    __u32 size;
};

struct event {
    __u8 type;
    void* event_data;
};

// Need an array to store data chunks, each chuck is a data segment for a packet

// Need an array to represent the window which stores the sequence number that is needed to be sent. 

struct
{
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 32);
    __type(key, struct flow_id);
    __type(value, struct tcp_md);
} tcp_connections SEC(".maps");

static __always_inline int parse_ethhdr_new(struct hdr_cursor *nh,
					void *data_end,
					struct ethhdr **ethhdr)
{
	struct ethhdr *eth = nh->pos;
	int hdrsize = sizeof(*eth);
	if (nh->pos + hdrsize > data_end)
		return -1;
	nh->pos += hdrsize;
	*ethhdr = eth;
	return eth->h_proto; /* network-byte-order */
}

static __always_inline int packet_event_print(struct packet_event *event) {
    bpf_printk("\nIPs: %u, %u", event->fid.sender_ip, event->fid.receiver_ip);
    bpf_printk("\nPorts: %u, %u", event->fid.sender_port, event->fid.receiver_port);
    bpf_printk("\nPacket length: %u", event->size);
    bpf_printk("\npacket seq_num: %u", event->seq_num);
    return 1;
}

static __always_inline void app_event_processor(struct app_event* ae) {
    bpf_printk("\napp_event_processor is called");
    // Get tcp_ctx and update
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, &(ae->fid));
    if(!tcp_ctx) {
        bpf_printk("tcp_ctx does not exist with the fid");
        return;
    }
    struct packet_event pe;
    __builtin_memset(&pe, 0, sizeof(pe));
    tcp_ctx->segment_size = ae->size;

    // Generate packet event: send all [window-size] packets
    pe.fid = ae->fid;
    pe.data = ae->data;
    pe.size =tcp_ctx->window_size;
    pe.seq_num = tcp_ctx->window_start_seq;
    packet_event_print(&pe);
}

static __always_inline void net_event_processor(struct net_event* ne, struct packet_event* pe) {
    bpf_printk("\napp_event_processor is called");
    // Get tcp_ctx and update
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, &(ne->fid));
    if(!tcp_ctx) {
        bpf_printk("tcp_ctx does not exist with the fid");
        return;
    }

    //Use ack in ne to update the current window, then send next packets if allowed
}

static __always_inline void dispatcher(struct event *event) {
    switch (event->type) {
        case APP_EVENT: {
            struct app_event *ae = event->event_data;
            app_event_processor(ae);
            break;
        }
        default:
            bpf_printk("Unknown event type: %d\n", event->type);
            break;
    }
}

// Problems: 
// 1. Failed to use inline packet parsing helpers
SEC("xdp")
int simply_drop(struct xdp_md *ctx)
{

    // Get packet and packet length
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;

    // Generate app event
    struct event e;
    __builtin_memset(&e, 0, sizeof(e));
    e.type = APP_EVENT;
    struct app_event ae;
    __builtin_memset(&ae, 0, sizeof(ae));
    e.event_data = &ae;
    ae.data = data;
    ae.size = data_end - data;

    // Parsing begins
    struct ethhdr *eth;
    struct iphdr *iphdr;
    struct tcphdr *tcphdr;
    struct hdr_cursor nh = {
        .pos = data,
    };
    struct flow_id fid;

    // Parsing ETh Header
    parse_ethhdr_new(&nh, data_end, &eth);
    //bpf_printk("\nETH: %u, %u", eth->h_source, eth->h_dest);
    
    // Parsing IP Header
    struct iphdr *iph = nh.pos;
	int hdrsize;
	if (iph + 1 > data_end)
		return -1;
	hdrsize = iph->ihl * 4;
	if(hdrsize < sizeof(*iph))
		return -1;
	if (nh.pos + hdrsize > data_end)
		return -1;
	nh.pos += hdrsize;
	iphdr = iph;
    fid.sender_ip = iphdr->saddr;
    fid.receiver_ip = iphdr->daddr;
    bpf_printk("\nIP: %u, %u", fid.sender_ip, fid.receiver_ip);

    // Parsing TCP Header
    int len;
	struct tcphdr *h = nh.pos;
	if (h + 1 > data_end) {
		return -1;
    }
	len = h->doff * 4;
	if(len < sizeof(*h)) {
		return -1;
    }
	if (nh.pos + len > data_end) {
		return -1;
    }
	nh.pos += len;
	tcphdr = h;
    fid.sender_port = bpf_ntohl(tcphdr->source);
    fid.receiver_port = bpf_ntohl(tcphdr->dest);
    bpf_printk("\nTCP: %d, %d", fid.sender_port, fid.receiver_port);

    // Send the app event to dispatcher
    ae.fid = fid;
    dispatcher(&e);

    return XDP_DROP;
}

char _license[] SEC("license") = "GPL";
