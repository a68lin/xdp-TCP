#ifndef COMMON_DEF_H
#define COMMON_DEF_H

#define MAX_NUMBER_CORES 8
#define MAX_NUMBER_FLOWS 20
#define MAX_EVENT_QUEUE_LEN 10
#define MAX_NUM_PROCESSED_EVENTS 3
#define MAX_NUMBER_TIMERS 10
#define NO_TIMER_AVAILABLE 999999
#define MAX_NUMBER_PROG_EVENTS 10

enum major_event_type {
    APP_EVENT,
    TIMER_EVENT,
    PROG_EVENT
};

enum minor_event_type {
    SEND,
    ACK,
    MISS_ACK,
    PROG_TEST,
};

struct flow_id {
    __u8 src_ip;
    __u8 src_port;
    __u8 dest_ip;
    __u8 dest_port;
};

struct hash_key {
    int cpu;
};

struct app_event {
    enum minor_event_type event_type;
    struct flow_id ev_flow_id;
    __u64 occupied;
    __u64 value;
};

struct net_event {
    enum minor_event_type event_type;
    struct flow_id ev_flow_id;
    __u64 value;
};

struct timer_event {
    enum minor_event_type event_type;
    struct flow_id ev_flow_id;
    __u64 value;

    __u64 valid_bit;
};

struct prog_event {
    enum minor_event_type event_type;
    struct flow_id ev_flow_id;
    __u64 value;
    /*__u64 value1;
    __u64 value2;
    __u64 value3;
    __u64 value4;
    __u64 value5;
    __u64 value6;
    __u64 value7;
    __u64 value8;
    __u64 value9;
    __u64 value10;
    __u64 value11;
    __u64 value12;
    __u64 value13;
    __u64 value14;
    __u64 value15;
    __u64 value16;
    __u64 value17;
    __u64 value18;
    __u64 value19;
    __u64 value20;
    __u64 value21;
    __u64 value22;
    __u64 value23;
    __u64 value24;
    __u64 value25;
    __u64 value26;
    __u64 value27;
    __u64 value28;
    __u64 value29;
    __u64 value30;
    __u64 value31;
    __u64 value32;
    __u64 value33;
    __u64 value34;
    __u64 value35;
    __u64 value36;
    __u64 value37;
    __u64 value38;
    __u64 value39;
    __u64 value40;
    __u64 value41;
    __u64 value42;
    __u64 value43;
    __u64 value44;
    __u64 value45;
    __u64 value46;
    __u64 value47;
    __u64 value48;
    __u64 value49;
    __u64 value50;
    __u64 value51;
    __u64 value52;
    __u64 value53;
    __u64 value54;
    __u64 value55;
    __u64 value56;
    __u64 value57;
    __u64 value58;
    __u64 value59;
    __u64 value60;*/
};

struct timer_trigger {
    struct bpf_timer timer;
    struct timer_event t_event;
    __u32 cpu_id;
    __u32 triggered;
};

struct queue_head_tail {
    __u32 net_head;
    __u32 net_tail;
    __u32 timer_head;
    __u32 timer_tail;
    __u32 prog_head;
    __u32 prog_tail;
};

struct flow_info {
    struct app_info {
        __u32 app_head;
        __u32 app_tail;
        __u32 len_app_queue;
    } app_info;
    struct timer_info {
        __u64 len_timer_queue;
        __u32 timer_head;
        __u32 timer_tail;
        __u64 executing_enqueue;
    } timer_info;
    struct prog_info {
        __u32 len_prog_queue;
        __u32 prog_head;
        __u32 prog_tail;
    } prog_info;
};

struct flow_loop_data {
    struct flow_id f_id;
    __u32 len_app_queue;
    __u32 len_net_queue;
    __u32 len_timer_queue;
    __u32 len_prog_queue;
};

struct context {
    __u32 value1;
    __u32 value2;
    __u32 value3;
};

struct intermediate_output {
    __u32 value;
};

struct sched_loop_args {
    __u32 cpu_id;
    struct flow_info *f_info;
    struct flow_id f_id;
};

struct timer_loop_args {
    __u32 index;
};

struct test {
    int value;
};

#endif