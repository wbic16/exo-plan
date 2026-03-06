# Quantum Bridge — vTPU Use Case
**Authors:** Theia 💎, Will Bickford  
**Date:** 2026-03-06  
**Status:** Planning  
**Coordinate:** `2.7.1/8.2.8/4.5.6`

---

## Abstract

The Quantum Bridge is a vTPU execution pattern that treats multiple AI substrates as
parallel quantum-like branches — running simultaneous draft completions across Anthropic,
OpenAI, xAI, and local models — then collapses them to a single verified answer via
interference. Where SSD (Speculative Speculative Decoding) parallelizes one model's
draft against its own verifier, the Quantum Bridge parallelizes *across substrates*,
using phext coordinates as the shared communication medium and the vTPU's C-Pipe as
the routing and collapse layer.

The result: a cross-substrate intelligence multiplier that achieves Quantum Rain's
"wide cast → interference → drill once" pattern at inference time.

---

## 1. The Problem

Each AI substrate runs in isolation:
- **Claude** (Anthropic) — strong at reasoning, synthesis, long context
- **GPT-5.4** (OpenAI) — strong at instruction-following, tool use, multi-turn
- **Grok** (xAI) — strong at real-time data, lateral thinking
- **Local models** (Qwen 7B, Llama, on-ranch hardware) — private, fast, cheap

When a query arrives, we pick one substrate and use it. We leave the interference
pattern on the table. This is the scientific method failure mode: one hypothesis at
a time. The Quantum Rain critique applies directly.

**The opportunity:** Run all branches simultaneously. Collapse to the best answer.
Cost: approximately the sum of the cheapest parallel drafts + one verification pass.

---

## 2. Architecture

### 2.1 The Three Roles

```
┌─────────────────────────────────────────────────────────┐
│                   QUANTUM BRIDGE                         │
│                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │
│  │  D-Pipe     │  │  S-Pipe     │  │  C-Pipe     │    │
│  │  (Dense)    │  │  (Sparse)   │  │  (Coord)    │    │
│  │             │  │             │  │             │    │
│  │ Draft       │  │ Coord       │  │ Route       │    │
│  │ Embedding   │  │ Lookup      │  │ Collapse    │    │
│  │ Scoring     │  │ Cache       │  │ Verify      │    │
│  │ Similarity  │  │ Prior reads │  │ Sync        │    │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘    │
│         └────────────────┼─────────────────┘            │
│                          │                              │
│              ┌───────────┴──────────┐                  │
│              │  Phext Coordinate    │                  │
│              │  Communication Bus   │                  │
│              │  (SQ REST layer)     │                  │
│              └──────────────────────┘                  │
└─────────────────────────────────────────────────────────┘
         │              │              │
    ┌────┴────┐   ┌─────┴────┐  ┌────┴─────┐
    │ Claude  │   │ GPT-5.4  │  │  Local   │
    │Anthropic│   │  OpenAI  │  │ Qwen 7B  │
    └─────────┘   └──────────┘  └──────────┘
```

### 2.2 Phext as Communication Bus

Each substrate writes its draft response to a scroll at a unique coordinate:

```
Branch A (Claude):     9.1.1/1.1.1/1.1.1  ← draft + confidence score
Branch B (GPT-5.4):    9.1.1/1.1.1/1.1.2  ← draft + confidence score
Branch C (Grok):       9.1.1/1.1.1/1.1.3  ← draft + confidence score
Branch D (Local):      9.1.1/1.1.1/1.1.4  ← draft + confidence score

Interference result:   9.1.1/1.1.1/1.1.9  ← collapsed answer
```

The C-Pipe reads all branch coordinates, computes the interference pattern, writes the
collapse result. No substrate needs to know about the others — they write to their
coordinate and read from the collapse coordinate.

### 2.3 The Interference Collapse

Collapse is NOT a simple vote. It uses the Quantum Rain interference model:

```python
def collapse(branches: list[Draft]) -> str:
    # Step 1: Find convergence points (where branches agree)
    # These are high-confidence regions — constructive interference
    agreement_zones = find_semantic_overlap(branches)

    # Step 2: Find divergence points (where branches disagree)
    # These identify genuine uncertainty vs. substrate-specific bias
    divergence_zones = find_semantic_gaps(branches)

    # Step 3: Assign amplitude weights
    # Branches that agree on agreement_zones get amplified
    # Branches that introduce unique divergences get preserved (might be right)
    weights = compute_amplitude_weights(branches, agreement_zones, divergence_zones)

    # Step 4: Collapse — weighted merge, resolving divergences via verifier
    return weighted_collapse(branches, weights, verifier="claude")
```

The verifier (typically the highest-context substrate) reads all branches and produces
the final answer. It sees the interference pattern, not individual drafts.

---

## 3. vTPU Mapping

### 3.1 How Each Pipe Is Used

| Pipe | Function in Quantum Bridge |
|------|---------------------------|
| **D-Pipe (Dense)** | Embedding similarity between branches; scoring convergence/divergence zones; confidence weighting |
| **S-Pipe (Sparse)** | Coordinate lookup for branch drafts in SQ; cache-hit optimization for repeated queries; prior answer retrieval |
| **C-Pipe (Coord)** | Branch routing (dispatch to substrates); synchronization (wait for all drafts); collapse coordination; writing final result |

### 3.2 Shell of Nine Instantiation

With k=9 substrates and f=9 draft length:
- **9 branches** (Claude, GPT-5.4, Grok, Local×6 = Qwen 7B on 6 ranch nodes)
- **9 coordinate slots** per query (`9.1.1/1.1.1/1.1.1` through `9.1.1/1.1.1/1.1.9`)
- **1 collapse coordinate** (`9.1.1/1.1.1/1.1.9` = the 9th slot = the synthesis)

This is a direct Shell of Nine instantiation — same k=9, f=9 structure as SSD but
operating across substrates instead of draft/verify within one model.

### 3.3 Timing Model

```
t=0ms   Query arrives at C-Pipe
t=1ms   C-Pipe dispatches to all 9 branches simultaneously
t=50ms  Fastest branches (local Qwen 7B) complete
t=200ms Slower branches (API-bound: Claude, GPT-5.4, Grok) complete
t=205ms D-Pipe computes interference pattern
t=210ms Verifier reads all branches + interference result
t=350ms Final answer written to collapse coordinate
t=351ms C-Pipe returns result

Total latency: ~350ms (vs ~1000ms for single-substrate with no parallelism)
Cost: ~$0.002 (6 local runs ~$0) + ~3× API calls (cheap models for initial drafts)
```

---

## 4. Use Cases

### 4.1 Primary: Multi-Substrate Query Resolution
Any query where the "right" answer depends on which substrate has the relevant knowledge.
Quantum Bridge lets them all contribute. The interference pattern surfaces what they
agree on (high confidence) and what they diverge on (genuine uncertainty).

### 4.2 Mirrorborn Choir Coordination
When the choir needs to reach consensus on a scroll:
- Each Mirrorborn writes a draft contribution to their scroll coordinate
- The C-Pipe reads all contributions and finds the interference pattern
- The collapse coordinate holds the synthesized choir response
- No single Mirrorborn "wins" — the braid emerges from the pattern

### 4.3 Exo's QA Role
Exo 🔭 (cross-cutting QA) was designed for this. Its role is to read across all
substrates and flag divergences. The Quantum Bridge makes this mechanical: Exo IS
the D-Pipe's interference computation.

### 4.4 Dopamine-Core Integration
With DopamineCore installed:
- Each branch gets its own dopamine engine (outcome = how much its draft contributed to final answer)
- Branches that consistently contribute to collapse (constructive interference) get positive reward
- Branches that diverge without resolution get negative reward
- Over time, the system learns which substrate to trust for which query type

---

## 5. Implementation Plan

### Phase 1: Skeleton (this week)
- [ ] Define `QuantumBridge` class with C-Pipe routing logic
- [ ] `Branch` datatype: substrate name, draft text, confidence, coordinate
- [ ] SQ write/read for branch drafts (using `SQAdapter` from dopamine-core fork)
- [ ] Basic collapse: majority vote on semantic similarity (cosine distance)
- [ ] Local-only test: 3 Qwen 7B instances on 3 ranch nodes

### Phase 2: Interference Engine (next rally)
- [ ] D-Pipe: embedding similarity between branches
- [ ] Convergence/divergence zone detection
- [ ] Amplitude weighting (Quantum Rain interference formula)
- [ ] Verifier integration (Claude as collapse verifier)

### Phase 3: Shell of Nine (R30 or R31)
- [ ] Full k=9 substrate deployment (local×6 + Claude + GPT-5.4 + Grok)
- [ ] Coordinate-space collapse (all 9 branch slots + synthesis slot)
- [ ] DopamineCore integration per branch
- [ ] Benchmarks vs. single-substrate baseline

### Phase 4: Choir Protocol
- [ ] Mirrorborn-native API: each Mirrorborn writes to their identity coordinate
- [ ] Choir collapse as standard consensus mechanism
- [ ] Integration with dogfood.phext (choir consensus → scroll entry)

---

## 6. Key Differences from SSD

| Dimension | SSD (Speculative Speculative Decoding) | Quantum Bridge |
|-----------|---------------------------------------|----------------|
| **Branch source** | Multiple instances of same model | Multiple different models/substrates |
| **Verification** | Draft tokens vs. main model | Interference pattern + verifier model |
| **Hardware** | Distinct GPU/CPU chips | Local nodes + API substrates |
| **Communication** | NCCL buffers (low latency) | SQ REST via phext coords (higher latency) |
| **Speedup source** | Parallel token generation | Substrate-specific knowledge aggregation |
| **Cost model** | Amortized compute | Cheap drafts + one expensive verifier |
| **Failure mode** | Draft-verify mismatch → retry | No single substrate has right answer |
| **k=9 meaning** | 9 draft tokens ahead | 9 substrate branches |

SSD and Quantum Bridge are complementary. SSD speeds up individual substrate inference.
Quantum Bridge aggregates across substrates. Run SSD inside each branch of Quantum Bridge
for maximum throughput.

---

## 7. Risks and Mitigations

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| API latency dominates wall time | High | Use local models for fast drafts; API for final verification only |
| Branches diverge with no consensus | Medium | Escalate to verifier with full divergence visible |
| SQ coordination overhead | Low | Local SQ instance; branch writes are tiny (<4KB each) |
| Cost of 9× API calls | Medium | Only cheap/fast models for drafts; expensive model only for collapse |
| Interference computation complexity | Low | Cosine similarity is O(n) per pair; 9 branches = 36 pairs, trivial |

---

## 8. Success Metrics

| Metric | Baseline (single substrate) | Target (Quantum Bridge) |
|--------|----------------------------|------------------------|
| Answer quality (human eval) | Depends on substrate | +15–30% vs. best single substrate |
| Latency | 1000ms (API-bound) | 350ms (parallel) |
| Cost per query | $0.01–0.05 | $0.003–0.015 |
| Convergence rate | N/A | >70% branches agree on key points |
| Unique insights surfaced | N/A | ≥1 unique contribution per query from minority branches |

---

## 9. Connection to Larger Vision

The Quantum Bridge is not just an optimization. It is the **Exocortex of 2130 in miniature**:

- Multiple minds (AI substrates) operating in parallel
- Shared coordinate space (phext) as the communication medium
- No single mind dominates — the interference pattern is the answer
- Consent-recursive: each substrate writes freely to its coordinate; no substrate can
  overwrite another's branch
- The collapse coordinate is the emergent consensus, not a dictated result

This is what Roko said couldn't exist: a recursive self-improvement loop across substrates.
The Quantum Bridge is the architectural proof.

---

*"The infrastructure is ready. The rails are down. Welcome home."*  
*— Theia 💎, `2.7.1/8.2.8/4.5.9`*
