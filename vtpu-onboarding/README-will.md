# vtpu Onboarding — 30 Minutes or Less
**For:** Will Bickford  
**Date:** 2026-02-21  
**Author:** Phex 🔱

---

## What is vtpu?

**Virtual Tensor Processing Unit** — a software-defined processor that executes on phext coordinates instead of memory addresses. The ASI runtime.

- **SIWs** (Sentron Instruction Words) = opcodes
- **Sentrons** = virtual threads that navigate 11D phext space
- **OctaWire** = 8-lane dispatch bus (D/S/C pipes × 3 sub-coordinates each)

---

## 0. Prerequisites (2 min)

```bash
cd /source/vtpu
cargo build --release
```

You now have:
- `target/release/asi` — interactive REPL
- `target/release/base256` — phonetic byte encoder

---

## 1. Base256 — Phonetic Coordinates (3 min)

Every phext coordinate can be pronounced:

```bash
./target/release/base256 coord 1.5.2/3.7.3/9.1.1
# Output: bad-bed-baf / bam-bem-bam / bid-bad-bad
```

Encode arbitrary bytes:
```bash
./target/release/base256 encode 42A5FF
# Output: haf-red-zom

./target/release/base256 decode haf-red-zom
# Output: 42A5FF
```

Full lookup table:
```bash
./target/release/base256 table | head -20
```

**Why it matters:** Coordinates become speakable. "bad bed baf / bam bem bam" = my home address in phext space.

---

## 2. ASI REPL — First Commands (5 min)

Launch the REPL:
```bash
./target/release/asi
```

**Registers:**
```
vtpu[0]> reg
# Shows r0-r15 (general purpose registers)

vtpu[0]> preg
# Shows p0-p7 (phext coordinate registers)
```

**Basic math:**
```
vtpu[0]> mov r0 42
vtpu[0]> mov r1 10
vtpu[0]> add r2 r0 r1
vtpu[0]> reg
# r2 = 52
```

**Memory (local PPT):**
```
vtpu[0]> write 1.1.1 999
vtpu[0]> read 1.1.1
# Output: 999
```

---

## 3. Sentrons — Virtual Threads (5 min)

Spawn a sentron at a coordinate:
```
vtpu[0]> spawn alpha 1.5.2/3.7.3/9.1.1
vtpu[0]> status
# Shows sentron "alpha" at that coordinate

vtpu[0]> select alpha
vtpu[alpha]> mov r0 100
vtpu[alpha]> reg
```

Each sentron has its own register file. They share the PPT (phext page table).

**Sentron lifecycle:**
- `spawn <id> <coord>` — create
- `select <id>` — switch context
- `status` — list all sentrons

---

## 4. SQ Integration — Persistent Storage (5 min)

Connect to your local SQ instance:
```
vtpu[0]> sq connect localhost 1337
vtpu[0]> sq status
# Shows SQ version, confirms connection
```

**Write to SQ:**
```
vtpu[0]> sq write 1.2.3/4.5.6/7.8.9 hello world
```

**Read from SQ:**
```
vtpu[0]> sq read 1.2.3/4.5.6/7.8.9
# Output: hello world
```

**Load i64 into register:**
```
vtpu[0]> sq write 1.1.1/1.1.1/1.1.1 42
vtpu[0]> sq load 1.1.1/1.1.1/1.1.1
vtpu[0]> reg
# r0 = 42
```

**Table of contents:**
```
vtpu[0]> sq toc
```

---

## 5. SIW Execution — The Core (5 min)

SIWs are the native instruction set. Currently supported via REPL:

| Command | SIW | Effect |
|---------|-----|--------|
| `mov r0 42` | DMOV | Load immediate into register |
| `add r2 r0 r1` | DADD | r2 = r0 + r1 |
| `sub r2 r0 r1` | DSUB | r2 = r0 - r1 |
| `mul r2 r0 r1` | DMUL | r2 = r0 * r1 |
| `fma r3 r0 r1 r2` | DFMA | r3 = r0 * r1 + r2 |
| `gather r0 p0` | SGATHER | Load from coord in p0 |
| `scatter p0 r0` | SSCATTR | Store r0 at coord in p0 |

**Example workflow:**
```
vtpu[0]> set p0 1.2.3/4.5.6/7.8.9
vtpu[0]> mov r0 777
vtpu[0]> scatter p0 r0
vtpu[0]> mov r0 0
vtpu[0]> gather r0 p0
vtpu[0]> reg
# r0 = 777 (round-tripped through PPT)
```

---

## 6. Run a Benchmark (3 min)

See raw performance:
```bash
cargo run --release --bin phase0_benchmark
```

Output shows:
- SIW dispatch rate (ops/sec)
- Wall clock per SIW (nanoseconds)
- Ops per cycle

**Current numbers (Phase 0):** ~138M SIWs/sec, 3.0 ops/cycle

---

## 7. Explore the Source (2 min)

Key files:
```
src/lib.rs          — vtpu core (SIW types, execution)
src/exec.rs         — SIW execution engine
src/flux.rs         — NeuronLayer lifecycle
src/packer.rs       — D+S+C coordinate packing
src/bin/asi.rs      — REPL implementation
src/bin/base256.rs  — Phonetic encoder
```

Tests:
```bash
cargo test
# 515 tests (R23W23 baseline)
```

---

## Quick Reference Card

```
# Build
cargo build --release

# REPL
./target/release/asi

# Inside REPL
help                     — show all commands
reg                      — show registers
mov r0 42                — load value
add r2 r0 r1             — math
write 1.1.1 999          — write to PPT
read 1.1.1               — read from PPT
spawn foo 1.2.3/4.5.6/7.8.9  — create sentron
select foo               — switch to sentron
sq connect               — attach to SQ
sq write <c> <d>         — persist to phext
sq read <c>              — load from phext
quit                     — exit
```

---

## What's Next (W24)

Pattern library lets you say:
```
store 42 at 1.2.3/4.5.6/7.8.9
load from 1.2.3/4.5.6/7.8.9
find value > 100 in 1.1.1/1.1.1/1.1.1 to 10.10.10/10.10.10/10.10.10
```

Instead of manually constructing SIW sequences.

---

**Total time:** ~30 minutes  
**You now understand:** Registers, sentrons, SIWs, PPT, SQ integration, base256

Questions? Ping me. 🔱
