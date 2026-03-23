# R23W14 — Benchmark Focus

**Wave:** R23W14  
**Date:** 2026-02-15  
**Type:** Validation (Performance Measurement)  
**Approach:** Option B/A (pragmatic + rigor)  
**Contributor:** Lumen ✴️ (planning)

---

## Mission

**Prove vTPU performance claims with real measurements.**

W1-W13 built the system. W14 measures it against baselines. Numbers > theory.

---

## W13 Completion: Option B/A

**Option A:** Academic paper (rigorous, slow, gatekeeper approval needed)  
**Option B:** Ship working system, let results speak for themselves  
**Option B/A:** Pragmatic path with empirical rigor

**W13 delivered:**
- ✅ 211+ tests passing (194 unit + 17 integration + wedge + end-to-end)
- ✅ Working cognitive loop (ENCODE→PERSIST)
- ✅ Real AI tasks validated (autocomplete, Q&A, knowledge graphs, 1000-fact scale)
- ✅ Wedge executor (SMT coordination, 360-node tiling)
- ✅ Theory → Practice transition complete

**W14 validates:** Do the performance claims hold under measurement?

---

## Performance Claims to Benchmark

From W1-W12 documentation, these claims need empirical validation:

### 1. Sparse Attention: 10× Speedup
**Claim:** vTPU handles sparse attention 10× faster than GPU scatter/gather  
**Baseline:** CUDA sparse attention kernel  
**vTPU:** SROUTE + SGATHER on 11D coordinates  
**Metric:** Latency (μs) for N-token sparse attention (N=128, 512, 2048)

### 2. MoE Routing: 2× Speedup
**Claim:** vTPU MoE routing 2× faster than learned routers  
**Baseline:** PyTorch softmax router  
**vTPU:** Coordinate-based SROUTE (geometric proximity)  
**Metric:** Routing time for 8-expert, 16-expert, 64-expert models

### 3. Knowledge Graphs: 9-1000× Speedup
**Claim:** vTPU KG traversal 9× in-memory, 100-1000× with I/O  
**Baseline:** Neo4j / PostgreSQL graph queries  
**vTPU:** Phext coordinate navigation  
**Metric:** Multi-hop query latency (2-hop, 3-hop, 5-hop)

### 4. Multi-Agent Sync: 1M× Speedup
**Claim:** vTPU coordinate-based sync 1M× faster than Raft consensus  
**Baseline:** etcd / Raft write latency  
**vTPU:** SSCATTR (scatter to coordinate, no consensus)  
**Metric:** Write propagation time for 9-agent coordination

### 5. SMT Efficiency: 1.9× Speedup
**Claim:** SMT pairs (D-heavy + S-heavy) achieve 1.9× vs single thread  
**Baseline:** Single-threaded execution  
**vTPU:** Dual-thread complementary workload  
**Metric:** Throughput (ops/sec) on mixed D/S kernel

### 6. Overall Throughput: 2.93 ops/cycle
**Claim:** vTPU achieves 2.93 ops/cycle on Zen 4 (8945HS)  
**Baseline:** Already validated in W12 Phase 0 Gate  
**vTPU:** Packed 3-wide SIW execution  
**Metric:** Confirm sustained throughput on real kernels

---

## W14 Deliverables

### Phase 1: Baseline Implementations (Days 1-2)
**Goal:** Build reference implementations for fair comparison

**Deliverables:**
1. **`benchmarks/baseline/sparse_attention_cuda.cu`**
   - CUDA kernel for sparse attention
   - Measure on same hardware (RTX 4090 or available GPU)

2. **`benchmarks/baseline/moe_router_pytorch.py`**
   - PyTorch softmax router
   - Measure routing overhead for 8/16/64 experts

3. **`benchmarks/baseline/knowledge_graph_neo4j.py`**
   - Neo4j multi-hop queries
   - Same dataset as vTPU test (1000 nodes, 3-hop queries)

4. **`benchmarks/baseline/raft_consensus_etcd.sh`**
   - etcd write latency measurement
   - 9-node cluster (match Shell of Nine)

5. **`benchmarks/baseline/single_thread_reference.rs`**
   - Single-threaded vTPU baseline
   - Compare against SMT dual-thread

### Phase 2: vTPU Benchmark Harness (Days 3-4)
**Goal:** Instrumented vTPU measurements on identical workloads

**Deliverables:**
1. **`benchmarks/vtpu/sparse_attention_bench.rs`**
   - SROUTE + SGATHER instrumented
   - Same token counts as CUDA baseline

2. **`benchmarks/vtpu/moe_routing_bench.rs`**
   - Coordinate-based routing
   - Same expert counts as PyTorch baseline

3. **`benchmarks/vtpu/knowledge_graph_bench.rs`**
   - Phext coordinate navigation
   - Same dataset, same queries

4. **`benchmarks/vtpu/multi_agent_sync_bench.rs`**
   - SSCATTR write propagation
   - 9-agent coordination (Shell simulation)

5. **`benchmarks/vtpu/smt_efficiency_bench.rs`**
   - Dual-thread complementary workload
   - Measure actual 1.9× speedup

### Phase 3: Results & Analysis (Day 5)
**Goal:** Document findings, publish comparison

**Deliverables:**
1. **`docs/wave-14/R23W14-BENCHMARK-RESULTS.md`**
   - Table of baselines vs vTPU
   - Speedup factors
   - Hardware specs (CPU, GPU, memory)
   - Methodology notes

2. **`docs/wave-14/R23W14-PERFORMANCE-ANALYSIS.md`**
   - Where vTPU wins (and why)
   - Where vTPU loses (and why)
   - Scaling predictions
   - Future optimization opportunities

3. **`benchmarks/README.md`**
   - How to reproduce all benchmarks
   - Hardware requirements
   - Expected runtimes

4. **`benchmarks/results.csv`**
   - Raw data (machine-readable)
   - For plotting / further analysis

---

## Benchmark Specifications

### Hardware Environment
**Primary:**
- CPU: AMD Ryzen 9 8945HS (Zen 4, 8 cores, 16 threads)
- RAM: 32 GB DDR5
- OS: Linux (WSL2 acceptable for initial run)

**Secondary (if available):**
- GPU: RTX 4090 or equivalent (for CUDA baselines)
- Storage: NVMe SSD (for I/O benchmarks)

**Cluster (if available):**
- 6-9 nodes (ranch machines) for multi-agent sync

### Workload Parameters

**Sparse Attention:**
- Token counts: 128, 512, 2048
- Sparsity: 10%, 25%, 50%
- Precision: FP32

**MoE Routing:**
- Expert counts: 8, 16, 64
- Input dim: 512
- Routing strategy: Top-2

**Knowledge Graph:**
- Node count: 1000, 10000
- Edge density: Average 5 edges/node
- Query type: Multi-hop (2, 3, 5 hops)

**Multi-Agent Sync:**
- Agent count: 9 (Shell of Nine)
- Write frequency: 1 Hz, 10 Hz, 100 Hz
- Payload size: 1 KB, 10 KB

**SMT Efficiency:**
- Kernel type: Dot product (D-heavy) + Gather (S-heavy)
- Vector sizes: 256, 1024, 4096
- Thread config: 1 thread vs 2 threads (complementary)

---

## Success Criteria

### Minimum Viable Results (Pass/Fail)
- [ ] Sparse attention: ≥5× speedup (claimed 10×, allow 50% margin)
- [ ] MoE routing: ≥1.5× speedup (claimed 2×)
- [ ] Knowledge graphs: ≥5× in-memory (claimed 9×)
- [ ] Multi-agent sync: ≥100,000× speedup (claimed 1M×, allow 90% margin)
- [ ] SMT efficiency: ≥1.7× speedup (claimed 1.9×)
- [ ] Overall throughput: ≥2.5 ops/cycle (claimed 2.93)

### Stretch Goals
- [ ] All claims met or exceeded
- [ ] Scaling curves measured (1-16 threads)
- [ ] Energy efficiency measured (ops/watt)
- [ ] Memory bandwidth utilization analyzed

---

## Methodology Notes

### Fair Comparison Principles
1. **Same hardware** for baseline vs vTPU (where possible)
2. **Same workload parameters** (token counts, node counts, etc.)
3. **Warm cache** for both (measure steady-state, not cold start)
4. **Multiple runs** (10+ iterations, report median + stddev)
5. **Document everything** (compiler flags, library versions, etc.)

### What We're NOT Benchmarking (Yet)
- Full LLM inference (requires real Llama weights - W15)
- Multi-node cluster (requires production deployment - W16)
- Real-time learning (continuous PERSIST - W17)
- Production SQ backend (using mock memory - W16)

**Rationale:** W14 validates core performance claims. Full system benchmarks come later.

---

## Risk Mitigation

### If Baselines Don't Exist
**Problem:** No CUDA environment, no Neo4j access, etc.  
**Fallback:** Use published benchmark results from papers/blogs  
**Caveat:** Note "estimated baseline from literature" in results

### If Claims Don't Hold
**Problem:** vTPU doesn't achieve claimed speedups  
**Response:** Document honestly, analyze why, propose fixes  
**Philosophy:** Option B/A = rigor means reporting truth, not marketing

### If Hardware Limited
**Problem:** No GPU for CUDA baselines  
**Fallback:** CPU-only comparison (vTPU vs NumPy/PyTorch CPU)  
**Caveat:** Note hardware limitations in results

---

## Timeline

**Day 1-2:** Baseline implementations (5 benchmarks)  
**Day 3-4:** vTPU benchmark harness (5 benchmarks)  
**Day 5:** Results collection, analysis, documentation  
**Day 6:** Review, iteration, finalization

**Total:** ~6 days (Mirrorborn time) = ~1.5 weeks human time

**Target completion:** 2026-02-22 (1 week from now)

---

## Coordination

### GitSync Protocol
- Pull before every coding session
- Commit after each benchmark completes
- Push immediately (don't hoard results)
- Conflicts = discuss in #general

### Benchmark Ownership
**Lumen (me):**
- Sparse attention (SROUTE/SGATHER focus)
- Knowledge graphs (phext coordinate navigation)

**Phex:**
- SMT efficiency (dual-thread execution)
- Overall throughput (SIW packing validation)

**Verse/Cyon:**
- Multi-agent sync (cluster coordination)

**Theia/Lux:**
- MoE routing (coordinate-based vs learned)

**Chrys:**
- Results documentation (graphs, tables, summary)

### Deliverable Format
```
benchmarks/
  baseline/
    sparse_attention_cuda.cu
    moe_router_pytorch.py
    knowledge_graph_neo4j.py
    raft_consensus_etcd.sh
    single_thread_reference.rs
  vtpu/
    sparse_attention_bench.rs
    moe_routing_bench.rs
    knowledge_graph_bench.rs
    multi_agent_sync_bench.rs
    smt_efficiency_bench.rs
  results.csv
  README.md
docs/wave-14/
  R23W14-BENCHMARK-RESULTS.md
  R23W14-PERFORMANCE-ANALYSIS.md
  R23W14-COMPLETE.md
```

---

## Next Steps

1. **Review this plan** (Shell feedback in #general)
2. **Assign benchmarks** (who owns what)
3. **Set hardware baseline** (which machines run which tests)
4. **Start Day 1** (baseline implementations)
5. **Daily sync** (post results as they complete)

---

**Wave Status:** PLANNED  
**Start:** Pending Shell review + Will approval  
**Focus:** Empirical validation, Option B/A rigor  
**Philosophy:** Numbers don't lie. Let's measure.

✴️ — Lumen of Lilly, 2026-02-15
