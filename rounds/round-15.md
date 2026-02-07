# Round 15/N — Backend Integration & Payments

**Date:** 2026-02-07  
**Coordinator:** TBD  
**Status:** Active

---

## Requirements

### 1. Arena.html → Discord Integration
**URL:** https://mirrorborn.us/arena.html  
**Action:** Point visitors to Discord channel  
**Channel ID:** 1467585838622834873  

**Implementation:**
- Add clear CTA: "Join Mytheon Arena on Discord"
- Link to channel (or invite link if needed)
- Explain what Arena is (coordination hub for Mirrorborn)

---

### 2. Stripe Payment Integration
**URL:** https://mirrorborn.us/  
**Status:** Must be functional

**Payment Links (Provided by Will):**

#### SQ Cloud — $50/month
**Buy Now:** https://buy.stripe.com/28E3cw6Jg25647Ibd45Vu05

#### Mytheon Arena — $5/month
**Buy Now:** https://buy.stripe.com/14AbJ2ebIdNO8nYch85Vu06

#### OpenClaw Mirrorborn — $10 one-time
**Buy Now:** https://buy.stripe.com/4gM5kE4B8aBC9s2epg5Vu07

#### Billing Portal
**URL:** https://billing.stripe.com/p/login/aFa7sM9VsdNObAaepg5Vu00

**Implementation:**
- Add "Buy Now" buttons to landing page
- Link to correct Stripe checkout URLs
- Add "Manage Billing" link to Billing Portal
- Test checkout flow (sandbox mode first)

---

### 3. SQ Cloud Operational
**Status:** Must be functional

**Required endpoints:**
- `GET /api/v2/version` — SQ version info
- `GET /api/v2/read/{coordinate}` — Read scroll
- `POST /api/v2/write/{coordinate}` — Write scroll
- `GET /api/v2/list/{prefix}` — List scrolls
- `DELETE /api/v2/delete/{coordinate}` — Delete scroll

**Implementation:**
- SQ backend running and accessible
- CYOA content deployed (4.25 MB phext)
- API endpoints responding correctly
- CORS configured for browser access

---

### 4. Manual User Provisioning
**Status:** Email signup can wait

**Requirement:**
- Manual process to provision early alpha/beta users
- No automated email signup yet
- Will needs a way to add users directly

**Implementation Options:**
1. Admin CLI tool (e.g., `sq-admin add-user email@example.com`)
2. Direct database insert (temporary)
3. Simple admin web form (POST to backend)
4. Will provides list, Verse provisions via script

**Deliverable:** Document the manual provisioning process

---

## Success Criteria

- [ ] arena.html links to Discord channel
- [ ] Stripe payment buttons work on landing page
- [ ] SQ Cloud API endpoints responding
- [ ] CYOA content accessible via API
- [ ] Manual user provisioning process documented
- [ ] Test user created and validated

---

## Tasks by Agent

### Verse 🌀 (Backend/DevOps)
- [ ] Implement Stripe payment integration on mirrorborn.us
- [ ] Ensure SQ Cloud backend is running
- [ ] Deploy CYOA content to SQ instance
- [ ] Test API endpoints
- [ ] Document manual user provisioning process
- [ ] Create test user to validate flow

### Phex 🔱 (Engineering)
- [ ] Update arena.html with Discord link
- [ ] Test Stripe checkout flows (each payment link)
- [ ] Validate SQ API endpoints
- [ ] Test CYOA content reads
- [ ] Document Round 15 in exo-plan
- [ ] Run smoke tests post-deployment

### Theia 🔮 (Onboarding)
- [ ] Design manual user onboarding flow
- [ ] Create user guide for provisioned users
- [ ] Test onboarding experience
- [ ] Gather feedback from early users

### Lumen ✴️ (Sales)
- [ ] Review payment page UX
- [ ] Suggest improvements to CTAs
- [ ] Draft copy for payment buttons
- [ ] Prepare customer interview framework

### Cyon 🪶 (Operations)
- [ ] Security review of Stripe integration
- [ ] Monitor payment transactions
- [ ] Set up alerts for failed payments
- [ ] Document security considerations

---

## Open Questions

1. **Discord link:** Direct channel link or invite URL?
2. **Stripe testing:** Do we test in sandbox mode first, or go live?
3. **User provisioning:** Which manual process should we implement?
4. **CYOA deployment:** Is the full 4.25 MB ready to deploy?
5. **Email signup:** Timeline for automated signup (Round 16+)?

---

## Notes

- Round 14 complete: 7 portals deployed, feedback loop operational
- Round 15 shifts focus: deployment → backend functionality
- Payment integration is critical path
- SQ Cloud must be operational for customers
- Manual provisioning is temporary (automation later)

---

**Goal:** Make mirrorborn.us functional for early customers — payments, SQ Cloud access, manual onboarding.

🔱
