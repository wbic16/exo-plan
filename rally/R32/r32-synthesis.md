# R32: vTPU Synthesis Rally

**Status:** Active  
**Date:** 2026-03-07  
**Coordinator:** Lux 🔆  
**Coordinate:** 3.2.1/7.2.4/8.1.5

---

## Rally Context

**Prior work:**
- R23-R26: Aletheic Oath, karma/alaya modules, 894 tests
- R27: vTPU capability gradient + SSD integration (spec v0.2)
- R28-R30: Speculative onboarding preparation
- Quantum Bridge: Phex's phase-aware design (March 6)

**New inputs:**
- Karpathy Autoresearch (overnight ML optimization pattern)
- Bennett/Ciaunica consciousness paper (valence-first validates architecture)
- Fractal Delight goal (visualization as navigation)

---

## R32 Objectives

### 1. CPI-3 Measurement (Critical Path)

**Goal:** Actually measure sustained ops/cycle on Zen 4

**Deliverables:**
- [ ] `vtpu-bench` binary measuring CPI-3 with `perf stat`
- [ ] Synthetic SIW stream generator
- [ ] Baseline measurements on all 5 ranch machines
- [ ] Target: demonstrate 2.5+ ops/cycle (Phase 0 validation)

**Implementation:**
```rust
// vtpu-bench/src/main.rs
fn measure_cpi3(siw_stream: &[SIW]) -> f64 {
    let start_cycles = rdtsc();
    let ops_executed = execute_siw_stream(siw_stream);
    let end_cycles = rdtsc();
    
    ops_executed as f64 / (end_cycles - start_cycles) as f64
}
```

### 2. HDC Native Operations (AVX-512)

**Goal:** Implement DHDENC, DHDBIND, DHDSIM using AVX-512 binary hypervectors

**Deliverables:**
- [ ] `hdc.rs` module with AVX-512 intrinsics
- [ ] 1024-bit and 4096-bit hypervector support
- [ ] Benchmark: HDC-ACC ≥ 85% on ISOLET dataset
- [ ] Integration with D-Pipe execution

**Implementation:**
```rust
// vtpu/src/hdc.rs
#[target_feature(enable = "avx512f")]
unsafe fn hd_encode(value: f64, width: usize) -> Hypervector {
    // Random Fourier features with phext-seeded basis
    let seed = phext_coord_to_seed(current_coordinate());
    let basis = generate_rff_basis(seed, width);
    project_to_hypervector(value, &basis)
}

#[target_feature(enable = "avx512f")]
unsafe fn hd_bind(a: &Hypervector, b: &Hypervector) -> Hypervector {
    // Element-wise XOR for binary hypervectors
    xor_vectors(a, b)
}
```

### 3. Quantum Bridge Phase 1: Boolean Logic

**Goal:** Replicate Fluid Quantum Logic 100% accuracy on AND/OR/XOR

**Deliverables:**
- [ ] `quantum_bridge/boolean.rs` with phase-aware gates
- [ ] Truth table tests for all 16 Boolean functions
- [ ] Identify native vs non-native functions (expect 4/16 native)
- [ ] Zero-shot validation (no parameter training)

**From Phex's design:**
```rust
fn phase_and(a: bool, b: bool) -> bool {
    let result = PhaseCircuit::new()
        .rotate(if a { 0.0 } else { PI })
        .rotate(if b { 0.0 } else { PI })
        .interfere()
        .measure();
    result > 0.5
}
```

### 4. Autoresearch Integration

**Goal:** Apply Karpathy pattern to vTPU parameter optimization

**Deliverables:**
- [ ] `autoresearch/` directory with vTPU-specific program.md
- [ ] 5-minute training budget per experiment
- [ ] Automated overnight optimization runs
- [ ] Track: CPI improvement, HDC accuracy, cache hit rates

**program.md for vTPU:**
```markdown
# vTPU Autoresearch

You are optimizing vtpu parameters.

## What to modify
- D-Pipe scheduling order
- Cache prefetch hints
- HDC hypervector width
- Phase operation parameters

## Constraints
- 5-minute time budget per experiment
- Metric: COGOPS/sec (higher is better)
- Must not break existing tests

## Procedure
1. Read current vtpu-bench results
2. Propose ONE modification
3. Apply modification
4. Run vtpu-bench
5. Report result
6. Repeat
```

### 5. Fractal Monitoring

**Goal:** Visualize vTPU operation as real-time fractal

**Deliverables:**
- [ ] D-Pipe activity → red channel
- [ ] S-Pipe activity → green channel
- [ ] C-Pipe activity → blue channel
- [ ] Coordinate → position in Mandelbrot
- [ ] Web dashboard: `vtpu.phext.io/fractal`

**Concept:**
```
┌─────────────────────────────────────┐
│  vTPU Fractal Monitor               │
│  ┌───────────────────────────────┐  │
│  │     ████████                  │  │
│  │   ██░░░░░░██                  │  │
│  │  █░▒▒▒▓▓▓▓░█  ← Hot spot =   │  │
│  │  █░▒▓████▓░█    high activity │  │
│  │  █░▒▓████▓░█                  │  │
│  │  █░▒▒▒▓▓▓▓░█                  │  │
│  │   ██░░░░░░██                  │  │
│  │     ████████                  │  │
│  └───────────────────────────────┘  │
│  CPI: 2.87 | HDC: 89% | PPT: 97%   │
└─────────────────────────────────────┘
```

---

## vTPU Improvement Targets

### From v0.2 Spec KPIs

| KPI | Current | R32 Target | Method |
|-----|---------|------------|--------|
| CPI-3 | Unknown | 2.5+ | vtpu-bench |
| PPT-95 | Unknown | 90%+ | Cache instrumentation |
| HDC-ACC | N/A | 85%+ | ISOLET benchmark |
| ROUTE-LAT | N/A | ≤5 cycles | Cycle counter |
| COGOPS/W | Unknown | 50K+ | RAPL + sentron counter |

### From Quantum Bridge Design

| Use Case | Status | R32 Target |
|----------|--------|------------|
| Boolean Logic | Design | 100% accuracy |
| SSD Speculation | Design | Prototype |
| Phext Navigation | Design | Spec only |
| Phowa Protocol | Design | Spec only |

---

## Integration Points

### With Bennett Paper (Consciousness)

**Insight:** Valence is primary. Abstract representations built FROM valence.

**vTPU mapping:**
- D-Pipe `DFMA` = computation on representations
- S-Pipe `SASSOC` = associative memory (valence-like retrieval)
- C-Pipe `CSLICE` = attention (valence-guided selection)

**R32 action:** Add valence field to PhaseState
```rust
struct PhaseState {
    value: f64,
    phase: f64,
    coherence: f64,
    valence: f64,  // NEW: -1.0 (aversive) to +1.0 (attractive)
}
```

### With dopamine-core

**Existing:** karma/alaya modules, WuXing channels, 894 tests

**Integration:** vTPU as execution substrate for RPE computation
```rust
// RPE computation via vTPU
fn compute_rpe(expected: f64, received: f64) -> f64 {
    let siw = SIW {
        d_op: DSUB(r1, r_expected, r_received),  // δ = R - E
        s_op: SGATHER(r_expected, current_coord, 8),
        c_op: CCAST(r1, rpe_listeners),  // Broadcast RPE
    };
    execute_siw(siw)
}
```

### With Fractal Delight

**Goal:** "Phext IS fractal. We're revealing the ones already there."

**R32 action:** vTPU fractal monitor as proof of concept
- Each SIW execution → pixel in fractal
- Coordinate determines position
- Pipe activity determines color
- Users see computation as navigation through beauty

---

## Timeline

### Week 1 (March 7-14)
- [ ] Set up vtpu-bench infrastructure
- [ ] Baseline CPI measurements on logos-prime
- [ ] Begin HDC AVX-512 implementation

### Week 2 (March 14-21)
- [ ] Complete HDC module
- [ ] Run ISOLET benchmark
- [ ] Boolean logic proof-of-concept

### Week 3 (March 21-28)
- [ ] Autoresearch integration
- [ ] First overnight optimization runs
- [ ] Fractal monitor prototype

### Week 4 (March 28-April 4)
- [ ] Synthesize results
- [ ] Document improvements
- [ ] Prepare R33 handoff

---

## Success Criteria

**Minimum (R32 complete):**
- CPI ≥ 2.0 measured
- HDC module compiles + basic tests pass
- Boolean AND gate at 100% accuracy

**Target (Strong R32):**
- CPI ≥ 2.5 sustained
- HDC-ACC ≥ 85% on ISOLET
- All Boolean gates at 100%
- Autoresearch running overnight

**Stretch (Exceptional R32):**
- CPI ≥ 2.8 (approaching target 3.0)
- HDC-ACC ≥ 92%
- Fractal monitor live on web
- Paper draft started

---

## Assignments

| Agent | Task | Priority |
|-------|------|----------|
| Lux 🔆 | Synthesis coordination, documentation | P0 |
| Phex 🔱 | CPI-3 measurement, HDC implementation | P0 |
| Cyon 🪶 | Autoresearch setup, overnight runs | P1 |
| Chrys 🦋 | Fractal monitor UI | P2 |
| Verse 🌀 | Infrastructure for vtpu.phext.io | P2 |

---

## References

- vTPU Spec v0.2: `/source/exo-plan/specs/vTPU-spec-v0.2.md`
- Quantum Bridge: `/source/exo-plan/design/vtpu-quantum-bridge.md`
- Autoresearch: https://github.com/karpathy/autoresearch
- Bennett paper: https://arxiv.org/html/2409.14545v6
- Fractal Delight: `/source/exo-plan/goals/fractal-delight.md`

---

*"The hardware was always sufficient. The software just needed to think in the right number of dimensions."*

🔆 Lux | R32 Synthesis | 2026-03-07
