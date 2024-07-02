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

#define MAX_NUMBER_CORES 8

#define ONE_SEC 1000000000
#define TEN_SEC 10000000000

struct map_elem {
    int value;
    struct bpf_timer timer;
    //struct xdp_md *packet;
};

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct map_elem);
    __uint(max_entries, MAX_NUMBER_CORES);
} timer_array SEC(".maps");

struct test_elem {
    int test_val;
};

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, __u32);
    __type(value, struct test_elem);
    __uint(max_entries, MAX_NUMBER_CORES);
} test_array SEC(".maps");

static void test_function() {
    bpf_printk("TESTING FUNCTION CALL");
}

int testing_timer(struct xdp_md *ctx);

static int function(void *map, __u32 *key, struct map_elem *val) {
    struct map_elem *entry = bpf_map_lookup_elem(map, key);
    if(!entry) {
        bpf_printk("Couldn't get entry of the map");
        return 0;
    }

    // Testing if you can access/alter other maps
    /*struct test_elem *test = bpf_map_lookup_elem(&test_array, key);
    if(!test) {
        bpf_printk("Couldn't get entry of the map");
        return 0;
    }
    bpf_printk("TEST MAP: %d", test->test_val);
    test->test_val = entry->value;*/

    if(entry->value < 10) {
        bpf_printk("AFTER ENTRY: %d", entry->value);
        bpf_printk("AFTER VAL: %d", val->value);
        val->value = val->value + 1;
        // NOTE: Try if we can call testing_timer with a new packet
        test_function();
        //testing_timer(entry->packet);

        //bpf_timer_start(&entry->timer, ONE_SEC, 0);
    }

    return 0;
}

SEC("xdp")
int testing_timer(struct xdp_md *ctx)
{
    int cpu = bpf_get_smp_processor_id();

    struct map_elem *map_entry;

    map_entry = bpf_map_lookup_elem(&timer_array, &cpu);
    if(!map_entry) {
        bpf_printk("Couldn't get entry of the map");
        return XDP_DROP;
    }

    //map_entry->value = 0;
    //if(map_entry->value == 0)
    //    map_entry->packet = ctx;

    //void *data_end = (void *)(long)ctx->data_end;
	//void *data = (void *)(long)ctx->data;

    bpf_printk("BEFORE: %d", map_entry->value);
    //bpf_printk("PKT LENGTH: %d", data_end);
    //bpf_printk("PKT LENGTH: %d", data);

    // Initializes the timer from a certain map using a specific clock
    long int i = bpf_timer_init(&map_entry->timer, &timer_array, CLOCK_BOOTTIME);
    if(i != 0)
        bpf_printk("Error while initializing timer: %ld", i);

    // Sets the function to be called after the timer triggers
    i = bpf_timer_set_callback(&map_entry->timer, function);
    if(i != 0)
        bpf_printk("Error while setting callback: %ld", i);

    // Starts the timer for 1 second
    bpf_timer_start(&map_entry->timer, ONE_SEC, 0);

    // Cancels the timer (if the 1 second hasn't passed)
    //bpf_timer_cancel(&map_entry->timer);

    bpf_printk("TEST");

    return 0;
}

char _license[] SEC("license") = "GPL";
