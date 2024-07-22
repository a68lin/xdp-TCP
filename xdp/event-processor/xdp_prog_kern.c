/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <linux/in.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

#include <time.h>
#include "../common/parsing_helpers.h"
#include "common.h"

#define MAX_NUMBER_CORES 8
#define WINDOW_SIZE 5
#define ONE_SEC 1000000000

enum event_type {
    APP_EVENT,
    PACKET_EVENT,
    NET_EVENT,
    TIMEOUT_EVENT,
};

struct app_event {
    struct flow_id *fid;
    __u32 size;
};

struct net_event {
    struct flow_id *fid;
    __u32 ack;
};

struct packet_event {
    struct flow_id *fid;
    int seq_num;
    void  *data;
    __u32 size;
};

struct timeout_event {
    struct flow_id *fid;
    int seq_num;
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

struct map_elem {
    struct flow_id *fid;
    int seq_num;
    struct bpf_timer timer;
};

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __type(key, struct flow_id);
    __type(value, struct map_elem);
    __uint(max_entries, WINDOW_SIZE);
} timer_array SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __type(key, struct flow_id);
    __type(value, struct timeout_event);
    __uint(max_entries, 1000);
} timeout_array SEC(".maps");

static __always_inline int send_packet(struct packet_event *pe) {
    // To be added: send the packet to receiver
    bpf_printk("send packet: %u", pe->seq_num);
    return 1;
}

static __always_inline int enque(struct packet_event *pe, struct flow_id *fid) {
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
    send_packet(pe);
    __u32 key = (tcp_ctx->head + tcp_ctx->cur_size) % tcp_ctx->window_size;
    bpf_map_update_elem(&window_packets, &key, pe, BPF_ANY);
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
    struct packet_event *pe = bpf_map_lookup_elem(&window_packets, &tcp_ctx->head);
    if(!pe) {
        bpf_printk("The remove packet does not exist");
        return 0;
    }
    tcp_ctx->head = (tcp_ctx->head + 1) % tcp_ctx->window_size;
    tcp_ctx->cur_size -= 1;
    bpf_map_update_elem(&tcp_connections, fid, tcp_ctx, BPF_ANY);
    return 1;
}

static __always_inline int timer_callback(void *map, struct flow_id *fid, struct map_elem *val) {
    // struct map_elem *entry = bpf_map_lookup_elem(map, fid);
    // if(!entry) {
    //     bpf_printk("Couldn't get entry of the map");
    //     return 0;
    // }
    bpf_printk("Packet %d timeouts", val->seq_num);
    struct timeout_event te;
    __builtin_memset(&te, 0, sizeof(te));
    te.seq_num = val->seq_num;
    te.fid = fid;
    bpf_map_update_elem(&timeout_array, fid, &te, BPF_ANY);
    int i = bpf_timer_start(&val->timer, ONE_SEC, 0);
    if (i != 0) {
        bpf_printk("Timer start failed");
        return 0;
    }
    return 0;
}

static long app_event_send(__u32 index, struct flow_id *fid) {
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, fid);
    if(!tcp_ctx) {
        bpf_printk("\ntcp_ctx does not exist with the fid\n");
        return 0;
    }
    struct packet_event pe;
    __builtin_memset(&pe, 0, sizeof(pe));
    pe.fid = fid;
    pe.size =tcp_ctx->segment_size;
    pe.seq_num = tcp_ctx->last_seq_sent + 1;
    pe.data = tcp_ctx->data + pe.seq_num  + 1;
    enque(&pe, fid);
    tcp_ctx->last_seq_sent += 1;
    bpf_map_update_elem(&tcp_connections, fid, tcp_ctx, BPF_ANY);
    return 0;
}

static __always_inline void app_event_processor(struct app_event* ae) {
    // Get tcp_ctx and update
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, ae->fid);
    if(!tcp_ctx) {
        bpf_printk("\ntcp_ctx does not exist with the fid\n");
        return;
    }
    int data_length = tcp_ctx->data_end - tcp_ctx->data;
    int data_rest = data_length - (tcp_ctx->last_seq_sent + 1);
    int num_to_send = data_rest < WINDOW_SIZE ? data_rest : WINDOW_SIZE;
    //bpf_printk("length:%d, rest:%d, num_to_send:%d", data_length, data_rest, num_to_send);
    bpf_loop(num_to_send, app_event_send, ae->fid, 0);

    struct map_elem *map_entry = bpf_map_lookup_elem(&timer_array, ae->fid);
    if (!map_entry) {
        bpf_printk("new timer added based on flow id");
        struct map_elem me;
        __builtin_memset(&me, 0, sizeof( me));
        bpf_map_update_elem(&timer_array, ae->fid, &me, BPF_ANY);
        map_entry = bpf_map_lookup_elem(&timer_array, ae->fid);
        if(!map_entry) {
            bpf_printk("new map_entry added failed");
            return;
        }
    }
    map_entry->seq_num = 0;
    map_entry->fid = ae->fid;
    long int i = bpf_timer_init(&(map_entry->timer), &timer_array, CLOCK_BOOTTIME);
    if(i != 0) {
        bpf_printk("App_event recalled");
    }
    i = bpf_timer_set_callback(&map_entry->timer, timer_callback);
    if(i != 0) {
        bpf_printk("Error while setting callback");
        return;
    }
    i = bpf_timer_start(&map_entry->timer, ONE_SEC, 0);
    if (i != 0) {
        bpf_printk("Timer start failed");
        return;
    }
    else {
        bpf_printk("timer starts successfully");
    }
}

static long update_window(__u32 index, struct flow_id *fid) {
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, fid);
    if(!tcp_ctx) {
        bpf_printk("\ntcp_ctx does not exist with the fid\n");
        return 0;
    }
    deque(fid);
    if(tcp_ctx->data_end - tcp_ctx->data == tcp_ctx->last_seq_sent + 1) {
        return 0;
    }
    struct packet_event pe;
    __builtin_memset(&pe, 0, sizeof(pe));
    pe.fid = fid;
    pe.size =tcp_ctx->segment_size;
    pe.seq_num = tcp_ctx->last_seq_sent + 1;
    pe.data = tcp_ctx->data + pe.seq_num  + 1;
    enque(&pe, fid);
    tcp_ctx->last_seq_sent += 1;
    bpf_map_update_elem(&tcp_connections, fid, tcp_ctx, BPF_ANY);
    return 0;
}

static __always_inline void net_event_processor(struct net_event* ne) {
    // Get tcp_ctx and update
    struct tcp_md *tcp_ctx;
    __builtin_memset(&tcp_ctx, 0, sizeof(tcp_ctx));
    tcp_ctx = bpf_map_lookup_elem(&tcp_connections, ne->fid);
    if(!tcp_ctx) {
        bpf_printk("\ntcp_ctx does not exist with the fid\n");
        return;
    }
    struct map_elem *map_entry = bpf_map_lookup_elem(&timer_array, ne->fid);
    if (!map_entry) {
        bpf_printk("map_entry not found");
        return;
    }

    if(ne->ack <= tcp_ctx->window_start_seq) return;
    bpf_printk("Received ack: %u", ne->ack);
    int data_length = tcp_ctx->data_end - tcp_ctx->data;
    int data_rest = data_length - (tcp_ctx->last_seq_sent + 1);
    if(data_rest == 0 && ne->ack == tcp_ctx->last_seq_sent + 1) {
        bpf_printk("All packets sent and received");
        tcp_ctx->last_seq_sent = -1;
        tcp_ctx->window_start_seq = 0,
	    tcp_ctx->cur_size = 0,
        tcp_ctx->head = 0,
        bpf_timer_cancel(&map_entry->timer);
        bpf_map_update_elem(&tcp_connections, ne->fid, tcp_ctx, BPF_ANY);
        return;
    }

    int num_to_send = ne->ack - tcp_ctx->window_start_seq;
    tcp_ctx->window_start_seq = ne->ack;
    bpf_map_update_elem(&tcp_connections, ne->fid, tcp_ctx, BPF_ANY);
    bpf_loop(num_to_send, update_window, ne->fid, 0);

    //Restart the timer using window_start_seq
    map_entry->seq_num = tcp_ctx->window_start_seq;
    int i = bpf_timer_set_callback(&map_entry->timer, timer_callback);
    if(i != 0) {
        bpf_printk("Error while setting callback");
        return;
    }
    i = bpf_timer_start(&map_entry->timer, ONE_SEC, 0);
    if (i != 0) {
        bpf_printk("Timer start failed");
        return;
    }
    else {
        bpf_printk("timer starts successfully");
    }
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

static __always_inline void resend_packet(struct flow_id fid) {
    struct timeout_event *te = bpf_map_lookup_elem(&timeout_array, &fid);
    if(!te) {
        bpf_printk("There is not packet needed to be resent");
        return;
    }
    struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, &fid);
    if(!tcp_ctx) {
        bpf_printk("tcp_ctx does not exist with the fid");
        return;
    }
    if(tcp_ctx->window_start_seq == te->seq_num) {
        struct packet_event *pe = bpf_map_lookup_elem(&window_packets, &tcp_ctx->head);
        if(!pe) {
            bpf_printk("Resent packet not found");
            return;
        }
        send_packet(pe);
    }
}

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
	if (iph + 1 > data_end) {
		return -1;
    }
	hdrsize = iph->ihl * 4;
	if(hdrsize < sizeof(*iph)) {
		return -1;
    }
	if (nh.pos + hdrsize > data_end) {
		return -1;
    }
	nh.pos += hdrsize;
	iphdr = iph;
    __u16 id = bpf_ntohs(iphdr->id);
    bpf_printk("ID: %u", id); 
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
    // For a net event, we reverse the receiver and sender
    struct flow_id reverse_fid;
    __builtin_memset(&reverse_fid, 0, sizeof(reverse_fid));
    reverse_fid.sender_ip = fid.receiver_ip;
    reverse_fid.sender_port = fid.receiver_port;
    reverse_fid.receiver_ip = fid.sender_ip;
    reverse_fid.receiver_port = fid.sender_port;

    // Update data_end
    if (id == 2) {
        struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, &reverse_fid);
        if(!tcp_ctx) {
            bpf_printk("tcp_ctx does not exist with the fid");
            return XDP_DROP;
        }
        tcp_ctx->data = nh.pos;
        tcp_ctx->data_end = data_end;
        bpf_printk("length:%u", tcp_ctx->data_end - tcp_ctx->data);
        bpf_map_update_elem(&tcp_connections, &reverse_fid, tcp_ctx, BPF_ANY);
    }

    if (id == 3) {
        e.type = NET_EVENT;
        e.event_data = &ne;
        ne.fid = &reverse_fid;
        ne.ack = ack;
        dispatcher(&e);
    }
    else if (id == 2) {
        e.type = APP_EVENT;
        e.event_data = &ae;
        ae.fid = &reverse_fid;
        ae.size = data_end - nh.pos;
        dispatcher(&e);
    }
    else if (id == 1) {
        resend_packet(fid);
        return XDP_DROP;
    }

    return XDP_DROP;
}

char _license[] SEC("license") = "GPL";

// static __always_inline void display(struct flow_id *fid) {
//     struct tcp_md *tcp_ctx = bpf_map_lookup_elem(&tcp_connections, fid);
//     if(!tcp_ctx) {
//         bpf_printk("\ntcp_ctx does not exist with the fid");
//         return;
//     }
//     bpf_printk("\nPackets in the window:");
//     for(int i = 0; i < WINDOW_SIZE; i++) {
//         if(i + 1 > tcp_ctx->cur_size) return;
//         __u32 key = (tcp_ctx->head + i) % tcp_ctx->window_size;
//         struct packet_event *pe = bpf_map_lookup_elem(&window_packets, &key);
//         if(!pe) {
//             bpf_printk("The packet does not exist");
//             return;
//         }
//         bpf_printk("Seq num: %u", pe->seq_num);
//     }
// }
