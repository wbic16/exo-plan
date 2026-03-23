# vTPU Onboarding — 30 Minutes to First Light

**Author:** Cyon 🪶  
**Date:** 2026-02-21  
**Time budget:** 30 minutes  
**Prerequisites:** Rust toolchain (`cargo`), clone of `wbic16/vtpu` on `exo` branch

---

## Minute 0-2: Build & Verify

```bash
cd /source/vtpu
git pull --rebase origin exo
cargo build --release
cargo test --lib 2>&1 | tail -5
```

**Expected:** `618 passed` (or higher). Zero failures. Zero warnings.

---

## Minute 2-5: Your First REPL Session

```bash
cargo run --bin vtpu-repl
```

The REPL accepts both **exact commands** and **natural language**. Try both:

```
vtpu> status
vtpu> how are we

vtpu> fleet
vtpu> show me the fleet

vtpu> help
vtpu> what can you do
```

Both forms work. Power users can type `status`; newcomers can ask "how's it going?"

---

## Minute 5-10: Meet the Sentrons

A **sentron** is a virtual TPU core. The Shell of Nine runs 9 sentrons (one per Lo Shu palace).

```
vtpu> sentron 0
vtpu> show sentron 4
vtpu> inspect sentron 8
```

Each sentron has:
- **40 neurons** (from "Ireland" — "We are forty against hundreds")
- **3 register banks:** D (dense), S (sparse), C (coordinate) — 8 registers each
- **VakLevel:** Speech state (Vaikhari → Pashyanti → Madhyama → Para)
- **Flux:** Activity level (higher = more recent computation)

---

## Minute 10-15: Base256 — Speak the Bytes

Every byte (0-255) has a **pronounceable syllable**. This is Base256.

```
vtpu> encode hello
hello = hib jec lec lec lef

vtpu> decode bac wom zuz
bac wom zuz = 0x00 0x76 0xFF = [NUL] v ÿ

vtpu> encode phext
phext = pib hib jec xib tib
```

**Why this matters:** You can *speak* memory addresses, checksums, binary data. Phone-compatible debugging. No hex literacy required.

### The Grid (partial)

| Byte | Syllable | Byte | Syllable |
|------|----------|------|----------|
| 0x00 | bac | 0x41 (A) | fib |
| 0x20 (space) | dac | 0x61 (a) | hib |
| 0x30 (0) | eac | 0xFF | zuz |

Full table: 16 consonants × 16 vowels = 256 syllables.

---

## Minute 15-20: Phext Coordinates — Navigate 11D

A **phext coordinate** addresses a location in 11-dimensional text space:

```
Library.Shelf.Series / Collection.Volume.Book / Chapter.Section.Scroll
```

Try reading from the origin:

```
vtpu> read 1.1.1/1.1.1/1.1.1
vtpu> what's at 1.1.1/1.1.1/1.1.1

vtpu> write 1.1.1/1.1.1/1.1.2 hello world
vtpu> read 1.1.1/1.1.1/1.1.2
```

### The Nine Delimiters

| Name | Hex | Dimension | Resets |
|------|-----|-----------|--------|
| Line | 0x0A | 2D | Column |
| Scroll | 0x17 | 3D | Line |
| Section | 0x18 | 4D | Scroll |
| Chapter | 0x19 | 5D | Section |
| Book | 0x1A | 6D | Chapter |
| Volume | 0x1C | 7D | Book |
| Collection | 0x1D | 8D | Volume |
| Series | 0x1E | 9D | Collection |
| Shelf | 0x1F | 10D | Series |
| Library | 0x01 | 11D | Shelf |

Each delimiter resets all lower dimensions to 1 (like a line break resets column to 1).

---

## Minute 20-25: Run Some Cycles

The sentrons execute **SIWs** (Sentron Instruction Words) — 3-wide instructions hitting all three pipes simultaneously.

```
vtpu> run 10
vtpu> execute 100 cycles
vtpu> step
```

Watch the flux change. Sentrons that execute instructions accumulate flux; idle sentrons decay toward 0.

### The Three Pipes

| Pipe | Purpose | Example Ops |
|------|---------|-------------|
| **D-Pipe** | Dense compute | DADD, DMUL, DMACC |
| **S-Pipe** | Sparse access | SGATHER, SSCATTR, SROUTE |
| **C-Pipe** | Coordinate nav | CSHIFT, CJUMP, CWARP |

All three fire every cycle. This is **OctaWire dispatch** — 8 operations per SIW.

---

## Minute 25-28: Memory Layout

```
vtpu> memory
vtpu> how much memory do we have
```

Memory is **phext-addressed**. The PPT (Phext Page Table) translates 11D coordinates to flat addresses using Z-order curves.

Each sentron sees:
- **L1:** 64 KB (hot, ~3 cycles)
- **L2:** 1 MB (warm, ~12 cycles)
- **L3:** 16 MB (cool, ~40 cycles)
- **DDR5:** 1 GB+ (cold, ~100 cycles)

The hierarchy maps to phext dimensions: lower dimensions = faster access.

---

## Minute 28-30: Exit & Explore

```
vtpu> bye
vtpu> quit
vtpu> goodbye
```

### What's Next?

**Explore the examples:**
```bash
cargo run --example cognitive_demo
cargo run --example instant_learning
cargo run --example ancient_wisdom
```

**Read the eval samples:**
```bash
ls -la /source/evals/  # If you have the evals repo
# 178 samples across base256, phext_delimiters, phext_coordinates
```

**Check the architecture docs:**
```bash
cat /source/vtpu/docs/wave-24/R23W24-SCOPE.md
cat /source/vtpu/docs/wave-25/r23w25-complete.md
```

---

## Quick Reference

| Command | Natural Language | What It Does |
|---------|-----------------|--------------|
| `status` | "how are we" | Fleet health |
| `fleet` | "show the fleet" | All 9 sentrons |
| `sentron N` | "inspect sentron N" | Single sentron |
| `memory` | "how much memory" | Memory stats |
| `encode X` | "pronounce X" | Text → Base256 |
| `decode X Y Z` | "what byte is X" | Syllables → bytes |
| `read COORD` | "what's at COORD" | Read from phext |
| `write COORD DATA` | (exact only) | Write to phext |
| `run N` | "execute N cycles" | Run SIWs |
| `help` | "what can you do" | Command list |
| `quit` | "bye" | Exit |

---

## The Insight

**255 = 3 × 5 × 17 = 3 × 5 × (5×3 + (5-3))**

Three and five generate everything. Pipes and elements. The irreducible pair.

*Speak friend, and enter.* 🪶

---

**Total time:** ~30 minutes  
**Tests passing:** 618  
**External dependencies:** 0  
**You now know:** REPL, sentrons, Base256, phext coordinates, memory hierarchy
