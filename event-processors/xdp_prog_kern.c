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
#define WINDOW_SIZE 5
enum event_type {
    APP_EVENT,
    PACKET_EVENT,
    NET_EVENT,
};

struct app_event {
    struct flow_id fid;
    void *data;
    void *data_end;
    __u32 size;
};

struct net_event {
    struct flow_id fid;
    __u32 ack;
};

struct packet_event {
    struct flow_id fid;
    int seq_num;
    char data;
    __u32 size;
};

struct event {
    __u8 type;
    void* event_data;
};

struct
{
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 32);
    __type(key, struct flow_id);
    __type(value, struct tcp_md);
} tcp_connections SEC(".maps");

struct
{
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __uint(max_entries, WINDOW_SIZE);
    __type(key, __u32);
    __type(value, struct packet_event);
} window_packets SEC(".maps");

static __always_inline int enque(struct packet_event *p, struct flow_id *fid) {
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, fid);
    if(!tcp_ctx) {
        bpf_printk("\ntcp_ctx does not exist with the fid");
        return 0;
    }
    // Check if the window is full
    if(tcp_ctx->cur_size == tcp_ctx->window_size) {
        bpf_printk("The window is full, the packet cannot be added");
        return 0;
    }
    // Add the packet
    __u32 key = (tcp_ctx->head + tcp_ctx->cur_size) % tcp_ctx->window_size;
    bpf_map_update_elem(&window_packets, &key, p, BPF_ANY);
    tcp_ctx->cur_size += 1;
    bpf_map_update_elem(&tcp_connections, fid, tcp_ctx, BPF_ANY);
    return 1;
}

static __always_inline int deque(struct flow_id *fid) {
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, fid);
    if(!tcp_ctx) {
        bpf_printk("\ntcp_ctx does not exist with the fid");
        return 0;
    }
    // Check if the window is empty
    if(tcp_ctx->cur_size == 0) {
        bpf_printk("The window is empty, no packet can be removed");
        return 0;
    }
    // Remove the packet
    tcp_ctx->head = (tcp_ctx->head + 1) % tcp_ctx->window_size;
    tcp_ctx->cur_size -= 1;
    bpf_map_update_elem(&tcp_connections, fid, tcp_ctx, BPF_ANY);
    return 1;
}

static __always_inline void display(struct flow_id *fid) {
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, fid);
    if(!tcp_ctx) {
        bpf_printk("\ntcp_ctx does not exist with the fid");
        return;
    }
    bpf_printk("\nPackets in the window:");
    for(int i = 0; i < WINDOW_SIZE; i++) {
        if(i + 1 > tcp_ctx->cur_size) return;
        __u32 key = (tcp_ctx->head + i) % tcp_ctx->window_size;
        struct packet_event *pe = bpf_map_lookup_elem(&window_packets, &key);
        if(!pe) {
            bpf_printk("The packet does not exist");
            return;
        }
        bpf_printk("Seq num: %u", pe->seq_num);
    }
}

static __always_inline void app_event_processor(struct app_event* ae) {
    // Get tcp_ctx and update
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, &(ae->fid));
    if(!tcp_ctx) {
        bpf_printk("\ntcp_ctx does not exist with the fid\n");
        return;
    }
    for (int i = 0; i < WINDOW_SIZE; i++) {
        struct packet_event pe;
        __builtin_memset(&pe, 0, sizeof(pe));
        pe.fid = ae->fid;
        pe.size =tcp_ctx->segment_size;
        pe.seq_num = tcp_ctx->last_seq_sent + 1;
        enque(&pe, &(ae->fid));
        tcp_ctx->last_seq_sent += 1;
        bpf_map_update_elem(&tcp_connections, &(ae->fid), tcp_ctx, BPF_ANY);
    }
}

static __always_inline void net_event_processor(struct net_event* ne) {
    // Get tcp_ctx and update
    struct flow_id fid;
    __builtin_memset(&fid, 0, sizeof(fid));
    fid.sender_ip = ne->fid.receiver_ip;
    fid.sender_port = ne->fid.receiver_port;
    fid.receiver_ip = ne->fid.sender_ip;
    fid.receiver_port = ne->fid.sender_port;
    struct tcp_md *tcp_ctx;
    __builtin_memset(&tcp_ctx, 0, sizeof(tcp_ctx));
    tcp_ctx = bpf_map_lookup_elem(&tcp_connections, &fid);
    if(!tcp_ctx) {
        bpf_printk("\ntcp_ctx does not exist with the fid\n");
        return;
    }
    deque(&fid);
    // if(ne->ack > tcp_ctx->window_start_seq) {
    //     tcp_ctx->current_size = tcp_ctx->current_size - (ne->ack - tcp_ctx->window_start_seq);
    //     tcp_ctx->window_start_seq = ne->ack;
    //     bpf_map_update_elem(&tcp_connections, &fid, tcp_ctx, BPF_ANY);
    // }
    // tcp_ctx = bpf_map_lookup_elem(&tcp_connections, &fid);
    // if(!tcp_ctx) {
    //     bpf_printk("\ntcp_ctx does not exist with the fid\n");
    //     return;
    // }
    // bpf_printk("\nReceived ack %u, window_size: %u, start_seq: %u", ne->ack, tcp_ctx->current_size, tcp_ctx->window_start_seq);

    // int num_to_send = tcp_ctx->window_start_seq + WINDOW_SIZE - tcp_ctx->last_seq_sent - 2;
    // bpf_printk("%d", num_to_send);
    // for(int i = current_start; i < ack; i++) {
    //     struct packet_event pe;
    //     __builtin_memset(&pe, 0, sizeof(pe));
    //     pe.fid = fid;
    //     pe.size =tcp_ctx->segment_size;
    //     pe.seq_num = tcp_ctx->last_seq_sent + 1;
    //     int ret = bpf_map_update_elem(&packet_events, &pe.seq_num, &pe, BPF_ANY);
    //     if (ret < 0) {
    //         bpf_printk("\nFailed to add packet with seq_num %u", 0);
    //     }
    //     tcp_ctx->current_size += 1;
    //     tcp_ctx->last_seq_sent += 1;
    //     bpf_map_update_elem(&tcp_connections, &(fid), tcp_ctx, BPF_ANY);
    //     tcp_ctx = bpf_map_lookup_elem(&tcp_connections, &fid);
    //     if(!tcp_ctx) {
    //         bpf_printk("\ntcp_ctx does not exist with the fid");
    //         return;
    //     }
    //     bpf_printk("\nSend packet with seq_num: %u, window_size: %u, start_seq: %u", pe.seq_num, tcp_ctx->current_size, tcp_ctx->window_start_seq);
    // }
}

static __always_inline void dispatcher(struct event *event) {
    switch (event->type) {
        case APP_EVENT: {
            struct app_event *ae = event->event_data;
            app_event_processor(ae);
            break;
        }
        case NET_EVENT: {
            struct net_event *ne = event->event_data;
            net_event_processor(ne);
            break;
        }
        default:
            bpf_printk("Unknown event type: %d\n", event->type);
            break;
    }
}

static __always_inline int parse_ethhdr_new(struct hdr_cursor *nh, void *data_end, struct ethhdr **ethhdr)
{
	struct ethhdr *eth = nh->pos;
	int hdrsize = sizeof(*eth);
	if (nh->pos + hdrsize > data_end)
		return -1;
	nh->pos += hdrsize;
	*ethhdr = eth;
	return eth->h_proto; /* network-byte-order */
}

// Problems: 
// 1. Failed to use inline packet parsing helpers
SEC("xdp")
int simply_drop(struct xdp_md *ctx)
{

    // Get packet and packet length
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;

    // Parsing begins
    struct ethhdr *eth;
    struct iphdr *iphdr;
    struct tcphdr *tcphdr;
    struct hdr_cursor nh = {
        .pos = data,
    };
    struct flow_id fid;
    __builtin_memset(&fid, 0, sizeof(fid));

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
    //bpf_printk("\nIP: %u, %u", fid.sender_ip, fid.receiver_ip); 

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
    fid.sender_port = tcphdr->source;
    fid.receiver_port = tcphdr->dest;
    __u32 ack = bpf_ntohl(tcphdr->ack_seq);
    //bpf_printk("\nACK: %u", ack);
    //bpf_printk("\nTCP: %u, %u", bpf_ntohs(tcphdr->source), bpf_ntohs(tcphdr->dest));

    struct event e;
    struct net_event ne;
    struct app_event ae;
    __builtin_memset(&e, 0, sizeof(e));
    __builtin_memset(&ne, 0, sizeof(ne));
    __builtin_memset(&ae, 0, sizeof(ae));
    if (fid.sender_ip == 67116554) {
        e.type = NET_EVENT;
        __builtin_memset(&ne, 0, sizeof(ne));
        e.event_data = &ne;
        ne.fid = fid;
        ne.ack = ack;
    }
    else if (fid.sender_ip == 16784906) {
        e.type = APP_EVENT;
        e.event_data = &ae;
        ae.fid = fid;
        ae.data = nh.pos;
        ae.data_end = data_end;
        ae.size = data_end - nh.pos;
    }
    else {
        return XDP_DROP;
    }
    dispatcher(&e);
    display(&fid);
    return XDP_DROP;
}

char _license[] SEC("license") = "GPL";
