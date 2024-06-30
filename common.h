#include <linux/types.h>

struct flow_id {
    __u32 sender_ip;
    __u16 sender_port;
    __u32 receiver_ip;
    __u16 receiver_port;
};

struct tcp_md {
    __u32 segment_size;
    __u32 window_size;
    __u32 initial_seq;
    __u32 window_start_seq;
    __u32 last_seq_sent;
};