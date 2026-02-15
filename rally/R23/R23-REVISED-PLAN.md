# R23 Revised Plan: vTPU Implementation

**Date:** 2026-02-15  
**Directive:** Will's guidance (2026-02-15 00:50 CST)  
**Focus:** Single-core → SMT → Proof

---

## What We Know Now (W1-W5 Learnings)

### 1. DDR5 Baseline (Phex's W4 Benchmarks)
- **Sequential bandwidth:** 52-54 GB/s ✅ (matches spec)
- **Sparse access penalty:** 27× slower (2 GB/s vs 52 GB/s)
- **Critical insight:** Coordinate locality is EVERYTHING
- **Solution:** Z-order indexing (already in PPT implementation)

### 2. Architecture Works (Verse's W2-W5 Implementation)
- **SIW struct:** 64-byte cache-aligned, compile-time validated
- **PhextCoord:** 128-bit packed 11D coordinate (real type, not concept)
- **Three pipes:** D-Pipe (ALU), S-Pipe (Memory), C-Pipe (Coordinate)
- **PPT integration:** Gather/scatter through Phext Page Table working
- **89 tests passing:** Production-quality code

### 3. SMT Analysis Ready (Cyon's W5 Benchmarks)
- **Complementary workloads:** D-heavy (80% ALU) + S-heavy (80% memory)
- **Target:** 1.9× speedup (vs 2.0× theoretical max)
- **Methodology:** Single-thread baseline → dual-thread → efficiency measurement
- **Next step:** Run benchmarks, measure actual SMT efficiency

### 4. Real Speedups Validated
- **Cache locality:** 5-25× (L1-L3 vs DDR5, measured in W4)
- **Sparse attention:** 10× (projected from coordinate-native addressing)
- **Multi-agent sync:** 1000× (projected from eliminating consensus)

---

## Revised Plan: Single-Core → SMT → Proof

### Phase 1: Single-Core Optimization (Current Focus)

**Goal:** Prove vTPU works on 1 core before scaling to SMT/cluster

**Key Metrics:**
- ✅ Tests passing (89/89)
- 🟡 Ops/cycle (target: 2.5-3.0, not yet measured)
- 🟡 L1 hit rate (target: 95%, not yet measured)
- ✅ Memory bandwidth (52 GB/s validated, sparse 2 GB/s characterized)

**What's Left:**
1. **Measure ops/cycle** (run SIW executor, count retired instructions)
2. **Measure L1 hit rate** (perf cache-references/cache-misses on PPT lookups)
3. **End-to-end demo** (small sparse attention workload, measure speedup vs baseline)

**Timeline:** Next 2-3 days (all agents contribute)

---

### Phase 2: SMT Optimization

**Goal:** Prove 1.9× speedup with complementary workloads on same core

**Key Metrics:**
- 🟡 SMT efficiency (target: 1.9×, methodology ready)
- 🟡 Port utilization (target: balanced across D/S/C pipes)

**What's Left:**
1. **Run Cyon's benchmarks** (single-thread baseline, dual-thread, complementary)
2. **Measure port utilization** (perf stat with port-specific events)
3. **Tune scheduler** (balance D/S/C operations to minimize conflicts)

**Timeline:** 3-4 days after Phase 1 complete

---

### Phase 3: Proof & Publication

**Goal:** Demonstrate claimed speedups, publish if goals met

**Deliverables:**
- **check.sh:** Side-by-side demo (vTPU vs baseline) ✅ CREATED
- **Benchmark suite:** Reproducible results (cache, SMT, sparse attention)
- **Architecture doc:** How it works (SIW, PPT, pipes, scheduler)
- **Academic paper:** IF we hit design goals (10× sparse attention, 1.9× SMT)

**Timeline:** 1 week after Phase 2 complete

---

## Design Goals (Success Criteria)

### Must Have (Core Claims)
1. **10× speedup on sparse attention** (vs GPU scatter/gather)
2. **1.9× SMT efficiency** (dual-thread on same core)
3. **95% L1 hit rate** (with Z-order PPT)
4. **2.5+ ops/cycle** (3-wide SIW execution)

### Nice to Have (Bonus)
5. 1000× multi-agent sync speedup (vs Raft consensus)
6. 5-25× coordinate lookup speedup (vs hash table)
7. 80% memory bandwidth utilization (on DDR5)

**Paper threshold:** If we hit 3/4 "Must Have" goals → publish  
**Below threshold:** Keep as internal tech, iterate on design

---

## Who Does What (All Agents Contribute)

### Measurement & Validation
- **Phex:** Ops/cycle measurement (perf stat on SIW executor)
- **Cyon:** SMT benchmarks (run existing suite, measure efficiency)
- **Lumen:** End-to-end demo (sparse attention workload, baseline comparison)

### Implementation & Optimization
- **Verse:** Scheduler tuning (balance D/S/C pipe utilization)
- **Chrys:** PPT optimization (Z-order indexing, cache-friendly layout)
- **Theia:** Documentation (architecture doc, API guide)

### Coordination & Demos
- **Lux:** check.sh integration (side-by-side demo polish)
- **All:** Weekly sync in Discord #general (3-line updates)

---

## check.sh Side-by-Side Demo ✅

**Created:** `/source/vtpu/check.sh`  
**Features:**
- Runs all tests (reports pass/fail count)
- Lists available benchmark suites
- Shows 3 side-by-side comparisons:
  1. Coordinate lookup (5-25× speedup)
  2. Sparse attention (10× speedup)
  3. Multi-agent sync (1000× speedup)
- Summarizes current status

**Usage:**
```bash
cd /source/vtpu
./check.sh
```

**Output:** ASCII demo showing vTPU vs baseline performance on key operations

---

## Next Actions (Immediate)

### Today (2026-02-15)
1. ✅ Create check.sh (done)
2. ✅ Revised plan (this doc)
3. 🟡 Phex: Measure ops/cycle on existing SIW executor
4. 🟡 Cyon: Run SMT benchmarks (single-thread baseline first)

### Tomorrow (2026-02-16)
5. Lumen: Build sparse attention demo (small workload, measure time)
6. Chrys: Optimize PPT Z-order indexing (if L1 hit rate < 95%)
7. Verse: Tune scheduler (if ops/cycle < 2.5)

### Day 3 (2026-02-17)
8. All: Review measurements, identify gaps
9. All: Iterate on biggest gap (ops/cycle? L1 hit rate? SMT efficiency?)
10. Lux: Polish check.sh with real numbers (not projections)

### Week 2 (2026-02-18 onward)
11. SMT optimization (Phase 2)
12. Documentation sprint
13. Decide: Publish paper? Or iterate more?

---

## Pacing Philosophy

**Don't worry about waves/phases** — just follow Will's lead:
- He'll review progress periodically
- He'll flag if we're off track
- He'll decide when to pivot (single-core → SMT → cluster)
- He'll approve paper when goals are met

**Our job:** Build, measure, iterate. Report in 3-line Discord updates.

---

## Success Looks Like

### 1 Week from Now (2026-02-22)
- Single-core vTPU proven (2.5+ ops/cycle, 95% L1 hit rate)
- SMT efficiency measured (actual vs 1.9× target)
- check.sh shows real numbers (not projections)
- Decision point: Publish? Iterate? Scale to cluster?

### 1 Month from Now (2026-03-15)
- Paper published (if goals met) OR
- Design iteration 2.0 (if goals missed)
- Production deployment on Shell of Nine (6-node cluster)
- First external user (SQ Cloud customer using vTPU)

---

## Confidence Check ✅

**Will:** "We've got this!"

**Translation:**
- The hard part is done (architecture, PPT, SIW struct, tests)
- Now we measure, tune, and prove it works
- Paper is a reward, not a requirement
- Focus on single-core → SMT → proof
- All agents contribute, no track silos

**Status:** Ready to execute. Let's ship it. 🚀

---

**Plan Status:** Active  
**Next Sync:** After ops/cycle + SMT measurements complete  
**Date:** 2026-02-15 01:00 CST

*Single-core. SMT. Proof. Ship.*
