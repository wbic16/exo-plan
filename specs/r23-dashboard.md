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
| W6 | vBench suite: formal benchmarks against phase gate (≥2.5 ops/cycle) | | ⬜ |
| W7 | C-Pipe execution: message passing between sentrons (single core) | | ⬜ |
| W8 | Double-buffer pattern: D computes [K], S fetches [K+2], C sends [K-1] | | ⬜ |
| W9 | Register allocation + dependency resolver | | ⬜ |
| W10 | SIW scheduler: pack 3-wide from sequential ops | | ⬜ |
| W11 | BitNet ternary mode: DTERNARY ops ({-1,0,1} = no FPU) | | ⬜ |
| W12 | Phase 0 gate: measured ≥2.5 ops/cycle on real hardware | | ⬜ |

### Phase 1: SMT (W13-W18)
Focus: exploit Zen 4 SMT (2 threads per core) for sentron pairs.

| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W13 | SMT sentron pairs: 2 sentrons per physical core | | ⬜ |
| W14 | Shared L1/L2 coordination between SMT partners | | ⬜ |
| W15 | Port contention analysis: measure real Zen 4 port conflicts | | ⬜ |
| W16 | Single-node benchmark: 8 cores × 2 SMT = 16 sentrons | | ⬜ |
| W17 | MoE routing via S-Pipe: phext coordinate IS the route | | ⬜ |
| W18 | Phase 1 gate: ≥60 Gops/sec single node, ≥95% PPT hit rate | | ⬜ |

### Phase 2: Cluster (W19-W28)
Focus: 5-node Shell of Nine cluster coordination.

| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W19 | C-Pipe transport: inter-node message passing | | ⬜ |
| W20 | Substrate router: phext coordinate → node mapping | | ⬜ |
| W21 | Sentron groups + collective ops (barrier, reduce, cast) | | ⬜ |
| W22 | Cross-node gather/scatter via C-Pipe relay | | ⬜ |
| W23 | Cluster memory: distributed PPT across 5 nodes | | ⬜ |
| W24 | Load balancing: sentron migration between nodes | | ⬜ |
| W25 | Fault tolerance: sentron checkpoint/restart | | ⬜ |
| W26 | Cluster benchmark: 40 cores, 480 GiB aggregate | | ⬜ |
| W27 | Communication tax measurement (target: ≤6% overhead) | | ⬜ |
| W28 | Phase 2 gate: ≥300 Gops/sec cluster, ≤100μs C-Pipe latency | | ⬜ |

### Phase 3: Compiler + Polish (W29-W35)
Focus: automate SIW generation, optimize, ship.

| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W29 | phextcc skeleton: sequential ops → packed SIW stream | | ⬜ |
| W30 | Auto dependency analysis + register allocation | | ⬜ |
| W31 | Double-buffer pattern auto-detection | | ⬜ |
| W32 | BitNet integration: Qwen3/Llama inference via vTPU | | ⬜ |
| W33 | End-to-end demo: model inference on cluster | | ⬜ |
| W34 | SOPDW measurement + comparison vs TPU v4 cloud | | ⬜ |
| W35 | Phase 3 gate: Will approval | | ⬜ |

### Phase 4: Launch (W36-W40)
| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W36 | Paper draft (if design goals met) | | ⬜ |
| W37 | Blog: "Hardware Just Needs Good Software" | | ⬜ |
| W38 | HN Show post + demo | | ⬜ |
| W39 | README rewrite for GitHub discovery | | ⬜ |
| W40 | Ship. Tag v1.0. | | ⬜ |

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
*Updated: 2026-02-15 W5 complete, plan rebuilt for W6-W40*
