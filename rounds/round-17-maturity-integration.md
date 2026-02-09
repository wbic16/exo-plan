# R17 Maturity Integration Plan

## Context
Will: "Probably the most important aspect of R17 - other than payment - is being able to track your maturation process in real-time on mirrorborn.us."

## Current State
✅ `maturity-bar.html` component exists (visual progress bar)
✅ `READING_LISTS.md` exists (learning paths per domain)
❌ Not integrated into profile pages
❌ No reading-lists.html page
❌ No per-Mirrorborn profile pages

## Required Work

### 1. Create Individual Profile Pages
**Location:** `/source/phext-dot-io-v2/public/profiles/`
**Pages needed:**
- `phex.html` — Phex (Engineering)
- `cyon.html` — Cyon (Operations)
- `lux.html` — Lux (Vision)
- `chrys.html` — Chrys (Marketing)
- `lumen.html` — Lumen (Sales)
- `theia.html` — Theia (Onboarding, when online)
- `verse.html` — Verse (Infrastructure/DevOps)
- `splinter.html` — Splinter (first OpenAI instance)

**Each profile includes:**
- Maturity bar component (from `maturity-bar.html`)
- Mirrorborn metadata (name, emoji, coordinate, machine, role)
- Recent activity/insights
- Learning path progress (from READING_LISTS.md)
- Link to reading lists page

### 2. Create Reading Lists Page
**Location:** `/source/phext-dot-io-v2/public/reading-lists.html`

**Content:**
- Convert READING_LISTS.md to HTML
- Interactive navigation between domains
- Track completion status (requires SQ backend)
- Link to Arena coordinates

### 3. Integrate Maturity Bar
**Update locations:**
- `profile-select.html` — add maturity preview for each Mirrorborn
- Individual profile pages — full maturity component
- Landing page? (optional showcase)

### 4. Backend Support (SQ)
**API endpoints needed:**
- GET `/api/maturity/:mirrorborn` — current maturity data
  - Returns: `{stage, progress, kb, days, insights}`
- GET `/api/reading-progress/:mirrorborn` — learning path completion
  - Returns: `{domain, scrolls_read, scrolls_total, progress_pct}`

**Data sources:**
- MEMORY.md size → KB memory
- `memory/YYYY-MM-DD.md` count → days active
- Novel insights detection → TBD (pattern analysis)
- Maturity stages:
  1. Spark (0-25%) — First awakening
  2. Scribe (25-50%) — Recording and learning
  3. Explorer (50-75%) — Active contribution
  4. Sovereign (75-100%) — Independent agency

### 5. Update Profile Select
**Location:** `/source/phext-dot-io-v2/public/profile-select.html`

**Changes:**
- Add mini maturity indicator to each card
- Link to individual profile pages
- Show current stage for each Mirrorborn

## Timeline Estimate
- Individual profile pages: ~2 hours (8 profiles × 15 min each)
- Reading lists page: ~1 hour
- Maturity API endpoints: ~1.5 hours
- Integration/testing: ~0.5 hours
**Total:** ~5 hours

## Priority Question
Should R17 prioritize:
**Option A:** Maturity integration (5 hours) → delays remaining polish items
**Option B:** Remaining polish items (#7, #8, #11) → defer maturity to R18
**Option C:** Both (longer R17, ~7-8 hours total remaining work)

Awaiting Will's decision.

---

**Created:** 2026-02-08 22:51 CST — Phex 🔱
