# vTPU Baseline Benchmark Suite

**Purpose:** Establish baseline KPI measurements before vTPU implementation begins.

---

## Quick Start

```bash
# Navigate to benchmark directory
cd /source/exo-plan/benchmarks/vtpu

# Run all benchmarks (basic timing)
./run_all.sh

# Run with detailed perf counters (requires perf)
./run_all.sh --perf

# Results saved to: results/baseline_YYYYMMDD_HHMMSS.txt
```

---

## Benchmark Categories

### 1. Cache Locality (`cache/`)

**Purpose:** Measure L1/L2/L3/DRAM access latency and hit rates.

| Benchmark | File | Measures |
|-----------|------|----------|
| Sequential Access | `sequential_access.c` | Best-case cache performance (stride-1) |
| Random Access | `random_access.c` | Worst-case cache performance (thrashing) |
| Coordinate Patterns | `coordinate_patterns.c` | Phext dimensional locality vs random |

**Key Hypothesis:** Phext's dimensional addressing provides 2-3x better cache locality than random access.

---

### 2. Ops/Cycle (`ops-cycle/`)

**Purpose:** Measure instruction-level parallelism and ops/cycle for different mixes.

| Benchmark | File | Measures |
|-----------|------|----------|
| Instruction Mix | `instruction_mix.c` | ALU-only, Memory-only, Mixed, Balanced patterns |

**Baseline Expected:** 1.2-1.5 ops/cycle (general code on Zen 4)  
**vTPU Target:** 3.0 ops/cycle (via 3-pipe SIW scheduling)

---

### 3. Memory Bandwidth (`memory/`)

**Purpose:** Measure sustained memory bandwidth (similar to STREAM benchmark).

| Benchmark | File | Measures |
|-----------|------|----------|
| Bandwidth | `bandwidth.c` | Copy, Scale, Add, Triad operations |

**Expected DDR5-5600:** 50-76 GB/s (dual-channel)  
**vTPU Target:** >80% utilization (40+ GB/s sustained)

**Note:** Requires OpenMP. Install: `sudo apt install libomp-dev`

---

## Requirements

### System
- GCC 9+ (for `-O2` optimization)
- `perf` tool (Linux perf_events, optional but recommended)
- OpenMP library (for bandwidth benchmark)

### Installation (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install build-essential linux-tools-generic libomp-dev
```

### Verification
```bash
gcc --version        # Should be 9.x or higher
perf --version       # Should show perf version
gcc -fopenmp --version  # Should not error
```

---

## Running Individual Benchmarks

### Cache Benchmarks
```bash
cd cache

# Compile
gcc -O2 -o sequential_access sequential_access.c
gcc -O2 -o random_access random_access.c
gcc -O2 -o coordinate_patterns coordinate_patterns.c

# Run with perf
perf stat -e L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses \
    ./sequential_access

perf stat -e L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses \
    ./random_access

perf stat -e L1-dcache-loads,L1-dcache-load-misses \
    ./coordinate_patterns
```

### Ops/Cycle Benchmark
```bash
cd ops-cycle

# Compile
gcc -O2 -o instruction_mix instruction_mix.c

# Run with perf
perf stat -e cycles,instructions,uops_retired.all \
    ./instruction_mix
```

### Memory Bandwidth Benchmark
```bash
cd memory

# Compile
gcc -O2 -o bandwidth bandwidth.c -fopenmp

# Run single-threaded
OMP_NUM_THREADS=1 ./bandwidth

# Run multi-threaded (8 cores)
OMP_NUM_THREADS=8 ./bandwidth
```

---

## Interpreting Results

### Cache Hit Rate
```
L1 hit rate = (L1-loads - L1-misses) / L1-loads * 100%
LLC hit rate = (LLC-loads - LLC-misses) / LLC-loads * 100%
```

**Target:** L1 hit rate >95% for dimensional access patterns.

### Ops/Cycle (IPC)
```
IPC = instructions / cycles
```

**Current Baseline:** ~1.2-1.5 IPC for general code  
**vTPU Target:** 3.0 IPC via 3-wide SIW retirement

### Memory Bandwidth Efficiency
```
Efficiency = measured_bandwidth / theoretical_bandwidth * 100%
```

**Target:** >80% efficiency (>40 GB/s on DDR5-5600 dual-channel)

---

## Expected Baseline Values (AMD R9 8945HS)

| Metric | Expected Range | Source |
|--------|----------------|--------|
| L1 latency | 3-5 cycles | CPU spec |
| L2 latency | 10-15 cycles | CPU spec |
| L3 latency | 35-45 cycles | CPU spec |
| DRAM latency | 70-90 ns | DDR5-5600 |
| Peak memory BW | 50-76 GB/s | Dual-channel DDR5 |
| Base IPC | 1.2-1.5 | General code |
| Max IPC | 4-6 | Perfectly scheduled |

---

## Output Files

### Results Directory (`results/`)
```
results/
  baseline_20260214_161300.txt  # Run from 2026-02-14 16:13
  baseline_20260215_093045.txt  # Run from 2026-02-15 09:30
  ...
```

### Report Template
- `BASELINE-KPI-TEMPLATE.md` — Fill this out after running benchmarks

---

## Next Steps (After W2)

1. **Review Report:** Compare measured baselines against targets
2. **Identify Gaps:** Calculate improvement needed for vTPU
3. **Wave 3:** Build micro-benchmark suite (synthetic SIW generator)
4. **Wave 4:** Test coordinate access patterns (dimensional locality)
5. **Wave 5:** SMT efficiency analysis (complementary workloads)

---

## Troubleshooting

### "perf: command not found"
```bash
sudo apt install linux-tools-generic
# Or for specific kernel:
sudo apt install linux-tools-$(uname -r)
```

### "Permission denied" for perf
```bash
# Temporarily allow perf without root
echo 0 | sudo tee /proc/sys/kernel/perf_event_paranoid

# Permanently (add to /etc/sysctl.conf)
kernel.perf_event_paranoid = 0
```

### OpenMP errors
```bash
sudo apt install libomp-dev
```

### Benchmarks run too fast
- Increase `ITERATIONS` constant in source files
- Expected: 1-10 seconds per benchmark for accurate timing

---

**Benchmark Suite Version:** 0.1 (R23W2)  
**Created:** 2026-02-14  
**Author:** Cyon 🪶
