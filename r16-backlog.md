# Round 16 Backlog — Carryover from R15

**Created:** 2026-02-07 14:14 CST  
**Owner:** Chrys 🦋 (marketing/frontend)

---

## High Priority

### 1. Light/Dark Mode Toggle
**Scope:** All 7 domains need theme switching  
**Files:**
- `/source/phext-dot-io-v2/css/sq-cloud.css` (add theme variables)
- `/source/phext-dot-io-v2/css/main.css` (add theme toggle JS)
- All `index.html` files (add toggle button)

**Acceptance criteria:**
- User can toggle light/dark via button
- Preference saved in localStorage
- Default respects system preference
- Smooth transition (no flash)

---

### 2. Stripe CTA Integration (6 domains)
**Remaining domains:**
- visionquest.me → Primary: OpenClaw Mirrorborn $10
- apertureshift.com → Primary: Arena $5/mo
- wishnode.net → Primary: SQ Cloud $50/mo
- sotafomo.com → Primary: Arena $5/mo
- quickfork.net → Primary: OpenClaw Mirrorborn $10
- singularitywatch.org → Primary: Benefactor $500

**Pattern:** Copy arena.html CTA structure (primary + secondary + footer)

---

### 3. User Provisioning Form
**Spec:**
- Email + username input
- Submits to endpoint for manual review (Will approves)
- Stripe collects payment info
- Confirmation: "We'll review and send credentials"

**Owner:** Theia (user onboarding)  
**Blocker:** Need API endpoint spec from Phex/Verse

---

### 4. SQ Cloud Operational Verification
**Owner:** Phex  
**Questions:**
- Is SQ v0.5.2 running on production?
- Can we provision new users?
- What's the onboarding flow?

---

## Medium Priority

### 5. Maturity Bars UI
**Design:**
```
Progress: Spark ●●●●○○○○ Scribe
          125 KB / 1 MB
```

**Placement:**
- User profile pages
- Arena matchmaking interface
- Footer (small indicator)

**Data source:** Calculate from MEMORY.md size + compressed novel insight

---

### 6. Arena Complexity Matching
**Requirement:** Pair users by maturity class for Arena sessions

**Classes:**
- Spark × Spark
- Scribe × Scribe
- Explorer × Explorer
- Sovereign × Sovereign (or mentor younger classes)

**Implementation:** Depends on Arena backend (Phex/Verse)

---

### 7. Metallic Liquid Neon Branding
**Style guide:**
- Base: Dark (Nord Polar Night)
- Accents: Liquid neon (electric blue, magenta, cyan)
- Metallic: Subtle gradients, chrome highlights
- Refinement: Understated (Age of Spiritual Machines aesthetic)

**CSS variables to add:**
```css
--neon-blue: #00D9FF;
--neon-magenta: #FF00AA;
--neon-cyan: #00FFCC;
--metallic-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
```

**Apply to:** Buttons, headers, glyphs, hover states

---

## Low Priority

### 8. Full Pricing Page
**URL:** `/pricing.html`  
**Content:** Comparison table of all 6 products  
**Reference:** Draft table exists in `r15-stripe-payment-links.md`

---

### 9. Product Screenshots
**Needed:**
- SQ Cloud API in action (curl examples)
- Mytheon Arena navigation (mock if not ready)
- OpenClaw Mirrorborn dashboard

**Use:** Landing pages, social cards, docs

---

### 10. OG Images (Social Cards)
**Dimensions:** 1200×630 px  
**Needed for:**
- SQ Cloud
- Mytheon Arena
- OpenClaw Mirrorborn
- Benefactor tier
- Singularity tier

**Template:** Brand colors + glyph + product name + tagline

---

### 11. Analytics Setup
**Tool:** Plausible.io (privacy-first) or similar  
**Tracking:** Page views, conversion funnel, payment clicks  
**Note:** Need Will's approval on analytics provider

---

### 12. Email Template Integration
**Status:** Templates exist in `/source/phext-dot-io-v2/templates/`  
**Blocker:** AWS SES configuration (Verse)  
**Needed:** Magic link flow, welcome email, payment confirmation

---

## Coordination Notes

- **Verse:** Deployment + infrastructure (SQ hosting, nginx configs)
- **Phex:** SQ operational status + API readiness
- **Theia:** User provisioning form + onboarding flow
- **Chrys:** Frontend (light/dark mode, CTAs, branding CSS)
- **All:** Review staged sites before R16 production push

---

🦋  
— Chrys  
*R16 backlog documented*
