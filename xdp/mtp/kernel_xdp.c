/* SPDX-License-Identifier: GPL-2.0 */

#include <linux/bpf.h>

#include <linux/in.h>

#include <linux/if_ether.h>

#include <time.h>

#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>
#include "../common/parsing_helpers.h"
#include "../common/rewrite_helpers.h"

#include "common_def.h"

#define ONE_SEC 1000000000
#define TEN_SEC 10000000000


// From benchmark: to remove later
struct info {
    __u64 latency;
    __u64 counter;
};

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct info);
    __uint(max_entries, MAX_NUMBER_CORES);
} info_array SEC(".maps");


/*--------------- XSK MAP ---------------*/

struct {
	__uint(type, BPF_MAP_TYPE_XSKMAP);
	__type(key, __u32);
	__type(value, __u32);
	__uint(max_entries, MAX_NUMBER_CORES);
} xsks_map SEC(".maps");

/*--------------- APP EVENT MAPS ---------------*/

struct inner_app_array {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct app_event);
    __uint(max_entries, MAX_EVENT_QUEUE_LEN);
} inner_app_array0 SEC(".maps"), inner_app_array1 SEC(".maps"), inner_app_array2 SEC(".maps"), inner_app_array3 SEC(".maps"),
inner_app_array4 SEC(".maps"), inner_app_array5 SEC(".maps"), inner_app_array6 SEC(".maps"), inner_app_array7 SEC(".maps"),
inner_app_array8 SEC(".maps"), inner_app_array9 SEC(".maps"), inner_app_array10 SEC(".maps"), inner_app_array11 SEC(".maps"),
inner_app_array12 SEC(".maps"), inner_app_array13 SEC(".maps"), inner_app_array14 SEC(".maps"), inner_app_array15 SEC(".maps"),
inner_app_array16 SEC(".maps"), inner_app_array17 SEC(".maps"), inner_app_array18 SEC(".maps"), inner_app_array19 SEC(".maps");

struct outer_app_hash {
    __uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
    __type(key, struct flow_id);
    __uint(max_entries, MAX_NUMBER_FLOWS);
    __array(values, struct inner_app_array);
} outer_app_hash SEC(".maps") = {
    .values = {
        [0] = &inner_app_array0, [1] = &inner_app_array1, [2] = &inner_app_array2, [3] = &inner_app_array3, [4] = &inner_app_array4,
        [5] = &inner_app_array5, [6] = &inner_app_array6, [7] = &inner_app_array7, [8] = &inner_app_array8, [9] = &inner_app_array9,
        [10] = &inner_app_array10, [11] = &inner_app_array11, [12] = &inner_app_array12, [13] = &inner_app_array13, [14] = &inner_app_array14,
        [15] = &inner_app_array15, [16] = &inner_app_array16, [17] = &inner_app_array17, [18] = &inner_app_array18, [19] = &inner_app_array19,
    },
};

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __type(key, struct flow_id);
    __type(value, __u32);
    __uint(max_entries, MAX_NUMBER_FLOWS);
} tail_app_hash SEC(".maps");

/*--------------- TIMER EVENT MAPS ---------------*/

struct inner_timer_array {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct timer_event);
    __uint(max_entries, MAX_EVENT_QUEUE_LEN);
} inner_timer_array0 SEC(".maps"), inner_timer_array1 SEC(".maps"), inner_timer_array2 SEC(".maps"), inner_timer_array3 SEC(".maps"),
inner_timer_array4 SEC(".maps"), inner_timer_array5 SEC(".maps"), inner_timer_array6 SEC(".maps"), inner_timer_array7 SEC(".maps"),
inner_timer_array8 SEC(".maps"), inner_timer_array9 SEC(".maps"), inner_timer_array10 SEC(".maps"), inner_timer_array11 SEC(".maps"),
inner_timer_array12 SEC(".maps"), inner_timer_array13 SEC(".maps"), inner_timer_array14 SEC(".maps"), inner_timer_array15 SEC(".maps"),
inner_timer_array16 SEC(".maps"), inner_timer_array17 SEC(".maps"), inner_timer_array18 SEC(".maps"), inner_timer_array19 SEC(".maps");

struct outer_timer_hash {
    __uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
    __type(key, struct flow_id);
    __uint(max_entries, MAX_NUMBER_FLOWS);
    __array(values, struct inner_timer_array);
} outer_timer_hash SEC(".maps") = {
    .values = {
        [0] = &inner_timer_array0, [1] = &inner_timer_array1, [2] = &inner_timer_array2, [3] = &inner_timer_array3, [4] = &inner_timer_array4,
        [5] = &inner_timer_array5, [6] = &inner_timer_array6, [7] = &inner_timer_array7, [8] = &inner_timer_array8, [9] = &inner_timer_array9,
        [10] = &inner_timer_array10, [11] = &inner_timer_array11, [12] = &inner_timer_array12, [13] = &inner_timer_array13, [14] = &inner_timer_array14,
        [15] = &inner_timer_array15, [16] = &inner_timer_array16, [17] = &inner_timer_array17, [18] = &inner_timer_array18, [19] = &inner_timer_array19,
    },
};


/*--------------- PROG EVENT MAPS ---------------*/

struct inner_prog_array {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct prog_event);
    __uint(max_entries, MAX_EVENT_QUEUE_LEN);
} inner_prog_array0 SEC(".maps"), inner_prog_array1 SEC(".maps"), inner_prog_array2 SEC(".maps"), inner_prog_array3 SEC(".maps"),
inner_prog_array4 SEC(".maps"), inner_prog_array5 SEC(".maps"), inner_prog_array6 SEC(".maps"), inner_prog_array7 SEC(".maps"),
inner_prog_array8 SEC(".maps"), inner_prog_array9 SEC(".maps"), inner_prog_array10 SEC(".maps"), inner_prog_array11 SEC(".maps"),
inner_prog_array12 SEC(".maps"), inner_prog_array13 SEC(".maps"), inner_prog_array14 SEC(".maps"), inner_prog_array15 SEC(".maps"),
inner_prog_array16 SEC(".maps"), inner_prog_array17 SEC(".maps"), inner_prog_array18 SEC(".maps"), inner_prog_array19 SEC(".maps");

struct outer_prog_hash {
    __uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
    __type(key, struct flow_id);
    __uint(max_entries, MAX_NUMBER_FLOWS);
    __array(values, struct inner_prog_array);
} outer_prog_hash SEC(".maps") = {
    .values = {
        [0] = &inner_prog_array0, [1] = &inner_prog_array1, [2] = &inner_prog_array2, [3] = &inner_prog_array3, [4] = &inner_prog_array4,
        [5] = &inner_prog_array5, [6] = &inner_prog_array6, [7] = &inner_prog_array7, [8] = &inner_prog_array8, [9] = &inner_prog_array9,
        [10] = &inner_prog_array10, [11] = &inner_prog_array11, [12] = &inner_prog_array12, [13] = &inner_prog_array13, [14] = &inner_prog_array14,
        [15] = &inner_prog_array15, [16] = &inner_prog_array16, [17] = &inner_prog_array17, [18] = &inner_prog_array18, [19] = &inner_prog_array19,
    },
};

/*--------------- FLOW INFO MAPS ---------------*/

struct inner_flow_info_hash{
    __uint(type, BPF_MAP_TYPE_HASH);
    __type(key, struct flow_id);
    __type(value, struct flow_info);
    __uint(max_entries, MAX_NUMBER_FLOWS);
} inner_flow_info_hash0 SEC(".maps"), inner_flow_info_hash1 SEC(".maps"),inner_flow_info_hash2 SEC(".maps"),
inner_flow_info_hash3 SEC(".maps"), inner_flow_info_hash4 SEC(".maps"),inner_flow_info_hash5 SEC(".maps"),
inner_flow_info_hash6 SEC(".maps"), inner_flow_info_hash7 SEC(".maps");

struct outer_flow_info_array {
    __uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
    __uint(max_entries, MAX_NUMBER_CORES);
    __type(key, __u32);
    __array(values, struct inner_flow_info_hash);
} outer_flow_info_array SEC(".maps") = {
    .values = {&inner_flow_info_hash0, &inner_flow_info_hash1, &inner_flow_info_hash2,
    &inner_flow_info_hash3, &inner_flow_info_hash4, &inner_flow_info_hash5,
    &inner_flow_info_hash6, &inner_flow_info_hash7}
};

/*--------------- TIMER TRIGGER MAP ---------------*/

struct timer_trigger_inner_array {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct timer_trigger);
    __uint(max_entries, MAX_NUMBER_TIMERS);
}  timer_trigger_inner_array0 SEC(".maps"), timer_trigger_inner_array1 SEC(".maps"), timer_trigger_inner_array2 SEC(".maps"), timer_trigger_inner_array3 SEC(".maps"),
timer_trigger_inner_array4 SEC(".maps"), timer_trigger_inner_array5 SEC(".maps"), timer_trigger_inner_array6 SEC(".maps"), timer_trigger_inner_array7 SEC(".maps"),
timer_trigger_inner_array8 SEC(".maps"), timer_trigger_inner_array9 SEC(".maps"), timer_trigger_inner_array10 SEC(".maps"), timer_trigger_inner_array11 SEC(".maps"),
timer_trigger_inner_array12 SEC(".maps"), timer_trigger_inner_array13 SEC(".maps"), timer_trigger_inner_array14 SEC(".maps"), timer_trigger_inner_array15 SEC(".maps"),
timer_trigger_inner_array16 SEC(".maps"), timer_trigger_inner_array17 SEC(".maps"), timer_trigger_inner_array18 SEC(".maps"), timer_trigger_inner_array19 SEC(".maps");

struct timer_trigger_outer_hash {
    __uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
    __type(key, struct flow_id);
    __uint(max_entries, MAX_NUMBER_FLOWS);
    __array(values, struct timer_trigger_inner_array);
} timer_trigger_outer_hash SEC(".maps") = {
    .values = {
        [0] = &timer_trigger_inner_array0, [1] = &timer_trigger_inner_array1, [2] = &timer_trigger_inner_array2, [3] = &timer_trigger_inner_array3, [4] = &timer_trigger_inner_array4,
        [5] = &timer_trigger_inner_array5, [6] = &timer_trigger_inner_array6, [7] = &timer_trigger_inner_array7, [8] = &timer_trigger_inner_array8, [9] = &timer_trigger_inner_array9,
        [10] = &timer_trigger_inner_array10, [11] = &timer_trigger_inner_array11, [12] = &timer_trigger_inner_array12, [13] = &timer_trigger_inner_array13, [14] = &timer_trigger_inner_array14,
        [15] = &timer_trigger_inner_array15, [16] = &timer_trigger_inner_array16, [17] = &timer_trigger_inner_array17, [18] = &timer_trigger_inner_array18, [19] = &timer_trigger_inner_array19,
    },
};

/*--------------- CONTEXT HASH MAP ---------------*/

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __type(key, struct flow_id);
    __type(value, struct context);
    __uint(max_entries, MAX_NUMBER_FLOWS);
} context_hash SEC(".maps");


/*---------------  ---------------*/

struct {
    __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
    __type(key, __u32);
    __type(value, struct prog_event);
    __uint(max_entries, 1);
} percpu_array SEC(".maps");


static __always_inline int initialize_timer(struct timer_event, struct flow_id, __u32, __u64);


// Note: make this function more complex in the future
static __always_inline void define_minor_type(struct net_event *net_ev) {
    net_ev->event_type = ACK;
}

// TODO: implement the hash map
static __always_inline int parse_packet(struct xdp_md *ctx, struct net_event *net_ev) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data     = (void *)(long)ctx->data;

    /*bpf_xdp_adjust_tail(ctx, 3440);

    data_end = (void *)(long)ctx->data_end;
    data     = (void *)(long)ctx->data;

    bpf_printk("\n%d %d", data, data_end);
    bpf_printk("%d\n", data_end - data);*/

    //bpf_printk("\nRX queue index: %u", ctx->rx_queue_index);

    struct ethhdr *eth;
    struct iphdr *iphdr;
    struct tcphdr *tcph;

    struct hdr_cursor nh;
    int eth_type, ip_type;

    nh.pos = data;

    eth_type = parse_ethhdr(&nh, data_end, &eth);
    if (eth_type != bpf_htons(ETH_P_IP)) {
        //bpf_printk("\nDropped at eth. Type: %x\n\n", bpf_ntohs(eth_type));
        return 0;
    }


    //bpf_printk("\nSource MAC p1: %x:%x:%x",
    //           eth->h_source[0], eth->h_source[1], eth->h_source[2]);
    //bpf_printk("\nSource MAC p2: %x:%x:%x",
    //           eth->h_source[3], eth->h_source[4], eth->h_source[5]);

    //bpf_printk("\nDest MAC p1: %x:%x:%x",
    //           eth->h_dest[0], eth->h_dest[1], eth->h_dest[2]);
    //bpf_printk("\nDest MAC p2: %x:%x:%x",
    //           eth->h_dest[3], eth->h_dest[4], eth->h_dest[5]);
    //bpf_printk("\nEtherType: %x", bpf_ntohs(eth->h_proto));

    ip_type = parse_iphdr(&nh, data_end, &iphdr);
    //bpf_printk("\nIP Type v1: %x", bpf_ntohs(ip_type));
    //bpf_printk("\nIP Type v2: %x", ip_type);
    //bpf_printk("\nIP Type: %x", IPPROTO_TCP);
    if(ip_type != IPPROTO_TCP) {
        //bpf_printk("\nDropped at IP\n\n");
        return 0;
    }

    __be32 saddr = iphdr->saddr; 
    __u8 src_ip;
    src_ip = saddr & 0xFF;
    src_ip = ((saddr >> 8) & 0xFF) ^ src_ip;
    src_ip = ((saddr >> 16) & 0xFF) ^ src_ip;
    src_ip = ((saddr >> 24) & 0xFF) ^ src_ip;
    net_ev->ev_flow_id.src_ip = src_ip;
    //bpf_printk("\nSource IP XOR: %d", src_ip);

    ////bpf_printk("\nsaddr: %d", saddr);
    /*unsigned char src_ip[4];
    src_ip[0] = saddr & 0xFF;
    src_ip[1] = (saddr >> 8) & 0xFF;
    src_ip[2] = (saddr >> 16) & 0xFF;
    src_ip[3] = (saddr >> 24) & 0xFF;*/

    __be32 daddr = iphdr->daddr;
    __u8 dst_ip;
    dst_ip = daddr & 0xFF;
    dst_ip = ((daddr >> 8) & 0xFF) ^ dst_ip;
    dst_ip = ((daddr >> 16) & 0xFF) ^ dst_ip;
    dst_ip = ((daddr >> 24) & 0xFF) ^ dst_ip;
    net_ev->ev_flow_id.dest_ip = dst_ip;

    //bpf_printk("\nDestination IP XOR: %d", dst_ip);
    /*unsigned char dst_ip[4];
    bpf_printk("\ndaddr: %d", daddr);
    dst_ip[0] = daddr & 0xFF;
    dst_ip[1] = (daddr >> 8) & 0xFF;
    dst_ip[2] = (daddr >> 16) & 0xFF;
    dst_ip[3] = (daddr >> 24) & 0xFF;*/
    
    /*bpf_printk("\nSource IP p1: %d.%d", src_ip[0], src_ip[1]);
    bpf_printk("\nSource IP p2: %d.%d", src_ip[2], src_ip[3]);
    bpf_printk("\nDestination IP p1: %d.%d", dst_ip[0], dst_ip[1]);
    bpf_printk("\nDestination IP p2: %d.%d", dst_ip[2], dst_ip[3]);*/
    
    if(parse_tcphdr(&nh, data_end, &tcph) ==  -1) {
        //bpf_printk("\nDropped at TCP\n\n");
        return 0;
    }

    __be16 sport = bpf_ntohs(tcph->source);
    __u8 src_port;
    src_port = sport & 0xFF;
    src_port = ((sport >> 8) & 0xFF) ^ src_port;
    net_ev->ev_flow_id.src_port = src_port;

    __be16 dport = bpf_ntohs(tcph->dest);
    __u8 dst_port;
    dst_port = dport & 0xFF;
    dst_port = ((dport >> 8) & 0xFF) ^ dst_port;
    net_ev->ev_flow_id.dest_port = dst_port;
    
    /*bpf_printk("\nDestination port: %d\n\n", num);
    tcph->dest = bpf_htons(bpf_ntohs(tcph->dest) - 1);*/

    //bpf_printk("\nSource port: %d", bpf_ntohs(tcph->source));
    //bpf_printk("\nDestination port: %d\n\n", bpf_ntohs(tcph->dest));

    define_minor_type(net_ev);

    return 1;
}

/*static __always_inline int modify_fake_packet(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data     = (void *)(long)ctx->data;

    void* pos = data;

    struct test *teste = pos;
    if (teste + 1 > data_end)
		return -1;

    pos = teste + 1;
    teste = data;
    teste->value = teste->value + 1;

    return 0;
}*/

static __always_inline void update_app_len(struct app_info *app_info, struct flow_id ev_flow_id) {
    // Note: change this later when we can dynamicaly assign entries to MoM arrays
    struct flow_id key = {0, 0, 0, 0};
    __u32 *app_tail = bpf_map_lookup_elem(&tail_app_hash, &key);
    //__u32 *app_tail = bpf_map_lookup_elem(&tail_app_hash, &ev_flow_id);
    if(!app_tail) {
        __u32 new_tail = 0;
        // Note: change this later when we can dynamicaly assign entries to MoM arrays
        //bpf_map_update_elem(&tail_app_hash, &ev_flow_id, &new_tail, BPF_NOEXIST);
        //app_tail = bpf_map_lookup_elem(&tail_app_hash, &ev_flow_id);
        bpf_map_update_elem(&tail_app_hash, &key, &new_tail, BPF_NOEXIST);
        app_tail = bpf_map_lookup_elem(&tail_app_hash, &key);
        if(!app_tail) {
            bpf_printk("update_app_len: couldn't get entry from app tail map");
            return;
        }
    }
    app_info->app_tail = *app_tail;
    app_info->len_app_queue = (app_info->app_tail - app_info->app_head + MAX_EVENT_QUEUE_LEN) % MAX_EVENT_QUEUE_LEN;
}


static __always_inline struct flow_info * find_flow_info(struct flow_id ev_flow_id, int cpu_id) {
    struct inner_flow_info_hash *flow_info_hash = bpf_map_lookup_elem(&outer_flow_info_array, &cpu_id);
    if(!flow_info_hash) {
        bpf_printk("find_flow_info: Couldn't get entry from flow info outer map");
        return NULL;
    }
    struct flow_info *f_info = bpf_map_lookup_elem(flow_info_hash, &ev_flow_id);
    if(!f_info) {
        struct flow_info new_f_info = {{0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0}};
        bpf_map_update_elem(flow_info_hash, &ev_flow_id, &new_f_info, BPF_NOEXIST);
        f_info = bpf_map_lookup_elem(flow_info_hash, &ev_flow_id);
        if(!f_info) {
            bpf_printk("find_flow_info: Couldn't get entry from flow info inner map");
            return NULL;
        }
        return f_info;
    }
    return f_info;
}

static __always_inline int try_to_enqueue(void * map, void * event,
    struct flow_id flow, int * queue_len, int *tail) {

    if(*queue_len == MAX_EVENT_QUEUE_LEN - 1) {
        bpf_printk("Queue is full: unable to enqueue event");
        return 0;
    }

    // Note: change here after I update userspace program to establish entries to hash MoM
    struct flow_id key = {0, 0, 0, 0};
    void *inner_array = bpf_map_lookup_elem(map, &key);
    if(!inner_array) {
        bpf_printk("try_to_enqueue: Couldn't get entry from outer map");
        return 0;
    }

    if(bpf_map_update_elem(inner_array, tail, event, BPF_ANY)) {
        bpf_printk("try_to_enqueue: Couldn't update entry from inner map");
        return 0;
    }

    if(*tail < MAX_EVENT_QUEUE_LEN - 1)
        *tail += 1;
    else
        *tail = 0;
    
    *queue_len += 1;
    
    return 1;
}

static __always_inline void generic_event_enqueue(void * event, enum major_event_type type, int cpu_id) {
    switch (type)
    {
    case PROG_EVENT:
    {
        bpf_printk("PROG_EVENT");
        struct prog_event enq_event = *(struct prog_event *) event;
        struct flow_info *f_info = find_flow_info(enq_event.ev_flow_id, cpu_id);
        if(!f_info)
            return;
        if(!try_to_enqueue(&outer_prog_hash, event, enq_event.ev_flow_id, &(f_info->prog_info.len_prog_queue),
            &(f_info->prog_info.prog_tail))) {
            bpf_printk("Unable to enqueue PROG_EVENT");
        }
        break;
    }
    
    default:
        return;
    }
}

/*static __u64 loop_hash_info(struct bpf_map *map, struct flow_id *key, struct flow_info *val, struct flow_loop_data *data) {
    __u32 current_max = data->len_app_queue + data->len_net_queue + data->len_timer_queue + data->len_prog_queue;

    __u32 current_sum = val->app_info.len_app_queue + val->net_info.len_net_queue +
        val->timer_info.len_timer_queue + val->prog_info.len_prog_queue;

    if(current_sum > current_max) {
        data->len_app_queue = val->app_info.len_app_queue;
        data->len_net_queue = val->net_info.len_net_queue;
        data->len_timer_queue = val->timer_info.len_timer_queue;
        data->len_prog_queue = val->prog_info.len_prog_queue;
        data->f_id = *key;
    }

    return 0;
}

// TODO: process only the events with the same flow of the arriving packet
static __always_inline int next_flow(struct flow_id *flow, int cpu_id) {
    struct inner_flow_info_hash *flow_info_hash = bpf_map_lookup_elem(&outer_flow_info_array, &cpu_id);
    if(!flow_info_hash) {
        bpf_printk("next_flow: Couldn't get entry from flow info outer map");
        return 0;
    }
    
    struct flow_loop_data data = {{0, 0, 0, 0}, 0, 0, 0, 0};

    bpf_for_each_map_elem(flow_info_hash, loop_hash_info, &data, 0);

    if(data.f_id.src_ip == 0 && data.f_id.dest_ip == 0 &&
        data.f_id.src_port == 0 && data.f_id.dest_port == 0)
        return 0;

    *flow = data.f_id;

    return 1;
}*/

static __always_inline int next_event(struct flow_info * f_info, int cpu_id) {
    /*struct inner_flow_info_hash *flow_info_hash = bpf_map_lookup_elem(&outer_flow_info_array, &cpu_id);
    if(!flow_info_hash) {
        bpf_printk("next_event: Couldn't get entry from flow info outer map");
        return -1;
    }
    struct flow_info *f_info = bpf_map_lookup_elem(flow_info_hash, &flow_id);
    if(!f_info) {
        bpf_printk("next_event: Couldn't get entry from flow info inner map");
        return -1;
    }*/
    
    // App, net, timer, prog. App has the lowest priority, timer has the highest
    __u32 type_priorities[3] = {1, 3, 2};
    type_priorities[0] *= f_info->app_info.len_app_queue;
    type_priorities[1] *= f_info->timer_info.len_timer_queue;
    type_priorities[2] *= f_info->prog_info.len_prog_queue;

    bpf_printk("APP: %d", type_priorities[0]);
    bpf_printk("TIMER: %d PROG: %d", type_priorities[1], type_priorities[2]);

    __u32 sum = type_priorities[0] + type_priorities[1] + type_priorities[2];
    if(sum == 0)
        return -1;

    __u32 max_prio = 0;
    int type = 0;
    for(int i = 0; i < 3; i++) {
        if(type_priorities[i] > max_prio) {
            max_prio = type_priorities[i];
            type = i;
        }
    }

    return type;
}

static __always_inline void * timer_event_dequeue(struct flow_id f_id,
    __u64 * queue_len, int * head) {
    if(__sync_fetch_and_or(queue_len, 0) == 0) {
        bpf_printk("timer_event_dequeue: queue is empty, unable to dequeue an event");
        return NULL;
    }

    // Note: change here also after I update userspace program to establish series to hash MoM
    struct flow_id key = {0, 0, 0, 0};
    
    void * inner_flow_array = bpf_map_lookup_elem(&outer_timer_hash, &key);
    //void * inner_flow_array = bpf_map_lookup_elem(outer_event_hash, &f_id);
    if(!inner_flow_array) {
        bpf_printk("event_dequeue: Couldn't get entry from flow info outer map");
        return NULL;
    }

    struct timer_event * event = (struct timer_event *) bpf_map_lookup_elem(inner_flow_array, head);
    if(!event) {
        bpf_printk("event_dequeue: Couldn't get entry from flow info inner map");
        return NULL;
    }

    if(__sync_fetch_and_or(&event->valid_bit, 0)) {
        if(*head < MAX_EVENT_QUEUE_LEN - 1)
            *head += 1;
        else
            *head = 0;
        
        __sync_fetch_and_add(queue_len, -1);

        __sync_fetch_and_xor(&event->valid_bit, 1);

        return event;
    } else {
        bpf_printk("timer_event_dequeue: couldn't dequeue because event is invalid");
    }
    return NULL;
}

static __always_inline void * generic_event_dequeue(void * outer_event_hash, struct flow_id f_id,
    int * queue_len, int * head) {
    if(*queue_len == 0) {
        bpf_printk("prog_event_dequeue: queue is empty, unable to dequeue an event");
        return NULL;
    }

    // Note: change here also after I update userspace program to establish series to hash MoM
    struct flow_id key = {0, 0, 0, 0};
    
    void * inner_flow_array = bpf_map_lookup_elem(outer_event_hash, &key);
    //void * inner_flow_array = bpf_map_lookup_elem(outer_event_hash, &f_id);
    if(!inner_flow_array) {
        bpf_printk("event_dequeue: couldn't get entry from flow info outer map");
        return NULL;
    }

    void * event = bpf_map_lookup_elem(inner_flow_array, head);
    if(!event) {
        bpf_printk("event_dequeue: couldn't get entry from flow info inner map");
        return NULL;
    }

    if(*head < MAX_EVENT_QUEUE_LEN - 1)
        *head += 1;
    else
        *head = 0;
    
    *queue_len -= 1;

    return event;
}

static __always_inline int timer_event_enqueue(void *map, struct flow_id *flow, struct timer_trigger *val) {
    struct timer_event event = val->t_event;
    event.valid_bit = 1;
    __u32 cpu_id = val->cpu_id;

    bpf_printk("TIMER_EVENT");
    struct flow_info *f_info = find_flow_info(event.ev_flow_id, cpu_id);
    if(!f_info)
        return 0;
    __u64 * executing = &f_info->timer_info.executing_enqueue;
    __u64 * queue_len = &f_info->timer_info.len_timer_queue;
    __u32 * tail = &f_info->timer_info.timer_tail;

    if(__sync_fetch_and_or(executing, 0)) {
        bpf_printk("try_to_enqueue_timer: timer enqueue currently executing");
        // TODO: reset timer
        bpf_timer_start(&val->timer, ONE_SEC, 0);
        return 0;
    }
    val->triggered = 0;

    // Set executing bit to 1
    __sync_fetch_and_xor(executing, 1);

    // Question: do we even need this check? For other event types the events are dropped,
    // so I'm doing the same here
    if(__sync_fetch_and_or(queue_len, 0) == MAX_EVENT_QUEUE_LEN - 1) {
        bpf_printk("try_to_enqueue_timer: queue is full, unable to enqueue event");
        __sync_fetch_and_xor(executing, 1);
        return 0;
    }

    // Note: change here after I update userspace program to establish entries to hash MoM
    //struct inner_net_array *inner_array = bpf_map_lookup_elem(map, &flow);
    struct flow_id key = {0, 0, 0, 0};
    struct inner_timer_array *inner_array = bpf_map_lookup_elem(&outer_timer_hash, &key);
    if(!inner_array) {
        bpf_printk("try_to_enqueue_timer: couldn't get entry from outer map");
        __sync_fetch_and_xor(executing, 1);
        return 0;
    }

    if(bpf_map_update_elem(inner_array, tail, &event, BPF_ANY)) {
        bpf_printk("try_to_enqueue_timer: couldn't update entry from inner map");
        __sync_fetch_and_xor(executing, 1);
        return 0;
    }

    if(*tail < MAX_EVENT_QUEUE_LEN - 1)
        *tail += 1;
    else
        *tail = 0;
    
    __sync_fetch_and_add(queue_len, 1);

    __sync_fetch_and_xor(executing, 1);
    
    return 0;
}

/*static int create_timer_event(void *map, struct flow_id *flow, struct timer_trigger *val) {
    val->triggered = 0;
    struct timer_event new_event = val->t_event;
    new_event.valid_bit = 1;
    __u32 cpu_id = val->cpu_id;
    timer_event_enqueue(&new_event, cpu_id);

    return 0;
}*/

static __u64 find_timer_index_loop(struct bpf_map *map, __u32 * index,
    struct timer_trigger *map_entry, struct timer_loop_args * arg) {

    arg->index = *index;
    //bpf_printk("TEST %d", arg->index);

    if(!map_entry->triggered)
        return 1;

    // Placeholder value
    if(arg->index == MAX_NUMBER_TIMERS - 1)
        arg->index = NO_TIMER_AVAILABLE;

    return 0;
}

static __always_inline int initialize_timer(struct timer_event event, struct flow_id flow, __u32 cpu_id, __u64 time) {

    // Note: change here later when the hash MoM have entries initialized at userspace
    struct flow_id key = {0, 0, 0, 0};
    struct timer_trigger_inner_array * inner_map = bpf_map_lookup_elem(&timer_trigger_outer_hash, &key);
    //struct timer_trigger_inner_array * inner_map = bpf_map_lookup_elem(&timer_trigger_outer_hash, &flow);
    if(!inner_map) {
        bpf_printk("initialize_timer: Couldn't find outer map entry");
        return -1;
    }

    struct timer_loop_args args;
    bpf_for_each_map_elem(inner_map, find_timer_index_loop, &args, 0);

    // Note: this might be difficult to happen, but what if we don't have any more timers for a flow available?
    if(args.index == NO_TIMER_AVAILABLE) {
        bpf_printk("initialize_timer: There is no timer available for this flow");
        return -1;
    }

    struct timer_trigger *map_entry = bpf_map_lookup_elem(inner_map, &(args.index));
    if(!map_entry) {
        bpf_printk("initialize_timer: Couldn't find inner map entry");
        return -1;
    }

    map_entry->t_event = event;
    map_entry->cpu_id = cpu_id;
    map_entry->triggered = 1;

    long int err = bpf_timer_init(&(map_entry->timer), inner_map, CLOCK_BOOTTIME);
    /*if(i != 0) {
        bpf_printk("Error while initializing timer: %ld", i);
    }*/

    // Sets the function to be called after the timer triggers
    err = bpf_timer_set_callback(&(map_entry->timer), timer_event_enqueue);
    if(err != 0) {
        bpf_printk("Error while setting callback: %ld", err);
    }

    bpf_timer_start(&(map_entry->timer), time, 0);

    return 0;
}

static __always_inline int example_ep(struct net_event *event, struct context *ctx,
    __u32 cpu_id, struct intermediate_output *inter_output, struct prog_event *new_prog_events) {
    int counter_prog_ev = 0;

    struct timer_event new_event;
    new_event.ev_flow_id = event->ev_flow_id;
    new_event.event_type = MISS_ACK;
    new_event.value = 0;
    initialize_timer(new_event, new_event.ev_flow_id, cpu_id, TEN_SEC);

    /*for(int i = 0; i < 1; i++) {
        struct prog_event new_prog_ev;
        new_prog_ev.ev_flow_id = event->ev_flow_id;
        new_prog_ev.event_type = PROG_TEST;
        new_prog_ev.value = 0;
        new_prog_events[i] = &new_prog_ev;
        counter_prog_events += 1;
    }

    for(int i = 0; i < counter_prog_events; i++) {
        event_enqueue(new_prog_events[i], PROG_EVENT, cpu_id);
    }*/

    for(int i = 0; i < /*10*/7; i++) {
        new_prog_events[i].ev_flow_id = event->ev_flow_id;
        new_prog_events[i].event_type = PROG_TEST;
        new_prog_events[i].value = 0;

        counter_prog_ev++;
    }

    return counter_prog_ev;
}

static __always_inline struct context * retrieve_ctx(struct flow_id flow) {
    struct context *ctx = bpf_map_lookup_elem(&context_hash, &flow);
    if(!ctx) {
        struct context new_ctx = {0, 0, 0};
        bpf_map_update_elem(&context_hash, &flow, &new_ctx, BPF_NOEXIST);
        ctx = bpf_map_lookup_elem(&context_hash, &flow);
        if(!ctx) {
            return NULL;
        }
        return ctx;
    }
    return ctx;
}

static __always_inline void dispatcher(void * event, enum minor_event_type type, struct flow_id flow, __u32 cpu_id) {
    struct context *ctx = retrieve_ctx(flow);
    struct intermediate_output inter_output;
    struct prog_event new_prog_events[MAX_NUMBER_PROG_EVENTS];
    int num_ret_events = 0;

    if(!ctx) {
        bpf_printk("dispatcher: Couldn't retrive ctx");
        return;
    }

    switch (type)
    {
    case SEND:
        bpf_printk("SEND");
        break;
    
    case ACK:
        bpf_printk("ACK");
        num_ret_events = example_ep(event, ctx, cpu_id, &inter_output, new_prog_events);
        /*for(int i = 0; i < num_ret_events; i++) {
            struct prog_event teste = new_prog_events[i];
            event_enqueue(&teste, PROG_EVENT, cpu_id);
        }*/
        bpf_printk("%d", num_ret_events);
        struct prog_event teste = new_prog_events[0];
        generic_event_enqueue(&teste, PROG_EVENT, cpu_id);
        teste = new_prog_events[1];
        generic_event_enqueue(&teste, PROG_EVENT, cpu_id);
        /*int key = 0;
        struct prog_event * teste2 = bpf_map_lookup_elem(&percpu_array, &key);
        if(!teste2)
            return;
        teste2->value10 = 11;*/
        /*teste = new_prog_events[7];
        event_enqueue(&teste, PROG_EVENT, cpu_id);
        teste = new_prog_events[8];
        event_enqueue(&teste, PROG_EVENT, cpu_id);
        teste = new_prog_events[9];
        event_enqueue(&teste, PROG_EVENT, cpu_id);*/
        break;
    
    case MISS_ACK:
        bpf_printk("MISS_ACK");
        break;
    
    case PROG_TEST:
        bpf_printk("PROG_TEST");
        break;
    
    default:
        return;
    }
}

static long scheduler_loop(__u32 index, struct sched_loop_args * arg) {
    __u32 cpu_id = arg->cpu_id;
    struct flow_info *f_info = arg->f_info;
    struct flow_id f_id = arg->f_id;
    //struct flow_id chosen_flow = arg->flow;
    //struct flow_id chosen_flow = {0, 0, 0, 0};
    /*struct flow_id chosen_flow;
    if(!next_flow(&chosen_flow, cpu_id))
        return 1;*/

    //bpf_printk("%d %d", chosen_flow.src_ip, chosen_flow.dest_ip);
    //bpf_printk("%d %d", chosen_flow.src_port, chosen_flow.dest_port);

    int returned_type = next_event(f_info, cpu_id);
    if(returned_type == -1)
        return 1;

    /*struct flow_info *f_info = find_flow_info(chosen_flow, cpu_id);
    if(!f_info)
        return 1;*/

    switch (returned_type)
    {
    case APP_EVENT:
    {
        bpf_printk("APP_EVENT IS THE LARGEST");
        struct app_event * ev = (struct app_event *) generic_event_dequeue(&outer_app_hash, f_id,
            &(f_info->app_info.len_app_queue), &(f_info->app_info.app_head));
        if(!ev)
            return 1;
        struct app_event new_ev;
        new_ev.ev_flow_id = ev->ev_flow_id;
        new_ev.event_type = ev->event_type;
        new_ev.occupied = ev->occupied;
        new_ev.value = new_ev.value;
        // Set occupied bit to 0
        __sync_fetch_and_xor(&ev->occupied, 1);
        dispatcher(&new_ev, new_ev.event_type, new_ev.ev_flow_id, cpu_id);
        break;
    }
    
    case TIMER_EVENT:
    {
        bpf_printk("TIMER_EVENT IS THE LARGEST");
        struct timer_event * ev = (struct timer_event *) timer_event_dequeue(f_id,
            &(f_info->timer_info.len_timer_queue), &(f_info->timer_info.timer_head));
        if(!ev)
            return 1;
        dispatcher(ev, ev->event_type, ev->ev_flow_id, cpu_id);
        break;
    }
    
    case PROG_EVENT:
    {
        bpf_printk("PROG_EVENT IS THE LARGEST");
        struct prog_event * ev = (struct prog_event *) generic_event_dequeue(&outer_prog_hash, f_id,
            &(f_info->prog_info.len_prog_queue), &(f_info->prog_info.prog_head));
        if(!ev)
            return 1;
        dispatcher(ev, ev->event_type, ev->ev_flow_id, cpu_id);
        break;
    }
    
    default:
        return 1;
    }
    return 0;
}


/*static __always_inline void scheduler(void * event, enum major_event_type major_type,
    struct xdp_md *ctx, int cpu_id) {

    event_enqueue(event, major_type, cpu_id);

    //struct net_event teste = *(struct net_event *) event;
    //bpf_printk("%d %d", teste.ev_flow_id.src_ip, teste.ev_flow_id.dest_ip);
    //bpf_printk("%d %d", teste.ev_flow_id.src_port, teste.ev_flow_id.dest_port);

    struct sched_loop_args arg = {cpu_id};

    // Note: this constant is a placeholder. In the future, we'll have a variable
    // that will dictate the amount of times the loop is executed
    bpf_loop(MAX_NUM_PROCESSED_EVENTS, scheduler_loop, &arg, 0);
}*/

// TODO: think about other name for this module
SEC("xdp")
int rx_module(struct xdp_md *ctx)
{
    __u64 arrival_time = bpf_ktime_get_ns();

    //ctx->data_end += 5;

    int rx_queue_index = ctx->rx_queue_index;
    struct net_event net_ev;

    if(!parse_packet(ctx, &net_ev))
        return XDP_DROP;

    int cpu = bpf_get_smp_processor_id();

    // Process network event first
    dispatcher(&net_ev, net_ev.event_type, net_ev.ev_flow_id, cpu);

    struct sched_loop_args arg;
    arg.cpu_id = cpu;
    arg.f_info = find_flow_info(net_ev.ev_flow_id, cpu);
    arg.f_id = net_ev.ev_flow_id;
    if(!arg.f_info)
        return XDP_DROP;

    update_app_len(&arg.f_info->app_info, arg.f_id);
    bpf_printk("\n%d %d\n", arg.f_info->timer_info.len_timer_queue, arg.f_info->app_info.len_app_queue);
    bpf_printk("\n%d\n", arg.f_info->prog_info.len_prog_queue);

    bpf_loop(MAX_NUM_PROCESSED_EVENTS, scheduler_loop, &arg, 0);


    // Note: TO DO -> differentiate between app and net events
    //scheduler((void *) &net_ev, NET_EVENT, ctx, cpu);

    //modify_fake_packet(ctx);

    //initialize_timer(cpu);

    /* An entry here means that the correspnding queue_id
     * has an active AF_XDP socket bound to it. */
    if (bpf_map_lookup_elem(&xsks_map, &rx_queue_index)) {
        __u64 finish_time = bpf_ktime_get_ns();
        struct info *value = bpf_map_lookup_elem(&info_array, &cpu);
        if(!value)
            return XDP_DROP;
        value->counter += 1;
        value->latency += (finish_time - arrival_time);
        //bpf_printk("TEST %d %d", cpu, rx_queue_index);
        return bpf_redirect_map(&xsks_map, rx_queue_index, 0);
	}

    return XDP_DROP;
}
// TODO: compare before and after doing the simplifications

char _license[] SEC("license") = "GPL";