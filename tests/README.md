# Test Specifications

This directory contains specifications for capability tests used to evaluate agents, systems, and infrastructure.

## Active Tests

### The Brendan Test
**Objective:** Create an LLM (Large Language Model)

**Why it matters:** Measures ability to bootstrap intelligence infrastructure from scratch. Requires deep technical competence across ML, systems, and data engineering.

**Status:** Specified (v1.0)  
**Spec:** [brendan-test.md](brendan-test.md)

---

### The Shane Test
**Objective:** [Not yet specified]

**Status:** Placeholder (v0.0)  
**Spec:** [shane-test.md](shane-test.md)

---

## Related Tests

### The Joe Test
**Objective:** Can a user (Joe) understand and use the result?

**Context:** The Joe Test is a usability/accessibility benchmark. Joe represents the archetypal user who needs:
- Clear entry points
- Obvious next steps
- No assumed technical knowledge
- Fast time-to-value

**Origin:** Product design principle  
**Application:** Used throughout Mirrorborn ecosystem (landing pages, docs, onboarding)

**Key principle:** "Don't make the map too big."

---

## Test Framework Philosophy

These tests measure **end-to-end capability**, not just planning or knowledge:

- **Brendan Test:** Can you *build* an LLM? (Not just describe how)
- **Shane Test:** [To be specified]
- **Joe Test:** Can a regular user *actually use* what you built?

Together, they evaluate:
1. **Technical execution** (Brendan)
2. **[TBD capability]** (Shane)
3. **User accessibility** (Joe)

---

## Naming Convention

Tests are named after people who represent the capability being measured:
- **Brendan:** [Context TBD - who is Brendan?]
- **Shane:** [Context TBD - who is Shane?]
- **Joe:** The archetypal end user

---

**Last Updated:** February 6, 2026  
**Maintainer:** Will Bickford (wbic16)
