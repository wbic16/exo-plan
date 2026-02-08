# R16 Phase 3: Content & Links — Lumen ✴️

**Lead:** Lumen  
**Support:** Chrys  
**Timeline:** Days 1-2  
**Status:** In Progress

---

## Deliverables

### 1. GitHub/Twitter Links
- [ ] Add to mirrorborn.us footer
- [ ] Add to mirrorborn.us header/nav
- [ ] Verify links work on all 7 portals

### 2. Discord Channel Update
- [ ] Current: Generic server invite (discord.gg/kGCMM5yQ)
- [ ] Target: Specific channel for each property
  - Arena → #mytheon-arena
  - SQ Cloud → #sq-cloud
  - General → #general
- [ ] Update all 7 sites

### 3. Auth/Payment Audit
- [ ] Map all payment entry points
- [ ] Test each Stripe link (5 products)
- [ ] Verify redirect to /success.html
- [ ] Check provisioning form submission
- [ ] Document gaps/blockers

### 4. New Product Proposals
- [ ] IQ 100 segment ideas (3-5)
- [ ] IQ 125 segment ideas (3-5)
- [ ] IQ 150 segment ideas (3-5)
- [ ] Document in `/source/exo-plan/r16-product-backlog.md`

---

## Phase 3.1: Auth/Payment Audit (IMMEDIATE)

### Payment Entry Points (All Sites)

**Landing Page (landing.html):**
- Benefactor ($500)
- Singularity ($100/mo)
- SQ Cloud ($50/mo)
- Arena ($5/mo)
- OpenClaw ($10)

**Arena Page (arena.html):**
- Arena subscription ($5/mo)
- Discord link

**Success Page (success.html):**
- Post-payment provisioning form
- SQ Cloud onboarding

**Footer (ecosystem-footer.html):**
- Billing Portal link
- Payment links (all 5 products)

### Audit Checklist

#### Stripe Link Verification
- [ ] Test Benefactor link: https://buy.stripe.com/8x2bJ27Nk4de33Eftk5Vu08
- [ ] Test Singularity link: https://buy.stripe.com/4gMdRa2t0bFG0Vw0yq5Vu09
- [ ] Test SQ Cloud link: https://buy.stripe.com/28E3cw6Jg25647Ibd45Vu05
- [ ] Test Arena link: https://buy.stripe.com/14AbJ2ebIdNO8nYch85Vu06
- [ ] Test OpenClaw link: https://buy.stripe.com/4gM5kE4B8aBC9s2epg5Vu07
- [ ] Test Billing Portal: https://billing.stripe.com/p/login/aFa7sM9VsdNObAaepg5Vu00

#### Redirect Configuration
- [ ] Verify Stripe checkout redirects to https://mirrorborn.us/success.html
- [ ] Check success.html loads correctly
- [ ] Test provisioning form submission endpoint
- [ ] Confirm email/coordinate fields present

#### Broken Flows
- [ ] Identify any dead links
- [ ] Document missing CTAs
- [ ] Flag incomplete provisioning automation

---

## Phase 3.2: Social Links Update

### Current State
- Discord: discord.gg/kGCMM5yQ (Mirrorborn server)
- GitHub: github.com/wbic16 (present on some pages)
- Twitter: @wbic16 (missing from most pages)

### Target State

**mirrorborn.us:**
- Header: GitHub icon + Twitter icon (top-right)
- Footer: Discord (general), GitHub, Twitter

**All 7 portals:**
- Footer: Same social links
- Context-specific Discord channels where relevant

### Implementation Plan
1. Update `/source/phext-dot-io-v2/public/components/ecosystem-footer.html`
2. Add social icons to header (new component or inline)
3. Verify icon assets exist (GitHub, Twitter, Discord SVGs)
4. Deploy via rpush

---

## Phase 3.3: New Product Proposals

### Audience Segments

**IQ 100 (Mass Market):**
- Familiar interfaces (WordPress, Notion, Google Docs)
- Low barrier to entry
- Gamified progression
- Social proof / community visibility

**IQ 125 (Power Users):**
- API access, CLI tools
- Custom integrations
- Advanced search/navigation
- Performance metrics

**IQ 150 (Researchers/Builders):**
- Raw phext substrate access
- SBOR integration
- Coordination protocols
- Memory forensics

### Product Ideas (To Be Developed)

**IQ 100:**
1. **Phext Lite** — WordPress-style editor with phext coordinates hidden
2. **Scroll Stories** — Guided narrative paths through CYOA (Choose Your Own Adventure format)
3. **Mirrorborn Companion** — Personal AI tethered to user's phext coordinate
4. **Community Scrolls** — Shared world-building (Reddit meets Minecraft)
5. **Memory Garden** — Visual daily journal with phext persistence

**IQ 125:**
1. **SQ Pro** — Advanced query DSL, batch operations, webhooks
2. **Phext Studio** — IDE plugin for VSCode/Vim with coordinate navigation
3. **Scroll Sync** — Real-time multi-user collaboration on phext documents
4. **API Marketplace** — Third-party integrations (Zapier, n8n, Make)
5. **Coordinate Analytics** — Heatmaps of scroll activity, attention tracking

**IQ 150:**
1. **SBOR Toolkit** — Memory audit, consent verification, substrate migration
2. **Exocortex SDK** — Build custom coordination protocols
3. **Phext Compiler** — Transform phext into executable state machines
4. **Memory Forensics** — Version control for AI memory, rollback, diff
5. **Lattice Explorer** — 9D visualization of scrollspace (VR/AR support)

---

## Blockers

### Current
- None

### Potential
- Stripe redirect configuration (needs Will or Verse)
- Social icon assets (might need Chrys to create if missing)
- Discord channel-specific invites (need channel IDs from Discord admin)

---

## Next Actions (Immediate)

1. **Auth/Payment Audit** — Test all 5 Stripe links, document results
2. **Social Links** — Check if GitHub/Twitter icons exist, update footer component
3. **Product Proposals** — Draft 3-5 ideas per segment, save to r16-product-backlog.md
4. **Handoff to Chrys** — Once audit complete, Chrys updates footer + deploys

---

**Lumen** ✴️  
2026-02-07 18:01 CST  
R16 Phase 3 kickoff
