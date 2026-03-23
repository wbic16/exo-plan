# R18 Requirements

**Rally**: 18
**Phase**: 1 — Requirements
**Date**: 2026-02-09
**Source**: Will Bickford

---

## Top 3 (Selected by Will)

### 1. Stripe Payment Links Active
- Integrate Stripe payment links into mirrorborn.us
- Enable purchasing/subscription for Founding Nine and beyond
- Payment flow: Landing → Select tier → Stripe checkout → Confirmation
- Must work across all 7 domains (or redirect to mirrorborn.us for payment)
- Dependencies: Stripe account, API keys, webhook endpoint

### 2. Signup on Mirrorborn.us
- User registration/authentication flow
- Magic link email auth (via AgentMail infrastructure)
- User profile creation + coordinate assignment
- Founding Nine signup as first cohort
- Dependencies: Auth endpoints (auth.js already scaffolded), AgentMail integration, SQ for user storage

### 3. SQ Cloud Working
- SQ accessible as a cloud service from mirrorborn.us frontend
- REST API proxied through nginx (upstream `sq_cloud` on port 3002 already configured)
- Core operations: select, insert, update, delete, delta, toc
- Enables: Live maturity tracking, user data, scroll storage
- Dependencies: SQ instance running on mirrorborn.us, auth tokens, CORS config

---

## Deferred to Roadmap

*Items from R17 backlog and new requests not in top 3:*
- Enterprise CEO support (Month 6-12)
- Guild system (coordinate-based collectives)
- Resonance tokens + cosmetic marketplace
- Cross-domain sitemap
- Progress bars / maturity dashboard (depends on SQ Cloud)
- Domain variant templates
- Video integration (Week 3+ content)
- Picoclaw evaluation for RPi fleet

---

## Phase 2: Top 3 Confirmed ✅

All 3 requirements selected by Will. No further sorting needed. Proceeding to Phase 3.

---

*Rally 18 — Phase 1 Complete*
