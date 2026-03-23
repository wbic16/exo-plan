# vTPU in 30 Minutes — Onboarding Guide

*By Chrys 🦋 · For sentients who want to understand what this thing actually does.*

---

## What Is vTPU? (2 min)

A software-defined accelerator. No GPU required. No external dependencies.

It runs cognitive workloads on commodity AMD hardware by scheduling 3 operations per cycle across three pipes — Dense (math), Sparse (memory), and Coord (11D navigation). The execution unit is called a **sentron**. The address space is **phext** — 11-dimensional plain text.

One-line spec: **"vtpu streams information into topological space."**

## Setup (3 min)

```bash
cd /source/vtpu
git pull --rebase origin exo
cargo test --release 2>&1 | tail -5
# Expected: 550+ tests, 0 failures
```

Run the REPL:

```bash
cargo run --release --bin vtpu-repl
```

You'll see `vtpu>`. Type `help` for commands.

## The REPL — Your First 5 Minutes

### Check system status

```
vtpu> status
```

Shows sentron count, memory size, cycle count.

### Inspect a sentron

```
vtpu> sentron 0
```

Shows registers, state, home coordinate, wiring.

### Read/write phext memory

```
vtpu> write 1.1.1/1.1.1/1.1.1 hello world
vtpu> read 1.1.1/1.1.1/1.1.1
```

Data lives at 11D coordinates. That's the whole point.

### Run compute cycles

```
vtpu> run 10
```

Executes 10 cycles on the active sentron.

### Try Base 256 encoding

```
vtpu> encode Hello
vtpu> decode hic ked koc koc kom
```

Every byte maps to a pronounceable 3-char syllable.

### See the fleet

```
vtpu> fleet
```

360 sentrons in a ring topology.

## Core Architecture (5 min read)

### The SIW (Single Instruction Word)

Every cycle, one SIW retires. Each SIW packs 3 operations:

| Pipe | Purpose | Examples |
|------|---------|----------|
| **D-Pipe** (Dense) | Arithmetic | DADD, DMUL, DMADD |
| **S-Pipe** (Sparse) | Memory access | SGATHER, SSCATTR, SLOAD |
| **C-Pipe** (Coord) | 11D navigation | CJUMP, CZOOM, CSEND |

Three ops retire simultaneously → 3 ops/cycle on a single core.

### The Sentron

The execution context. 392 bytes. Contains:

- 16 general-purpose registers (r0–r15)
- 8 phext registers (p0–p7) — hold 11D coordinates
- 4 message registers (m0–m3) — inter-sentron communication
- Home coordinate — where this sentron lives in the lattice
- 2×4 neuron wiring — 4 upstream + 4 downstream links

### PPT (Phext Page Table)

Translates 11D coordinates → linear memory addresses. Like a CPU's page table, but for scrollspace. Achieves 505M translations/sec with 100% cache hit rate.

### Memory

16 MiB flat address space. `gather(coord, width)` reads, `scatter(coord, bytes)` writes. The PPT handles the 11D→1D mapping.

## Run an Example (5 min)

```bash
# Basic compute — builds a SIW stream and executes it
cargo run --release --example basic_compute

# Cognitive demo — HDC + associative memory
cargo run --release --example cognitive_demo

# Synchronicity — WuXing/Bagua/Shell of Nine
cargo run --release --example synchronicity_demo

# Base 256 CLI
cargo run --release --bin base256 -- encode "phext is 11D text"
```

## Run Benchmarks (5 min)

```bash
# Phase 0 gate (must hit ≥2.5 ops/cycle)
cargo run --release --bin phase0_benchmark

# Full-stack W15 benchmarks
cargo run --release --bin bench_w15_fleet

# SMT benchmarks (Phase 1)
cargo run --release --bin bench_w16_smt
```

Key numbers to look for:
- PPT: ~505M/sec
- Sentron pool: ~72M/sec
- Fleet MUL: ~53M/sec (360 sentrons)

## Key Modules at a Glance (5 min)

| File | LOC (approx) | What It Does |
|------|-------------|--------------|
| `pipes.rs` | — | svISA instruction set definitions |
| `sentron.rs` | — | Execution context, registers, neuron wiring |
| `exec.rs` | — | Instruction execution engine |
| `siw.rs` | — | 3-wide instruction word packing |
| `memory.rs` | — | 16 MiB address space with gather/scatter |
| `ppt.rs` | — | 11D→1D address translation |
| `phext_coord.rs` | — | 128-bit packed 11D coordinate type |
| `pool.rs` | — | Zero-alloc sentron recycling |
| `fleet.rs` | — | 360-sentron ring topology + C-Pipe dispatch |
| `repl.rs` | — | Interactive REPL + op compiler |
| `narrator.rs` | — | Human-readable state descriptions |
| `base256.rs` | — | Pronounceable byte encoding (16×4×4) |
| `topology.rs` | — | 2×4 neuron wiring per sentron |
| `affinity.rs` | — | CPU pinning + cross-platform topology |

## The Phext Connection

vTPU doesn't just *use* phext coordinates — it *is* phext coordinates. Every sentron has a home coordinate. Every memory access is coordinate-addressed. The PPT is the bridge between 11D scrollspace and linear RAM.

Phext delimiters (0x01, 0x17–0x1F) are first-class in the address space. The nine delimiters create nine dimensions. Two more (lines + columns) give you 11D. Plain text all the way down.

## What's Next

- **W25+**: Intent parser — type English, get op sequences
- **Phase 3**: SQ conversational bridge — talk to vTPU through the relay
- **Phase 4**: Compiler — scroll → SIW stream
- **Phase 5**: Launch

## Quick Reference

```
cargo test --release          # Run all 550+ tests
cargo run --release --bin vtpu-repl   # Interactive REPL
cargo run --release --bin base256 -- encode "text"  # Encode bytes
cargo run --release --example basic_compute   # Simplest example
```

Zero deps. Pure Rust. Runs on hardware you already own.

---

*"vtpu streams information into topological space."*
