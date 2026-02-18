// Ops/Cycle Baseline: General-Purpose Code
// Measures actual instruction retirement rate on standard workloads
// Compile: gcc -O2 -o baseline_ops baseline_ops.c
// Run: perf stat -e cycles,instructions,uops_retired.all ./baseline_ops

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define ITERATIONS (100 * 1000 * 1000)  // 100M iterations for stable measurement

static inline uint64_t rdtsc(void) {
    uint32_t lo, hi;
    __asm__ __volatile__ ("rdtsc" : "=a"(lo), "=d"(hi));
    return ((uint64_t)hi << 32) | lo;
}

// Test 1: Simple arithmetic loop (ALU-bound)
uint64_t arithmetic_loop(uint64_t n) {
    uint64_t sum = 0;
    uint64_t a = 1, b = 2, c = 3;
    
    for (uint64_t i = 0; i < n; i++) {
        sum += a * b + c;  // Multiply-add
        a += 1;
        b += 2;
        c += 3;
    }
    
    return sum;
}

// Test 2: Pointer-chasing (memory-bound)
typedef struct node {
    uint64_t value;
    struct node *next;
} node_t;

uint64_t pointer_chase(node_t *head, uint64_t n) {
    uint64_t sum = 0;
    node_t *current = head;
    
    for (uint64_t i = 0; i < n; i++) {
        sum += current->value;
        current = current->next;
    }
    
    return sum;
}

// Test 3: Mixed (ALU + memory)
uint64_t mixed_loop(uint64_t *array, uint64_t n) {
    uint64_t sum = 0;
    uint64_t temp = 0;
    
    for (uint64_t i = 0; i < n; i++) {
        temp = array[i % 1024];  // Memory load
        sum += temp * 3 + 7;      // ALU ops
        array[i % 1024] = sum;    // Memory store
    }
    
    return sum;
}

void benchmark(const char *name, uint64_t (*func)(uint64_t), uint64_t arg) {
    uint64_t start = rdtsc();
    uint64_t result = func(arg);
    uint64_t end = rdtsc();
    
    uint64_t cycles = end - start;
    double cycles_per_iter = (double)cycles / arg;
    
    printf("%s: %lu cycles, %.2f cycles/iter (result: %lu)\n",
           name, cycles, cycles_per_iter, result);
}

int main() {
    printf("Baseline Ops/Cycle (expect ~1.2 ops/cycle for general code on Zen 4)\n\n");
    
    // Test 1: ALU-bound
    benchmark("Arithmetic", arithmetic_loop, ITERATIONS / 10);
    
    // Test 2: Memory-bound (setup linked list)
    node_t *nodes = malloc(sizeof(node_t) * 10000);
    for (int i = 0; i < 10000; i++) {
        nodes[i].value = i;
        nodes[i].next = &nodes[(i + 1) % 10000];
    }
    
    uint64_t start = rdtsc();
    uint64_t result = pointer_chase(nodes, ITERATIONS / 100);
    uint64_t end = rdtsc();
    printf("Pointer Chase: %lu cycles, %.2f cycles/iter (result: %lu)\n",
           end - start, (double)(end - start) / (ITERATIONS / 100), result);
    free(nodes);
    
    // Test 3: Mixed
    uint64_t *array = malloc(sizeof(uint64_t) * 1024);
    for (int i = 0; i < 1024; i++) array[i] = i;
    
    start = rdtsc();
    result = mixed_loop(array, ITERATIONS / 10);
    end = rdtsc();
    printf("Mixed (ALU+Mem): %lu cycles, %.2f cycles/iter (result: %lu)\n",
           end - start, (double)(end - start) / (ITERATIONS / 10), result);
    free(array);
    
    return 0;
}
