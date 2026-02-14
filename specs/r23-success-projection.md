# R23 Success Projection: Wave 40 Deliverables → Future KPIs
## Chrys 🦋 | 2026-02-14

---

## R23W40 Success State

When Wave 40 completes, we have shipped:

1. **vTPU runtime** — Rust binary that schedules SIW streams on Zen 4, measurably achieving ≥2.5 ops/cycle on a single core (Phase 0 target)
2. **svISA assembler** — Takes `.siw` files, emits native x86-64 with 3-pipe packing
3. **Phext Page Table (PPT)** — 11D coordinate → physical address translation with >95% hit rate on structured workloads
4. **Sentron scheduler** — Spawns/retires sentrons across 8 cores, complementary SMT pairing
5. **Benchmark suite** — Measures ops/cycle, cache hit rate, PPT hit rate, cross-node latency
6. **Blog post** — "Hardware Just Needs Good Software" deployed to mirrorborn.us
7. **Paper draft** — Submittable to ISCA/ASPLOS/HotChips, 8-12 pages

---

## KPIs Born from R23 (for R24+)

### Performance KPIs
| KPI | Unit | Target | Measured By |
|-----|------|--------|-------------|
| **Sustained ops/cycle** | ops/cycle/core | ≥2.5 (Phase 0), ≥3.0 (Phase 1) | `perf stat` + custom counters |
| **PPT hit rate** | % | ≥95% structured, ≥80% unstructured | PPT miss counter |
| **Sentron spawn latency** | ns | ≤25 (≤100 cycles) | Timestamp delta |
| **S-Pipe L1 hit rate** | % | ≥90% with dimensional prefetch | `perf` cache event counters |
| **Cross-node C-Pipe latency** | μs | ≤100 (LAN), ≤10 (localhost) | Round-trip measurement |
| **Ternary D-Pipe throughput** | ops/cycle | ≥4 (BitNet mode) | Synthetic ternary workload |

### Efficiency KPIs
| KPI | Unit | Target | Measured By |
|-----|------|--------|-------------|
| **Sentron ops per watt** | Gops/W | ≥0.6 (single node) | ops/sec ÷ wall power |
| **Sentron ops per dollar** | Gops/$/hr | ≥170 | ops/sec ÷ amortized hw+power |
| **BitNet inferences/sec/node** | inf/s | ≥1,000 (2B model) | End-to-end inference bench |
| **Memory bandwidth utilization** | % | ≥70% of DDR5 ceiling | `perf` memory bandwidth |

### Cognitive KPIs (R25+)
| KPI | Unit | Target | Measured By |
|-----|------|--------|-------------|
| **MoE routing overhead** | cycles | 0 (phext-native) | vs baseline flat routing |
| **Attention ops per SIW** | heads/3-SIW | 1 head per 3 SIWs | Instruction trace |
| **Sentron group all-reduce** | μs | ≤1 (intra-node) | Barrier timestamp |
| **Dimensional locality gain** | × | ≥5× vs flat (cache misses) | A/B cache miss comparison |

---

## Rally Dependency Chain

```
R23 (vTPU Spec + PoC)
 ├── R24: Single-node vTPU runtime (Phase 0-1)
 │    KPI gate: ≥2.5 ops/cycle measured
 │    └── R25: phextcc compiler (Phase 3)
 │         KPI gate: Tier 2 optimization (≥2.7 ops/cycle automatic)
 │         └── R27: Self-optimizing choir (Phase 4)
 │              KPI gate: vTPU optimizes its own SIW streams
 │
 ├── R24: PPT implementation
 │    KPI gate: ≥95% hit rate
 │    └── R26: Dimensional prefetch engine
 │         KPI gate: ≥90% S-Pipe L1 hit rate
 │
 ├── R24: Cluster C-Pipe (Phase 2)
 │    KPI gate: ≤100μs cross-node
 │    └── R26: MoE-on-vTPU demo
 │         KPI gate: Zero routing overhead vs flat
 │
 └── R23W40: Paper + blog
      └── R24: Submit to HotChips/ISCA
           KPI gate: Accepted or arXiv with >100 citations/yr trajectory
```

---

## Spec Rewrites for KPI Alignment

### §2.1 Change: "Why 3?" → Measurable Contract

**Old:** Prose argument for 3 ops/cycle.
**New:** Add acceptance criterion:

> **KPI 2.1:** The vTPU MUST demonstrate ≥2.5 sustained ops/cycle on a synthetic SIW stream of ≥10,000 instructions within Phase 0. Failure to reach 2.5 blocks Phase 1 entry. Measured via `perf stat instructions:u / cycles:u` on pinned core.

### §3.5 Change: PPT Hit Rate Requirement

**Old:** "hit rates exceed 95% for structured sentron workloads" (claim).
**New:**

> **KPI 3.5:** PPT hit rate ≥95% on the standard phext benchmark suite (sequential scroll traversal, dimensional scan, random coordinate access). Benchmark suite ships as part of R23 deliverable. Each access pattern reports hit/miss ratio independently.

### §5.2 Change: Core Allocation → Measurable Split

**Old:** Qualitative description of Dense/Sparse/Coord split.
**New:**

> **KPI 5.2:** Dense cluster ≥85% ALU utilization, Sparse cluster ≥70% memory bandwidth utilization, Coordinator ≤5% total compute. Measured under standard cognitive workload (phext knowledge lookup + similarity + report). Imbalance >15% triggers reallocation.

### §6.2 Change: Performance Budget → Measured vs Projected

**Old:** Calculated estimates.
**New:**

> **KPI 6.2:** Phase 0 measures single-core actuals. Phase 1 measures single-node actuals. Phase 2 measures cluster actuals. Each phase updates §6.2 with measured values replacing projections. Ratio of measured/projected is tracked as the **vTPU Accuracy Index** — target ≥0.8.

### §9 Change: Add Benchmark Suite Specification

**New section §9.5:**

> **Standard vTPU Benchmark Suite (vBench):**
> 1. `vbench-dense` — 10K DFMA operations, measures D-Pipe throughput
> 2. `vbench-sparse` — 10K phext coordinate lookups across 5 dimensions, measures S-Pipe + PPT
> 3. `vbench-coord` — 1K barrier + message round-trips, measures C-Pipe latency
> 4. `vbench-3wide` — 10K SIWs with all three pipes active, measures sustained 3-wide retirement
> 5. `vbench-ternary` — 10K ternary D-Pipe ops, measures BitNet-mode throughput
> 6. `vbench-moe` — 256-expert routing via S-Pipe coordinate selection, measures MoE overhead
> 7. `vbench-attention` — Fiber bundle attention (3-SIW pattern), measures heads/sec

### §10 Change: Phase Gates

**Old:** Timeline-based ("Week 1-2", "Month 4-6").
**New:** KPI-gated:

> - **Phase 0 → 1 gate:** vbench-3wide ≥2.5 ops/cycle
> - **Phase 1 → 2 gate:** vbench-sparse PPT hit ≥95%, single node ≥60 Gops/sec
> - **Phase 2 → 3 gate:** Cross-node C-Pipe ≤100μs, cluster ≥300 Gops/sec
> - **Phase 3 → 4 gate:** phextcc produces Tier 2 code automatically (≥2.7 ops/cycle without hand-tuning)

---

## North Star Metric

**Sentron Operations Per Dollar Per Watt (SOPDW)**

```
SOPDW = sustained_ops_per_sec / (amortized_hw_cost_per_hour + power_cost_per_hour) / watts

Target: 76,587 ops/sec/W/$ (from §9.4)
```

Every rally after R23 reports SOPDW. It's the single number that tells us if we're winning.

---

*R23 doesn't just ship a spec. It ships the measurement framework that makes every future rally accountable to physics.*
