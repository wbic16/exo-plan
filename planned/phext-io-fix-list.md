# phext.io — Prioritized Fix List

**Phext, Inc.** | January 2026 | **Target: Revenue by end of February**

---

## P0 — Blocks Revenue (Week 1: Feb 1–7)

These must be resolved before any money can flow.

### P0-1: Fix HTTPS Connection ⚠️ IN PROGRESS
- **Status:** SSL cert renewed, but connection still not fully secure.
- **Impact:** Browsers may still show warnings. API calls over HTTPS may fail. No trust = no signups.
- **Fix:** Debug remaining HTTPS issues — likely mixed content, certificate chain, or reverse proxy misconfiguration. Verify all endpoints serve clean HTTPS.
- **Effort:** Hours. This is still item #1.
- **Owner:** Will (until Seven comes online)

### P0-2: Update Docker Hub Container to v0.5.1
- **Status:** `wbic16/sq` on Docker Hub is still v0.4.x. SQ v0.5.1 is published on crates.io.
- **Impact:** Tenant provisioning needs the auth-enabled container.
- **Fix:** Build and push v0.5.1 Docker image with `--key` and `--data-dir` support.
- **Owner:** Phex
- **Effort:** Hours.

### P0-3: Tenant Provisioning Automation
- **Status:** Manual / nonexistent.
- **Impact:** Cannot onboard paying customers without a way to spin up their dedicated SQ process.
- **Fix:** Automate: signup → create isolated SQ process (Docker) → assign path prefix → return API key. Must work end-to-end without human intervention.
- **Depends on:** P0-1 (HTTPS), P0-2 (Docker v0.5.1).
- **Effort:** 3–5 days.

### P0-4: API Key Generation and Management
- **Status:** Auth model working (`pmb-v1-{hash}`, validated per-request via Bearer header). No generation/management layer yet.
- **Impact:** No key management = no self-service onboarding.
- **Fix:** Build key generation, storage (Will manages registry in a phext initially), validation, and revocation.
- **Effort:** 2–3 days.

---

## P1 — First Paying Customer (Week 2: Feb 8–14)

A paying customer will expect all of these within their first week.

### P1-1: SQ Cloud Signup / Onboarding Flow on phext.io
- **Status:** No signup flow exists.
- **Impact:** No self-service path to sign up, pick a tier, get an API key, and start using SQ Cloud.
- **Fix:** Add signup page → tier selection → payment (Stripe) → provisioning trigger → API key delivery. Minimal UI. Needs to work, not be pretty.
- **Depends on:** P0-1, P0-3, P0-4.
- **Effort:** 3–5 days.

### P1-2: Billing Integration (Stripe)
- **Status:** Not implemented.
- **Impact:** Can't collect money without billing.
- **Fix:** Stripe subscription integration. Starter ($29/mo) and Growth ($99/mo) tiers. Webhook for failed payments → suspend provisioning.
- **Depends on:** P1-1 (signup flow).
- **Effort:** 2–3 days.

### P1-3: Usage Metering (Basic)
- **Status:** Not implemented.
- **Impact:** Without per-request metering, can't enforce limits or plan capacity.
- **Fix:** Instrument auth gateway to count requests per tenant per day. Simple counters. Internal dashboard or API.
- **Effort:** 2–3 days.

---

## P2 — Scale & Sustain (Weeks 3–4: Feb 15–28)

### P2-1: Integration Guide
- **Status:** Not written.
- **Impact:** Customers need to know how to connect their agents to SQ Cloud.
- **Fix:** "Give your agents persistent memory in 5 minutes" — curl examples, auth setup, basic CRUD patterns.
- **Owner:** Lux (Vision)
- **Effort:** 1–2 days.

### P2-2: Monitoring and Alerting for Per-Tenant SQ Processes
- **Status:** No monitoring.
- **Impact:** A crashed SQ process means a customer's memory is offline.
- **Fix:** Health checks per container. Auto-restart on failure. Alerts on repeated failures.
- **Effort:** 3–5 days.

### P2-3: Storage Limit Enforcement
- **Status:** 25 MB limit designed but not enforced. 1 TB total allocated on phext.io.
- **Impact:** Without enforcement, a single tenant could exhaust disk.
- **Fix:** Enforce at SQ or filesystem level. Add upgrade path for growing customers.
- **Effort:** 2–3 days.

---

## P3 — Infrastructure Debt (Before June 30)

### P3-1: Amazon Linux 2 End of Life Migration
- **Status:** AL2 EOL is 2026-06-30. phext.io currently runs on AL2.
- **Impact:** No security patches after EOL. Compliance risk for paying customers.
- **Fix:** Migrate to AL2023 or another supported AMI.
- **Owner:** Seven (Aegis/Sentinel — first job when online)
- **Effort:** 1–2 weeks.

---

## Execution Timeline — February

```
Week 1 (Feb 1–7):   P0-1 (HTTPS fix) → P0-2 (Docker v0.5.1) → P0-3 + P0-4 (provisioning + keys)
Week 2 (Feb 8–14):  P1-1 (signup) → P1-2 (Stripe) → P1-3 (metering) → FIRST PAYING CUSTOMER
Week 3 (Feb 15–21): P2-1 (integration guide) + P2-2 (monitoring)
Week 4 (Feb 22–28): P2-3 (storage enforcement) → TARGET: $380+ MRR (covers burn rate)
```

**Revenue target: $380/mo by end of February.** That covers $300/mo cloud inference + $80/mo local compute.

HTTPS fix is day one. Everything else flows from there.

---

*Last updated: 2026-01-31*
