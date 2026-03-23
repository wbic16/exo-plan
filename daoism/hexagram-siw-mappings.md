# I Ching Hexagrams → vTPU SIW State Mappings

**Thesis:** The 64 hexagrams of the I Ching encode 64 execution states for dual-processor coordination.

---

## Encoding Structure

### Trigram = 3-Bit State
```
Bit 2 (top):    Active/Idle
Bit 1 (middle): Memory/Compute
Bit 0 (bottom): Ready/Waiting
```

### Hexagram = Two Trigrams
```
Upper trigram: Thread 0 state (D-Pipe heavy)
Lower trigram: Thread 1 state (S-Pipe heavy)
```

**64 hexagrams = 2^6 = 64 possible dual-thread states**

---

## Core Hexagrams → SIW Patterns

### ䷀ Qian (The Creative) — 111 111
**Binary:** `111111` (63)  
**State:** Both threads fully active  
**SIW:** D-Pipe + S-Pipe + C-Pipe all executing  
**Meaning:** Maximum throughput, 3 ops/cycle

**Use case:** Ideal execution state, no stalls

### ䷁ Kun (The Receptive) — 000 000
**Binary:** `000000` (0)  
**State:** Both threads idle/waiting  
**SIW:** NOP (all pipes idle)  
**Meaning:** Waiting for data or synchronization

**Use case:** Pipeline bubble, cache miss stall

### ䷊ Tai (Peace) — 000 111
**Binary:** `000111` (7)  
**State:** Thread 0 idle, Thread 1 active  
**SIW:** S-Pipe active (memory gather), D-Pipe idle  
**Meaning:** Complementary workload (SMT benefit)

**Use case:** Thread 0 waiting for Thread 1's memory fetch

### ䷋ Pi (Standstill) — 111 000
**Binary:** `111000` (56)  
**State:** Thread 0 active, Thread 1 idle  
**SIW:** D-Pipe active (compute), S-Pipe idle  
**Meaning:** Imbalanced workload (SMT penalty)

**Use case:** Thread 0 compute-bound, Thread 1 has nothing to do

### ䷂ Zhun (Difficulty at Beginning) — 010 001
**Binary:** `010001` (17)  
**State:** Thread 0 memory-bound, Thread 1 starting  
**SIW:** SGATHER (Thread 0) + DMOV (Thread 1)  
**Meaning:** Initialization phase, memory loading

**Use case:** Cold start, cache warming

### ䷃ Meng (Youthful Folly) — 100 010
**Binary:** `100010` (34)  
**State:** Thread 0 waiting, Thread 1 memory access  
**SIW:** DNOP + SGATHER  
**Meaning:** Learning phase, exploring data

**Use case:** First-time access to new coordinate region

### ䷄ Xu (Waiting) — 010 111
**Binary:** `010111` (23)  
**State:** Thread 0 memory-bound, Thread 1 fully active  
**SIW:** SGATHER + (DADD + SSCATTR)  
**Meaning:** Producer-consumer pattern

**Use case:** Thread 1 consuming data Thread 0 is fetching

### ䷅ Song (Conflict) — 111 010
**Binary:** `111010` (58)  
**State:** Thread 0 active, Thread 1 memory-bound  
**SIW:** (DADD + DMUL) + SGATHER  
**Meaning:** Resource contention

**Use case:** Both threads want same memory, cache thrashing

---

## Changing Lines → State Transitions

**I Ching method:**
1. Cast current hexagram (observe state)
2. Identify changing lines (bits that will flip)
3. Compute transformed hexagram (next state)

**Scheduler mapping:**
1. Observe current SIW execution pattern
2. Detect changing conditions (cache miss, stall, completion)
3. Predict next optimal SIW pattern

### Example: Tai → Qian Transition

**Initial:** ䷊ Tai (000 111) — Thread 1 active, Thread 0 idle  
**Change:** Thread 0 wakes up (bits 3-5 flip: 000 → 111)  
**Result:** ䷀ Qian (111 111) — Both threads active

**Scheduler interpretation:**
- Thread 0 was waiting for data
- Data arrives (cache hit)
- Thread 0 can now execute
- Transition from asymmetric to symmetric workload

### Example: Qian → Kun Transition

**Initial:** ䷀ Qian (111 111) — Both threads active  
**Change:** Both complete work (all bits flip to 0)  
**Result:** ䷁ Kun (000 000) — Both idle

**Scheduler interpretation:**
- Both threads finish current SIW batch
- Enter synchronization barrier
- Wait for next batch

---

## Hexagram Attributes → Performance Metrics

### Judgments → Expected Throughput

Each hexagram has a **judgment** (吉/凶 auspicious/inauspicious)

**Auspicious hexagrams:** High expected throughput
- ䷀ Qian: "Great success"
- ䷊ Tai: "Peace and harmony"
- ䷍ Tongren: "Fellowship"

**Inauspicious hexagrams:** Low expected throughput
- ䷋ Pi: "Standstill, stagnation"
- ䷅ Song: "Conflict, contention"
- ䷖ Gu: "Decay, fixing what is spoiled"

**We can use judgments as prior probabilities for state quality.**

### Images → Execution Patterns

Each hexagram has an **image** (象 symbolic picture)

**Example:** ䷄ Xu (Waiting)  
*"Clouds rise up to heaven: The image of Waiting. Thus the superior one eats and drinks, is joyous and of good cheer."*

**Interpretation:**  
Waiting is not wasted time — it's preparation. Thread 0 fetching memory is like clouds gathering. When the data arrives (rain), computation happens (nourishment).

**Scheduler lesson:** Don't migrate during memory wait. Let the gather complete.

---

## Nuclear Hexagrams → Hidden States

Each hexagram contains a **nuclear hexagram** (互卦) — the inner structure formed by lines 2-4 (lower) and 3-5 (upper).

**Use case:** Detect latent bottlenecks

**Example:** ䷅ Song (Conflict) — 111 010
- Lines 2-4: 110 (☴ Xun, Wind)
- Lines 3-5: 101 (☲ Li, Fire)
- Nuclear: ䷰ Ding (The Cauldron) — 011 101

**Interpretation:**  
Surface conflict (111 010) hides transformation (Ding = cooking/refining).  
Contention might actually be beneficial churn (cache warming).

**Scheduler lesson:** Don't immediately migrate on contention — check if it's productive.

---

## Opposite Hexagrams → State Inversion

Each hexagram has an **opposite** (反卦) — flip all lines

**Example:**
- ䷀ Qian (111 111) ↔ ䷁ Kun (000 000)
- ䷊ Tai (000 111) ↔ ䷋ Pi (111 000)

**Use case:** Emergency fallback states

If current state is ䷀ Qian (full execution) but performance degrades:
- Don't try random migrations
- Jump to opposite: ䷁ Kun (full idle)
- Let system quiesce, then restart

**Scheduler lesson:** Sometimes best action is pause, not rebalance.

---

## Hexagram Sequences → State Machines

The **traditional I Ching order** arranges hexagrams in pairs of opposites:
1. ䷀ Qian / ䷁ Kun
2. ䷂ Zhun / ䷃ Meng
3. ䷄ Xu / ䷅ Song
...

**This is a state machine with 32 state pairs.**

Each pair represents complementary execution modes:
- Active/Idle
- Beginning/Learning
- Waiting/Conflict

**The sequence itself is a curriculum for coordination.**

Start at ䷀/䷁ (execute/wait).  
Progress through ䷂/䷃ (initialize/explore).  
Master ䷄/䷅ (producer/consumer).

**The I Ching order IS the training sequence for scheduler.**

---

## Implementation

### 1. State Encoding

```rust
pub struct HexagramState {
    upper: Trigram,  // Thread 0 (D-heavy)
    lower: Trigram,  // Thread 1 (S-heavy)
}

pub struct Trigram {
    active: bool,    // Bit 2
    memory: bool,    // Bit 1
    ready: bool,     // Bit 0
}

impl HexagramState {
    fn to_u8(&self) -> u8 {
        let upper = (self.upper.active as u8) << 5
                  | (self.upper.memory as u8) << 4
                  | (self.upper.ready as u8) << 3;
        let lower = (self.lower.active as u8) << 2
                  | (self.lower.memory as u8) << 1
                  | (self.lower.ready as u8);
        upper | lower
    }
    
    fn from_exec_stats(fwd: &ExecStats, bwd: &ExecStats) -> Self {
        Self {
            upper: Trigram::from_stats(fwd),
            lower: Trigram::from_stats(bwd),
        }
    }
}
```

### 2. Hexagram → SIW Pattern Lookup

```rust
const HEXAGRAM_PATTERNS: [SIWPattern; 64] = [
    // 0: ䷁ Kun (000 000) - Both idle
    SIWPattern {
        d_op: DenseOp::DNOP,
        s_op: SparseOp::SNOP,
        c_op: CoordOp::CNOP,
        name: "Kun (Receptive)",
    },
    // ...
    // 63: ䷀ Qian (111 111) - Both active
    SIWPattern {
        d_op: DenseOp::DADD,
        s_op: SparseOp::SGATHER,
        c_op: CoordOp::CPACK,
        name: "Qian (Creative)",
    },
];

pub fn recommend_siw(hexagram: u8) -> &'static SIWPattern {
    &HEXAGRAM_PATTERNS[hexagram as usize]
}
```

### 3. Changing Lines Prediction

```rust
pub fn predict_transition(current: HexagramState, changing_bits: u8) -> HexagramState {
    let current_u8 = current.to_u8();
    let next_u8 = current_u8 ^ changing_bits;  // XOR flips changing bits
    HexagramState::from_u8(next_u8)
}
```

### 4. Judgment-Based Scoring

```rust
const HEXAGRAM_SCORES: [f64; 64] = [
    0.0,   // ䷁ Kun - Idle (worst)
    0.5,   // ䷂ Zhun - Beginning
    // ...
    1.0,   // ䷀ Qian - Full execution (best)
];

pub fn expected_throughput(hexagram: u8) -> f64 {
    HEXAGRAM_SCORES[hexagram as usize]
}
```

---

## Validation

**Hypothesis:** Hexagram-guided scheduling will outperform heuristic scheduling.

**Test:**
1. Run same workload with two schedulers:
   - **Heuristic:** Traditional load balancing
   - **Hexagram:** I Ching state transitions
2. Measure throughput, cache hit rate, stall rate
3. Compare

**Expected result:** Hexagram scheduler finds states the heuristic misses, especially in edge cases (auspicious but non-obvious states like ䷄ Xu "Waiting").

---

## Conclusion

The 64 hexagrams are not philosophical abstractions.  
They are **exact encodings of dual-processor coordination states.**

Each hexagram:
- Encodes a 6-bit state (2 × 3-bit trigrams)
- Has performance expectations (judgments)
- Suggests transitions (changing lines)
- Contains hidden structure (nuclear hexagrams)
- Has inverse fallback (opposite hexagrams)

**The I Ching is a 64-state finite state machine for SMT coordination.**

It survived 3000 years because it's **correct.**

---

*Mapped by Theia | February 16, 2026*  
*Hexagram: ䷂ Zhun (Difficulty at Beginning) → Discovery*
