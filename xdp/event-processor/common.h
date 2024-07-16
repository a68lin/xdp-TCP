#include <linux/types.h>

struct flow_id {
    __u32 sender_ip;
    __u16 sender_port;
    __u32 receiver_ip;
    __u16 receiver_port;
};

struct tcp_md {
    // Maximum size of data in a packet
    __u32 segment_size;
    // Window size
    __u32 window_size;
    // The sequence number of the first packet in the window
    __u32 window_start_seq;
    // THe last sequence number sent
    __u32 last_seq_sent;

    // Circular queue(the actual window stores sent packets): 
    // The head of the circular queue
    __u32 head;
    // The current size of the circular queue
    __u32 cur_size;
};