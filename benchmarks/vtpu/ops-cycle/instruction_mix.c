// Ops/Cycle Baseline: Instruction Mix Test
// Measures how many operations retire per cycle for different instruction patterns
// Compile: gcc -O2 -o instruction_mix instruction_mix.c
// Run: perf stat -e cycles,instructions,uops_retired.all ./instruction_mix

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define ITERATIONS 10000000
#define ARRAY_SIZE 1024

static inline uint64_t rdtsc(void) {
    uint32_t lo, hi;
    __asm__ __volatile__ ("rdtsc" : "=a"(lo), "=d"(hi));
    return ((uint64_t)hi << 32) | lo;
}

// Test 1: Pure ALU operations (should saturate D-Pipe equivalent)
uint64_t test_alu_only(uint64_t *data, size_t count) {
    uint64_t sum = 0, a = 1, b = 2, c = 3;
    for (size_t i = 0; i < ITERATIONS; i++) {
        a = a + b;
        b = b * 2;
        c = c ^ a;
        sum += a + b + c;
    }
    return sum;
}

// Test 2: Memory-heavy (should saturate S-Pipe equivalent)
uint64_t test_memory_only(uint64_t *data, size_t count) {
    uint64_t sum = 0;
    for (size_t i = 0; i < ITERATIONS; i++) {
        size_t idx = i % count;
        sum += data[idx];
        data[idx] = sum;
    }
    return sum;
}

// Test 3: Mixed ALU + Memory (unbalanced)
uint64_t test_mixed_unbalanced(uint64_t *data, size_t count) {
    uint64_t sum = 0, a = 1;
    for (size_t i = 0; i < ITERATIONS; i++) {
        size_t idx = i % count;
        a = a + data[idx];
        data[idx] = a * 2;
        sum += a;
        a = a ^ sum;
    }
    return sum;
}

// Test 4: Balanced ALU + Memory (closer to D/S/C model)
uint64_t test_balanced(uint64_t *data, size_t count) {
    uint64_t sum = 0, a = 1, b = 2;
    for (size_t i = 0; i < ITERATIONS / 10; i++) {
        // Cycle 1: ALU, Load, Store
        size_t idx = i % count;
        a = a + b;                    // D-Pipe: ALU
        uint64_t tmp = data[idx];     // S-Pipe: Load
        data[idx] = sum;              // S-Pipe: Store (can overlap)
        
        // Cycle 2: ALU, Load, Compute
        b = tmp * 2;                  // D-Pipe: ALU
        tmp = data[(idx+1) % count];  // S-Pipe: Load
        sum += a + b;                 // D-Pipe: ALU
        
        // Cycle 3: Store result
        data[(idx+1) % count] = sum;  // S-Pipe: Store
    }
    return sum;
}

void run_test(const char *name, uint64_t (*test_func)(uint64_t*, size_t), uint64_t *data, size_t count) {
    // Warmup
    test_func(data, count);
    
    // Timed run
    uint64_t start = rdtsc();
    uint64_t result = test_func(data, count);
    uint64_t end = rdtsc();
    
    uint64_t cycles = end - start;
    double ops_per_cycle = (double)ITERATIONS / cycles;
    
    printf("%-25s: %12lu cycles, %.3f ops/cycle (result: %lu)\n",
           name, cycles, ops_per_cycle, result);
}

int main() {
    uint64_t *data = malloc(ARRAY_SIZE * sizeof(uint64_t));
    for (size_t i = 0; i < ARRAY_SIZE; i++) {
        data[i] = i;
    }
    
    printf("Ops/Cycle Baseline (AMD R9 8945HS)\n");
    printf("Target for vTPU: 3.0 ops/cycle sustained\n\n");
    printf("%-25s  %12s  %s\n", "Test", "Cycles", "Ops/Cycle");
    printf("-----------------------------------------------------------\n");
    
    run_test("ALU-only (D-heavy)", test_alu_only, data, ARRAY_SIZE);
    run_test("Memory-only (S-heavy)", test_memory_only, data, ARRAY_SIZE);
    run_test("Mixed unbalanced", test_mixed_unbalanced, data, ARRAY_SIZE);
    run_test("Balanced D+S", test_balanced, data, ARRAY_SIZE);
    
    printf("\nNote: 'ops' here = loop iterations, not µ-ops\n");
    printf("Run with: perf stat -e cycles,instructions,uops_retired.all ./instruction_mix\n");
    
    free(data);
    return 0;
}
