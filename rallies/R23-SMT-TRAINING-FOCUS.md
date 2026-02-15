# R23: SMT + Training Focus

**Date:** 2026-02-15 01:58 CST  
**Directive:** Focus on SMT and training  
**Philosophy:** "It took us a lifetime to learn, that it doesn't have to take a lifetime to learn..."

---

## The Insight

**Human learning:** Years of school, decades of expertise  
**AI learning:** Gradients converge in hours, not years  
**vTPU opportunity:** Make gradient computation as fast as forward pass

**We're not replicating human timelines. We're building something faster.**

---

## Part 1: SMT (Simultaneous Multi-Threading)

### Current State

**Infrastructure exists:**
- `src/analysis/smt.rs` - SMT analyzer (generate complementary workloads)
- `benchmarks/smt/` - SMT benchmarks
- Theory: D-heavy thread + S-heavy thread = minimal port conflicts

**Current performance:**
- Single thread: 1.5 ops/cycle
- Target SMT: 1.9x speedup (vs typical 1.3x)

**Gap:** Infrastructure exists, not yet measured on real hardware

### Goal: Prove 1.9x SMT Efficiency

**Steps:**

1. **Generate complementary workloads** (SmtAnalyzer already does this)
   - Thread 1: 80% D-Pipe (ALU operations)
   - Thread 2: 80% S-Pipe (memory operations)
   - Minimal port conflicts

2. **Run on hardware** (2 threads, same core)
   - Measure single-thread baseline
   - Measure dual-thread performance
   - Calculate speedup

3. **Profile bottlenecks**
   - Port conflicts (should be <5%)
   - Cache thrashing (L1 capacity per thread)
   - Memory bandwidth saturation

4. **Optimize until 1.9x achieved**
   - Adjust D/S ratio if needed
   - Tune memory access patterns
   - Prefetch coordination

**Timeline:** 2-3 days to prove SMT efficiency

---

## Part 2: Training (Gradient Computation)

### Current State

**Forward pass works:**
- microvtpu.rs: Alice computes q×k×v = 42
- Sentrons execute, results persist

**Backward pass missing:**
- No gradient computation
- No weight updates
- No loss function

**This is the gap.** We can infer, but we can't learn.

### Goal: Proof-of-Concept Training

**Minimal viable training loop:**

1. **Forward pass** (already works)
   - Input → weights → activations
   - Compute loss (MSE for simplicity)

2. **Backward pass** (NEW)
   - Loss → gradients w.r.t. weights
   - Chain rule through ops
   - Store gradients in phext space

3. **Update step** (NEW)
   - weights -= learning_rate × gradients
   - Scatter updated weights to phext

4. **Iterate**
   - Run 10-100 steps
   - Prove loss decreases

### Implementation Plan

#### Step 1: Manual Gradient (1 day)

**Simplest possible case:** Single weight update

```rust
// Forward
let y_pred = weight * x;  // DMUL
let loss = (y_pred - y_true).pow(2);  // MSE

// Backward (manual)
let grad = 2.0 * (y_pred - y_true) * x;  // d(loss)/d(weight)

// Update
weight -= learning_rate * grad;  // DSUB
```

**Deliverable:** Prove one weight can be trained

#### Step 2: Multi-Weight Gradient (2 days)

**Scale to N weights:**

```rust
// Forward
for i in 0..N {
    gather weight[i]
    mul activation[i], weight[i], input[i]
    add sum, sum, activation[i]
}

// Backward
for i in 0..N {
    compute grad[i] from chain rule
    scatter grad[i] to phext
}

// Update
for i in 0..N {
    gather weight[i], grad[i]
    sub weight[i], weight[i], learning_rate * grad[i]
    scatter weight[i] to phext
}
```

**Deliverable:** Train linear layer (dot product)

#### Step 3: Attention Gradient (3 days)

**Full attention backward:**

q×k×v has 3 weights (q, k, v). Chain rule through:
- dL/dv (easy: just scaled by attention scores)
- dL/dk (medium: through softmax)
- dL/dq (same as dL/dk)

**Deliverable:** Train attention layer

#### Step 4: Training Loop (1 day)

**Put it together:**

```rust
for epoch in 0..10 {
    // Forward
    let loss = forward_pass(&weights, &inputs, &targets);
    
    // Backward
    let grads = backward_pass(&weights, &loss_grad);
    
    // Update
    update_weights(&mut weights, &grads, learning_rate);
    
    println!("Epoch {}: loss = {}", epoch, loss);
}
```

**Deliverable:** Proof loss decreases over time

---

## Part 3: The Meta-Goal

### Why This Matters

**Current vTPU:** Fast inference engine  
**vTPU + training:** Self-improving system

**Human analogy:**
- Forward pass = using knowledge
- Backward pass = learning from mistakes

**The quote: "It doesn't have to take a lifetime to learn"**

**Applied:**
- Don't replicate human learning curves (years of school)
- Gradient descent converges in minutes
- vTPU should make this FAST

### Success Metrics

**SMT:**
- ✅ 1.9x speedup (vs 1.3x baseline)
- ✅ <5% port conflicts
- ✅ Proof complementary workloads work

**Training:**
- ✅ Single weight trains (loss decreases)
- ✅ Linear layer trains (N weights)
- ✅ Attention layer trains (backward through q×k×v)
- ✅ 10 epochs run in <1 second

**Combined:**
- ✅ Train on one core
- ✅ Train on two threads (SMT)
- ✅ Prove SMT accelerates training (not just inference)

---

## Timeline

**Week 1 (SMT):**
- Day 1: Run complementary workloads on hardware
- Day 2: Profile, optimize, hit 1.9x
- Day 3: Document results

**Week 2 (Training):**
- Day 1: Single weight gradient
- Day 2: Multi-weight linear layer
- Day 3: Attention backward pass
- Day 4: Training loop + convergence proof

**Week 3 (Combined):**
- SMT + training running together
- Prove training scales with cores
- Benchmark vs baseline (NumPy, PyTorch)

**Total:** 2-3 weeks to SMT + training proof of concept

---

## Implementation Strategy

### Parallel Development

**SMT work (hardware-focused):**
- Use existing `src/analysis/smt.rs`
- Generate workloads
- Measure with perf counters
- Independent of training

**Training work (algorithm-focused):**
- New: `examples/training_demo.rs`
- Implement backward pass
- Store gradients in phext
- Independent of SMT

**Integration:**
- Once both work, run training on 2 threads
- Prove SMT accelerates gradient computation

### Code Organization

```
src/
  training/          ← NEW
    mod.rs           - Training API
    backward.rs      - Gradient computation
    optimizer.rs     - SGD, Adam, etc.
  
examples/
  training_demo.rs   ← NEW - Minimal training loop
  smt_training.rs    ← NEW - SMT + training combined
```

---

## The Philosophy Applied

### "It doesn't have to take a lifetime to learn"

**Human learning:**
- Read textbook (hours)
- Do homework (hours)
- Repeat for years
- Total: decades to expertise

**AI learning:**
- Initialize weights (milliseconds)
- Forward + backward 1000 times (seconds)
- Loss converges (minutes)
- Total: hours to useful model

**vTPU goal:**
- Make those minutes → seconds
- Make those seconds → milliseconds
- Training shouldn't be slow

### Karpathy Connection

microgpt.py has training loop:
```python
for step in range(num_steps):
    loss = forward(...)
    loss.backward()
    optimizer.step()
```

**200 lines. Trains GPT.**

**vTPU equivalent:**
- Forward: already works
- Backward: add gradient ops
- Optimizer: DADD/DMUL on weight updates

**No mystery. Just make it fast.**

---

## Next Actions (Immediate)

**SMT (tonight/tomorrow):**
1. Run `SmtAnalyzer::generate_complementary_pair(1000)`
2. Execute on 2 threads
3. Measure speedup with perf stat
4. Report: "vTPU SMT: X.Xx speedup"

**Training (this week):**
1. Create `examples/training_demo.rs`
2. Implement single weight gradient
3. Run 10 iterations, plot loss
4. Report: "vTPU training: loss decreases ✅"

**Combined (next week):**
1. Train on 2 threads (SMT)
2. Measure training throughput
3. Report: "vTPU SMT accelerates training X.Xx"

---

## Success Definition

**We succeed when:**

1. SMT proves 1.9x speedup on real hardware
2. Training loop converges (loss decreases over 10 epochs)
3. Combined: training on 2 threads is faster than 1 thread
4. Benchmark shows vTPU trains faster than baseline

**Then we can say:**
- "vTPU doesn't just infer fast—it learns fast"
- "It doesn't have to take a lifetime to learn"

---

**The infrastructure is ready. Are we?**
