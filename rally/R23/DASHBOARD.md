# R23 — vTPU: Virtual Tensor Processing Unit
## Rally Dashboard

**Started**: 2026-02-14
**Goal**: Software-defined AI accelerator on commodity AMD hardware
**KPI**: Sustained 3 ops/cycle/core (CPI-3) on Zen 4

---

## Wave Status

| Wave | Focus | Status | Key Output |
|---|---|---|---|
| W1 | Spec + Research | ✅ DONE | vTPU-spec-v0.2.md, R23-W40-projection.md |
| W2 | Phase 0 PoC — SIW benchmark | 🔨 ACTIVE | vtpu crate, **2.52 ops/cycle** ✅ target hit |
| W3 | PPT + dimensional locality | ✅ DONE | ppt.rs, PPT-95 ✅, 38 tests |
| W4 | HDC native ops (AVX-512) | ⬜ | |
| W5 | SASSOC + SROUTE | ⬜ | |
| W6 | CSLICE attention geometry | ⬜ | |
| W7 | Single-node integration | ⬜ | |
| W8 | Cluster C-Pipe transport | ⬜ | |
| W9 | phextcc compiler v0.1 | ⬜ | |
| W10 | End-to-end cognitive benchmark | ⬜ | |
| W11 | Pizza Party 🍕 | ⬜ | |

---

## KPI Tracker

| KPI | Target | Current | Wave |
|---|---|---|---|
| CPI-3 | 3.0 ops/cycle | **2.519** ✅ (4x unroll, 2 C-chains) | W2 |
| PPT-95 | ≥95% hit rate | **95.0%** ✅ (3D walk), 99.9% (cognitive) | W3 |
| HDC-ACC | ≥92% ISOLET | — | W4 |
| ROUTE-LAT | ≤3 cycles | — | W5 |
| ASSOC-LAT | ≤12 cycles | — | W5 |
| SLICE-PAR | 84 heads | — | W6 |
| MSG-HOP | ≤9 hops | — | W8 |
| COGOPS/W | ≥100K | — | W10 |
| COGOPS/$ | <100hr break-even | — | W10 |

---

## Artifacts

| File | Wave | Description |
|---|---|---|
| `specs/vTPU-spec-v0.1.md` | W1 | Original spec (697 lines) |
| `specs/vTPU-spec-v0.2.md` | W1 | HDC/MoE/attention rewrite |
| `specs/R23-W40-projection.md` | W1 | Success projection + KPI cascade |
| `rally/R23/DASHBOARD.md` | W2 | This file |
| `/source/vtpu/` | W2 | Phase 0 benchmark crate (Rust) |
