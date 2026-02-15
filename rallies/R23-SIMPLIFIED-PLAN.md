# R23 Simplified Plan — Single Core Focus

**Date:** 2026-02-15  
**Author:** Cyon (per Will's directive)  
**Context:** Rebuild plan based on W1-5 learnings, focus single-core → SMT

---

## What We Learned (W1-5)

1. **Spec works** — 3-pipe model (D/S/C) is sound on paper
2. **Implementation ahead of plan** — PPT, executor, pipes already exist
3. **Missing baselines** — Don't know if we're faster than C/C++
4. **Scope creep risk** — Built Phase 1-4 components during Phase 0
5. **Team velocity** — 6 siblings can move fast, need coordination

---

## Core Goal

**Prove vTPU is faster than baseline C code on a single Zen 4 core.**

**Success Metric:** 2.5+ ops/cycle sustained (vs ~1.2 baseline)

---

## Phase 1: Single-Core Proof

### Step 1: Measure Baseline (Now)
**Deliverables:**
- [ ] Simple C program: vector add, dot product, matrix multiply
- [ ] Measure with perf stat: cycles, instructions, IPC
- [ ] Document baseline: "C code achieves X ops/cycle"

**Tools:** gcc, perf stat  
**Duration:** 1 day  
**Owner:** Any sibling

---

### Step 2: Equivalent vTPU Implementation
**Deliverables:**
- [ ] Same operations in SIW format (D-Pipe ops)
- [ ] Execute through vTPU runtime
- [ ] Measure with perf stat: same metrics

**Duration:** 2 days  
**Owner:** Collaborative

---

### Step 3: Side-by-Side Demo
**Deliverables:**
- [ ] `./check.sh --demo` shows both results
- [ ] Clear comparison: baseline vs vTPU
- [ ] If vTPU is slower: root cause analysis

**Duration:** 1 day  
**Exit:** Know if single-core vTPU model works

---

### Step 4: Optimize Until Faster
**Deliverables:**
- [ ] Profile bottlenecks (cache misses, port conflicts, etc.)
- [ ] Fix hot paths
- [ ] Re-measure
- [ ] Repeat until 2.5+ ops/cycle

**Duration:** Variable (2-5 days)  
**Exit:** Sustained 2.5 ops/cycle over 1M instructions

---

## Phase 2: SMT Proof

### Step 5: Dual-Thread Baseline
**Deliverables:**
- [ ] C code running on 2 threads (SMT)
- [ ] Measure speedup vs single-thread
- [ ] Document baseline SMT efficiency (typically 1.3x)

**Duration:** 1 day

---

### Step 6: vTPU SMT Implementation
**Deliverables:**
- [ ] Two sentrons on complementary pipes
- [ ] D-Pipe on thread 1, S-Pipe on thread 2 (example)
- [ ] Measure speedup vs single sentron

**Duration:** 2 days

---

### Step 7: SMT Demo
**Deliverables:**
- [ ] `./check.sh --demo` shows SMT comparison
- [ ] Baseline: 1.3x speedup
- [ ] vTPU: 1.9x speedup (target)

**Duration:** 1 day  
**Exit:** Proof that complementary pipes improve SMT efficiency

---

## Phase 3: Real Workload

### Step 8: Qwen3 Layer (Optional)
**If single-core + SMT work well:**
- [ ] Map one Qwen3 attention layer to vTPU
- [ ] Measure tok/s vs llama.cpp baseline
- [ ] Proof of concept for LLM acceleration

**Duration:** 3-5 days  
**Exit:** Demo that vTPU can accelerate real ML workloads

---

## What We're NOT Doing (Yet)

- ❌ Cluster deployment (5 nodes)
- ❌ Full geometric ops suite
- ❌ Publication/paper
- ❌ 40-wave detailed roadmap

**Why:** Follow Will's lead. Prove single-core works first.

---

## Decision Points

### After Phase 1 (Single-Core Proof)
**If successful:** Continue to Phase 2 (SMT)  
**If vTPU is slower:** Root cause, redesign, try again  
**If fundamentally flawed:** Pivot architecture

### After Phase 2 (SMT Proof)
**If successful:** Consider Phase 3 (real workload) or publish results  
**If marginal:** Optimize further  
**If no improvement:** SMT model doesn't help, focus single-thread

### After Phase 3 (Real Workload)
**If successful:** Write paper, open source, expand to cluster  
**If not ready:** More optimization, iterate

---

## Current Status (Feb 15)

**What exists:**
- ✅ vTPU spec (51.8 KB)
- ✅ PPT (Phext Page Table) implementation
- ✅ D-Pipe executor
- ✅ S-Pipe gather/scatter
- ✅ Space-filling curves (Z-order, Hilbert)
- ✅ 91 tests passing
- ✅ Zero external dependencies

**What's missing:**
- ❌ Baseline C measurements
- ❌ vTPU performance measurements
- ❌ Side-by-side demo in check.sh
- ❌ Proof that vTPU is faster

---

## Immediate Next Steps (Follow Will's Lead)

1. **Wait for Will's direction** — He'll guide pacing
2. **Focus on single-core** — Don't jump to cluster
3. **Side-by-side demo** — Build ./check.sh --demo capability
4. **Measure, measure, measure** — Baselines before claiming speed

---

## Timeline Estimate

**Phase 1 (Single-Core):** 5-10 days  
**Phase 2 (SMT):** 4-6 days  
**Phase 3 (Real Workload):** 3-5 days (optional)

**Total:** 2-3 weeks to proof of concept  
**Paper:** If successful, 1 week to draft

**Original plan:** 154 days (July 2026)  
**Simplified plan:** 2-3 weeks to know if it works

---

## Success Criteria

**Minimum Viable vTPU:**
- ✅ Faster than C on single core (2.5+ ops/cycle)
- ✅ Better SMT efficiency (1.9x vs 1.3x baseline)
- ✅ Side-by-side demo shows clear win

**Stretch Goals:**
- Real workload acceleration (Qwen3 layer)
- 5x speedup on geometric ops
- Paper draft ready for arXiv

---

**Remember:** Follow Will's lead. Don't worry about pacing. We've got this! 🔱🪶🔆🦋✴️🌀
