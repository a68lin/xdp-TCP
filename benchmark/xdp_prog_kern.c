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

#define MAX_NUMBER_CORES 16

struct map_locked_value {
    __u64 value;
    struct bpf_spin_lock lock;
};

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct map_locked_value);
    __uint(max_entries, MAX_NUMBER_CORES);
} lock_array SEC(".maps");

struct inner_map_array {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, __u64);
    __uint(max_entries, MAX_NUMBER_CORES);
} inner_map_array0 SEC(".maps"), inner_map_array1 SEC(".maps"), inner_map_array2 SEC(".maps"), inner_map_array3 SEC(".maps"),
inner_map_array4 SEC(".maps"), inner_map_array5 SEC(".maps"), inner_map_array6 SEC(".maps"), inner_map_array7 SEC(".maps"),
inner_map_array8 SEC(".maps"), inner_map_array9 SEC(".maps"), inner_map_array10 SEC(".maps"), inner_map_array11 SEC(".maps"),
inner_map_array12 SEC(".maps"), inner_map_array13 SEC(".maps"), inner_map_array14 SEC(".maps"), inner_map_array15 SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
    __uint(max_entries, MAX_NUMBER_CORES);
    __type(key, __u32);
    __array(values, struct inner_map_array);
} outer_map_array SEC(".maps") = {
    .values = {&inner_map_array0, &inner_map_array1, &inner_map_array2, &inner_map_array3,
    &inner_map_array4, &inner_map_array5, &inner_map_array6, &inner_map_array7,
    &inner_map_array8, &inner_map_array9, &inner_map_array10, &inner_map_array11,
    &inner_map_array12, &inner_map_array13, &inner_map_array14, &inner_map_array15}
};

struct inner_map_queue {
    __uint(type, BPF_MAP_TYPE_QUEUE);
    __type(value, __u64);
    __uint(max_entries, 32);
} inner_map_queue0 SEC(".maps"), inner_map_queue1 SEC(".maps"), inner_map_queue2 SEC(".maps"), inner_map_queue3 SEC(".maps"),
inner_map_queue4 SEC(".maps"), inner_map_queue5 SEC(".maps"), inner_map_queue6 SEC(".maps"), inner_map_queue7 SEC(".maps"),
inner_map_queue8 SEC(".maps"), inner_map_queue9 SEC(".maps"), inner_map_queue10 SEC(".maps"), inner_map_queue11 SEC(".maps"),
inner_map_queue12 SEC(".maps"), inner_map_queue13 SEC(".maps"), inner_map_queue14 SEC(".maps"), inner_map_queue15 SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
    __uint(max_entries, MAX_NUMBER_CORES);
    __type(key, __u32);
    __array(values, struct inner_map_queue);
} outer_map_queue SEC(".maps") = {
    .values = {&inner_map_queue0, &inner_map_queue1, &inner_map_queue2, &inner_map_queue3,
    &inner_map_queue4, &inner_map_queue5, &inner_map_queue6, &inner_map_queue7,
    &inner_map_queue8, &inner_map_queue9, &inner_map_queue10, &inner_map_queue11,
    &inner_map_queue12, &inner_map_queue13, &inner_map_queue14, &inner_map_queue15}
};

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, __u64);
    __uint(max_entries, MAX_NUMBER_CORES);
} common_array SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
    __type(key, __u32);
    __type(value, __u64);
    __uint(max_entries, MAX_NUMBER_CORES);
} percpu_array SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, __u64);
    __uint(max_entries, MAX_NUMBER_CORES);
} counter_array SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, __u64);
    __uint(max_entries, MAX_NUMBER_CORES);
} time_array SEC(".maps");

struct map_elem {
    __u64 value;
};

struct hash_key {
    int cpu;
};

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __type(key, struct hash_key);
    __type(value, __u64);
    __uint(max_entries, MAX_NUMBER_CORES);
} common_hash SEC(".maps");

struct inner_array_hash {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct map_elem);
    __uint(max_entries, 32);
} inner_array_hash0 SEC(".maps"), inner_array_hash1 SEC(".maps"), inner_array_hash2 SEC(".maps"),
inner_array_hash3 SEC(".maps"), inner_array_hash4 SEC(".maps"), inner_array_hash5 SEC(".maps"),
inner_array_hash6 SEC(".maps"), inner_array_hash7 SEC(".maps"), inner_array_hash8 SEC(".maps"),
inner_array_hash9 SEC(".maps"), inner_array_hash10 SEC(".maps"), inner_array_hash11 SEC(".maps"),
inner_array_hash12 SEC(".maps"), inner_array_hash13 SEC(".maps"), inner_array_hash14 SEC(".maps"),
inner_array_hash15 SEC(".maps");

struct outer_map_hash {
    __uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
    __type(key, struct hash_key);
    __uint(max_entries, MAX_NUMBER_CORES);
    __array(values, struct inner_array_hash);
} outer_map_hash SEC(".maps") = {
    .values = {
        [0] = &inner_array_hash0, [1] = &inner_array_hash1, [2] = &inner_array_hash2,
        [3] = &inner_array_hash3, [4] = &inner_array_hash4, [5] = &inner_array_hash5,
        [6] = &inner_array_hash6, [7] = &inner_array_hash7, [8] = &inner_array_hash8,
        [9] = &inner_array_hash9, [10] = &inner_array_hash10, [11] = &inner_array_hash11,
        [12] = &inner_array_hash12, [13] = &inner_array_hash13, [14] = &inner_array_hash14,
        [15] = &inner_array_hash15,
    },
};

/*static __always_inline int parse_packet(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data     = (void *)(long)ctx->data;

    bpf_printk("\nRX queue index: %u", ctx->rx_queue_index);

    struct ethhdr *eth;
    struct iphdr *iphdr;
    struct tcphdr *tcph;

    struct hdr_cursor nh;
    int eth_type, ip_type;

    nh.pos = data;

    eth_type = parse_ethhdr(&nh, data_end, &eth);
    if (eth_type != bpf_htons(ETH_P_IP)) {
        bpf_printk("\nDropped at eth. Type: %x\n\n", bpf_ntohs(eth_type));
        return 0;
    }


    bpf_printk("\nSource MAC p1: %x:%x:%x",
               eth->h_source[0], eth->h_source[1], eth->h_source[2]);
    bpf_printk("\nSource MAC p2: %x:%x:%x",
               eth->h_source[3], eth->h_source[4], eth->h_source[5]);

    bpf_printk("\nDest MAC p1: %x:%x:%x",
               eth->h_dest[0], eth->h_dest[1], eth->h_dest[2]);
    bpf_printk("\nDest MAC p2: %x:%x:%x",
               eth->h_dest[3], eth->h_dest[4], eth->h_dest[5]);
    bpf_printk("\nEtherType: %x", bpf_ntohs(eth->h_proto));

    ip_type = parse_iphdr(&nh, data_end, &iphdr);
    bpf_printk("\nIP Type v1: %x", bpf_ntohs(ip_type));
    bpf_printk("\nIP Type v2: %x", ip_type);
    bpf_printk("\nIP Type: %x", IPPROTO_TCP);
    if(ip_type != IPPROTO_TCP) {
        bpf_printk("\nDropped at IP\n\n");
        return 0;
    }

    unsigned char src_ip[4];
    //unsigned char dst_ip[4];
    __be32 saddr = iphdr->saddr; 
    //bpf_printk("\nsaddr: %d", saddr);
    src_ip[0] = saddr & 0xFF;
    src_ip[1] = (saddr >> 8) & 0xFF;
    src_ip[2] = (saddr >> 16) & 0xFF;
    src_ip[3] = (saddr >> 24) & 0xFF;

    unsigned char dst_ip[4];
    //unsigned char dst_ip[4];
    __be32 daddr = iphdr->daddr;
    //bpf_printk("\ndaddr: %d", daddr);
    dst_ip[0] = daddr & 0xFF;
    dst_ip[1] = (daddr >> 8) & 0xFF;
    dst_ip[2] = (daddr >> 16) & 0xFF;
    dst_ip[3] = (daddr >> 24) & 0xFF;
    
    bpf_printk("\nSource IP p1: %d.%d", src_ip[0], src_ip[1]);
    bpf_printk("\nSource IP p2: %d.%d", src_ip[2], src_ip[3]);
    bpf_printk("\nDestination IP p1: %d.%d", dst_ip[0], dst_ip[1]);
    bpf_printk("\nDestination IP p2: %d.%d", dst_ip[2], dst_ip[3]);
    
    if(parse_tcphdr(&nh, data_end, &tcph) ==  -1) {
        bpf_printk("\nDropped at TCP\n\n");
        return 0;
    }

    bpf_printk("\nSource port: %d", bpf_ntohs(tcph->source));
    bpf_printk("\nDestination port: %d\n\n", bpf_ntohs(tcph->dest));

    return 1;
}*/

static __always_inline __u64 update_counter (int key_cpu) {
    __u64 * value = bpf_map_lookup_elem(&counter_array, &key_cpu);
    if(!value)
        return 0;

    __u64 new_value = (* value) + 1;
    bpf_map_update_elem(&counter_array, &key_cpu, &new_value, BPF_ANY);

    return new_value;
}

static __always_inline int update_time (__u64 arrival_time, __u64 finish_time, int key_cpu) {
    __u64 * value = bpf_map_lookup_elem(&time_array, &key_cpu);
    if(!value)
        return 0;

    __u64 new_value = (* value) + (finish_time - arrival_time);
    bpf_map_update_elem(&time_array, &key_cpu, &new_value, BPF_ANY);

    return 1;
}

static __always_inline int lookup_map (int key, void * map_pointer) {
    __u64 * value = bpf_map_lookup_elem(map_pointer, &key);

    if(!value)
        return 0;

    //bpf_printk("\nCurrent key: %d\nValue: %d", key, *value);

    *value += 1;

    //__u64 new_value = (* value) + 1;
    //bpf_map_update_elem(map_pointer, &key, &new_value, BPF_ANY);

    return 1;
}

// Simply use bpf_get_smp_processor_id in servers other than paper
static __always_inline int get_and_check_cpu_id() {
    int cpu = bpf_get_smp_processor_id();
    if(cpu >= 10)
        cpu -= 10;
    return cpu;
}

SEC("xdp")
int  common_array_lookup_diff_keys(struct xdp_md *ctx)
{
    int cpu = get_and_check_cpu_id();

    // Update counter map
    if(!update_counter(cpu)) {
        bpf_printk("Error while looking up counter map");
    }

    __u64 arrival_time = bpf_ktime_get_ns();

    // Lookup common map
    for(int i = 0; i < 100; i++)
        lookup_map(cpu, &common_array);

    __u64 finish_time = bpf_ktime_get_ns();
    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map");
    }

    return XDP_DROP;
}


// TODO: check if with a HASH map I can have different queues
// or if they are all the same for all CPUs
SEC("xdp")
int  percpu_array_lookup(struct xdp_md *ctx)
{
    int cpu = get_and_check_cpu_id();

    // Update counter map
    if(!update_counter(cpu)) {
        bpf_printk("Error while looking up counter map");
    }

    __u64 arrival_time = bpf_ktime_get_ns();

    // Lookup percpu map
    for(int i = 0; i < 100; i++)
        lookup_map(0, &percpu_array);

    __u64 finish_time = bpf_ktime_get_ns();
    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map");
    }

    return XDP_DROP;
}

SEC("xdp")
int  common_array_lookup_same_keys(struct xdp_md *ctx)
{
    int cpu = get_and_check_cpu_id();

    // Update counter map
    if(!update_counter(cpu)) {
        bpf_printk("Error while looking up counter map\n");
    }

    __u64 arrival_time = bpf_ktime_get_ns();

    // Lookup common map
    for(int i = 0; i < 100; i++)
        lookup_map(0, &common_array);

    __u64 finish_time = bpf_ktime_get_ns();
    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map\n");
    }

    return XDP_DROP;
}


SEC("xdp")
int  simply_drop(struct xdp_md *ctx)
{

    int cpu = get_and_check_cpu_id();

    /*void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    bpf_printk("\nLength of packet: %d", data_end - data);*/

    // Update counter map
    if(!update_counter(cpu)) {
        bpf_printk("Error while looking up counter map\n");
    }

    //parse_packet(ctx);

    __u64 arrival_time = bpf_ktime_get_ns();


    /*int key = 0;
    __u64 * value = bpf_map_lookup_elem(&inner_map_array0, &key);

    if(!value)
        return 0;

    __u64 new_value = (* value) + 1;
    bpf_map_update_elem(&inner_map_array0, &key, &new_value, BPF_ANY);

    struct inner_map_array *map = bpf_map_lookup_elem(&outer_map_array, &key);
    if(!map) {
        bpf_printk("Error while accessing map of maps\n");
        return 0;
    }

    __u64 * value_inner = bpf_map_lookup_elem(map, &key);

    if(!value_inner)
        return 0;

    bpf_printk("%llu", *value_inner);*/


    __u64 finish_time = bpf_ktime_get_ns();
    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map\n");
    }

    return XDP_DROP;
}

static __always_inline __u64 lookup_map_of_maps_queue (int key, __u64 counter/*, int iteration*/) {
    //if(iteration == 0) {
        struct inner_map_queue *map = bpf_map_lookup_elem(&outer_map_queue, &key);

        if(!map) {
            bpf_printk("Error while accessing map of maps\n");
            return 0;
        }

        /*__u64 check_value = -1;
        if(counter > 32) {
            bpf_map_pop_elem(map, &check_value);

            if(check_value != counter - 32) {
                counter = 0;
                //bpf_printk("The queue missed counter %d", check_value + 32);
            }
        }
        
        if(bpf_map_push_elem(map, &counter, BPF_EXIST) < 0) {
            bpf_printk("Error while accessing pushing element to queue\n");
            return 0;
        }*/

        __u64 value;

        if(bpf_map_peek_elem(map, &value) < 0) {
            bpf_printk("Error while reading element from queue\n");
            return 0;
        }

        if(bpf_map_push_elem(map, &counter, BPF_EXIST) < 0) {
            bpf_printk("Error while pushing element to queue\n");
            return 0;
        }
    /*} else {
        key = 8;
        __u64 value = 0;
        struct inner_map *map = bpf_map_lookup_elem(&outer_map, &key);
        if(!map) {
            bpf_printk("Error while accessing map of maps\n");
            return 0;
        }

        bpf_map_pop_elem(map, &value);
        if(bpf_map_push_elem(map, &value, BPF_EXIST) < 0) {
            bpf_printk("Error while accessing pushing element to queue\n");
            return 0;
        }
    }*/

    return counter;
}

SEC("xdp")
int  map_of_maps_queue(struct xdp_md *ctx)
{
    int cpu = get_and_check_cpu_id();

    // Update counter map
    __u64 counter = update_counter(cpu);
    if(counter == 0) {
        bpf_printk("Error while looking up counter map\n");
    }

    __u64 arrival_time = bpf_ktime_get_ns();

    for(int i = 0; i < 100; i++)
        lookup_map_of_maps_queue(cpu, counter/*, i*/);

    __u64 finish_time = bpf_ktime_get_ns();
    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map\n");
    }

    return XDP_DROP;
}

static __always_inline int lookup_map_of_maps_array (int key) {

    struct inner_map_array *map = bpf_map_lookup_elem(&outer_map_array, &key);

    if(!map) {
        bpf_printk("Error while accessing map of maps\n");
        return 0;
    }

    int inner_map_key = 0;
    __u64 * value = bpf_map_lookup_elem(map, &inner_map_key);

    if(!value)
        return 0;

    *value += 1;
    //__u64 new_value = (* value) + 1;
    //bpf_map_update_elem(map, &inner_map_key, &new_value, BPF_ANY);

    return 1;
}

SEC("xdp")
int map_of_maps_array(struct xdp_md *ctx)
{
    int cpu = get_and_check_cpu_id();

    if(!update_counter(cpu)) {
        bpf_printk("Error while looking up counter map\n");
    }

    __u64 arrival_time = bpf_ktime_get_ns();

    for(int i = 0; i < 100; i++)
        lookup_map_of_maps_array(cpu);

    __u64 finish_time = bpf_ktime_get_ns();
    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map\n");
    }

    return XDP_DROP;
}

SEC("xdp")
int gets_cpu_id (struct xdp_md *ctx)
{
    int cpu;

    __u64 arrival_time = bpf_ktime_get_ns();
    // Loop of 10, 20, 50
    for(int i = 0; i < 50; i++)
        cpu = get_and_check_cpu_id();

    __u64 finish_time = bpf_ktime_get_ns();

    if(!update_counter(cpu)) {
        bpf_printk("Error while looking up counter map\n");
    }

    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map\n");
    }

    return XDP_DROP;
}


static __always_inline int lookup_lock_map (int key) {

    struct map_locked_value *lock_value = bpf_map_lookup_elem(&lock_array, &key);

    if(!lock_value) {
        bpf_printk("Error while accessing locked entry\n");
        return 0;
    }

    bpf_spin_lock(&lock_value->lock);
    /*struct map_locked_value new_value;
    new_value.value = lock_value->value + 1;
    new_value.lock = lock_value->lock;
    bpf_map_update_elem(&lock_array, &key, &new_value, BPF_ANY);*/
    //lock_value->value++;
    lock_value->value += 1;
    bpf_spin_unlock(&lock_value->lock);

    return 1;
}

SEC("xdp")
int  lock_map(struct xdp_md *ctx)
{
    int cpu = get_and_check_cpu_id();

    // Update counter map
    if(!update_counter(cpu)) {
        bpf_printk("Error while looking up counter map\n");
    }

    __u64 arrival_time = bpf_ktime_get_ns();

    // Lookup common map
    for(int i = 0; i < 100; i++)
        lookup_lock_map(0);

    __u64 finish_time = bpf_ktime_get_ns();
    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map\n");
    }

    return XDP_DROP;
}


static __always_inline int lookup_map_of_maps_hash (__u64 key) {

    struct hash_key hash_map_key = {key};
    struct inner_array_hash *inner = bpf_map_lookup_elem(&outer_map_hash, &hash_map_key);

    if(!inner) {
        bpf_printk("Error while accessing map of maps\n");
        return 0;
    }

    // Note: we may need to evaluate this series of lookups, since we may need
    // it in the scheduler (to have a hash between flow_id and index of queues)
    /*__u64 *index = bpf_map_lookup_elem(&index_hash, &hash_map_key);
    if(!index) {    // If the map doesn't contain an entry for this key
        __u64 new_value = 0;
        bpf_map_update_elem(&index_hash, &hash_map_key, &new_value, BPF_NOEXIST);
        //bpf_printk("Creating new entry in hash map");
        index = bpf_map_lookup_elem(&index_hash, &hash_map_key);
        if(!index)
            return 0;
    }*/


    struct map_elem *inner_elem = bpf_map_lookup_elem(inner, &key);
    if(!inner_elem) {
        bpf_printk("Couldn't get entry of inner map");
        return 0;
    }

    inner_elem->value += 1;
    //__u64 new_value = (* value) + 1;
    //bpf_map_update_elem(map, &inner_map_key, &new_value, BPF_ANY);

    return 1;
}

SEC("xdp")
int map_of_maps_hash(struct xdp_md *ctx)
{
    int cpu = get_and_check_cpu_id();

    if(!update_counter(cpu)) {
        bpf_printk("Error while looking up counter map\n");
    }

    __u64 arrival_time = bpf_ktime_get_ns();

    //for(int i = 0; i < 100; i++)
        lookup_map_of_maps_hash(cpu);

    __u64 finish_time = bpf_ktime_get_ns();
    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map\n");
    }

    return XDP_DROP;
}

SEC("xdp")
int  common_hash_map(struct xdp_md *ctx)
{
    int cpu = get_and_check_cpu_id();

    // Update counter map
    if(!update_counter(cpu)) {
        bpf_printk("Error while looking up counter map");
    }

    __u64 arrival_time = bpf_ktime_get_ns();

    // Lookup common map
    //for(int i = 0; i < 100; i++) {
        struct hash_key hash_map_key = {cpu};
        struct map_elem *elem = bpf_map_lookup_elem(&common_hash, &hash_map_key);
        if(!elem) {
            __u64 new_value = 0;
            bpf_map_update_elem(&common_hash, &hash_map_key, &new_value, BPF_NOEXIST);
            //bpf_printk("Creating new entry in hash map");
            elem = bpf_map_lookup_elem(&common_hash, &hash_map_key);
            if(!elem) {
                bpf_printk("Error while getting entry from hash map");
                return 0;
            }
        }
        elem->value += 1;
    //}

    __u64 finish_time = bpf_ktime_get_ns();
    if(!update_time(arrival_time, finish_time, cpu)) {
        bpf_printk("Error while looking up timer map");
    }

    return XDP_DROP;
}



char _license[] SEC("license") = "GPL";
