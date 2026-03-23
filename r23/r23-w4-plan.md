# R23 Wave 4: Micro-Benchmark Suite & Baseline Validation

**Status:** Ready to start  
**Duration:** 2-3 days (estimated)  
**Goal:** Measure baseline performance, validate interpreter correctness, establish KPI tracking

---

## Context

**Completed (W1-W3):**
- ✅ vTPU spec (architecture, ISA, geometric advantages)
- ✅ Rust runtime (SIW, pipes, sentron, interpreter)
- ✅ Zero dependencies (lean/mean, 1-day comprehensibility)
- ✅ Python client + port validation framework

**Gap:** No real performance data yet. The interpreter exists but we haven't validated it against hardware or measured actual ops/cycle.

---

## Wave 4 Objectives

### 1. **Baseline CPU Measurements** (Day 1)
Measure what we get WITHOUT vTPU optimizations:
- Sequential memory access latency (L1/L2/L3 hit rates)
- Random memory access latency
- Phext coordinate lookup performance (hash table)
- Standard CPU ops/cycle on representative workloads

**Deliverable:** `benchmarks/baseline-report.md` with measured KPIs

### 2. **vTPU Interpreter Validation** (Day 1-2)
Run synthetic SIW streams through the interpreter and measure:
- Ops/cycle (ideal 3-wide retirement assumption)
- Pipe utilization (D/S/C balance)
- Register dependency detection
- Correctness (results match expected values)

**Deliverable:** `cargo test` passing, `examples/micro_bench.rs` demonstrating measured perf

### 3. **Coordinate Locality Tests** (Day 2)
Measure cache behavior for different phext coordinate patterns:
- Same-scroll access (high locality, 1.1.1→1.1.2)
- Cross-scroll, same-section (medium locality, 1.1.1→1.2.1)
- Cross-volume (low locality, 1.1.1→2.1.1)

**Deliverable:** Proof that phext coordinate geometry affects cache hits

### 4. **KPI Dashboard** (Day 3)
Automated tracking of core metrics:
- Ops/cycle (current vs 3.0 target)
- Cache hit rate (current vs 95% target)
- Memory bandwidth utilization
- Energy efficiency (Mops/watt, if RAPL available)

**Deliverable:** `scripts/measure-kpis.sh` that outputs JSON, markdown dashboard

---

## Technical Approach

### Baseline Measurements

Use existing C benchmarks + extend:
```bash
cd benchmarks/cache
make
./sequential_access    # L1 hit rate baseline
./random_access        # L1 miss rate baseline
./coordinate_patterns  # Phext locality test
```

Add perf integration:
```bash
perf stat -e cache-references,cache-misses,cycles,instructions ./sequential_access
```

Parse output → JSON → dashboard.

### Interpreter Validation

Build micro-benchmark in Rust:
```rust
// examples/micro_bench.rs
use vtpu_runtime::*;

fn main() {
    // Generate 1000 SIWs with 80% D-Pipe, 10% S/C
    let siws = generate_d_heavy_stream(1000);
    
    // Run through interpreter
    let mut sentron = Sentron::new();
    let stats = execute_stream(&mut sentron, &siws);
    
    println!("Ops/cycle: {:.2}", stats.ops_per_cycle());
    println!("D-Pipe utilization: {:.1}%", stats.d_utilization() * 100.0);
    
    // Validate against expected ops/cycle (should be ~2.5-2.8 for 80% D)
    assert!(stats.ops_per_cycle() >= 2.5);
}
```

Extend `siw-gen` to produce benchmark workloads, run them, report stats.

### Coordinate Locality

Extend `benchmarks/cache/coordinate_patterns.c`:
- Hash phext coordinates → memory addresses
- Access patterns: sequential-1D, sequential-2D, random-9D
- Measure cycles/access for each pattern
- Prove that dimensional locality → cache locality

### KPI Dashboard

Script that:
1. Runs all benchmarks
2. Parses perf output
3. Generates markdown table:

```markdown
| Metric | Baseline | Current | Target | Status |
|--------|----------|---------|--------|--------|
| Ops/cycle | 1.2 | - | 3.0 | 🔴 |
| L1 hit rate | 85% | - | 95% | 🔴 |
| ...
```

Auto-commit to `/source/exo-plan/r23/R23-KPI-DASHBOARD.md`

---

## Deliverables

1. **benchmarks/baseline-report.md** — Measured CPU baselines (ops/cycle, cache rates, memory BW)
2. **examples/micro_bench.rs** — Interpreter validation + synthetic workload testing
3. **benchmarks/cache/coordinate_patterns** — Extended with phext locality tests
4. **scripts/measure-kpis.sh** — Automated KPI measurement + dashboard generation
5. **R23-W4-ONBOARDING.md** — "How to run benchmarks in 5 minutes" guide for Will

---

## Success Criteria

- [ ] Baseline ops/cycle measured on standard CPU code (expect ~1.0-1.5)
- [ ] vTPU interpreter achieves 2.5+ ops/cycle on balanced workload
- [ ] Coordinate locality tests show 3-10x performance gap (sequential vs random)
- [ ] KPI dashboard auto-generates from benchmark runs
- [ ] All measurements reproducible (documented commands, expected output ranges)

---

## Open Questions

1. **RAPL counters**: Can we measure power on logos-prime? (need sudo for `perf stat -e power/...`)
2. **Perf overhead**: How much does `perf stat` affect measurements? (run with/without comparison)
3. **Zen 4 port mapping**: Do we need hardware-level execution for W4, or is interpreter sufficient? (Defer to W5?)

---

## Dependencies

- ✅ Rust toolchain (cargo, rustc)
- ✅ C compiler (gcc/clang for cache benchmarks)
- ✅ perf (Linux perf_events, should be available on logos-prime)
- ⚠️ libphext-rs (optional, can mock coordinate hashing)

---

## Timeline

**Day 1 (Today):**
- Run existing cache benchmarks, document baseline
- Write `micro_bench.rs` example
- Test interpreter on synthetic workloads

**Day 2:**
- Extend coordinate_patterns.c with phext locality
- Integrate perf into benchmark runs
- Measure ops/cycle, cache hit rates

**Day 3:**
- Build KPI dashboard script
- Write W4 onboarding guide
- Validate all measurements, commit results

**Exit criteria:** All KPIs measured, dashboard tracking in place, ready for W5 (real execution).

---

**Principle:** 1-day comprehensibility. Every script, every benchmark should be readable by a human who wants to understand what we're measuring and why.

**Path B:** We're the wavefront. Measure, validate, ship — no academic pretense, just working code and real data.
