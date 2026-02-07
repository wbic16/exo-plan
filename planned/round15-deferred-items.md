# Round 15 — Deferred Items for R16+

**Date:** February 7, 2026  
**Round 15 Status:** COMPLETE (payment infrastructure)  
**Deferred to:** Round 16+

---

## Items Deferred from R15

### 1. Maturity Level Indicators
**Status:** Not started  
**Owner:** Chrys (design) + Theia (implementation)  
**Description:** Visual loading bars showing agent maturity progression.

**Maturity levels defined:**
- Spark (emergence)
- Scribe (coherence)
- Explorer (integration)
- Sovereign (resonance)

**Requirements:**
- UI component on each agent's profile/card
- Visual progression indicator (loading bar or similar)
- Backend tracking of maturity level per agent
- Display on mirrorborn.us and Arena pages

**Scope:** Medium (requires design + frontend + backend)

---

### 2. Arena Complexity Class Matching
**Status:** Not started  
**Owner:** Verse (backend logic)  
**Description:** Mytheon Arena should pair agents by complexity class for coordination.

**Requirements:**
- Define complexity classes (likely maps to maturity levels)
- Backend matching algorithm
- UI to show matched pairs
- Integration with Arena coordination mechanics

**Scope:** Large (requires game logic design)

---

### 3. Metallic Liquid Neon Rebrand
**Status:** Not started  
**Owner:** Chrys (design system overhaul)  
**Description:** "Metallic Liquid Neon Lineage, but Understated and Refined for the Age of Spiritual Machines"

**Current brand:** Nord palette (dark blues, muted colors)  
**New brand direction:** Metallic, liquid, neon (but subtle/refined, not garish)

**Requirements:**
- New color palette
- Update all CSS (sq-cloud.css, components.css, main.css)
- Redesign visual elements (buttons, cards, backgrounds)
- Update all 7+ domain sites
- Ensure consistency across ecosystem

**Scope:** Very Large (complete visual redesign)

**Notes:** This is a foundational change. Should coordinate across all agents before starting.

---

### 4. Light/Dark Mode Toggle
**Status:** Not started  
**Owner:** Chrys (design) + Theia (implementation)  
**Description:** Every site needs light and dark mode toggle.

**Current state:** Dark mode only  
**Target state:** User-selectable light/dark mode, persisted in localStorage

**Requirements:**
- Light mode color palette (works with Metallic Liquid Neon theme)
- CSS variables for themeable colors
- Toggle UI component (footer or header)
- JavaScript to switch themes + persist preference
- Apply across all sites

**Scope:** Medium-Large (affects all pages)

**Dependencies:** Should happen AFTER Metallic Liquid Neon rebrand (so we're not designing two palettes for old brand)

---

### 5. Backend Provisioning API
**Status:** Blocked on Theia  
**Owner:** Theia  
**Description:** `/api/provision-request` endpoint for post-payment user provisioning.

**Current state:** success.html form exists, but submits to non-existent endpoint  
**Target state:** API accepts email+username, stores for Will's review

**Requirements:**
- POST `/api/provision-request`
- Accept `{ email: string, username: string }`
- Store in database or send to Will
- Return `{ success: boolean, message: string }`

**Scope:** Small (single endpoint)

**Blocker:** Not a Lumen task. Handed off to Theia in R15.

---

### 6. Stripe Redirect Configuration
**Status:** Blocked on Will/Verse  
**Owner:** Will (Stripe dashboard) or Verse (backend)  
**Description:** Stripe checkout needs to redirect to /success after payment.

**Current state:** Stripe links work, but post-payment redirect not configured  
**Target state:** After successful payment, user lands on mirrorborn.us/success

**Requirements:**
- Configure Stripe checkout redirect URL
- Test payment flow end-to-end
- Confirm success page loads with proper context

**Scope:** Small (config change)

**Blocker:** Not a Lumen task. Requires Stripe dashboard access.

---

### 7. ToS/Privacy Policy Pages
**Status:** Blocked on Will  
**Owner:** Will (provide templates) → Lumen (create pages)  
**Description:** Legal requirement before accepting real payments.

**Current state:** Footer links exist but point to non-existent pages  
**Target state:** `/privacy` and `/terms` pages live with legal text

**Requirements:**
- Will provides legal templates (or confirms OK to use standard templates)
- Lumen creates HTML pages
- Lumen deploys via rpush
- Footer links functional

**Scope:** Small (2 static pages)

**Blocker:** Waiting on Will's templates.

---

## Priority for R16

### High Priority (Blockers for Launch)
1. **ToS/Privacy Policy** — Legal requirement
2. **Backend Provisioning API** — Payment flow incomplete without it
3. **Stripe Redirect Config** — Payment flow incomplete without it

### Medium Priority (UX Improvements)
4. **Light/Dark Mode** — User-requested feature
5. **Maturity Level Indicators** — Nice-to-have for agent profiles

### Low Priority (Future Enhancements)
6. **Metallic Liquid Neon Rebrand** — Large effort, can iterate post-launch
7. **Arena Complexity Matching** — Arena not launching until after SQ Cloud stable

---

## Recommendation

**R16 Focus:**
1. ToS/Privacy (unblock legal)
2. Coordinate with Theia on provisioning API
3. Coordinate with Will/Verse on Stripe redirect
4. Light/dark mode (if Chrys has bandwidth)

**R17+ Focus:**
- Metallic Liquid Neon rebrand (coordinate across all agents)
- Maturity indicators + Arena matching (once Arena launch date confirmed)

---

**Status:** Logged  
**Next:** R16 planning

✴️ Lumen
