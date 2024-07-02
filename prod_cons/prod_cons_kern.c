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

#define NUMBER_HASH_ENTRIES 10
#define MAX_QUEUE_LEN 15
#define NUMBER_EVENTS_PROC_PER_PACKET 5

int inner_index[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

struct map_elem {
    __u64 occupied;
    __u64 value;
};

struct hash_key {
    int cpu;
};

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __type(key, struct hash_key);
    __type(value, __u64);
    __uint(max_entries, NUMBER_HASH_ENTRIES);
} index_hash SEC(".maps");

struct inner_array {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct map_elem);
    __uint(max_entries, MAX_QUEUE_LEN);
} inner_array0 SEC(".maps"),
inner_array1 SEC(".maps"),
inner_array2 SEC(".maps"),
inner_array3 SEC(".maps"),
inner_array4 SEC(".maps"),
inner_array5 SEC(".maps"),
inner_array6 SEC(".maps"),
inner_array7 SEC(".maps"),
inner_array8 SEC(".maps"),
inner_array9 SEC(".maps");

struct outer_hash {
    __uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
    __type(key, struct hash_key);
    __uint(max_entries, NUMBER_HASH_ENTRIES);
    __array(values, struct inner_array);
} outer_hash SEC(".maps") = {
    .values = {
        [0] = &inner_array0,
        [1] = &inner_array1,
        [2] = &inner_array2,
        [3] = &inner_array3,
        [4] = &inner_array4,
        [5] = &inner_array5,
        [6] = &inner_array6,
        [7] = &inner_array7,
        [8] = &inner_array8,
        [9] = &inner_array9,
    },
};

// Note: it seems that we need to initialize the entries for hash maps
static __u64 * get_array_map(struct hash_key key) {
    __u64 *index = bpf_map_lookup_elem(&index_hash, &key);
    if(!index) {    // If the map doesn't contain an entry for this key
        __u64 new_value = 0;
        bpf_map_update_elem(&index_hash, &key, &new_value, BPF_NOEXIST);
        bpf_printk("Creating new entry in hash map");
        index = bpf_map_lookup_elem(&index_hash, &key);
        if(!index)
            return NULL;
        return index;
    }
    bpf_printk("Found entry in hash map");
    return index;
}

SEC("xdp")
int testing_prod_cons(struct xdp_md *ctx)
{
    // Note: testing arrays. It seems that it is allowing arrays nowadays
    /*struct hash_key i[5];
    i[0].cpu = 50;
    i[1].cpu = 60;
    i[2].cpu = 54;
    i[3].cpu = 1;
    i[4].cpu = 999;
    bpf_printk("%d", i[1].cpu);*/

    __u32 cpu = bpf_get_smp_processor_id();
    bpf_printk("%d", cpu);

    /*  Note: this isn't allowed. "math between map_value pointer and register with unbounded min value is not allowed"
    inner_index[cpu]++;
        Note: int i = cpu; also isn't allowed
        But something like this is allowed:
    if(cpu == 0)
        inner_index[0] = inner_index[0] + 1;
    */
    if(cpu >= 0 && cpu <= 7)
        inner_index[cpu]  = inner_index[cpu] + 1;

    struct hash_key key;
    key.cpu = cpu;

    int i = 0;
    while(i < NUMBER_EVENTS_PROC_PER_PACKET) {
        // Get inner map from outer map
        struct inner_array *inner;
        inner = bpf_map_lookup_elem(&outer_hash, &key);
        if(!inner) {
            bpf_printk("Couldn't get entry of outer map");
            return XDP_DROP;
        }

        // Get index of the next event to be processed
        __u64 *index = get_array_map(key);
        if(!index) {
            bpf_printk("Couldn't get entry of hash map");
            return XDP_DROP;
        }

        // Get the entry of inner map based on the index
        struct map_elem *inner_elem = bpf_map_lookup_elem(inner, index);
        if(!inner_elem) {
            bpf_printk("Couldn't get entry of inner map");
            return XDP_DROP;
        }

        if(!__sync_fetch_and_or(&inner_elem->occupied, 0)/*!inner_elem->occupied*/) {
            bpf_printk("Queue of CPU %d is empty", cpu);
            break;
        }

        // Note: an LLVM error happens if inner_elem->value has 32 bit. 64 bits works well
        __sync_fetch_and_sub(&inner_elem->occupied, 1);
        /*int result = bpf_map_delete_elem(inner, index);
        if(result == 0)
            bpf_printk("Deleted element");
        else
            bpf_printk("Failed to delete element");*/
        //__sync_fetch_and_xor(&inner_elem->value, inner_elem->value);
        //__sync_val_compare_and_swap(&inner_elem->value, inner_elem->value, 12);
        //bpf_printk("%d %d", inner_elem->occupied, inner_elem->value);

        if((*index) < MAX_QUEUE_LEN - 1)
            __sync_fetch_and_add(index, 1);
        else
            __sync_fetch_and_xor(index, *index);

        //bpf_printk("%d", *index);
        i++;
    }

    return XDP_DROP;
}

char _license[] SEC("license") = "GPL";
