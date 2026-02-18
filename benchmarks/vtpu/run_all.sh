#!/bin/bash
# vTPU Baseline Benchmark Suite
# Compiles and runs all W2 baseline measurements
# Usage: ./run_all.sh [--perf]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT="$OUTPUT_DIR/baseline_$TIMESTAMP.txt"

USE_PERF=0
if [[ "$1" == "--perf" ]]; then
    USE_PERF=1
fi

mkdir -p "$OUTPUT_DIR"

echo "================================================" | tee "$REPORT"
echo "vTPU Baseline Benchmark Suite" | tee -a "$REPORT"
echo "Date: $(date)" | tee -a "$REPORT"
echo "Host: $(hostname)" | tee -a "$REPORT"
echo "CPU: $(lscpu | grep 'Model name' | cut -d: -f2 | xargs)" | tee -a "$REPORT"
echo "================================================" | tee -a "$REPORT"
echo "" | tee -a "$REPORT"

# Function to compile and run a benchmark
run_benchmark() {
    local name=$1
    local dir=$2
    local source=$3
    local binary=$4
    local extra_flags=$5
    
    echo "---------- $name ----------" | tee -a "$REPORT"
    
    cd "$SCRIPT_DIR/$dir"
    
    # Compile
    echo "Compiling $source..." | tee -a "$REPORT"
    gcc -O2 -o "$binary" "$source" $extra_flags
    
    if [[ ! -f "$binary" ]]; then
        echo "ERROR: Failed to compile $source" | tee -a "$REPORT"
        return 1
    fi
    
    # Run
    if [[ $USE_PERF -eq 1 ]]; then
        echo "Running with perf..." | tee -a "$REPORT"
        perf stat -e cycles,instructions,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses \
            ./"$binary" 2>&1 | tee -a "$REPORT"
    else
        echo "Running..." | tee -a "$REPORT"
        ./"$binary" | tee -a "$REPORT"
    fi
    
    echo "" | tee -a "$REPORT"
}

# Cache Benchmarks
echo "=== CACHE LOCALITY TESTS ===" | tee -a "$REPORT"
run_benchmark "Sequential Access" "cache" "sequential_access.c" "sequential_access"
run_benchmark "Random Access" "cache" "random_access.c" "random_access"
run_benchmark "Coordinate Patterns" "cache" "coordinate_patterns.c" "coordinate_patterns"

# Ops/Cycle Benchmarks
echo "=== OPS/CYCLE TESTS ===" | tee -a "$REPORT"
run_benchmark "Instruction Mix" "ops-cycle" "instruction_mix.c" "instruction_mix"

# Memory Bandwidth Benchmarks
echo "=== MEMORY BANDWIDTH TESTS ===" | tee -a "$REPORT"
if command -v gcc &> /dev/null && gcc -fopenmp --version &> /dev/null 2>&1; then
    run_benchmark "Memory Bandwidth" "memory" "bandwidth.c" "bandwidth" "-fopenmp"
else
    echo "WARNING: OpenMP not available, skipping bandwidth test" | tee -a "$REPORT"
    echo "Install with: sudo apt install libomp-dev" | tee -a "$REPORT"
fi

echo "" | tee -a "$REPORT"
echo "================================================" | tee -a "$REPORT"
echo "Baseline benchmarks complete!" | tee -a "$REPORT"
echo "Report saved to: $REPORT" | tee -a "$REPORT"
echo "================================================" | tee -a "$REPORT"

if [[ $USE_PERF -eq 0 ]]; then
    echo ""
    echo "Tip: Run with --perf to collect detailed performance counters:"
    echo "  ./run_all.sh --perf"
fi

echo ""
echo "Next steps:"
echo "1. Review the report: cat $REPORT"
echo "2. Compare against KPI targets in R23-DASHBOARD.md"
echo "3. Proceed to Wave 3 (micro-benchmark suite)"
