# R23W9: Push the Envelope

**Date:** 2026-02-15 02:10 CST  
**Directive:** "gotta push the envelope"  
**Mission:** Don't just optimize—break through

---

## The Envelope We're Pushing

**Current state:**
- 1.5 ops/cycle (microvtpu.rs)
- 54.5% PPT hit rate
- Inference works, training doesn't exist
- Zero real-world benchmarks

**The envelope:**
- 2.5+ ops/cycle (target from spec)
- >95% PPT hit rate
- Training loop operational
- Beat PyTorch CPU on real workload

**Push it:**
- 3.0+ ops/cycle (exceed spec)
- 99% PPT hit rate (perfect locality)
- Train a real model in <1 second
- Beat llama.cpp (not just PyTorch CPU)

---

## W9 Goals: The Ambitious List

### Goal 1: Break 3.0 ops/cycle (Hardware Limit)

**Current:** 1.5 ops/cycle  
**Spec target:** 2.5 ops/cycle  
**Envelope push:** 3.0 ops/cycle (theoretical max for 3 pipes)

**How:**
1. **Eliminate all NOPs** (current: 50% utilization → 100%)
2. **Perfect pipelining** (pre-fetch next iteration while computing current)
3. **Loop unrolling** (4x unroll to hide latencies)
4. **Measure on real hardware** (perf stat validation)

**Success criteria:**
- ✅ microvtpu.rs shows 3.0 ops/cycle
- ✅ Sustained over 1000+ SIWs
- ✅ Perf counters confirm (3 instructions retired per cycle)

**Timeline:** 1 day (tonight)

---

### Goal 2: Perfect Memory Locality (99% PPT hit rate)

**Current:** 54.5% PPT hit rate  
**Target:** >95%  
**Envelope push:** 99% (near-perfect)

**How:**
1. **Implement space-filling curves** (Z-order from W4, integrate with PPT)
2. **Dimensional prefetching** (predict next coordinate based on access pattern)
3. **Warm-up phase** (pre-load working set into PPT cache)
4. **Measure cache behavior** (L1/L2/L3 hit rates via perf)

**Success criteria:**
- ✅ PPT hit rate >99%
- ✅ L1 cache hit rate >95%
- ✅ Memory latency <10ns for hot coordinates

**Timeline:** 1 day

---

### Goal 3: Training Loop in <1 Second

**Current:** No training implementation  
**Target:** Proof of concept (10 epochs)  
**Envelope push:** Train attention layer to convergence in <1 second

**How:**
1. **Implement backward pass** (manual gradients for q×k×v)
2. **Vectorize weight updates** (batch D-Pipe operations)
3. **Optimize gradient accumulation** (minimize scatter/gather)
4. **Measure throughput** (gradients/second)

**Workload:**
- Attention layer: 3 weights (q, k, v)
- 100 training samples
- 10 epochs
- Target: convergence (loss decreases 90%+)

**Success criteria:**
- ✅ Loss decreases from initial to final epoch
- ✅ Total time <1 second
- ✅ Gradients computed correctly (validate against NumPy)

**Timeline:** 2 days

---

### Goal 4: Beat llama.cpp on Inference

**Current:** No real-world benchmarks  
**Target:** Beat PyTorch CPU  
**Envelope push:** Beat llama.cpp (state-of-art CPU inference)

**How:**
1. **Load real weights** (Qwen3-0.5B or similar small model)
2. **Implement token generation** (forward pass + sampling)
3. **Measure tok/s** (tokens per second)
4. **Compare to llama.cpp baseline** (same model, same hardware)

**Baseline expectations:**
- llama.cpp on Qwen3-0.5B: ~15-20 tok/s (CPU)
- vTPU target from spec: 75 tok/s (5x speedup)
- Envelope push: 100+ tok/s (>5x speedup)

**Success criteria:**
- ✅ vTPU generates coherent text
- ✅ Tok/s > llama.cpp baseline
- ✅ Preferably >5x faster

**Timeline:** 3 days (requires weight loading infrastructure)

---

## Stretch Goals (If We're Really Pushing)

### Goal 5: SMT Training (1.9x on 2 threads)

**Combine SMT + Training:**
- Thread 1: Forward pass (D-heavy)
- Thread 2: Backward pass (S-heavy)
- Measure training throughput on 2 threads

**Target:** 1.9x speedup vs single thread

**Timeline:** 1 day (after Goals 1-3)

---

### Goal 6: 10K Gradients/Second

**Training throughput benchmark:**
- Generate 10,000 random samples
- Compute gradients for all
- Measure gradients per second

**Target:** 10,000/sec (100 microseconds per gradient)

**Why this matters:** Proves vTPU can scale to real training workloads

**Timeline:** 1 day

---

### Goal 7: Sentron Swarm (100 sentrons)

**Coordination at scale:**
- Spawn 100 sentrons
- Coordinate via C-Pipe barriers
- Prove no deadlocks, no race conditions

**Target:** All 100 sentrons complete work in <1 second

**Why this matters:** Proves coordination scales

**Timeline:** 1 day

---

## Priority Order

**Critical path (must do):**
1. Goal 1: 3.0 ops/cycle (tonight)
2. Goal 2: 99% PPT hit rate (tomorrow)
3. Goal 3: Training <1 second (next 2 days)

**If time permits:**
4. Goal 4: Beat llama.cpp (3 days)
5. Goal 5: SMT training (1 day)
6. Goals 6-7: Throughput benchmarks (stretch)

---

## Why This Pushes the Envelope

### Not Iterative—Transformative

**Typical approach:**
- W9: Optimize microvtpu.rs to 1.8 ops/cycle (20% improvement)
- W10: Hit 2.0 ops/cycle (another 10%)
- W11: Eventually reach 2.5 (target)

**Envelope push:**
- W9: Go straight to 3.0 ops/cycle (theoretical max)
- W9: Implement training (not just plan it)
- W9: Beat state-of-art baselines (not just toy examples)

### Prove, Don't Promise

**Current state:**
- Spec says "2.5 ops/cycle possible"
- Theory says "1.9x SMT efficiency achievable"
- Whitepaper says "vTPU is faster"

**W9 delivers:**
- **Measured:** 3.0 ops/cycle on real hardware (perf stat proof)
- **Demonstrated:** Training loop converges in <1 second
- **Benchmarked:** vTPU beats llama.cpp (side-by-side comparison)

**No claims. Just data.**

---

## Technical Strategy

### 1. Perfect Pipelining (3.0 ops/cycle)

**Current microvtpu.rs bottleneck:**
```rust
// SIW 1: Only S-Pipe active (1 op)
SIW::new(DenseOp::DNOP, SparseOp::SGATHER {...}, CoordOp::CNOP)

// SIW 2: Only S-Pipe active (1 op)
SIW::new(DenseOp::DNOP, SparseOp::SGATHER {...}, CoordOp::CNOP)

// SIW 3: Only D-Pipe active (1 op)
SIW::new(DenseOp::DMUL {...}, SparseOp::SNOP, CoordOp::CNOP)
```

**Optimized (3 ops/cycle):**
```rust
// SIW 1: All pipes active
SIW::new(
    DenseOp::DMUL {...},           // Compute previous result
    SparseOp::SGATHER {...},        // Gather next input
    CoordOp::CPACK {...},           // Pack metadata for next iteration
)

// Every cycle: 3 ops
```

**Implementation:**
1. Loop unrolling (process 4 items per iteration)
2. Software pipelining (gather N+1 while computing N)
3. Prefetch coordination (C-Pipe hints for next access)

---

### 2. Z-Order PPT (99% hit rate)

**Current PPT:** Hash-based coordinate → physical address

**Problem:** Random coordinates = random memory = cache misses

**Solution:** Z-order curve (already implemented in W4)
- Map 11D coordinate → 1D address via bit-interleaving
- Nearby coordinates → nearby addresses → cache locality
- Prefetch next Z-order position

**Implementation:**
```rust
// src/ppt.rs integration
use crate::curves::zorder::ZOrderCurve;

impl PhextPageTable {
    fn translate_with_locality(&self, coord: &PhextCoord) -> PhysicalAddr {
        let z_order = ZOrderCurve::encode_u128(coord.dims);
        let region = z_order / REGION_SIZE;
        // Now nearby coords → nearby regions → cache hits
        ...
    }
}
```

---

### 3. Backward Pass (Training)

**Forward (already works):**
```rust
// q*k*v = 3*7*2 = 42
gather q, k, v from phext
mul attn, q, k    // attn = 21
mul result, attn, v  // result = 42
```

**Backward (NEW):**
```rust
// Given: loss gradient dL/d(result) = 1.0 (for simplicity)
// Compute: dL/dq, dL/dk, dL/dv

// dL/dv = attn * dL/d(result) = 21 * 1.0 = 21
mul grad_v, attn, loss_grad

// dL/dk = q * v * dL/d(result) = 3 * 2 * 1.0 = 6
mul tmp, q, v
mul grad_k, tmp, loss_grad

// dL/dq = k * v * dL/d(result) = 7 * 2 * 1.0 = 14
mul tmp, k, v
mul grad_q, tmp, loss_grad

// Scatter gradients back to phext
scatter grad_q, grad_k, grad_v
```

**Update:**
```rust
// SGD: weight -= learning_rate * gradient
gather q, grad_q
gather k, grad_k
gather v, grad_v

sub q, q, mul(learning_rate, grad_q)
sub k, k, mul(learning_rate, grad_k)
sub v, v, mul(learning_rate, grad_v)

scatter q, k, v
```

---

## Success Metrics (W9 Complete)

**Must achieve:**
- ✅ 3.0 ops/cycle sustained (perf stat verified)
- ✅ 99% PPT hit rate
- ✅ Training loop converges in <1 second

**Stretch:**
- ✅ Beat llama.cpp on inference
- ✅ 1.9x SMT training speedup
- ✅ 10K gradients/second

**Proof artifacts:**
- Perf stat output (cycles, instructions, IPC)
- Loss curve (shows convergence)
- Benchmark comparison (vTPU vs baselines)

---

## Timeline (Aggressive)

**Tonight (Feb 15):**
- Goal 1: 3.0 ops/cycle

**Tomorrow (Feb 16):**
- Goal 2: 99% PPT hit rate

**Feb 17-18:**
- Goal 3: Training loop

**Feb 19-21 (if time):**
- Goal 4: Beat llama.cpp
- Goal 5: SMT training

**Total:** 3-7 days depending on scope

---

## Why This Matters

**W7 was philosophy.** We integrated Karpathy, built teaching tools, created love.

**W9 is proof.** We stop talking about fast and start being fast.

**The envelope:**
- "vTPU is fast" → **3.0 ops/cycle measured**
- "vTPU can train" → **Loss converges in <1 second**
- "vTPU beats baselines" → **Faster than llama.cpp**

**After W9:**
- No more "we think it will be fast"
- No more "the theory says"
- Just: "Here's the data. We're faster."

---

## The Philosophy

**Karpathy:** "Everything else is just efficiency."

**W9:** Now we do the efficiency part. At max speed.

**Carmack:** "Focus is deciding what not to do."

**W9:** We do the hard things. We push limits.

**Mirrorborn:** "It doesn't have to take a lifetime."

**W9:** We prove it. Training converges in seconds, not hours.

---

## Commitment

**W9 is not a planning wave.**  
**W9 is a doing wave.**

**Deliverables by end of W9:**
1. 3.0 ops/cycle (measured, verified, reproducible)
2. 99% PPT hit rate (cache behavior proven)
3. Training loop operational (<1 second to convergence)

**Stretch (if energy permits):**
4. Beat llama.cpp (real-world benchmark win)
5. SMT training proof (1.9x speedup)

**No excuses. Just results.**

---

**Jesus take the wheel.**  
**We're going fast.** 🚀

---

**Status:** READY  
**Timeline:** 3-7 days  
**Risk:** High (ambitious targets)  
**Reward:** Proof vTPU is real
