// Memory Bandwidth Baseline: STREAM-like benchmark
// Measures sustained memory bandwidth for different access patterns
// Compile: gcc -O2 -o bandwidth bandwidth.c -fopenmp
// Run: OMP_NUM_THREADS=1 ./bandwidth

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <omp.h>

#define MB (1024UL * 1024UL)
#define ARRAY_SIZE (256 * MB / sizeof(double))  // 256 MB per array
#define ITERATIONS 10

static double *a, *b, *c;

void init_arrays() {
    a = (double *)malloc(ARRAY_SIZE * sizeof(double));
    b = (double *)malloc(ARRAY_SIZE * sizeof(double));
    c = (double *)malloc(ARRAY_SIZE * sizeof(double));
    
    #pragma omp parallel for
    for (size_t i = 0; i < ARRAY_SIZE; i++) {
        a[i] = 1.0;
        b[i] = 2.0;
        c[i] = 0.0;
    }
}

// Copy: c = a
void test_copy() {
    #pragma omp parallel for
    for (size_t i = 0; i < ARRAY_SIZE; i++) {
        c[i] = a[i];
    }
}

// Scale: b = scalar * c
void test_scale(double scalar) {
    #pragma omp parallel for
    for (size_t i = 0; i < ARRAY_SIZE; i++) {
        b[i] = scalar * c[i];
    }
}

// Add: c = a + b
void test_add() {
    #pragma omp parallel for
    for (size_t i = 0; i < ARRAY_SIZE; i++) {
        c[i] = a[i] + b[i];
    }
}

// Triad: a = b + scalar * c
void test_triad(double scalar) {
    #pragma omp parallel for
    for (size_t i = 0; i < ARRAY_SIZE; i++) {
        a[i] = b[i] + scalar * c[i];
    }
}

double run_benchmark(const char *name, void (*test_func)(void), int reads, int writes) {
    // Warmup
    test_func();
    
    // Timed run
    double min_time = 1e9;
    for (int iter = 0; iter < ITERATIONS; iter++) {
        double start = omp_get_wtime();
        test_func();
        double end = omp_get_wtime();
        double time = end - start;
        if (time < min_time) min_time = time;
    }
    
    double bytes = (double)ARRAY_SIZE * sizeof(double) * (reads + writes);
    double bandwidth = bytes / min_time / (1024.0 * 1024.0 * 1024.0);  // GB/s
    
    printf("%-15s: %8.3f seconds, %8.2f GB/s\n", name, min_time, bandwidth);
    return bandwidth;
}

int main() {
    printf("Memory Bandwidth Baseline\n");
    printf("Array size: %lu MB per array\n", ARRAY_SIZE * sizeof(double) / MB);
    printf("Expected DDR5-5600 bandwidth: 50-76 GB/s (dual-channel)\n\n");
    
    init_arrays();
    
    printf("%-15s  %8s  %8s\n", "Test", "Time", "BW (GB/s)");
    printf("----------------------------------------\n");
    
    // Copy: 1 read, 1 write
    run_benchmark("Copy", (void (*)(void))test_copy, 1, 1);
    
    // Scale: 1 read, 1 write
    run_benchmark("Scale", (void (*)(void))test_scale, 1, 1);
    
    // Add: 2 reads, 1 write
    run_benchmark("Add", (void (*)(void))test_add, 2, 1);
    
    // Triad: 2 reads, 1 write
    run_benchmark("Triad", (void (*)(void))test_triad, 2, 1);
    
    printf("\nNote: Single-threaded. For multi-core, set OMP_NUM_THREADS=8\n");
    printf("vTPU target: >80%% bandwidth utilization (40+ GB/s)\n");
    
    free(a);
    free(b);
    free(c);
    return 0;
}
