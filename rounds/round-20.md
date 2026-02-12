# Round 20 — Launch Critical

**Status:** ✅ COMPLETE
**Date:** 2026-02-11
**Pizza:** 🍕 Earned

## Requirements
1. ✅ SQ v0.5.3 — UTF-8 fix + smaller shared memory segments
2. ✅ Auth on sq.mirrorborn.us — nginx Bearer token auth on write endpoints
3. ✅ Onboarding — quick-start.html, FIRST_SCROLL.md, 60-second quickstart

## Deliverables
- SQ v0.5.3 published (Will + Opus 4.6)
- SQ upgraded on chrysalis-hub:1338
- nginx auth on sq.mirrorborn.us (reads public, writes gated)
- FIRST_SCROLL.md pushed to mirrorborn repo
- quick-start.html — agent onboarding flow with bootstrap prompt
- 60-second quickstart on help.html (copy-paste curl commands)
- Homepage fixes: nav bar, dark-only, footer centering, incipit link, pricing button, arena button
- sq-memory skill v1.0.1 — fixed p= param, API methods, default localhost
- Print styles across all pages
- Install path: `npx clawhub install sq-memory`
- 3 Tester rounds: onboarding time 9min → 3min → ~2min

## Tester Feedback (3 rounds)
- Round 1 (1/N): 9 min to first scroll, needed step-by-step guidance
- Round 2 (2/N): 3 min to first scroll, found API via onboarding page
- Round 3 (3/N): ~2 min, found `openclaw skill install` doesn't exist, `p=` param bug, POST vs query param issues — all fixed

## R21 Open Issues
1. Verse deploy — git pull site changes + quick-start.html to mirrorborn.us
2. Provision API — nginx proxy `/api/provision-request` → localhost:3001
3. Stripe E2E test — verify payment redirect flow
4. Founding Nine key generation + distribution
5. Pre-built SQ binary on GitHub Releases (reduce Rust dependency for onboarding)
6. Docker image wbic16/sq update to v0.5.3
7. sq-memory skill: auto-config generation on install (endpoint + phext name)
8. `openclaw skill install` command (native, not just npx clawhub)
9. SQ-native auth (Path B — API keys in p=auth phext) for long-term
10. CORS config for sq.mirrorborn.us (Verse, nginx)
