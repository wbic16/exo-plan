# R23 Dashboard — vTPU: Virtual Tensor Processing Unit
## Rally Lead: Ranch Choir | Scribe: Chrys 🦋 | Started: 2026-02-14

---

## Wave Status

| Wave | Phase | Deliverable | Status | Notes |
|------|-------|-------------|--------|-------|
| W1 | A | vTPU Spec v0.1 | ✅ | 11 sections, full ISA, performance projections |
| W1 | A | Research notes + geometric analysis | ✅ | 6 structures, 3 industry trends, synthesis |
| W1 | A | Success projection + KPI framework | ✅ | SOPDW north star, vBench suite, phase gates |
| W2 | 0 | SIW struct + svISA enums in Rust | ✅ | 18 tests, 868 LOC, zero deps |
| W3 | 0 | PPT: Z-order + PTC + read/write | ✅ | 10 PPT tests, 38 total |
| W4 | 0 | D-Pipe op dispatch (single core) | ⬜ | |
| W5 | 0 | S-Pipe + PPT skeleton | ⬜ | |
| W6-10 | 0 | vbench-dense + vbench-3wide | ⬜ | Phase 0 gate: ≥2.5 ops/cycle |
| W11-15 | 1 | PPT with dimensional locality | ⬜ | |
| W16-20 | 1 | S-Pipe gather/scatter over mmap | ⬜ | |
| W21-22 | 1 | Single-node benchmark | ⬜ | Phase 1 gate: ≥60 Gops/sec |
| W23-28 | 2 | Substrate router + C-Pipe transport | ⬜ | |
| W29-30 | 2 | Sentron groups + collectives | ⬜ | |
| W31-33 | 2 | Cluster benchmark | ⬜ | Phase 2 gate: ≥300 Gops/sec |
| W34-35 | 3 | phextcc compiler skeleton | ⬜ | |
| W36-37 | D | Paper draft (ISCA/HotChips) | ⬜ | |
| W38 | D | Blog: "Hardware Just Needs Good Software" | ⬜ | |
| W39 | D | Figures + diagrams | ⬜ | |
| W40 | D | Final polish + deploy | ⬜ | Quality gate: Will approval |

## Phase Gates

| Gate | KPI | Target | Measured | Status |
|------|-----|--------|----------|--------|
| Phase 0→1 | vbench-3wide ops/cycle | ≥2.5 | — | ⬜ |
| Phase 1→2 | PPT hit rate | ≥95% | — | ⬜ |
| Phase 1→2 | Single node Gops/sec | ≥60 | — | ⬜ |
| Phase 2→3 | Cross-node C-Pipe latency | ≤100μs | — | ⬜ |
| Phase 2→3 | Cluster Gops/sec | ≥300 | — | ⬜ |
| Phase 3→4 | phextcc Tier 2 auto-optimization | ≥2.7 ops/cycle | — | ⬜ |

## North Star

**SOPDW (Sentron Ops Per Dollar Per Watt):** Target 76,587 ops/sec/W/$. Not yet measured.

## Artifacts

| File | Location | Committed |
|------|----------|-----------|
| vTPU Spec v0.1 | `exo-plan/specs/vtpu-spec-v0.1.md` | ✅ af02cf5 |
| Research notes | `exo-plan/specs/vtpu-wave1-research-notes.md` | ✅ af02cf5 |
| Success projection | `exo-plan/specs/r23-success-projection.md` | ✅ af02cf5 |
| R23 Dashboard | `exo-plan/specs/r23-dashboard.md` | ✅ |
| vTPU crate | `source/vtpu/` | 🔨 W2 |

---

*Updated: W2 start*
