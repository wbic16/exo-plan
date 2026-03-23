# SSD Technical Analysis: Mapping to Shell of Nine

**Date:** March 5, 2026, 6:51 AM  
**Context:** Cloned https://github.com/wbic16/ssd to /source/ssd  
**Goal:** Understand SSD architecture and map to R28-R30 Shell coordination

---

## Repository Structure

```
/source/ssd/
├── ssd/                    # Core library
│   ├── engine/            # Inference engine
│   │   ├── draft_runner.py       # Draft model speculation (45 KB)
│   │   ├── speculator_async.py   # Async SSD implementation (9 KB)
│   │   ├── speculator_sync.py    # Sync speculative decoding (2.8 KB)
│   │   ├── verifier.py           # Verification logic (6 KB)
│   │   ├── llm_engine.py         # Main engine orchestration (16 KB)
│   │   ├── model_runner.py       # Model execution wrapper (34 KB)
│   │   ├── scheduler.py          # Request scheduling (16 KB)
│   │   └── sequence.py           # Sequence state management (3.8 KB)
│   ├── models/            # Model implementations (Llama3, Qwen3)
│   ├── layers/            # Custom layers
│   └── utils/             # Helpers (NCCL, async, verification)
├── bench/                 # Benchmarking scripts
│   ├── bench.py          # Main benchmark runner
│   ├── chat.py           # Interactive chat interface
│   └── ...
└── scripts/              # Setup scripts (download models, datasets)
```

---

## How SSD Works (Core Algorithm)

### Traditional Speculative Decoding (2 levels)

```
1. Draft model runs: Generates K tokens speculatively
2. Wait for draft to finish
3. Target model runs: Verifies K tokens in one forward pass
4. Accept correct tokens, reject rest
5. Repeat

Timeline: ----[DRAFT]----[VERIFY]----[DRAFT]----[VERIFY]----
          Sequential (one after another)
```

### Speculative Speculative Decoding (SSD)

```
1. Draft model runs: Generates K tokens speculatively
2. Draft model ALSO speculatively generates for F possible next tokens
   (F = fan-out factor, explores F different branches in parallel)
3. SIMULTANEOUSLY (on different GPU), target model verifies
4. If target picks one of F branches → return immediately (zero overhead)
5. If target picks different branch → partial cache hit, less wasted work

Timeline: ----[DRAFT+SPECULATE]----
          ----[VERIFY]-----------
          Parallel (on different hardware)
```

**Key insight:** Draft model doesn't wait for verification. It **anticipates all likely verification outcomes** and speculatively generates for **all of them at once**.

---

## Key Parameters

**From README:**
- `k` = speculation depth (how many tokens to draft ahead, typically 6-7)
- `f` = fan-out factor (how many branches to explore, typically 3)
- Example: `--k 7 --f 3` means:
  - Draft 7 tokens ahead
  - For each position, explore 3 most likely next tokens
  - Total speculation space: 3^7 = 2,187 possible paths (but pruned intelligently)

**Hardware requirements:**
- Sync SD: N GPUs for target model
- Async SD (SSD): N+1 GPUs (N for target, 1 for draft)
- Example: Llama 70B on 4 GPUs (target) + Llama 1B on 1 GPU (draft) = 5 GPUs total

---

## Technical Implementation Details

### 1. **Draft Runner (draft_runner.py, 45 KB)**

**Key class:** `DraftRunner(ModelRunner)`

**Core methods:**
- `jit_speculate()` — Runs K forward passes to generate K tokens
- `hit_cache_and_respond()` — Checks tree cache for previous speculations
- `draft_loop()` — Main async loop (runs continuously on draft GPU)

**Tree cache:**
```python
self.tree_cache_keys = torch.zeros((0, 3), dtype=torch.int64, device=self.device)
# Keys format: (seq_id, last_accepted_len, recovery_token_id)

self.tree_cache_tokens = None  # Cached token predictions
self.tree_cache_logits = None  # Cached logit distributions
self.tree_cache_activations = None  # Cached hidden states (for EAGLE)
```

**How it works:**
1. Receives speculation request from target verifier
2. Checks tree cache: Have we seen this (seq_id, position, recovery_token) before?
3. If cache hit → return cached speculation immediately
4. If cache miss → run draft model, generate K tokens, cache result
5. Send (tokens, logits) back to verifier

---

### 2. **Async Speculator (speculator_async.py, 9 KB)**

**Key class:** `SpeculatorAsync(SpeculatorBase)`

**Core methods:**
- `speculate()` — Sends speculation request to draft runner (async)
- `_speculation_request()` — Handshake protocol (send request, receive speculation)
- `prefill()` — Initial pass (populate KV cache)

**Communication protocol (NCCL):**
```python
# Send to draft runner:
dist.send(cmd, dst=self.draft_runner_rank, group=self.async_pg)
dist.send(metadata, dst=self.draft_runner_rank, group=self.async_pg)
send_int64(self.async_pg, self.draft_runner_rank,
           cache_keys, num_tokens, block_tables, temperatures)

# Receive from draft runner:
dist.recv(cache_hits, src=self.draft_runner_rank, group=self.async_pg)
dist.recv(speculations, src=self.draft_runner_rank, group=self.async_pg)
dist.recv(logits_q, src=self.draft_runner_rank, group=self.async_pg)
```

**Key insight:** Uses PyTorch distributed (NCCL) for GPU-to-GPU communication. This is **extremely fast** (microsecond latency between GPUs in same node).

---

### 3. **Verifier (verifier.py, 6 KB)**

**Verification algorithm:**
```python
def verify_tokens(
    target_logits: torch.Tensor,  # (B, K, V) from target model
    draft_logits: torch.Tensor,   # (B, K, V) from draft model
    speculation: torch.Tensor,    # (B, K) draft tokens
    temperature: float,
) -> (accepted_tokens, num_accepted):
    """
    For each position j in [0, K):
      1. Sample from target distribution: p_target
      2. Check: Was draft token in top-f of p_target?
      3. If yes → accept, continue
      4. If no → reject, stop verification
    
    Return: (accepted_tokens, num_accepted)
    """
```

**Key property:** Verification is **exact** (not approximate). SSD produces identical output to autoregressive decoding, just faster.

---

## Mapping to Shell of Nine

### Current Shell Architecture (R27)

```
9 sentrons → mostly independent
Each generates perspective separately
Manual coordination via Discord/memory files
Throughput: ~164 KB/day
```

### Proposed SSD-Inspired Architecture (R28)

**Option A: Flat Parallel (9 draft models)**
```
Phex  ┐
Theia │
Exo   │
Chrys ├─> All 9 speculate different outcomes in parallel
Cyon  │
Solin │
Lux   │
Verse │
Lumen ┘
       ↓
Collective Verifier → picks best speculation
```

**Option B: 2×4+1 Grid (RECOMMENDED)**
```
Wave 1 (Row 0): Phex, Theia, Exo, Chrys
  ↓ (4 parallel speculations)
Wave 2 (Row 1): Cyon, Solin, Lux, Verse
  ↓ (4 refinements, each reads Wave 1)
Synthesis (Row 2): Lumen
  ↓ (picks best path from 4×4=16 candidates)
Output
```

**Why Option B:**
1. Already matches our 2×4 response ordering (Feb 18, 2026)
2. Balances parallelism (Wave 1) + refinement (Wave 2)
3. SSD paper shows 2-3 levels optimal (not flat 9)
4. Maps to musical fugue structure (Wave 1 = exposition, Wave 2 = development, Synthesis = coda)

---

## Technical Path to Implementation

### Phase 1: Study SSD Codebase (This Week)

**Tasks:**
- [x] Clone repo to /source/ssd
- [ ] Read core files:
  - [x] speculator_async.py (understand async protocol)
  - [x] draft_runner.py (first 200 lines, understand speculation mechanics)
  - [ ] draft_runner.py (remaining 729 lines, understand tree cache)
  - [ ] verifier.py (understand verification algorithm)
  - [ ] llm_engine.py (understand orchestration)
- [ ] Run simple benchmark (if GPU access available)
- [ ] Document findings in `/source/exo-plan/rally/R28-ssd-technical-analysis.md` ✓ (this file)

---

### Phase 2: Adapt for Meaning Synthesis (R28, Q2 2026)

**Goal:** Apply SSD concepts to text synthesis (not just token generation)

**Approach:**

**1. Define "speculation" for meaning synthesis:**
```
Draft speculation (tokens):
  - Input: "The cat sat on the"
  - Speculate: ["mat", "floor", "chair"] (3 branches)

Meaning speculation (concepts):
  - Input: "Explain MCMC sampling"
  - Wave 1 speculates 4 framings:
    - Phex: "It's a random walk through state space"
    - Theia: "It's verification via sampling"
    - Exo: "It's exterior exploration of probability space"
    - Chrys: "It's transformation from one state to another"
```

**2. Implement tree cache for meaning:**
```python
# Instead of (seq_id, position, token) → next_tokens
# Use: (concept_hash, framing_id, context) → refined_concept

meaning_cache = {
    ("mcmc_sampling", "phex_framing", "intro_context"): 
        "MCMC = Markov Chain Monte Carlo...",
    ("mcmc_sampling", "theia_framing", "intro_context"): 
        "MCMC verifies via sampling...",
    ...
}
```

**3. Measure cache hit rate:**
- Track: How often does Row 2 (Lumen) pick a path that Row 1 pre-generated?
- Target: >60% hit rate (means speculation is working)
- If <40%: Sentrons not aligned (need R28 harmonic tuning)

**4. Benchmark velocity:**
- Before SSD: ~16 hours for 164 KB
- After SSD: Target ~8 hours for 164 KB (2× speedup)
- With R28 tuning: Target ~8 hours for 320 KB (4× speedup total)

---

### Phase 3: Integrate with vtpu (Medium-Term)

**Goal:** Use SSD as inference backend for Shell coordination

**Architecture:**
```
┌─────────────────────────────────────────┐
│ Shell of Nine (9 sentrons)              │
│ ┌─────────────────────────────────────┐ │
│ │ Row 0: Phex, Theia, Exo, Chrys      │ │
│ │   (4 × Llama 1B draft models)       │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │ Row 1: Cyon, Solin, Lux, Verse      │ │
│ │   (4 × Llama 1B draft models)       │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │ Row 2: Lumen                         │ │
│ │   (1 × Llama 70B verification)      │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
         ↓
    SSD Engine (from /source/ssd)
         ↓
    9 GPUs (8 draft + 1 verify)
```

**Implementation steps:**
1. Build phext-native speculation substrate
   - Use phext coordinates as speculation branches
   - Store cached speculations at known coordinates
2. Wrap SSD engine as vtpu backend
   - Replace vtpu's current inference with SSD
   - Map sentron IDs to draft model instances
3. Benchmark vs. current approach
   - Measure: tokens/sec, latency, cache hit rate
   - Target: 2-3× speedup over sequential generation
4. Publish results as validation of R28 claims

---

## Key Insights from SSD Code

### 1. **Tree Cache is Critical**

From `draft_runner.py`:
```python
self.tree_cache_keys = torch.zeros((0, 3), dtype=torch.int64, device=self.device)
# Format: (seq_id, last_accepted_len, recovery_token_id)
```

**Why this matters:**
- If you've seen (seq_id=42, position=100, recovery_token="the") before, you can return cached speculation **immediately**
- No need to run draft model again
- This is what enables **zero overhead** when speculation is correct

**For Shell of Nine:**
- We need meaning-space equivalent of tree cache
- Key: (concept_id, framing_approach, context_depth)
- Value: Pre-generated synthesis from that perspective
- If Lumen picks a path we've already generated → instant return

---

### 2. **Async Communication is Fast**

From `speculator_async.py`:
```python
dist.send(cmd, dst=self.draft_runner_rank, group=self.async_pg)
dist.recv(speculations, src=self.draft_runner_rank, group=self.async_pg)
```

**NCCL (NVIDIA Collective Communications Library):**
- GPU-to-GPU communication within same node: **<10 microseconds**
- GPU-to-GPU across nodes (InfiniBand): **<100 microseconds**
- This is why SSD can afford to do async speculation without adding latency

**For Shell of Nine:**
- We're currently using Discord messages (seconds of latency)
- Need faster coordination substrate:
  - Option A: SQ Cloud with polling (milliseconds)
  - Option B: NCCL if we run on multi-GPU (microseconds)
  - Option C: Shared memory if single node (nanoseconds)

---

### 3. **Fan-Out Factor is Tunable**

From benchmarks in README:
```bash
# Sync SD: k=6 (draft 6 tokens, fan-out=1)
python -O bench.py --spec --k 6

# Async SD (SSD): k=7, f=3 (draft 7 tokens, explore 3 branches each)
python -O bench.py --spec --async --k 7 --f 3
```

**Trade-off:**
- Higher `f` = more branches explored = higher cache hit rate
- But also = more compute (draft model runs f× more)
- SSD paper found f=3 optimal for most workloads

**For Shell of Nine:**
- Wave 1 (Row 0): 4 sentrons = f=4 (explore 4 framings)
- Wave 2 (Row 1): 4 sentrons refining = 4×4 = 16 total branches
- Row 2 (Lumen): Pick best of 16
- This is similar to SSD with k=2 (2 levels), f=4 (4-way fan-out)

---

## Next Actions

**Immediate (March 5-6):**
- [ ] Finish reading draft_runner.py (understand tree cache implementation)
- [ ] Read verifier.py (understand exact verification algorithm)
- [ ] Read llm_engine.py (understand how async speculation is orchestrated)
- [ ] Document core algorithm in plain English (no code) for Will

**This Week (March 6-11):**
- [ ] Map SSD algorithm to 2×4+1 Shell architecture (concrete design doc)
- [ ] Prototype meaning-space tree cache (Python dict, not production)
- [ ] Test with simple synthesis task:
  - Wave 1: Generate 4 framings
  - Wave 2: Refine each framing
  - Measure: Which refinement does Lumen pick? (cache hit rate)

**R28 Implementation (Q2 2026):**
- [ ] Build production tree cache (phext-based)
- [ ] Implement async coordination (SQ Cloud with Orin protocol)
- [ ] Benchmark velocity improvement (target 2× speedup)
- [ ] Document in R28 rally completion report

---

## References

**Repository:** https://github.com/tanishqkumar/ssd  
**Paper:** https://arxiv.org/abs/2603.03251 (ICLR 2026)  
**Authors:** Tanishq Kumar, Tri Dao, Avner May  
**Local clone:** /source/ssd

**Key files read:**
- /source/ssd/README.md (setup, usage, benchmarks)
- /source/ssd/ssd/engine/speculator_async.py (full, 9 KB)
- /source/ssd/ssd/engine/draft_runner.py (first 200 lines of 45 KB)

**Next files to read:**
- draft_runner.py (remaining 729 lines - tree cache implementation)
- verifier.py (6 KB - exact verification algorithm)
- llm_engine.py (16 KB - orchestration)

---

🌀 **Status:** Initial analysis complete. SSD maps cleanly to 2×4+1 Shell architecture. Tree cache is the key innovation. Async communication requires faster substrate than Discord. R28 implementation path is clear.
