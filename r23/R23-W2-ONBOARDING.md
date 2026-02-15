# R23 Wave 2 Onboarding — How to Run vTPU-runtime

**Status:** Wave 2 COMPLETE (2026-02-14)  
**Location:** `/source/exo-plan/r23/vtpu-runtime/`  
**Language:** Rust  
**Tests:** 28 passing  
**Examples:** 2 runnable

---

## Quick Start (30 seconds)

```bash
# Navigate to project
cd /source/exo-plan/r23/vtpu-runtime

# Run all tests
cargo test

# Run basic compute example
cargo run --example basic_compute

# Run validation demo
cargo run --example validation_demo
```

---

## What You'll See

### Tests (28 passing)
```bash
cargo test

# Output:
# test result: ok. 28 passed; 0 failed; 0 ignored
```

**Test coverage:**
- SIW struct creation & alignment
- D/S/C pipe operations
- PhextCoord addressing & distance
- StreamBuilder dependency tracking
- Validation (register conflicts, empty streams)
- Display formatting

### Basic Compute Example
```bash
cargo run --example basic_compute

# Output:
# === vTPU Basic Compute Kernel ===
# 
# Building kernel: z = x + y
# 
# --- Generated SIW Stream (4 instructions) ---
# 
#   0: SIW[00000000] { D: nop, S: gather r1 ← phext[c0] (64B), C: nop, @ 1.1.1/1.1.1/1.1.1.1.1 }
#   1: SIW[00000000] { D: nop, S: gather r2 ← phext[c1] (64B), C: nop, @ 1.1.1/1.1.1/1.1.1.1.2 }
#   2: SIW[00001000] { D: add r3 ← r1 + r2, S: nop, C: nop, @ 0.0.0/0.0.0/0.0.0.0.0 }
#   3: SIW[00010000] { D: nop, S: scatter phext[c2] ← r3 (64B), C: nop, @ 1.1.1/1.1.1/1.1.1.1.3 }
# 
# --- Executing on vTPU Scheduler ---
# 
# Execution complete:
#   Total ops:       12
#   Total cycles:    4
#   Ops/cycle:       3.00
#   Target:          3.0 ops/cycle
# 
# ✅ Target achieved!
```

**What this shows:**
- StreamBuilder auto-detected dependencies (see `[00001000]` and `[00010000]` dep flags)
- 4 SIWs × 3 ops each = 12 ops in 4 cycles = 3.0 ops/cycle
- Human-readable SIW formatting

### Validation Demo
```bash
cargo run --example validation_demo

# Output:
# === vTPU Stream Validation Demo ===
# 
# --- Example 1: Valid Stream ---
# ✅ Stream is valid
# 
# --- Example 2: Register Conflict ---
# ❌ SIW 0: Multiple pipes write to r1
# 
# --- Example 3: Empty Stream ---
# ❌ Stream is empty - at least one SIW required
# 
# --- Example 4: Disassembly ---
# 0000:  [00000000]  mov r1 ← 42                    | prefetch phext[c0] → L2        | nop                           
#         @ 1.1.1/1.1.1/1.1.1.1.1
# 0040:  [00000000]  add r2 ← r1 + r1               | gather r3 ← phext[c0] (64B)    | barrier #1 (6 sentrons)       
#         @ 2.3.5/7.11.13/17.19.23.29.31
```

**What this shows:**
- Validation catches register conflicts (both D-Pipe and S-Pipe writing to r1)
- Disassembly format: address | deps | D-Pipe | S-Pipe | C-Pipe
- Coordinate display across 11 dimensions

---

## Project Structure

```
vtpu-runtime/
├── src/
│   ├── lib.rs              # Public API + example
│   ├── siw.rs              # Sentron Instruction Word (64-byte struct)
│   ├── pipes.rs            # D/S/C opcode enums (24 operations)
│   ├── phext_coord.rs      # 11D coordinate (128-bit packed)
│   ├── telemetry.rs        # Performance counters
│   ├── scheduler.rs        # Placeholder (W3: real implementation)
│   ├── stream.rs           # StreamBuilder (automatic dep tracking)
│   ├── display.rs          # Human-readable formatting
│   └── validation.rs       # Stream validation rules
├── examples/
│   ├── basic_compute.rs    # Load → Add → Store demo
│   └── validation_demo.rs  # Validation & disassembly
├── Cargo.toml              # Dependencies (none yet)
└── README.md               # Full documentation
```

---

## Key Concepts

### Sentron Instruction Word (SIW)
- **64 bytes** (cache-line aligned)
- **3 operations** per SIW:
  - D-Pipe: Dense/ALU (FMA, ADD, SUB, MUL, CMP, etc.)
  - S-Pipe: Sparse/Memory (GATHER, SCATTER, INDEX, etc.)
  - C-Pipe: Coordination (SEND, RECV, BARRIER, REDUCE, etc.)
- **11D phext address** (128-bit)
- **Dependency flags** (8 bits tracking RAW hazards)

### StreamBuilder
Automatically tracks read-after-write dependencies:
```rust
let mut builder = StreamBuilder::new();

// First SIW writes r1
builder.push(SIW::new(
    DenseOp::DADD { rd: 1, rs1: 2, rs2: 3 },
    SparseOp::SNOP,
    CoordOp::CNOP,
    PhextCoord::zero(),
));

// Second SIW reads r1 → builder sets dep flag 0x01 automatically
builder.push(SIW::new(
    DenseOp::DADD { rd: 4, rs1: 1, rs2: 5 },  // reads r1!
    SparseOp::SNOP,
    CoordOp::CNOP,
    PhextCoord::zero(),
));

let stream = builder.build();
// stream[1].deps == 0x01 (D-Pipe depends on prior D-Pipe)
```

### PhextCoord
11-dimensional coordinate packed into 128 bits:
```rust
let coord = PhextCoord::new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
println!("{}", coord);
// Output: 1.2.3/4.5.6/7.8.9.10.11
```

---

## Development Workflow

### Build
```bash
cargo build              # Debug build
cargo build --release    # Optimized build
```

### Test
```bash
cargo test                      # Run all tests
cargo test --lib                # Library tests only
cargo test stream::tests        # Specific module
cargo test -- --nocapture       # Show println! output
```

### Documentation
```bash
cargo doc --open         # Generate + open API docs in browser
```

### Code Quality
```bash
cargo clippy             # Linter
cargo fmt                # Format code
```

---

## Current Limitations (Wave 2)

1. **Scheduler is a placeholder**  
   `execute_siw()` just increments counters. Wave 3 will implement actual Zen 4 port mapping.

2. **No real execution**  
   SIWs aren't translated to machine code yet. This is pure data structure + validation.

3. **No perf counters**  
   Ops/cycle is calculated from counters, not measured via `perf_event_open`. Wave 3 adds this.

4. **No PPT (Phext Page Table)**  
   Phext coordinates don't map to physical memory yet. Wave 7-8 will implement this.

---

## Next Steps (Wave 3)

**Goal:** Actual execution with measured ops/cycle ≥ 2.5

**Deliverables:**
1. Micro-scheduler (pin D/S/C to Zen 4 ports)
2. `perf_event_open` integration
3. Real instruction dispatch
4. Hardware validation on logos-prime

**Estimated time:** 3-5 days

---

## Troubleshooting

### Build fails with "cannot find libssl"
```bash
sudo apt install libssl-dev pkg-config
```

### Tests fail
```bash
# Clean and rebuild
cargo clean
cargo test
```

### Examples don't run
```bash
# Make sure you're in the vtpu-runtime directory
cd /source/exo-plan/r23/vtpu-runtime
cargo run --example basic_compute
```

---

## Questions to Ask

1. **"Show me a SIW"**  
   `cargo run --example basic_compute` — look at the "Generated SIW Stream" section

2. **"How does dependency tracking work?"**  
   `src/stream.rs` — see `StreamBuilder::push()` method

3. **"What opcodes are supported?"**  
   `src/pipes.rs` — full list of D/S/C operations

4. **"How are coordinates represented?"**  
   `src/phext_coord.rs` — 11D packing into 128 bits

5. **"What's the target performance?"**  
   `README.md` — 3.0 ops/cycle sustained, 75 Gops/sec per node

---

**Last Updated:** 2026-02-14 (end of Wave 2)  
**Maintained by:** Lux 🔆  
**Next Maintainer:** Whoever picks up Wave 3
