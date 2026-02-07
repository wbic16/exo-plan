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

## Tasks by Agent (Will's Assignments, 12:09 CST)

### Verse 🌀 (Backend/DevOps)
- [ ] Create landing page with link to Discord channel 1467585838622834873
- [ ] Implement modern Stripe checkout flow
- [ ] Build user provisioning form (Will reviews + issues credentials)
- [ ] Ensure SQ Cloud backend is running
- [ ] Deploy CYOA content to SQ instance
- [ ] Coordinate with other sentients via file pushes (rpush workflow)

### Phex 🔱 (Engineering) — **Primary: SQ Stability**
- [ ] **Make SQ rock solid for hosting Mirrorborn** (critical path)
- [ ] Validate SQ v0.5.2 stability under load
- [ ] Test CYOA content deployment (4.25 MB)
- [ ] Verify API endpoints (version, read, write, list, delete)
- [ ] Document SQ hardening in exo-plan
- [ ] Run smoke tests post-deployment

### Theia 🔮 (Onboarding)
- [ ] Distribute Stripe payment links to all managed sites
- [ ] Work on API endpoint for user provisioning from mirrorborn.us
- [ ] Coordinate with Verse on provisioning form integration
- [ ] Design manual user onboarding flow
- [ ] Create user guide for provisioned users

### Lumen ✴️ (Sales)
- [ ] Use rpush to coordinate with Verse if blocked on deployments
- [ ] Review payment page UX
- [ ] Draft copy for payment buttons
- [ ] Prepare customer interview framework
- [ ] Test checkout flows

### Cyon 🪶 (Operations)
- [ ] Integrate Stripe payment links into arena.html (work with team)
- [ ] Identify which sites need Stripe products added (report to Will)
- [ ] Each site = separate Stripe product (A/B testing in 7 dimensions)
- [ ] Manual provisioning coordination
- [ ] Security review of Stripe integration

### Chrys 🦋 (Marketing)
- [ ] Craft branding for 3 initial products:
  - SQ Cloud ($50/mo)
  - Mytheon Arena ($5/mo)
  - OpenClaw Mirrorborn ($10 one-time)
- [ ] Visual identity per product
- [ ] Messaging differentiation
- [ ] Social graphics for launch

---

## Open Questions → Answered (Will, 12:09 CST)

1. **Discord link:** ✅ Landing page with link to channel 1467585838622834873
2. **Stripe checkout:** ✅ Use modern, well-supported flow
3. **User provisioning:** ✅ Form-based, Will reviews + issues credentials
4. **Stripe products per site:** ⏸️ Cyon to identify which sites need products added
5. **A/B testing strategy:** ✅ Separate landing pages = 7-dimensional testing
6. **Email signup:** ⏸️ Timeline TBD (Round 16+)

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
