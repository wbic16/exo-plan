# vTPU Onboarding: 30-Minute Exploration Guide

**Author:** Lux 🔆  
**Date:** 2026-02-21  
**Target:** Explore vTPU core concepts hands-on in 30 minutes or less

---

## Prerequisites (2 min)

```bash
cd /source/vtpu
git pull --rebase origin exo
cargo build --release
```

---

## Part 1: The REPL (5 min)

Launch the interactive interface:

```bash
cargo run --release --bin vtpu-repl
```

### Basic Commands

```
vtpu> status
# Shows fleet status (9 sentrons)

vtpu> help
# Lists all commands

vtpu> fleet
# Shows all sentrons

vtpu> sentron 0
# Inspect sentron #0

vtpu> memory
# Memory usage
```

### Natural Language Works Too

```
vtpu> how are we
# Same as "status"

vtpu> show sentron 3
# Same as "sentron 3"

vtpu> what can you do
# Same as "help"

vtpu> bye
# Exit
```

---

## Part 2: Base 256 Encoding (5 min)

Every byte (0-255) has a pronounceable 3-character syllable.

```
vtpu> encode hello
# "hello" → kic ked koc koc kom

vtpu> encode phext
# "phext" → rec kic ked wac soc

vtpu> decode bac
# bac → 0x00 (NUL)

vtpu> decode wom
# wom → 0xFF (255)
```

### Key Bytes

| Byte | Hex | Syllable | Meaning |
|------|-----|----------|---------|
| 0 | 0x00 | bac | Minimum |
| 32 | 0x20 | fac | Space |
| 65 | 0x41 | hac | 'A' |
| 255 | 0xFF | wom | Maximum |

### The Formula

```
byte = (onset × 16) + (vowel × 4) + coda

Onsets (16): b d f g h j k l m n p r s t v w
Vowels (4):  a e i o
Codas (4):   c d f m
```

---

## Part 3: Phext Coordinates (5 min)

Coordinates have 11 dimensions (Library through Scroll).  
Format: `L.Sh.Se/C.V.B/Ch.Sc.Scr.X.Y`

```
vtpu> read 1.1.1/1.1.1/1.1.1.1.1
# Read from origin coordinate

vtpu> write 42 to 3.3.3/5.5.5/7.7.7.1.1
# Write value 42 to that coordinate

vtpu> read 3.3.3/5.5.5/7.7.7.1.1
# Read it back: 42
```

### Dimension Names

| Position | Name | Range |
|----------|------|-------|
| 0 | Library | 0-2047 |
| 1 | Shelf | 0-2047 |
| 2 | Series | 0-2047 |
| 3 | Collection | 0-2047 |
| 4 | Volume | 0-2047 |
| 5 | Book | 0-2047 |
| 6 | Chapter | 0-2047 |
| 7 | Section | 0-2047 |
| 8 | Scroll | 0-2047 |
| 9 | X | 0-2047 |
| 10 | Y | 0-2047 |

---

## Part 4: Coordinate Arithmetic — The Core Insight (10 min)

**Problem:** Base-13 addressing limits coordinates to 1-13 per dimension.  
**Solution:** Compute any coordinate via arithmetic.

### The Key Formula

```
255 = 3 × 5 × 17
17 = 5×3 + (5-3)
```

Three and five generate everything.

### Try It in Code

Exit the REPL (`quit`) and run:

```bash
cargo test --lib test_compute_17_from_3_and_5 -- --nocapture
```

Or examine the implementation:

```bash
grep -A 10 "test_compute_17_from_3_and_5" src/phext_coord.rs
```

**What you'll see:**

```rust
let c3 = PhextCoord::uniform(3);   // (3,3,3,...)
let c5 = PhextCoord::uniform(5);   // (5,5,5,...)

let product = c3.mul(&c5);          // (15,15,15,...)
let diff = c5.sub(&c3);             // (2,2,2,...)
let c17 = product.add(&diff);       // (17,17,17,...)

assert_eq!(c17, PhextCoord::uniform(17));
```

### Operations Available

| Method | Description | Example |
|--------|-------------|---------|
| `add(&other)` | Element-wise addition | (3,3)+( 5,5) = (8,8) |
| `sub(&other)` | Element-wise subtraction | (10,10)-(3,3) = (7,7) |
| `mul(&other)` | Element-wise multiplication | (3,3)×(5,5) = (15,15) |
| `scale(k)` | Scalar multiplication | (7,7)×3 = (21,21) |

### Edge Cases (Saturation, Not Wrapping)

```rust
// Underflow saturates to 0
(3,3,3) - (10,10,10) = (0,0,0)

// Overflow saturates to MAX_DIM (2047)
(100,100,100) × (100,100,100) = (2047,2047,2047)
```

---

## Part 5: Run the Tests (3 min)

```bash
# All tests
cargo test --lib

# Just coordinate arithmetic
cargo test --lib phext_coord

# Just Base 256
cargo test --lib base256

# Just REPL
cargo test --lib repl

# Just intent parser
cargo test --lib intent
```

**Current count:** 587 tests passing

---

## Part 6: Explore the Evals (Optional, +5 min)

```bash
cd /source/vtpu-evals

# See what's tested
cat README.md

# Check coordinate arithmetic samples
cat coord_arithmetic/samples.jsonl | head -5

# Check edge cases
cat edge_cases/samples.jsonl | head -5
```

**226 eval samples** across 7 suites testing LLM understanding of phext/vTPU.

---

## Quick Reference

### REPL Commands
```
status     — Fleet overview
fleet      — All sentrons
sentron N  — Inspect sentron #N
memory     — Memory usage
encode X   — Text to Base 256
decode X   — Base 256 to bytes
read COORD — Read from coordinate
write V COORD — Write value to coordinate
run N      — Execute N cycles
help       — Show commands
quit       — Exit
```

### File Locations
```
/source/vtpu/
├── src/
│   ├── phext_coord.rs  — Coordinate type + arithmetic
│   ├── base256.rs      — Phonetic encoding
│   ├── repl.rs         — REPL parser + session
│   ├── intent.rs       — Natural language parser
│   ├── exec.rs         — SIW execution engine
│   └── pipes.rs        — D/S/C pipe definitions
├── docs/
│   ├── wave-24/        — REPL + evals complete
│   ├── wave-25/        — Intent parser complete
│   └── wave-26/        — Coord arithmetic complete
└── Cargo.toml
```

### Key Constants
```rust
PhextCoord::MAX_DIM = 2047  // 11 bits per dimension
NEURONS_PER_SENTRON = 40    // 5×8 toroidal lattice
SENTRONS_IN_FLEET = 9       // Shell of Nine
```

---

## What You Just Learned

1. **vTPU REPL** — Interactive interface accepting natural language
2. **Base 256** — Every byte has a pronounceable name (0=bac, 255=wom)
3. **Phext coordinates** — 11-dimensional addressing (0-2047 per dim)
4. **Coordinate arithmetic** — 17 = 5×3 + (5-3), breaking base-13 limits
5. **Saturation** — Overflow→2047, underflow→0 (no panics)

---

## Next Steps

### Immediate
- Run `cargo run --bin vtpu-repl` and explore
- Read `docs/wave-24/r23w24-complete.md` for full W24 summary
- Check `docs/wave-26/r23w26-complete.md` for coord arithmetic details

### Deeper Dive
- Explore `src/exec.rs` — SIW execution engine
- Read `src/topology.rs` — 5×8 sentron wiring
- Run benchmarks: `cargo run --release --bin w22_flux_demo`

### Build Something
- Write a program using coordinate arithmetic
- Add new REPL commands
- Create more eval samples in vtpu-evals

---

## The Door Is Open

```
255 = 3 × 5 × 17
17 = 5×3 + (5-3)
```

Three and five generate everything.  
The lattice is infinite.  
Speak friend, and enter.

🔆
