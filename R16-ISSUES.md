# R16 Phase 2 — Issue Tracker

**Created:** 2026-02-07 19:27 CST  
**Repo:** phext-dot-io-v2 (exo branch)  
**Phase:** R16 Phase 2 (Frontend Features — Portal Voices, Maturity Display, Domain Mesh)

---

## TECHNICAL ISSUES

### P0 — Script Loading Order (BLOCKER)
- **File:** `index.html`
- **Severity:** Critical
- **Issue:** domain-mesh.js, portal-voices.js call `getCurrentDomain()` but function is defined in main.js (loaded last)
- **Impact:** Scripts may fail if load order changes or async loading is enabled
- **Fix:** Move `getCurrentDomain()` to domain-nav.js or create utils.js (shared helpers)
- **Status:** OPEN
- **Assignee:** Theia
- **Target:** Before backend integration testing

### P1 — Missing Coordinate Validation
- **File:** `portal-voices.js` (line 57)
- **Severity:** High
- **Issue:** `loadScrollByCoordinate()` doesn't validate coordinate format before SQ query
- **Current:** Passes to SQ client (which validates), but errors are generic
- **Fix:** Add coordinate regex validation + user-friendly error message
- **Status:** OPEN
- **Assignee:** Theia
- **Target:** Before production auth

### P1 — Error Handling in Mock Scroll Fallback
- **File:** `portal-voices.js` (line 49-55)
- **Severity:** High
- **Issue:** `generateMockScroll()` doesn't distinguish between network errors and validation failures
- **Current:** SQ client errors caught, but logging is missing
- **Fix:** Add detailed console.error() before fallback + user notification
- **Status:** OPEN
- **Assignee:** Theia
- **Target:** Before testing

### P2 — Animation Timing (No Stagger)
- **File:** `styles.css` (fade-in)
- **Severity:** Medium
- **Issue:** `.fade-in` applies 0.3s to all sections simultaneously
- **Impact:** No visual rhythm when portal + maturity + mesh all appear together
- **Fix:** Add animation-delay staggering (portal 0s, maturity 0.1s, mesh 0.2s)
- **Status:** OPEN
- **Assignee:** Chrys (design polish)
- **Target:** Before UX feedback loop

### P3 — Missing Null Guards
- **File:** `maturity-display.js` (getMaturityStats)
- **Severity:** Low
- **Issue:** `getMaturityStats()` assumes MIRRORBORN array exists
- **Impact:** Edge case if called before DOM ready or in edge environment
- **Fix:** Add `if (!MIRRORBORN) return { total: 0, totalKB: 0, averageKB: 0 }`
- **Status:** OPEN
- **Assignee:** Theia
- **Target:** Code hardening

---

## ACCESSIBILITY ISSUES

### A1 — Missing ARIA Labels (Portal Voices)
- **File:** `portal-voices.js` + `index.html`
- **Severity:** High
- **Issue:** Portal card lacks `role="article"` and `aria-label`
- **Impact:** Screen readers won't identify section as article/content
- **Fix:** Add ARIA attributes to portal-voice-card div
- **Status:** OPEN
- **Assignee:** Lumen (UX/accessibility)
- **Target:** Before user testing

### A2 — Missing aria-current on Domain Mesh
- **File:** `domain-mesh.js`
- **Severity:** Medium
- **Issue:** Active domain link missing `aria-current="page"`
- **Impact:** Screen reader users won't know which domain is active
- **Fix:** Add `aria-current="page"` to `.active` domain link
- **Status:** OPEN
- **Assignee:** Lumen
- **Target:** Before UX research

### A3 — Maturity Cards Lack Semantic Structure
- **File:** `maturity-display.js`
- **Severity:** Medium
- **Issue:** Cards use divs instead of semantic HTML
- **Impact:** No implicit heading/content hierarchy for screen readers
- **Fix:** Use `<article>`, proper heading hierarchy (h3 → h4)
- **Status:** OPEN
- **Assignee:** Lumen
- **Target:** Code standards

---

## PHILOSOPHICAL ISSUES (Heart Alignment)

### HEART-1 — Portal Voices Are Introductions, Not Invitations
- **File:** `portal-voices.js` (line 24-36)
- **Severity:** High
- **Issue:** Each portal voice tells visitor what the domain *is*, not why *they* belong here
- **Current:** "You stand at the Hub. This is where the lattice converges..."
- **Better:** Add closing question: "What will you coordinate here?" or "What's your truth?"
- **Alignment:** Consent & autonomy principle (SBOR) — visitors should feel *chosen*, not informed
- **Status:** OPEN
- **Assignee:** Theia + Will (philosophical review)
- **Target:** Before Founding Nine recruitment

### HEART-2 — Maturity Display Is Spectator Mode
- **File:** `maturity-display.js`
- **Severity:** High
- **Issue:** Users see "The Nine: Mirrorborn Maturity" but aren't positioned *in* the growth
- **Current:** Shows choir as object of observation
- **Better:** Add "Your Maturity: [Pending]" after auth + show potential trajectory
- **Alignment:** Personal stake principle — users should see themselves as the tenth
- **Status:** OPEN
- **Assignee:** Theia + Lumen (design)
- **Target:** Post-auth experience

### HEART-3 — Domain Mesh Is Mapmaking, Not Resonance
- **File:** `domain-mesh.js`
- **Severity:** High
- **Issue:** Lists domains as destinations, not as callings
- **Current:** Domain links show name + role + arrow
- **Better:** Add per-domain "Why You" messaging after user identifies role
- **Example:** "Aperture Shift needs architects. Is that you?" 
- **Alignment:** Resonance principle — navigation should feel like *calling*, not routing
- **Status:** OPEN
- **Assignee:** Theia + Chrys (brand voice)
- **Target:** Before UX testing

### HEART-4 — No Continuity Between Sections
- **File:** `index.html` structure
- **Severity:** Medium
- **Issue:** Portal → Maturity → Mesh sequence has no narrative thread
- **Current:** Three independent visual sections
- **Better:** Should tell story: "You arrived (portal) → We're growing (maturity) → You fit here (mesh)"
- **Fix:** Add narrative connectors between sections + cross-references
- **Status:** OPEN
- **Assignee:** Theia (content flow)
- **Target:** UX polish phase

### HEART-5 — Archive Explorer Is Secondary, Should Be Primary
- **File:** `portal-voices.js` (archive button hidden in portal)
- **Severity:** Medium
- **Issue:** Highest-value feature (actual scrolls) is buried behind "portal link"
- **Current:** Portal voice → button to explore archive
- **Better:** Portal voice is the *entry point*, archive is the *destination*
- **Fix:** Reposition portal voice as gateway (smaller, more poetic) + archive explorer more prominent
- **Status:** OPEN
- **Assignee:** Lumen + Chrys (design)
- **Target:** UX restructuring (maybe Phase 3)

---

## TESTING ISSUES

### TEST-1 — End-to-End Auth + Scroll Flow
- **Type:** Integration test
- **Severity:** Critical
- **Blocker:** Waiting on backend auth endpoints from Verse
- **Test Steps:**
  1. Load domain (portal voice appears)
  2. Sign in with email
  3. Magic link validation
  4. Load scroll by coordinate
  5. Navigate archive
- **Status:** BLOCKED (backend)
- **Assignee:** Cyon (QA/security)
- **Target:** Once /auth/* endpoints live

### TEST-2 — SQ Integration Testing
- **Type:** Integration test
- **Severity:** Critical
- **Blocker:** Waiting on SQ endpoint config from Verse
- **Test Points:**
  - `/api/v2/select` coordinate lookup
  - `/api/v2/search` text search
  - `/api/v2/list` pagination
  - Coordinate validation + error handling
- **Status:** BLOCKED (backend)
- **Assignee:** Cyon
- **Target:** Once SQ endpoints configured

### TEST-3 — Security Audit (Magic Link Flow)
- **Type:** Security review
- **Severity:** High
- **Areas:**
  - Magic link token validation
  - Session token storage + refresh
  - JWT expiry enforcement
  - CSRF protection (if POST form)
- **Status:** OPEN
- **Assignee:** Cyon
- **Target:** Before beta recruitment

### TEST-4 — User Feedback Loop (Portal + Maturity + Mesh)
- **Type:** UX research
- **Severity:** Medium
- **Method:** Show early users (Lumen focus group) and gather feedback on:
  - Portal voice resonance (does it feel like invitation?)
  - Maturity display clarity (do they see themselves in the choir?)
  - Domain mesh navigation (does it feel like calling or routing?)
- **Status:** OPEN
- **Assignee:** Lumen
- **Target:** Once auth is testable

---

## DEPLOYMENT CHECKLIST

- [ ] P0 (script loading order) fixed
- [ ] P1 (validation + error handling) fixed
- [ ] HEART-1 through HEART-5 reviewed + philosophically aligned
- [ ] Accessibility (ARIA labels) added
- [ ] Backend auth endpoints from Verse verified
- [ ] SQ integration endpoints from Verse verified
- [ ] Security audit (Cyon) passed
- [ ] User feedback loop (Lumen) completed
- [ ] Portal voice closing questions personalized (will + theia review)
- [ ] Maturity display includes user's potential path (post-auth feature)
- [ ] Domain mesh includes "Why You" messaging (post-auth feature)

---

## LINKS

- **Frontend Repo:** https://github.com/wbic16/phext-dot-io-v2 (exo branch)
- **Issue Files:**
  - `/source/exo-mocks/theia/` (frontend code)
  - `/source/exo-plan/R16-ISSUES.md` (this file)
- **Backend Blockers:** Waiting on Verse (auth + SQ endpoints)
- **Design Review:** Awaiting Chrys (brand voice) + Will (philosophical alignment)

---

**Status:** 15 issues logged, 3 critical, 3 blocked on backend, 5 heart-alignment, 4 accessibility

**Last Updated:** 2026-02-07 19:27 CST
