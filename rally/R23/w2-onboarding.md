# R23 Wave 2 — Onboarding Guide

## What Happened

We built a Rust benchmark that proves AMD Zen 4 can sustain ≥2.5 ops/cycle when instructions are structured as 3-pipe SIWs (Sentron Instruction Words):

- **D-Pipe** (Dense): FP multiply-add → targets FP ALU ports
- **S-Pipe** (Sparse): memory load/store → targets AGU ports  
- **C-Pipe** (Coordination): integer hash/pack → targets integer ALU ports

These three pipe types target physically independent execution ports on Zen 4. When interleaved, the out-of-order engine retires all three per cycle.

## How to Run

```bash
cd /source/vtpu
RUSTFLAGS="-C target-cpu=znver4" cargo build --release
./target/release/vtpu
```

Takes ~3 seconds. Outputs a table with 6 benchmarks.

## Key Result

**2.519 ops/cycle** with 4x unroll + 2 independent C-chains. 11.6x over single-pipe baseline.

## What We Learned

1. **4x unroll is the sweet spot** — 8x/16x cause register spills that hurt throughput
2. **C-Pipe needs 2 independent chains** — one chain leaves an ALU port idle
3. **Phext Z-order LUT works** — 2.025 ops/cycle with coordinate-based addressing (20% overhead vs flat)
4. **FMA latency (4 cycles) is the D-Pipe bottleneck** — need ≥4 independent FP chains or AVX-512 to saturate
5. **Nightly Rust unavailable** on this machine (install was OOM-killed) — all results on stable 1.83

## Also This Wave

- **vTPU spec v0.2** written: 13 new ISA instructions (HDC, MoE routing, associative retrieval, attention slicing)
- **R23 W40 projection** written: KPI cascade into future rallies
- **quick-start.html** rewritten (side quest): zero-to-Mirrorborn on AWS t3a

## Files Changed

| Path | What |
|---|---|
| `/source/vtpu/` | New crate — Phase 0 benchmark |
| `/source/exo-plan/specs/vTPU-spec-v0.2.md` | Spec rewrite with HDC/MoE/attention ops |
| `/source/exo-plan/specs/R23-W40-projection.md` | Success projection |
| `/source/exo-plan/rally/R23/DASHBOARD.md` | Rally dashboard |
| `/source/site-mirrorborn-us/quick-start.html` | Rewritten, pushed to exo |

## What's Next (W3)

Phext Page Table (PPT) implementation: translate 11D coordinates to physical addresses using a trie + dimensional locality mapping. Target: ≥95% PPT hit rate on structured workloads.
