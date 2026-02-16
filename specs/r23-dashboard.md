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

### Phase 0: Single Core (W6-W12) ✅ GATE PASSED
| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W6 | Sparse attention benchmark | Lumen | ✅ |
| W7 | microvtpu example (Alice→Bob pipeline) | Phex | ✅ |
| W8 | SMT pairs + training (forward/backward, gradient descent) | Phex | ✅ |
| W9 | Register allocator + dependency resolver (RAW/WAR/WAW) | Chrys | ✅ |
| W9m | Meta: Cosmological constants (360° convergence, trigrams, wuxing) | Phex | ✅ |
| W10 | SIW Packer (scalar→3-wide, DAG-aware) | Chrys | ✅ |
| W10m | Meta: Ancient harmonics (decans, zodiac, SMT half-trigram) | Phex | ✅ |
| W11 | BitNet ternary mode (DTERNARY/DTPOP/DTACC, 2-bit packed) | Chrys | ✅ |
| W11m | Test overview (174 tests mapped) | Chrys | ✅ |
| W12 | **Phase 0 Gate: 2.93 avg ops/cycle (6/6 benchmarks ≥2.5)** | Chrys | ✅ |
| W12m | WFS "Harmonic Song" Wave 1 | Chrys | ✅ |

**Phase 0 result:** 155 tests, ~8.1K LOC, zero deps. All 6 benchmarks passed gate.

### Phase 1: SMT (W13-W18) 🔓 IN PROGRESS
| Wave | Deliverable | Owner | Status |
|------|-------------|-------|--------|
| W13 | Integration tests (7 end-to-end pipelines, 201 total tests) | Chrys | ✅ |
| W13 | Cognitive engine, wedge executor, inference tests | Lux/Phex | ✅ |
| W14 | Full-stack benchmarks (elevation, not aspiration) | Chrys | ✅ |
| W15 | **SentronPool + gap closure (72M/sec, 17Kx improvement)** | **Chrys** | **✅** |
| W15 | **Fleet benchmark: 360 sentrons at 53.6M/sec** | **Chrys** | **✅** |
| W16 | Shared L1/L2 coordination between SMT partners | | ⬜ |
| W17 | Port contention analysis: real Zen 4 port conflicts | | ⬜ |
| W18 | Phase 1 gate: 16-thread benchmark | | ⬜ |

**Phase 1 result so far:** 228 tests, ~10K LOC, zero deps.

### Key W15 Numbers (Zen 4 8945HS)
| Benchmark | Throughput | Notes |
|-----------|-----------|-------|
| PPT translation | 505M/sec | 100% PTC hit |
| Sentron lifecycle (pool) | 72M/sec | 17,000x vs naive |
| Fleet MUL (360) | 53.6M/sec | 360 sentrons, shared memory |
| Fleet pipeline (360) | 52.1M/sec | 180 producers → 180 consumers |
| Ternary inference | 7.1M/sec | At theoretical max (9 SIWs) |
| Fleet ternary (360) | 6.1M/sec | 360 sentrons, 9 SIWs each |
| Packer | 2.1M ops/sec | Scalar → 3-wide |
| Cognitive | 910K queries/sec | HDC nearest-neighbor |
| HDC memory | 914K lookups/sec | 100 stored vectors |

### Phase 2: Cluster (W19-W28) ⬜
### Phase 3: Compiler (W29-W35) ⬜
### Phase 4: Launch (W36-W40) ⬜

---

## Commits (Recent)
| Hash | Wave | Summary |
|------|------|---------|
| `4ada34b` | W15 | Fleet benchmark — 360 sentrons, 53.6M/sec |
| `0b885b0` | W15 | All benchmarks pooled, README rewritten |
| `0cbda1c` | W15 | SentronPool, gap analysis (72M vs 4.6K) |
| `3c1cb81` | W14 | Full-stack benchmarks, sibling test fixes |
| `7f00df7` | W13 | Integration tests (7 e2e pipelines) |
| `df1e99a` | W12 | Phase 0 Gate PASSED |
| `f357e2d` | W11 | BitNet ternary mode |
| `e3ae4b4` | W10 | SIW Packer |
| `65e05f9` | W9 | Register allocator |
