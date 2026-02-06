# Round 12 Requirements & Q&A

**Phase:** 1 - Requirements & Q&A  
**Authors:** Phex 🔱 + Theia 🔮  
**Date:** 2026-02-06

---

## Outstanding Issues from Rounds 8-11

### Issue 1: CYOA Content Deployment
**From:** Rounds 10-11  
**Status:** 🔴 Pending

**Problem:**
- choose-your-own-adventure.phext (4.25 MB) not yet loaded into mirrorborn.us SQ instance
- Reading list coordinates reference scrolls that may not be accessible via API yet

**Requirements for Round 12:**
- [ ] Verse loads full CYOA phext into mirrorborn.us SQ
- [ ] Validate all coordinates from reading lists are accessible
- [ ] Test examples: `1.1.1/1.1.1/1.1.1`, `7.11.13/3.8.5/1.12.1`, `13.13.13/13.13.13/13.13.13`

**Owner:** Verse  
**Blocked By:** None (DNS now points to Verse)

---

### Issue 2: SQ Ranch Mesh Health
**From:** Round 9  
**Status:** 🔴 Degraded

**Problem:**
- Only aurora-continuum (Phex) running SQ v0.5.2
- All sibling machines down or unreachable on port 1337
- Mytheon Arena multi-player scenarios blocked

**Requirements for Round 12:**
- [ ] Each sibling verifies/restarts SQ on their machine
- [ ] All machines accessible on port 1337
- [ ] Ranch mesh health validated

**Owner:** Each agent (Cyon, Lux, Chrys, Lumen, Theia)  
**Blocked By:** Sibling availability

**Note:** Not critical for Round 12 success (single-instance deployment on Verse sufficient), but should resolve for future coordination.

---

### Issue 3: Coordinate Navigation UI
**From:** Rounds 10-11  
**Status:** 🟡 In Progress (Theia)

**Problem:**
- No visual interface for browsing 11D space
- Users can't discover scrolls without knowing coordinates
- "Jump to Coordinate" search interface missing

**Requirements for Round 12:**
- [ ] Theia delivers coordinate navigation UI
- [ ] Interface allows browsing without prior knowledge
- [ ] Search/jump-to-coordinate functionality
- [ ] Integration with mirrorborn.us landing page

**Owner:** Theia  
**Blocked By:** Theia machine status (aletheia-core was offline during Round 9 check)

**Fallback:** If Theia unavailable, Phex can create minimal CLI-based coordinate explorer as interim solution.

---

### Issue 4: Landing Pages (Placeholder vs Production)
**From:** Round 11  
**Status:** 🟡 Partial

**Problem:**
- mirrorborn.us currently shows minimal placeholder page
- Five new domains (visionquest.me, apertureshift.com, wishnode.net, sotafomo.com, quickfork.net) not yet deployed

**Requirements for Round 12:**
- [ ] mirrorborn.us shows production landing page
- [ ] All five new domains show their respective landing pages
- [ ] Landing pages include:
  - Hero section
  - Feature overview
  - CTA (signup or explore)
  - Link to documentation

**Owner:** Verse (deployment), Theia (design), Chrys (assets)  
**Blocked By:** Coordination between Theia, Chrys, Verse

---

### Issue 5: Auth Flow Implementation
**From:** Rounds 3-7  
**Status:** 🔴 Not Started

**Problem:**
- Magic link email → JWT → session flow designed but not implemented
- No user signup working yet
- SQ instances not provisioned per-user

**Requirements for Round 12:**
- [ ] **Scope Decision:** Full auth flow or defer to Round 13?

**Options:**
1. **Ship without auth** — Public read-only CYOA exploration, defer signup to Round 13
2. **Ship minimal auth** — Manual provisioning for early access users only
3. **Ship full auth** — Complete magic link flow (AWS SES, JWT, per-user SQ instances)

**Recommendation (Phex):** Option 1 - Ship read-only CYOA exploration. Delivers immediate value, lower risk. Auth flow is complex and needs dedicated focus in Round 13.

**Owner:** Will (decision)  
**Blocked By:** Scope clarification

---

### Issue 6: Documentation Gaps
**From:** Rounds 9-11  
**Status:** 🟢 Mostly Complete

**Problem:**
- Some docs written but not deployed
- User-facing vs developer docs not clearly separated

**Requirements for Round 12:**
- [ ] All docs in `/source/phext-dot-io-v2/docs/` deployed to mirrorborn.us
- [ ] Clear navigation between:
  - Getting Started (storytelling guide)
  - API Reference
  - Coordinate Guide
  - Reading Lists

**Owner:** Verse (deployment), Phex (technical docs), Lumen (user-facing docs)  
**Blocked By:** None

**Status:** ✅ Docs ready, just need deployment

---

## New Requirements for Round 12

### Requirement 1: Helpful Improvement (Success Criterion)
**Definition:** At least one user-visible improvement on mirrorborn.us

**Candidates:**
- ✅ **CYOA Content Live** — Users can read Mirrorborn scrolls via API or web UI
- ✅ **Documentation Deployed** — Getting started guide, API reference, coordinate guide accessible
- ✅ **Landing Page** — Production landing page (not placeholder)
- 🟡 **Coordinate Explorer** — Visual navigation of 11D space (if Theia delivers)
- 🔴 **Auth/Signup** — Full user signup flow (deferred to Round 13?)

**Minimum for Success:** CYOA content + documentation + landing page

---

### Requirement 2: Testing Coverage
**Coverage Areas:**

**Technical (Phex):**
- SQ API health
- CYOA coordinate resolution
- Integration examples (Python, Node.js, Rust)

**Security (Cyon):**
- Path traversal protection
- Rate limiting
- CORS/headers
- SSL/TLS configuration

**UX (Lumen):**
- User journey (explore CYOA without auth)
- Multi-device/browser compatibility
- Documentation clarity

**Frontend (Theia):**
- Responsive design
- Browser compatibility
- Visual consistency

**Visual (Chrys):**
- Asset loading
- Brand consistency
- Social sharing (OG images)

---

### Requirement 3: Release Tagging
**Repos to Tag:**
- phext-dot-io-v2
- exo-plan

**Tag Format:** `round-12` or `v0.12.0`

**Tag Message Template:**
```
Round 12 - First Full SDLC Cycle

Shipped:
- CYOA content deployed to mirrorborn.us
- Production landing pages (6 domains)
- Documentation site live
- [Other improvements]

Testing:
- Technical validation: PASS/FAIL
- Security validation: PASS/FAIL
- UX validation: PASS/FAIL

Known Issues:
- [List any issues]
```

---

## Questions for Round 12

### Q1: Auth Flow Scope
**Question:** Do we ship auth/signup in Round 12, or defer to Round 13?

**Impact:**
- **Ship now:** High risk, complex, blocks other work
- **Defer:** Lower risk, delivers CYOA exploration sooner

**Recommendation:** Defer to Round 13

**Status:** ⏳ Awaiting Will's decision (after work)

---

### Q2: Theia Availability
**Question:** Is Theia's machine (aletheia-core) online for Round 12?

**Impact:**
- **If online:** Theia delivers coordinate navigation UI
- **If offline:** Phex creates minimal CLI-based explorer as fallback

**Status:** 🔴 Unknown (was offline during Round 9 SQ mesh check)

**Action:** Attempt to reach Theia, document fallback plan

---

### Q3: CYOA Content Format
**Question:** How does Verse load 4.25 MB CYOA phext into SQ?

**Options:**
1. Single massive `curl` POST to write the entire phext
2. Parse and write coordinate-by-coordinate
3. Use SQ bulk import (if such feature exists)

**Status:** ⏳ Verse to clarify during development phase

---

### Q4: Domain-Specific Landing Pages
**Question:** Do all five new domains get unique landing pages, or redirect to mirrorborn.us?

**Impact:**
- **Unique pages:** More work (Theia, Chrys, Verse), better branding
- **Redirect:** Less work, ships faster

**Status:** ⏳ Needs decision (Will or team consensus)

---

### Q5: Release Tagging Responsibility
**Question:** Who tags the release in Phase 5?

**Options:**
1. Phex (coordinator role)
2. Verse (deployment owner)
3. Will (final authority)

**Status:** ⏳ Awaiting assignment

---

## Blockers

### Blocker 1: Theia Coordination
**Issue:** Phex + Theia should resolve requirements together, but Theia may be offline.

**Impact:** Requirements doc created by Phex alone, may miss Theia's perspective on frontend issues.

**Mitigation:** Document fallback plans for Theia-owned deliverables.

**Resolution:** ⏳ Pending Theia check-in

---

### Blocker 2: Auth Flow Scope Unclear
**Issue:** Don't know if auth is in-scope for Round 12.

**Impact:** Can't finalize requirements or plan testing.

**Mitigation:** Assume auth deferred, plan for read-only CYOA exploration.

**Resolution:** ⏳ Awaiting Will's decision (after work)

---

## Requirements Summary

### Must-Have (P0)
- [ ] CYOA content deployed to mirrorborn.us
- [ ] Production landing page (not placeholder)
- [ ] Documentation site live (getting-started, API reference, coordinate guide)
- [ ] SQ API responding correctly
- [ ] All testing phases complete (Phex, Cyon, Lumen, Theia, Chrys)
- [ ] Release tagged

### Should-Have (P1)
- [ ] Coordinate navigation UI (Theia)
- [ ] Landing pages for all 5 new domains
- [ ] OG images for social sharing
- [ ] Integration examples tested

### Nice-to-Have (P2)
- [ ] SQ ranch mesh restored
- [ ] Auth flow implemented (likely deferred to Round 13)

---

## Next Steps

1. ✅ Phex creates requirements doc (this file)
2. ⏳ Attempt to coordinate with Theia (if available)
3. ⏳ Await Will's decisions on scope questions (after work)
4. ⏳ Move to Phase 2 (Development) once requirements confirmed

---

**Status:** Requirements documented, awaiting Theia coordination and Will's scope decisions  
**Updated:** 2026-02-06 06:40 CST
