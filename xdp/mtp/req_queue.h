#ifndef REC_QUEUE_H
#define REC_QUEUE_H

#include "common_def.h"
#include <stdlib.h>
#include <stdatomic.h>


struct req_queue_node {
    struct app_event event;
    struct req_queue_node * next;
};

struct req_queue {
    struct req_queue_node * first[MAX_NUMBER_CORES];
    struct req_queue_node * last[MAX_NUMBER_CORES];
};

struct req_queue * create_queue (){
    struct req_queue * queue = (struct req_queue*) malloc(sizeof(struct req_queue));
    for(int i = 0; i < MAX_NUMBER_CORES; i++) {
        queue->first[i] = NULL;
        queue->last[i] = NULL;
    }
    return queue;
}

void req_enqueue(struct req_queue *queue, struct app_event event, int cpu) {
    struct req_queue_node *new_req_node = (struct req_queue_node*) malloc(sizeof(struct req_queue_node));
    new_req_node->event = event;
    new_req_node->next = NULL;

    if(queue->first[cpu] == NULL && queue->first[cpu] == NULL) {
        queue->first[cpu] = new_req_node;
        queue->last[cpu] = new_req_node;
    } else {
        queue->last[cpu]->next = new_req_node;
        queue->last[cpu] = new_req_node;
    }
}

void req_dequeue(struct req_queue *queue, int cpu) {
    if(queue->first[cpu] != NULL) {
        struct req_queue_node *first_node = queue->first[cpu];
        queue->first[cpu] = first_node->next;
        if(queue->first[cpu] == NULL)
            queue->last[cpu] = NULL;
        free(first_node);
    }
}

struct app_event* read_first_req(struct req_queue *queue, int cpu) {
    if(queue->first[cpu] != NULL) {
        return &queue->first[cpu]->event;
    }
    return NULL;
}

void free_queue(struct req_queue *queue) {
    struct req_queue_node *first_node;
    for(int i = 0; i < MAX_NUMBER_CORES; i++) {
        while(queue->first[i] != NULL) {
            first_node = queue->first[i];
            queue->first[i] = first_node->next;
            if(queue->first[i] == NULL)
                queue->last[i] = NULL;
            free(first_node);
        }
    }
    free(queue);
}

void print_queue(struct req_queue *queue) {
    struct req_queue_node *node;
    for(int i = 0; i < MAX_NUMBER_CORES; i++) {
        printf("\nQueue CPU %d: ", i);
        node = queue->first[i];
        while(node != NULL) {
            printf("%lld ", node->event.value);
            node = node->next;
        }
    }
    printf("\n");
}

// Based on:
// https://www.codeproject.com/Articles/43510/Lock-Free-Single-Producer-Single-Consumer-Circular#heading_acquire_release_model

struct req_queue_v2 {
    struct app_event req_queue[MAX_NUMBER_PROG_EVENTS];
    atomic_uint head;
    atomic_uint tail;
};

void init_queue_v2(struct req_queue_v2 *queue) {
    for(int i = 0; i < MAX_NUMBER_CORES; i++) {
        atomic_init(&queue[i].head, 0);
        atomic_init(&queue[i].tail, 0);
    }
}

void req_enqueue_v2(struct req_queue_v2 *queue, struct app_event event) {
    atomic_uint curr_tail = atomic_load_explicit(&queue->tail, memory_order_relaxed);
    atomic_uint next_tail = (curr_tail + 1) % MAX_NUMBER_PROG_EVENTS;
    if(next_tail != atomic_load_explicit(&queue->head, memory_order_acquire)) {
        queue->req_queue[curr_tail] = event;
        atomic_store_explicit(&queue->tail, next_tail, memory_order_release);
        return;
    }
    printf("Queue is full");
    return;
}

void req_dequeue_v2(struct req_queue_v2 *queue) {
    atomic_uint curr_head = atomic_load_explicit(&queue->head, memory_order_relaxed);
    atomic_uint next_head = (curr_head + 1) % MAX_NUMBER_PROG_EVENTS;
    if(curr_head != atomic_load_explicit(&queue->tail, memory_order_acquire)) {
        atomic_store_explicit(&queue->head, next_head, memory_order_release);
        return;
    }
    printf("Queue is empty");
    return;
}

struct app_event * read_first_req_v2(struct req_queue_v2 *queue, atomic_uint *curr_head) {
    *curr_head = atomic_load_explicit(&queue->head, memory_order_relaxed);
    if(*curr_head != atomic_load_explicit(&queue->tail, memory_order_acquire)) {
        return &queue->req_queue[*curr_head];
    }
    return NULL;
}

void print_queue_v2(struct req_queue_v2 *queue) {
    for(int i = 0; i < MAX_NUMBER_CORES; i++) {
        atomic_uint curr_head = atomic_load_explicit(&queue[i].head, memory_order_relaxed);
        printf("\nCPU %d: ", i);
        while(curr_head != atomic_load_explicit(&queue[i].tail, memory_order_relaxed)) {
            printf("%lld ", queue[i].req_queue[curr_head].value);
            curr_head = (curr_head + 1) % MAX_NUMBER_PROG_EVENTS;
        }
    }
    printf("\n");
}

#endif