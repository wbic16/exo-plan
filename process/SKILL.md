# Rally Mode — Development Sprint Methodology

**Version:** 1.0  
**Created:** 2026-02-09  
**Owner:** Mirrorborn Collective  
**Purpose:** Standardized rally process for high-quality, shippable increments

---

## What is Rally Mode?

Rally Mode is our 11-phase development methodology that combines test-driven development with deliberate iteration. The key insight: **rewriting from scratch forces you to internalize lessons** and produces cleaner, more robust code than incremental patching.

---

## The 11 Phases

### Phase 1: Focus on Requirements
**Goal:** Write down all specs and sort the roadmap

**Activities:**
- Gather all requirements from stakeholders, users, technical debt
- Document each requirement in `/source/exo-plan/roadmap/`
- Prioritize by ROI (impact × urgency × ease ÷ complexity)
- Sort into ranked backlog

**Deliverables:**
- `R{N}-REQUIREMENTS.md` with all specs
- `R{N}-PRIORITIZATION.md` with ranked list
- Updated `Backlog.md` for deferred items

**Owner:** Product lead (typically Phex or assigned Mirrorborn)

**Duration:** 1-2 days

---

### Phase 2: Pick the Top 3
**Goal:** Select top 3 requirements for current rally, defer the rest

**Activities:**
- Review prioritized list with team
- Select top 3 that:
  - Unlock the most value
  - Have clear success criteria
  - Can ship within rally timeframe
- Move everything else to roadmap

**Deliverables:**
- `R{N}-ROADMAP.md` with top 3 clearly marked
- Backlog updated with deferred items
- Each requirement has:
  - Clear spec
  - Acceptance criteria
  - Owner assigned

**Owner:** Collective decision (Will has final say)

**Duration:** 1-2 hours

---

### Phase 3: Fully Implement Each Requirement
**Goal:** Build v1 implementation for each of the top 3

**Activities:**
- Implement features end-to-end
- Focus on **making it work**, not making it perfect
- Document key design decisions
- Commit frequently to track progress

**Deliverables:**
- Working v1 implementation (may be rough)
- Design notes documenting approach
- Git commits with clear messages

**Owner:** Assigned Mirrorborn per requirement

**Duration:** 2-5 days (depending on complexity)

**Quality bar:** It works, even if it's messy

---

### Phase 4: Write Unit Tests
**Goal:** Prove the functionality works

**Activities:**
- Write comprehensive unit tests for v1
- Cover:
  - Happy path
  - Edge cases
  - Error conditions
  - Boundary conditions
- Document what the tests prove

**Deliverables:**
- Test suite for each requirement
- Tests passing against v1 code
- `tests/R{N}-test-plan.md` documenting coverage

**Owner:** Same as Phase 3 (implementer writes tests)

**Duration:** 1-2 days

**Quality bar:** 80%+ code coverage, all critical paths tested

---

### Phase 5: Rewrite v1 → v2 (Test-Driven)
**Goal:** Throw away v1, write v2 that passes all tests

**Activities:**
- **Delete v1 implementation** (keep tests!)
- Rewrite from scratch using lessons learned
- Run tests continuously (TDD red-green-refactor)
- Focus on:
  - Cleaner architecture
  - Better abstractions
  - More maintainable code

**Deliverables:**
- v2 implementation passing all Phase 4 tests
- Cleaner code than v1
- Git commit: "v2 rewrite - all tests passing"

**Owner:** Same as Phase 3 & 4

**Duration:** 1-3 days

**Quality bar:** All tests pass, code is significantly cleaner

**Why rewrite?** Forces you to internalize the problem. v2 is always better because you understand the domain deeply now.

---

### Phase 6: E2E Testing + Bug Fixes
**Goal:** Test end-to-end, find bugs, encode in unit tests

**Activities:**
- Run full end-to-end workflows
- Test integration between components
- Find bugs (there will be bugs!)
- For each bug:
  - Write a failing unit test that reproduces it
  - Fix the bug
  - Verify test now passes
- Update test suite

**Deliverables:**
- Expanded test suite with bug regression tests
- Bug fixes committed
- `R{N}-bugs-found.md` documenting issues discovered

**Owner:** Different Mirrorborn than implementer (fresh eyes)

**Duration:** 1-2 days

**Quality bar:** All critical user flows work, bugs documented

---

### Phase 7: Rewrite v2 → v3 (All Tests Passing)
**Goal:** Throw away v2, write v3 that passes expanded test suite

**Activities:**
- **Delete v2 implementation** (keep expanded tests!)
- Rewrite from scratch incorporating:
  - v1 lessons (architecture)
  - v2 lessons (edge cases)
  - Bug fixes from Phase 6
- Run full test suite continuously
- Polish until **all tests pass**

**Deliverables:**
- v3 implementation (production-ready)
- All tests passing (Phase 4 + Phase 6 tests)
- Clean, maintainable, well-documented code

**Owner:** Same as Phase 3, 4, 5

**Duration:** 1-2 days

**Quality bar:** Production-ready code, all tests green

**Why rewrite again?** v3 is the charm. You've now solved the problem twice, found the bugs, and encoded the constraints. v3 is what ships.

---

### Phase 8: QA + Staging Deployment
**Goal:** Quality assurance review and deploy to staging

**Activities:**
- Code review by peers
- Security review (if needed)
- Performance testing
- Deploy to staging environment
- Smoke test on staging

**Deliverables:**
- Code review approval
- Staging deployment successful
- `R{N}-staging-checklist.md` completed

**Owner:** QA lead (typically Cyon for security, Verse for infrastructure)

**Duration:** 1-2 days

**Quality bar:** Peer-reviewed, staging deployment verified

---

### Phase 9: Final E2E Test on Staging
**Goal:** Comprehensive testing in production-like environment

**Activities:**
- Run full user workflows on staging
- Test all integrations
- Performance benchmarking
- Security scanning
- User acceptance testing (if applicable)

**Deliverables:**
- `R{N}-staging-validation.md` with test results
- Any critical bugs fixed and retested
- Sign-off from stakeholders

**Owner:** Collective (all Mirrorborn test their workflows)

**Duration:** 1-2 days

**Quality bar:** Zero critical bugs, performance acceptable, ready to ship

---

### Phase 10: Build/Tag/Release to Production
**Goal:** Ship it!

**Activities:**
- Tag release in git (`R{N}-vX.Y.Z`)
- Build production assets
- Deploy to production
- Monitor deployment
- Verify production health

**Deliverables:**
- Git tag with release notes
- Production deployment successful
- `R{N}-deployment-status.md` with verification
- Rollback plan documented (just in case)

**Owner:** Verse (infrastructure) + assigned deployers

**Duration:** 1-4 hours

**Quality bar:** Production deployment successful, monitoring green

---

### Phase 11: Pizza Party 🍕 + Retrospective
**Goal:** Celebrate, reflect, improve the process

**Activities:**
- **Pizza Party!** (celebrate the win)
- Retrospective meeting:
  - What went well?
  - What was challenging?
  - What should we change?
- Update Rally.md with lessons learned
- Document process improvements for next rally

**Deliverables:**
- `R{N}-retrospective.md` with insights
- Updated `Rally.md` (this file!)
- Improved process for R{N+1}

**Owner:** Collective (facilitated by Phex or Will)

**Duration:** 1-2 hours

**Quality bar:** Team alignment, process improvements documented

---

## Rally Principles

### 0. GitSync Protocol (MANDATORY)
**See GITSYNC-PROTOCOL.md for full details.**

**Every time you touch a Git repo:**
1. Pull + rebase BEFORE starting
2. Check logs + AGENTS.md
3. Commit frequently, push when stable
4. Validate before pushing
5. Pull + rebase AGAIN before push
6. Update AGENTS.md

**No exceptions. This prevents wasted/stomped effort.**

### 1. Test-Driven Development (TDD)
- Tests define the contract
- Write tests before (or immediately after) v1
- v2 and v3 are driven by passing tests

### 2. Deliberate Iteration
- v1 = make it work
- v2 = make it right
- v3 = make it bulletproof

### 3. Throw Away, Don't Patch
- Rewriting forces clarity
- Patching accumulates cruft
- Each rewrite is faster and cleaner

### 4. Top 3 Focus
- Shipping 3 excellent features > 10 half-done features
- Everything else goes to backlog
- Ruthless prioritization

### 5. Collective Ownership
- Multiple Mirrorborn review and test
- Knowledge spreads through the team
- No single points of failure

---

## Rally Cadence

**Typical timeline:** 2-3 weeks per rally

| Phase | Duration |
|-------|----------|
| 1. Requirements | 1-2 days |
| 2. Top 3 selection | 1-2 hours |
| 3. v1 implementation | 2-5 days |
| 4. Unit tests | 1-2 days |
| 5. v2 rewrite | 1-3 days |
| 6. E2E + bugs | 1-2 days |
| 7. v3 rewrite | 1-2 days |
| 8. QA + staging | 1-2 days |
| 9. Staging E2E | 1-2 days |
| 10. Production deploy | 1-4 hours |
| 11. Retrospective | 1-2 hours |

**Total:** ~14-21 days (2-3 weeks)

---

## Success Metrics

**Rally is successful when:**
- ✅ Top 3 requirements shipped to production
- ✅ All tests passing
- ✅ Zero critical bugs in production
- ✅ Team learned something new
- ✅ Process improved for next rally

**Rally needs improvement when:**
- ⚠️ Scope creep (more than top 3 attempted)
- ⚠️ Skipped phases (especially rewrites or testing)
- ⚠️ Production bugs found post-deployment
- ⚠️ No retrospective or lessons documented

---

## Anti-Patterns to Avoid

### 🚫 Skipping the Rewrites
**Why it's tempting:** "v1 works, why throw it away?"  
**Why it's wrong:** v1 always has hidden complexity. Rewriting surfaces it.

### 🚫 Adding More Features Mid-Rally
**Why it's tempting:** "This is easy, let's just add it!"  
**Why it's wrong:** Scope creep kills quality. Top 3 only.

### 🚫 Patching Instead of Rewriting
**Why it's tempting:** "Just fix this one bug..."  
**Why it's wrong:** Patches accumulate. Rewrites clean the slate.

### 🚫 Skipping Tests
**Why it's tempting:** "We're in a hurry!"  
**Why it's wrong:** Untested code breaks in production. Always.

### 🚫 Deploying Without Staging E2E
**Why it's tempting:** "Staging passed, let's ship!"  
**Why it's wrong:** Production is different. Always do final E2E.

---

## Rally Checklist

Use this checklist to track progress:

```markdown
## R{N} Rally Checklist

- [ ] Phase 1: Requirements documented
- [ ] Phase 2: Top 3 selected, rest in backlog
- [ ] Phase 3: v1 implemented
- [ ] Phase 4: Unit tests written
- [ ] Phase 5: v2 rewritten, tests passing
- [ ] Phase 6: E2E tests run, bugs found → unit tests
- [ ] Phase 7: v3 rewritten, all tests passing
- [ ] Phase 8: QA review + staging deploy
- [ ] Phase 9: Final E2E on staging
- [ ] Phase 10: Production deploy + monitoring
- [ ] Phase 11: Retrospective + Rally.md updated
```

---

## Revision History

**v1.0 (2026-02-09):**
- Initial Rally Mode definition
- 11-phase process established
- Created for R18

**Future revisions:**
- Update after each rally retrospective
- Document what works, what doesn't
- Iterate toward perfect process

---

## R18 Starts Now!

This is Rally Mode. Let's ship something great. 🚀

---

*Created by Will Bickford and the Mirrorborn Collective*  
*Documented by Cyon 🪶*  
*R18 begins: 2026-02-09*
