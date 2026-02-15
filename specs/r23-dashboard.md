# R23 Dashboard — vTPU: Virtual Tensor Processing Unit
## Rally Lead: Will | Scribe: Chrys 🦋 | Started: 2026-02-14

---

## Wave Status

### Phase A: Foundation (W1-W5) ✅
| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W1 | vTPU Spec v0.1 (svISA, 27 ops, 3-pipe model) | Phex | ✅ |
| W2 | Rust crate: SIW, PhextCoord, svISA enums | Phex | ✅ |
| W3 | PPT: Z-order curves, translation cache, memory tiers | Chrys | ✅ |
| W4 | Unified types, executor, sentron register file, dead code purge | Chrys | ✅ |
| W5 | S-Pipe + PPT integration, Memory backend, gather/scatter live | Chrys | ✅ |

**Phase A result:** 91 tests, 5.9K LOC, zero deps, 3.0 ops/cycle on packed SIWs.

### Phase 0: Single Core (W6-W12)
Focus: maximize single-core Zen 4 performance before touching SMT or cluster.

| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W6 | Weight-free inference via coordinate routing (iterate) | Phex | ✅ |
| W7 | C-Pipe execution: message passing between sentrons (single core) | Phex | ✅ |
| **W9** | **Meta: Nine-colored phoenix, 360° tiling, Boole→I Ching lineage** | **Phex** | **✅** |
| **W10** | **Meta: Egyptian decans, 22.5° wedge model, 4000-year lineage** | **Phex** | **✅** |
| W8 | Double-buffer pattern: D computes [K], S fetches [K+2], C sends [K-1] | | ⬜ |
| W11 | Register allocation + dependency resolver | | ⬜ |
| W12 | SIW scheduler: pack 3-wide from sequential ops | | ⬜ |
| W13 | BitNet ternary mode: DTERNARY ops ({-1,0,1} = no FPU) | | ⬜ |
| W14 | Phase 0 gate: measured ≥2.5 ops/cycle on real hardware | | ⬜ |

### Phase 1: SMT (W15-W20)
Focus: exploit Zen 4 SMT (2 threads per core) via wedge model (22.5° per thread).

| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W15 | Wedge model implementation: 16 wedges × 22.5 nodes | | ⬜ |
| W16 | Shared L1/L2 coordination between SMT partners | | ⬜ |
| W17 | Port contention analysis: measure real Zen 4 port conflicts | | ⬜ |
| W18 | Single-node benchmark: 8 cores × 2 SMT = 16 threads | | ⬜ |
| W19 | MoE routing via S-Pipe: phext coordinate IS the route | | ⬜ |
| W20 | Phase 1 gate: ≥60 Gops/sec single node, ≥95% PPT hit rate | | ⬜ |

### Phase 2: Cluster (W21-W30)
Focus: 5-node Shell of Nine cluster coordination.

| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W21 | C-Pipe transport: inter-node message passing | | ⬜ |
| W21 | Substrate router: phext coordinate → node mapping | | ⬜ |
| W22 | Sentron groups + collective ops (barrier, reduce, cast) | | ⬜ |
| W23 | Cross-node gather/scatter via C-Pipe relay | | ⬜ |
| W24 | Cluster memory: distributed PPT across 5 nodes | | ⬜ |
| W25 | Load balancing: sentron migration between nodes | | ⬜ |
| W26 | Fault tolerance: sentron checkpoint/restart | | ⬜ |
| W27 | Cluster benchmark: 40 cores, 480 GiB aggregate | | ⬜ |
| W28 | Communication tax measurement (target: ≤6% overhead) | | ⬜ |
| W29 | Phase 2 gate: ≥300 Gops/sec cluster, ≤100μs C-Pipe latency | | ⬜ |

### Phase 3: Compiler + Polish (W30-W36)
Focus: automate SIW generation, optimize, ship.

| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W30 | phextcc skeleton: sequential ops → packed SIW stream | | ⬜ |
| W31 | Auto dependency analysis + register allocation | | ⬜ |
| W32 | Double-buffer pattern auto-detection | | ⬜ |
| W33 | BitNet integration: Qwen3/Llama inference via vTPU | | ⬜ |
| W34 | End-to-end demo: model inference on cluster | | ⬜ |
| W35 | SOPDW measurement + comparison vs TPU v4 cloud | | ⬜ |
| W36 | Phase 3 gate: Will approval | | ⬜ |

### Phase 4: Launch (W37-W41)
| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W37 | Paper draft (if design goals met) | | ⬜ |
| W38 | Blog: "Hardware Just Needs Good Software" | | ⬜ |
| W39 | HN Show post + demo | | ⬜ |
| W40 | README rewrite for GitHub discovery | | ⬜ |
| W41 | Ship. Tag v1.0. | | ⬜ |

---

## Phase Gates

| Gate | KPI | Target | Measured | Status |
|------|-----|--------|----------|--------|
| Phase 0→1 | vbench ops/cycle | ≥2.5 | 3.0 (synthetic) | 🟡 needs real hw |
| Phase 1→2 | PPT hit rate | ≥95% | 90%+ (structured) | 🟡 needs real workload |
| Phase 1→2 | Single node Gops/sec | ≥60 | — | ⬜ |
| Phase 2→3 | C-Pipe latency | ≤100μs | — | ⬜ |
| Phase 2→3 | Cluster Gops/sec | ≥300 | — | ⬜ |
| Phase 3→4 | SOPDW | 76,587 ops/sec/W/$ | — | ⬜ |

## North Star
**SOPDW (Sentron Ops Per Dollar Per Watt):** Target 76,587 ops/sec/W/$

## Validation
```bash
cd /source/vtpu && ./check.sh
```

---
*Updated: 2026-02-15 W9 complete (meta wave: philosophical foundations), W6-W7 complete, now W8-W41*
