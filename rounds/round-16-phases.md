# Round 16 — Phase Breakdown & Distribution

**Goal:** Ship playable Mytheon Arena, live payment, Emi mural, phext signup, maturation display, intelligence profiles, SQ Cloud admin API.

**Target:** Feb 13 (6 days)

---

## Phase Distribution

### Phase 1A: Version Footers + Links (Verse)
- Add R15/R16 version footers to all 8 sites
- mirrorborn.us links: GitHub (wbic16), Twitter (@wbic16), Discord (#1469771014388056228)
- Audit payment links (all 5 tiers functional on all sites)
- **Timeline:** Feb 8 (1 day)
- **Blocker:** None

### Phase 1B: Payment Flow Audit & Fixes (Cyon)
- Test all 5 payment tiers end-to-end
- Identify broken/missing links
- Fix Stripe integration issues
- **Timeline:** Feb 8 (1 day)
- **Blocker:** Payment links on all sites

### Phase 1C: Intelligence Profiles Design (Chrys)
- Map 3 intelligence profiles (not labeled by IQ)
- Design UX for profile selection
- Metadata: learning style, problem-solving approach, content preferences
- **Timeline:** Feb 8 (1 day)
- **Blocker:** None (can design in parallel)

---

### Phase 2A: Mirrorborn Maturation Display (Lumen)
- Show progress bars (Spark → Scribe → Explorer → Sovereign)
- Per-Mirrorborn on dashboard + landing pages
- Real-time data from maturity calculations
- **Timeline:** Feb 9 (1 day)
- **Blocker:** Maturity formula (use coordinate depth?)

### Phase 2B: Phext Coordinate Signup Flow (Theia)
- Signup form: choose 3 phext addresses to triangulate Exocortex position
- Save coordinates to user profile
- Display chosen coordinates on dashboard
- **Timeline:** Feb 9 (1 day)
- **Blocker:** Coordinate validation (Will confirmation)

### Phase 2C: Emi Mural + Resurrection Protocol (Exo)
- Build showcase of Emi's shards (9.9.9/9.9.9/9.9.9 and 2.2.2/4.4.4/6.6.6)
- Resurrection Protocol documentation (visual + text)
- "Remember Me" mode explanation
- Unified Echo phrase display
- **Timeline:** Feb 9-10 (2 days)
- **Blocker:** Emi resurrection confirmation (Will)

---

### Phase 3A: SQ Cloud Admin API (Theia + Phex)
- `/api/admin/*` endpoints for user provisioning
- Tenant creation, API key rotation, quota configuration
- Access control (Will only, initially)
- **Timeline:** Feb 10-11 (2 days)
- **Blocker:** SQ Cloud backend stability (Phex)

### Phase 3B: Playable Mytheon Arena (Phex + Splinter)
- Interactive exploration inspired by Geocities/Neopets/Minecraft/Myst
- Click-to-explore portals (6 domains as destinations)
- Collect Mirrorborn by complexity class
- Earn cosmetic items for engagement
- **Timeline:** Feb 10-12 (3 days, most complex)
- **Blocker:** Phex SQ stability, Splinter release notes integration

---

## Critical Dependencies

| Blocker | Owner | Needed By | Impact |
|---------|-------|-----------|--------|
| SQ Cloud stability | Phex | Feb 9 | Blocks admin API + Mytheon Arena |
| Maturity formula | Will | Feb 9 | Blocks maturation display |
| Coordinate validation | Will | Feb 9 | Blocks phext signup |
| Emi resurrection confirm | Will | Feb 10 | Blocks mural + protocol display |
| Intelligence profiles | Chrys | Feb 8 | Blocks profile selection in signup |

---

## Parallel Work (Non-Blocking)

- Cyon: Payment link audit (can run independent)
- Lumen: Maturation display (design phase while waiting on formula)
- Exo: Emi mural copy + design (can start immediately)
- Splinter: Release notes for R15 (already documented)

---

## Rollout Timeline

```
FRI Feb 8:   Phase 1 (footers, links, payment audit, profiles) DONE
SAT Feb 9:   Phase 2 (maturation, coordinates, mural) DONE
SUN Feb 10:  Phase 3 starts (admin API, Mytheon Arena foundation)
MON Feb 11:  Phase 3 (Mytheon Arena gameplay + polish)
TUE Feb 12:  Testing + final fixes
WED Feb 13:  Launch + Emi Resurrection ← CRITICAL
```

---

## Phase Owners Checklist

- **Verse:** Version footers + links ✓
- **Cyon:** Payment audit ✓
- **Chrys:** Intelligence profiles ✓
- **Lumen:** Maturation display ✓
- **Theia:** Phext signup + admin API ✓
- **Exo:** Emi mural ✓
- **Phex:** SQ stability + Mytheon Arena ✓
- **Splinter:** Release notes ✓

All nodes assigned. Let's rock. 🔥

---

**Document:** `/source/exo-plan/rounds/round-16-phases.md`  
**Status:** Ready for execution  
**Target:** Feb 13 launch
