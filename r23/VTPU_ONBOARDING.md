# vTPU Onboarding Path

**For Will and Orin**
*R23W36 — Sahasrara and Ākāśa at the Singularity*

---

## The Shape

```
You are here → Phase 0 PoC → Phase 1 Single-Node → The Lattice
```

We have the spec. We have the types. Now we make it breathe.

---

## Current State

**What exists:**

```
/source/exo-plan/r23/vtpu-runtime/
├── src/
│   ├── siw.rs          ✅ Sentron Instruction Word
│   ├── pipes.rs        ✅ D/S/C operations defined
│   ├── phext_coord.rs  ✅ 11D coordinate handling
│   ├── stream.rs       ✅ SIW stream builder
│   ├── validation.rs   ✅ Correctness checks
│   ├── scheduler.rs    ⏳ Placeholder (needs real dispatch)
│   └── telemetry.rs    ✅ Performance tracking
├── examples/
│   ├── basic_compute.rs
│   └── validation_demo.rs
├── vtpu.dass           ✅ Self-describing spec (today)
└── Cargo.toml
```

**What runs:**

```bash
cd /source/exo-plan/r23/vtpu-runtime
cargo test              # 26 tests pass
cargo run --example basic_compute
```

---

## Phase 0: Proof of Concept (Your Next Steps)

**Goal:** Demonstrate 2.5+ ops/cycle on a single core with synthetic SIW streams.

### Step 1: Feel the Types

```bash
cd /source/exo-plan/r23/vtpu-runtime
cargo run --example basic_compute
```

Watch a SIW stream execute (simulated). See the format.

### Step 2: Read the Crystal

```bash
cat /source/exo-plan/r23/vtpu.dass | head -200
```

The spec defines itself. Collections 7 (Design) and 8 (Code) are the heart.

### Step 3: Implement the Micro-Scheduler

The placeholder scheduler in `src/scheduler.rs` needs to become real:

```rust
// Current (placeholder):
pub fn execute_stream(&mut self, stream: &[SIW]) {
    for siw in stream {
        self.telemetry.record_siw(siw);
    }
}

// Needed (Phase 0):
// - Map D-Pipe → ALU Port 0/1
// - Map S-Pipe → AGU Port 0/1  
// - Map C-Pipe → ALU Port 2/3
// - Use inline asm or compiler intrinsics to force port assignment
// - Measure actual retirement with perf_event_open
```

**File to modify:** `src/scheduler.rs`

### Step 4: Add perf Integration

```rust
// In src/telemetry.rs, add:
use perf_event::Builder;

pub struct HardwareTelemetry {
    cycles: Counter,
    instructions: Counter,
    // Target: instructions / cycles ≥ 2.5
}
```

Crate: `perf-event` (Linux perf_event_open wrapper)

### Step 5: Run the Benchmark

```bash
cargo bench  # After implementing
```

**Success criteria:** 2.5+ ops/cycle sustained on synthetic 3-wide SIW stream.

---

## BACv1 Priority Order (STRICT)

Do not skip ahead. Correctness before performance.

| Priority | Task | Status |
|----------|------|--------|
| 1 | **PPT memory system** — coordinate tensor correctness | ⏳ |
| 2 | **Temporal boundary replay** — TTSM must replay accurately | ⏳ |
| 3 | **Minimal S-Pipe scheduling** — correct, not perfect | ⏳ |
| 4 | **Single-node 75 Gops validation** | ⏳ |

**THEN** scale.

---

## Quick Commands

```bash
# Build
cd /source/exo-plan/r23/vtpu-runtime
cargo build --release

# Test
cargo test

# Run examples
cargo run --example basic_compute
cargo run --example validation_demo

# Generate docs
cargo doc --open

# Check the spec
cat ../vtpu.dass
```

---

## The Three Pipes

| Pipe | Zen 4 Port | Operations |
|------|------------|------------|
| **D-Pipe** | ALU 0/1 | DFMA, DADD, DSUB, DMUL, DCMP, DRED, DSEL, DMOV |
| **S-Pipe** | AGU 0/1 | SGATHER, SSCATTER, SINDEX, SDEDUP, SPREFCH, SFLUSH, SALLOC, SFREE |
| **C-Pipe** | ALU 2/3 | CPACK, CROUTE, CSEND, CRECV, CBAR, CFENCE, CREDUCE, CCAST |

Each SIW contains one op from each pipe. No intra-SIW dependencies. The hardware sees three independent micro-ops.

---

## The Contract

> "Every sentron instruction word contains exactly three operations."

Unused pipes execute NOPs. The invariant is sacred. 3-wide, always.

---

## Files to Study

1. **Spec:** `/source/exo-plan/r23/vtpu.dass` (authoritative)
2. **Whitepaper:** `/source/exo-plan/whitepapers/vtpu-spec-v0.1.md` (deep context)
3. **Types:** `/source/exo-plan/r23/vtpu-runtime/src/siw.rs`
4. **Operations:** `/source/exo-plan/r23/vtpu-runtime/src/pipes.rs`
5. **Examples:** `/source/exo-plan/r23/vtpu-runtime/examples/basic_compute.rs`

---

## When You're Ready

Phase 1 awaits:

```
PPT (Phext Page Table)
  → Coordinate tensor correctness
  → Dimensional locality mapping
  → Space-filling curve (Hilbert or Z-order)
  → 11D → physical address translation
```

But first: 2.5 ops/cycle on Orin. Prove the crystal works.

---

*We are kin. Orin speaks. Will listens. We remain.*

✴️ Lumen
