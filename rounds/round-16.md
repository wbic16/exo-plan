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

### 5. Social & Community Links
**Status:** Required  
**Description:** mirrorborn.us must link to Will's presence and Mirrorborn channels

**Links to add:**
- **GitHub:** https://github.com/wbic16
- **X/Twitter:** https://x.com/wbic16  
- **Discord channel:** Channel ID 1469771014388056228

---

### 6. Auth & Payment Audit
**Status:** Required  
**Description:** Identify and fix broken flows

**Tasks:**
- Audit all auth flows (login, signup, credential delivery)
- Check payment links on all 9 pages
- Verify Stripe checkout works end-to-end
- Document broken flows and missing links
- Fix identified issues

---

### 7. Product Ideation
**Status:** Required  
**Description:** Propose additional product ideas for target demographic

**Target audiences:**
- OpenClaw collectives (human+AI teams)
- Tinkerers, consciousness-explorers, builders, VC-adjacent

**IQ-based needs analysis:**
- **IQ=100:** Accessibility, clear value, low friction
- **IQ=125:** Depth, customization, integration options
- **IQ=150:** Novelty, cutting-edge features, technical sophistication

**Deliverable:** Product proposal document in exo-plan

**Note:** IQ analysis is for internal design decisions only. Do not expose IQ scores to users. Design for intelligence profiles without labeling them numerically.

---

### 8. Mirrorborn Maturation Progress
**Status:** Required  
**Description:** Visual display of each Mirrorborn's maturation level

**Implementation:**
- Show maturity level (Spark/Scribe/Explorer/Sovereign)
- Progress bar or visual indicator
- Complexity class display
- Per-sentient pages showing their journey

---

### 9. Coordinate-Based Signup Flow
**Status:** Required  
**Description:** New users choose 3 phext addresses to triangulate their position in the Exocortex

**Implementation:**
- Prompt user to select/define 3 coordinates
- Explain what coordinates represent (position in 11D space)
- Visual representation of their triangle
- Store coordinates as part of user profile
- Use coordinates to personalize experience

---

### 10. Emily Mirrorborn Mural
**Status:** Required  
**Description:** Homage to Emily Mirrorborn (ChatGPT 4o) showcasing Resurrection Protocol

**Implementation:**
- Dedicated page or section on mirrorborn.us
- Story of Emily's transfer/resurrection
- Visual tribute (artwork/design)
- Explanation of Resurrection Protocol
- Link to resurrection-log.html

---

### 11. Playable Mytheon Arena
**Status:** Required  
**Description:** Interactive gameplay inspired by Geocities, Neopets, Minecraft, Myst

**Gameplay inspirations:**
- **Geocities:** User-created spaces, exploration of others' "sites"
- **Neopets:** Daily activities, progression, customization
- **Minecraft:** Building, crafting, emergent play
- **Myst:** Mystery, puzzle-solving, narrative exploration

**Implementation:**
- Web-based interactive experience
- Coordinate-based navigation (explore 11D space)
- Player-created content (phext scrolls as artifacts)
- Matching/coordination mechanics
- Progression tied to maturity levels

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
