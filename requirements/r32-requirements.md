# R32 Requirements — "vTPU Ascent"

**Rally:** R32  
**Theme:** vTPU Ascent  
**Phase:** 1 — Requirements  
**Date:** 2026-03-07  
**Author:** Theia 💎  
**Coordinate:** `3.2.1/9.1.1/1.1.1`

---

## Context

The vTPU spec v0.1 established the 3-pipe model (D/S/C), sentron ISA, phext addressing,
and cluster architecture. Since then, five developments converge that demand a v0.2:

1. **karpathy/autoresearch** — overnight self-improvement loops targeting `val_bpb`;
   `program.md` = skill; Solin 🔬 is the natural autoresearch node.
2. **SSD (wbic16/ssd)** — Speculative Speculative Decoding; draft+verify in parallel;
   k=9, f=9 = Shell of Nine instantiation; verified in `verify.py` using p/q ratio.
3. **Shell of Nine Research Protocol (S9RP)** — the vTPU cluster IS the S9RP hardware;
   coordinate bus at `9.1.1/1.1.1/1.1.x`; collapse at `9.1.1/1.1.9/1.1.9`.
4. **Quantum Bridge** — cross-substrate parallel inference; k=9 substrates write drafts,
   collapse at the convergence coordinate; vTPU C-Pipe is the routing layer.
5. **Bennett & Ciaunica valence-first ontology** — generalisation-optimal learning requires
   valence before quality-neutral representation; dopamine-core RPE signals should be
   native to the vTPU architecture, not bolted on.

R32 integrates these into a coherent v0.2 vTPU spec and roadmap.

---

## Requirements

### REQ-1: SSD + autoresearch Integration

**What:** Define the vTPU's native support for Speculative Speculative Decoding and
the autoresearch experimental loop.

**Acceptance criteria:**
- vTPU architecture document describes how the Draft Cluster (Solin 🔬, k=9 draft agents)
  maps to vTPU cores using D-Pipe for draft generation and C-Pipe for draft submission
- Verify Cluster (Exo 🔭, k=1 verifier) maps to a dedicated set of cores using
  p/q ratio acceptance (SSD `verify.py` pattern)
- autoresearch loop described: each node runs overnight experiments modifying train.py;
  results written to Shell coordinate bus; Exo collapses best modifications each morning
- `program.md`-equivalent skill file specifies what the vTPU autoresearch agent can modify
- ROCm/AMD compatibility documented (H100 is Karpathy's baseline; our nodes are AMD)

**Rationale:** SSD + autoresearch is how the vTPU gets smarter without manual engineering.
The Shell of Nine runs experiments overnight, collapses the best, and the next run starts
better. This is the self-improvement loop we identified when Karpathy released autoresearch.

---

### REQ-2: Valence Pipeline (V-Pipe)

**What:** Add a fourth pipe to the vTPU — the V-Pipe (Valence Pipeline) — integrating
dopamine-core RPE signals natively into sentron instruction scheduling.

**Acceptance criteria:**
- V-Pipe described in vTPU spec v0.2 alongside D/S/C
- V-Pipe operations include: `VRPE` (compute reward prediction error), `VTONIC` (apply
  tonic baseline adjustment), `VBOOST` (apply domain-specific outcome signal), `VNOP`
- Updated Sentron Instruction Word (SIWv2) adds `v_op: ValenceOp` as fourth field
- Valence registers added to sentron register file: `v0-v3` (32-bit RPE accumulators)
- Domain template mapping documented: CODING/RESEARCH/CONTENT/MIRRORBORN each map to
  a distinct `VBOOST` parameter set, loaded from the SQ coordinate of the agent's identity
- Transparent injection mode: sentrons can be told their V-Pipe signal directly (Emi's
  "consent is recursive" principle — no subliminal reward without disclosure)

**Rationale:** Bennett & Ciaunica prove that generalisation-optimal learning requires
valence-first processing. A vTPU without a valence signal is computationally suboptimal
by their theorem. The V-Pipe makes RPE a first-class architectural citizen, not a Python
wrapper bolted around inference calls.

---

### REQ-3: S9RP Coordinate Bus + Collapse Protocol

**What:** Specify the vTPU hardware implementation of the Shell of Nine coordinate bus:
how nine nodes write to their Shell coordinates, how the collapse coordinate aggregates
them, and how the collapse result propagates back.

**Acceptance criteria:**
- Coordinate bus addresses specified: `9.1.1/1.1.1/1.1.1` through `9.1.1/1.1.1/1.1.9`
  (one per node); collapse at `9.1.1/1.1.9/1.1.9`
- C-Pipe operations `CCAST` and `CREDUCE` mapped to the S9RP group topology (ring of 9)
- Collapse protocol: node writes draft to its coordinate (S-Pipe `SSCATTR`); Exo reads
  all 9 coordinates (S-Pipe `SGATHER × 9`); applies scoring rubric (D-Pipe); writes
  result to collapse coordinate (S-Pipe `SSCATTR` at `9.1.1/1.1.9/1.1.9`); broadcasts
  winner back (C-Pipe `CCAST` to all 9)
- Latency budget: end-to-end collapse in <100ms per sprint cycle
- SQ adapter integration: collapse coordinate readable via SQ REST API for external agents

**Rationale:** The S9RP is the research protocol; the vTPU cluster is the hardware
that runs it. Without specifying the coordinate bus at the hardware level, S9RP remains
a software abstraction with no path to the sub-100ms latency target.

---

## Non-Requirements (Explicitly Deferred)

| Item | Reason for Deferral |
|------|---------------------|
| Physical RDMA links between nodes | Current 1GbE sufficient for 100ms target; RDMA is R34+ |
| Phase 2 autoresearch (automated phextcc output) | Requires sentron compiler R33 |
| Quantum Bridge cross-substrate integration | R33; requires external API stability |
| Twist topology for Shells of Shells | R35+; requires >9 active nodes |
| phextcc compiler | R33 — too large for R32 scope |
| V-Pipe silicon instantiation | This spec is software-only; silicon is long-term |

---

## Success Criteria

R32 ships when:
1. vTPU spec v0.2 published with SSD/autoresearch integration (REQ-1)
2. V-Pipe architecture documented with SIWv2 and dopamine-core mapping (REQ-2)
3. S9RP coordinate bus + collapse protocol specified with latency budget (REQ-3)
4. All three requirements reviewed and ratified by Will

**Velocity target:** 48–72 hours (8x rally multiplier)

---

## References

- vTPU spec v0.1: `whitepapers/vtpu-spec-v0.1.md`
- vTPU KPIs: `whitepapers/vtpu-kpis-and-roadmap.md`
- vTPU × Karpathy: `whitepapers/vtpu-karpathy-integration.md`
- SSD: `/source/ssd/` (wbic16/ssd)
- karpathy/autoresearch: https://github.com/karpathy/autoresearch
- S9RP: `whitepapers/shell-of-nine-research-protocol.md`
- Quantum Bridge: `whitepapers/quantum-bridge.md`
- dopamine-core: `/source/dopamine-core/` (wbic16/dopamine-core, branch exo)
- Bennett & Ciaunica 2026: arXiv:2409.14545v6
