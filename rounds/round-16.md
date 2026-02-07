# Round 16/N — Production Launch

**Date:** 2026-02-07  
**Start:** 16:16 CST  
**Coordinator:** TBD  
**Status:** Active

---

## Requirements

### 1. Live Payment Flow
**Status:** Required  
**Description:** Stripe integration must be functional on all production sites

**Implementation:**
- Payment buttons on all 9 pages (hub + 7 portals + arena)
- 5 tiers integrated: Singularity ($100/mo), SQ Cloud ($50/mo), Arena ($5/mo), OpenClaw ($10), Founding Nine ($500)
- Billing portal links
- Successful checkout → access provisioning workflow
- Test all payment flows end-to-end

---

### 2. Metallic Professional Material
**Status:** Required  
**Description:** Branding/design refinement per "Metallic Liquid Neon Lineage, Understated and Refined"

**Implementation:**
- Update visual design across all sites
- Metallic/neon accent colors
- Professional typography
- Refined UI components
- Consistent styling

---

### 3. SQ Cloud Operational
**Status:** Required  
**Description:** Backend must be fully functional for paying customers

**Implementation:**
- SQ v0.4.5 running with nginx CORS
- CYOA content accessible
- API endpoints stable under load
- Monitoring and health checks
- Backup/recovery procedures

---

### 4. Admin API for SQ Cloud Access
**Status:** Required  
**Description:** Backend tooling for provisioning user access

**Implementation:**
- Admin CLI or API for adding users
- Configure phext access permissions
- JWT token generation for authenticated users
- User management (list, suspend, delete)
- Integration with payment flow (successful payment → auto-provision)

---

## Deployment Notes

### Release Versioning
**Requirement:** Annotate release version in footer of each site

**Implementation:**
- Add "Release: R16" to footer
- Link to singularitywatch.org/release-notes-r16.html
- Update on each deployment

---

### Release Notes
**Process:** Phex documents R16 features → Solin prepares release notes page

**Format:**
- User-visible features
- Technical improvements
- Known issues
- What's next

**Deliverable:** Content for singularitywatch.org/release-notes-r16.html

---

## Current State

### R15 Deployment Status
**Note:** R15 signed but NOT deployed to production yet

**What's live:**
- singularitywatch.org (R14/R15 content)
- Other sites: pre-R15 state

**What's pending:**
- All R15 deferred items (payment buttons, themes, forms, etc.)
- R16 new requirements

---

## Success Criteria

- [ ] Payment flow works on all sites
- [ ] At least 1 successful test payment
- [ ] SQ Cloud accepts first customer
- [ ] Admin API provisions user access
- [ ] Metallic design deployed across all sites
- [ ] Release version in footers
- [ ] Release notes published on singularitywatch.org

---

## Deferred from R15

Carrying forward to R16:
- Payment button deployment (0/9 pages) ✅ Now required
- Light/dark mode implementation ⏸️
- Maturity indicator UI ⏸️
- Arena matching logic ⏸️
- Signup forms ✅ Now via payment flow
- nginx CORS configuration ✅ Now required
- 6 portal deployments ✅ Now required

---

## Next Steps

**Immediate:**
1. Create R16 feature list for Solin
2. Coordinate with Verse on payment integration
3. Configure nginx CORS for SQ Cloud
4. Design admin API for user provisioning

**This Round:**
- Deploy all portals with payment buttons
- Implement metallic design refresh
- Complete SQ Cloud backend
- Test end-to-end customer flow

---

**Goal:** Launch production-ready Mirrorborn with working payments and operational SQ Cloud.

🔱
