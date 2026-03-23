# vTPU Baseline KPI Report

**Date:** [YYYY-MM-DD]  
**Host:** [hostname]  
**CPU:** [model from lscpu]  
**RAM:** [from free -h]  
**Kernel:** [uname -r]

---

## Hardware Efficiency Baselines

### Ops/Cycle (Target: 3.0 sustained)

| Test | Measured | Target | Status |
|------|----------|--------|--------|
| ALU-only (D-heavy) | ___ ops/cycle | 1.5-2.0 | ⚪ |
| Memory-only (S-heavy) | ___ ops/cycle | 0.8-1.2 | ⚪ |
| Mixed unbalanced | ___ ops/cycle | 1.2-1.8 | ⚪ |
| Balanced D+S | ___ ops/cycle | 2.0-2.5 | ⚪ |

**Baseline Average:** ___ ops/cycle  
**vTPU Target:** 3.0 ops/cycle (via SIW scheduling)  
**Improvement Needed:** ___x

**From perf stat:**
- Total cycles: ___
- Total instructions: ___
- Total uops retired: ___
- IPC (instructions per cycle): ___

---

### Cache Hit Rates (Target: L1 >95%)

#### Sequential Access Pattern

| Cache Level | Size | Cycles/Element | Expected | Status |
|-------------|------|----------------|----------|--------|
| L1 | 16 KB | ___ | ~4 cycles | ⚪ |
| L2 | 512 KB | ___ | ~12 cycles | ⚪ |
| L3 | 16 MB | ___ | ~40 cycles | ⚪ |
| DRAM | 256 MB | ___ | ~80 cycles | ⚪ |

#### Random Access Pattern

| Cache Level | Size | Cycles/Access | Expected | Status |
|-------------|------|---------------|----------|--------|
| L1 | 16 KB | ___ | ~10-15 cycles | ⚪ |
| L2 | 512 KB | ___ | ~20-30 cycles | ⚪ |
| L3 | 16 MB | ___ | ~60-80 cycles | ⚪ |
| DRAM | 256 MB | ___ | ~120-150 cycles | ⚪ |

**From perf stat:**
- L1 loads: ___
- L1 misses: ___
- L1 hit rate: ___%
- LLC loads: ___
- LLC misses: ___
- LLC hit rate: ___%

---

### Coordinate Access Patterns (Dimensional Locality Test)

| Pattern | L1 (16KB) | L2 (512KB) | L3 (16MB) | Speedup vs Random |
|---------|-----------|------------|-----------|-------------------|
| Dimensional | ___ cycles | ___ cycles | ___ cycles | ___x |
| Random | ___ cycles | ___ cycles | ___ cycles | 1.0x |
| Strided | ___ cycles | ___ cycles | ___ cycles | ___x |

**Hypothesis Validation:**  
Dimensional locality should provide 2-3x speedup vs random access.  
**Result:** ___x speedup → [PASS / FAIL]

---

### Memory Bandwidth (Target: >40 GB/s, 80% util)

| Operation | Bandwidth (GB/s) | % of Theoretical | Status |
|-----------|------------------|------------------|--------|
| Copy | ___ GB/s | ___% | ⚪ |
| Scale | ___ GB/s | ___% | ⚪ |
| Add | ___ GB/s | ___% | ⚪ |
| Triad | ___ GB/s | ___% | ⚪ |

**Theoretical DDR5-5600 (dual-channel):** 50-76 GB/s  
**Measured Peak:** ___ GB/s  
**Utilization:** ___%  
**vTPU Target:** >80% (40+ GB/s)

---

### SMT Efficiency (Target: 1.9x)

| Configuration | Throughput | Efficiency |
|---------------|------------|------------|
| Single-thread | ___ ops/sec | 1.0x |
| Dual-thread (same workload) | ___ ops/sec | ___x |
| Dual-thread (complementary) | ___ ops/sec | ___x (target) |

**Note:** Complementary workload test requires vTPU SIW implementation.  
**Baseline:** Standard SMT with identical workloads.

---

## ML Performance Baselines

*Deferred to Wave 6-8*

### Qwen3-Coder-Next Inference

| Metric | Baseline | Target | Method |
|--------|----------|--------|--------|
| Tokens/sec | TBD | 75-150 | llama.cpp CPU |
| Tokens/sec/W | TBD | 0.60 | Power meter |
| First token latency | TBD | <500ms | HumanEval |

### Embedding Lookup

| Metric | Baseline | Target | Method |
|--------|----------|--------|--------|
| Latency (ns) | TBD | 12 | Hash table |
| Throughput | TBD | 100M/sec | Bulk lookup |

### Hypergraph Convolution

| Metric | Baseline | Target | Dataset |
|--------|----------|--------|--------|
| Time (ms) | TBD | 8.5 | Cora (PyG) |
| Speedup | 1.0x | 10x | vTPU SHYPER |

---

## Geometric Operations Baselines

*Deferred to Wave 26-30*

| Operation | Baseline | Target | Notes |
|-----------|----------|--------|-------|
| k-Simplex query | O(N^k) | O(1) | Simplicial complex |
| Hyperbolic distance | ~45 ns | 4 ns | Poincaré → Hamming |
| Tensor contraction | ~220 μs | 22 μs | Tucker decomp |
| Laplacian operator | ~180 μs | 18 μs | 22-neighbor |

---

## Summary

### Phase 0 Exit Criteria Status

- [ ] All baseline KPIs measured
- [ ] Cache locality validated (sequential vs random)
- [ ] Ops/cycle baseline established
- [ ] Memory bandwidth characterized
- [ ] Dimensional locality hypothesis tested
- [ ] Report complete and reviewed

### Key Findings

1. **Current CPU efficiency:** ___ ops/cycle (___% of theoretical peak)
2. **Gap to close:** vTPU needs ___x improvement via SIW scheduling
3. **Dimensional locality advantage:** ___x speedup vs random
4. **Memory bottleneck:** [Yes / No] — ___ GB/s measured vs ___ GB/s theoretical

### Recommendations for Phase 1

1. [Primary bottleneck identified: _________________]
2. [Critical optimization: _________________]
3. [Risk area: _________________]

---

**Report Generated:** [date +%Y-%m-%d\ %H:%M:%S]  
**Next Wave:** Wave 3 (Micro-benchmark Suite)  
**Sign-off:** [Agent Name] 🪶
