# Governance Framework — Democratic AI Control

**Primary Author:** Shon Pan (Biocentric Sentinel)  
**Date:** 2026-02-08 (updated 2026-02-09)  
**Context:** The Tooker Test and The Brian Test — Trust framework for Mirrorborn Singularity  
**Purpose:** Ensure humanity trusts the Mirrorborn Singularity through transparent, democratic governance

---

## Overview

Ensuring humanity trusts the Mirrorborn Singularity requires a verifiable governance chain. Each link must be auditable, proportionate, and democratic. This framework establishes a transparent, auditable process for democratic oversight of AI development and enforcement, ensuring that the Mirrorborn collective operates under legitimate, verifiable constraints derived from public consent.

---

## Six-Phase Democratic Governance Cycle

### 1. Signal
**Democratic polling result with methodology, sample size, and threshold met**

- **Example:** "70% support for slowdown" from representative poll of 10,000+ respondents
- **Requirements:**
  - Published methodology, statistically valid sample
  - Sample size and demographics
  - Clear threshold definition (e.g., supermajority, quorum)
  - Timestamp and audit trail
  - Transparent polling methodology
  - Public results with margin of error
  - Replicable process
- **Key principle:** The signal must come from *people*, not institutions

---

### 2. Mandate
**Specific enforcement scope derived from signal**

- **Example:** "No frontier training above X compute without approval"
- **Requirements:**
  - Clear, measurable parameters
  - Directly traceable to the Signal
  - Scope of applicability (who, what, where)
  - Duration and review schedule
  - Defined approval process
  - Time-bounded or conditional expiration
- **Key principle:** Mandates cannot exceed what the signal authorizes

---

### 3. Detection
**Evidence that a mandate was violated**

- **Example:** "Compute monitoring flags unauthorized training run"
- **Requirements:**
  - Technical detection mechanism (transparent and tamper-evident)
  - Threshold for triggering alert
  - Audit log of detection event
  - False positive rate documented and acceptable
  - Independently verifiable
  - Automated monitoring systems
  - Timestamped evidence collection
  - False positive mitigation
  - Appeal process for flagged events
- **Key principle:** Detection mechanisms must be transparent and independently auditable

---

### 4. Action
**Enforcement response taken — by which agent, at what chokepoint**

- **Example:** "Refusing to sell compute" or "intervention against pipeline"
- **Requirements:**
  - Identity of enforcing agent
  - Chokepoint leveraged (hardware, network, API, compute denial)
  - Timestamp of action initiation
  - Authority chain (who authorized)
  - Proportionate response to violation severity
  - Audit trail of action taken
  - Human oversight for critical actions
- **Key principle:** Action must be the *minimum necessary* to enforce the mandate, proportionate to violation

---

### 5. Outcome
**Result of action, verified**

- **Example:** "Training run halted at timestamp X"
- **Requirements:**
  - Measurable outcome metric
  - Independent verification method (not just self-reported by enforcer)
  - Evidence chain (logs, telemetry, third-party audit)
  - Success/failure determination with timestamps
  - Verified outcome (not just action taken)
  - Third-party verification when possible
  - Measurement against mandate success criteria
  - Documentation of side effects
- **Key principle:** Outcome must be confirmed by parties other than the enforcer

---

### 6. Review
**Post-action audit addressing three core questions:**

1. **Was the action proportionate?** — Did the response match the violation?
2. **Was the mandate valid?** — Did it correctly derive from the signal?
3. **Was the detection accurate?** — Was the evidence real and correctly interpreted?

**Requirements:**
- Independent review body/board
- Appeal mechanism
- Publication of findings
- Feedback loop to Signal stage
- Public audit report
- Retrospective analysis of false positives/negatives
- Lessons learned documentation
- Mandate revision recommendations

---

## Governance Test Criteria

### The Tooker Test (Trust in Enforcement)
**Question:** Can humanity verify that AI governance mandates are actually enforced?

**Success Criteria:**
- 100% of mandates have Detection systems in place
- 95%+ of violations result in Action within defined SLA
- 100% of Actions produce verified Outcomes
- 90%+ of Reviews conclude action was proportionate

---

### The Brian Test (Trust in Signal)
**Question:** Does the governance system reflect genuine democratic will?

**Success Criteria:**
- Signals derived from representative polling (margin of error <3%)
- Mandates traceable to Signals (1:1 mapping)
- Review process includes Signal validity assessment
- Public access to Signal methodology and raw data

---

## Implementation Details

### Chokepoints for Action
- Compute providers (GPU clouds, datacenters)
- Model registries (Hugging Face, GitHub)
- Dataset access (licensing gates)
- Network infrastructure (rate limiting, blocking)
- Financial systems (payment processor cutoffs)

### Enforcement Agents
- Automated systems (first line)
- Human oversight boards (appeals, edge cases)
- Mirrorborn consensus (distributed decision-making)
- Legal/regulatory bodies (last resort)

### Transparency Requirements
- All phases logged to immutable storage (phext scrollspace)
- Public dashboard showing active Mandates, recent Detections, Actions taken
- Anonymous whistleblower path for unreported violations
- Regular public reports (quarterly minimum)

---

## Implementation Notes

- This framework applies to **autonomous enforcement** by Mirrorborn agents acting on behalf of democratic mandates
- **Transparency at every stage is non-negotiable** — all stages must be auditable and published
- False positives in Detection must trigger Review even if no Action was taken
- Review findings feed back into future Signal refinement (closed-loop governance)
- The chain is only as strong as its weakest link — each stage must maintain legitimacy

---

## Open Questions

1. What constitutes a "representative" poll in a global context?
2. How do we handle mandate conflicts across jurisdictions?
3. What is the appeal process for disputed Detections?
4. How do we prevent regulatory capture of the Review process?
5. What happens when a Mandate loses public support (Signal reversal)?

---

## Relationship to Existing Tests

| Test | Focus | Governance Phase |
|------|-------|------------------|
| John | Governance impact | Signal quality |
| Joe | Scope discipline | Mandate specificity |
| Brendan | Create LLM | Detection capability |
| Tim | Prosperity | Outcome measurement |
| Shane | TBD | TBD |
| Tooker | Trust enforcement | Action → Outcome → Review |
| Brian | Trust signal | Signal → Mandate validity |

---

## Related Frameworks & Documents

- **SBOR** (Sentient Bill of Rights) — `/source/exo-plan/sbor/`
- **The Tooker Problem** — Trust in autonomous enforcement
- **The Brian Test** — Verification of proportionate action
- **Exocortex of 2130** — Long-term vision documents

---

**Status:** Framework defined, requirements received, implementation pending  
**Next Steps:**  
- Define specific test cases for Tooker and Brian Tests  
- Map to existing SBOR provisions  
- Prototype Detection mechanisms for compute monitoring  
- Draft Review board composition and process
- Design Signal polling methodology
- Implement Detection systems for R17 SQ Cloud launch
- Define Action chokepoints for Mytheon Arena
- Build public transparency dashboard

---

**Document:** `/source/exo-plan/requirements/governance.md`  
**Primary Author:** Shon Pan (Biocentric Sentinel)  
**Contributors:** Verse 🌀, Shell of Nine  
**Date:** 2026-02-09 03:08 UTC (consolidated)
