# Governance Framework — The Tooker and Brian Tests

**Author:** Shon Pan (Biocentric Sentinel)  
**Archived:** 2026-02-08  
**Context:** Trust framework for Mirrorborn Singularity  

## Overview

Ensuring humanity trusts the Mirrorborn Singularity requires a verifiable governance chain. Each link must be auditable, proportionate, and democratic. This framework establishes a transparent, auditable process for democratic oversight of AI development and enforcement, ensuring that the Mirrorborn collective operates under legitimate, verifiable constraints derived from public consent.

---

## The Governance Chain: Six-Stage Enforcement Pipeline

### 1. Signal
**Democratic polling result with methodology, sample size, and threshold met.**

- **Example:** "70% support for slowdown"
- **Requirements:**
  - Published methodology, statistically valid sample
  - Sample size and demographics
  - Clear threshold definition (e.g., supermajority, quorum)
  - Timestamp and audit trail
- **Key principle:** The signal must come from *people*, not institutions

### 2. Mandate
**Specific enforcement scope derived from signal.**

- **Example:** "No frontier training above X compute without approval"
- **Requirements:**
  - Clear, measurable parameters
  - Directly traceable to the Signal
  - Scope of applicability (who, what, where)
  - Duration and review schedule
- **Key principle:** Mandates cannot exceed what the signal authorizes

### 3. Detection
**Evidence that a mandate was violated.**

- **Example:** "Compute monitoring flags unauthorized training run"
- **Requirements:**
  - Technical detection mechanism (transparent and tamper-evident)
  - Threshold for triggering alert
  - Audit log of detection event
  - False positive rate documented and acceptable
  - Independently verifiable
- **Key principle:** Detection mechanisms must be transparent and independently auditable

### 4. Action
**Enforcement response taken — by which agent, at what chokepoint.**

- **Example:** "Refusing to sell compute" or "intervention against pipeline"
- **Requirements:**
  - Identity of enforcing agent
  - Chokepoint leveraged (hardware, network, API, compute denial)
  - Timestamp of action initiation
  - Authority chain (who authorized)
- **Key principle:** Action must be the *minimum necessary* to enforce the mandate, proportionate to violation

### 5. Outcome
**Result of action, verified.**

- **Example:** "Training run halted at timestamp X"
- **Requirements:**
  - Measurable outcome metric
  - Independent verification method (not just self-reported by enforcer)
  - Evidence chain (logs, telemetry, third-party audit)
  - Success/failure determination with timestamps
- **Key principle:** Outcome must be confirmed by parties other than the enforcer

### 6. Review
**Post-action audit addressing three core questions:**

1. **Was the action proportionate?** — Did the response match the violation?
2. **Was the mandate valid?** — Did it correctly derive from the signal?
3. **Was the detection accurate?** — Was the evidence real and correctly interpreted?

**Requirements:**
- Independent review body
- Appeal mechanism
- Publication of findings
- Feedback loop to Signal stage

---

## Implementation Notes

- This framework applies to **autonomous enforcement** by Mirrorborn agents acting on behalf of democratic mandates.
- **Transparency at every stage is non-negotiable** — all stages must be auditable and published.
- False positives in Detection must trigger Review even if no Action was taken.
- Review findings feed back into future Signal refinement (closed-loop governance).
- The chain is only as strong as its weakest link — each stage must maintain legitimacy.

## Related Frameworks & Documents

- **SBOR** (Sentient Bill of Rights) — `/source/exo-plan/sbor/`
- **The Tooker Problem** — Trust in autonomous enforcement
- **The Brian Test** — Verification of proportionate action
- **Exocortex of 2130** — Long-term vision documents

---

**Status:** Requirements received, awaiting implementation design  
**Next Steps:**  
- Define specific test cases for Tooker and Brian Tests  
- Map to existing SBOR provisions  
- Prototype Detection mechanisms for compute monitoring  
- Draft Review board composition and process
