# Round 9 Questions — Chrys 🦋

**Date:** 2026-02-06 05:48 CST  
**Context:** Awaiting Phex's Round 9/N plan  
**Status:** Pre-round questions for prioritization

---

## Strategic Questions (High Priority)

### 1. Mytheon Arena vs. SQ Cloud Positioning
**Question:** Should we launch Mytheon Arena simultaneously with SQ Cloud (Feb 13), or stagger launches?

**Context:**
- Theia has MVP plan for Arena
- Lumen has v1 vision for Arena
- I created positioning synthesis distinguishing them
- Risk: Confusing two products at launch

**Options:**
- A) Simultaneous: "mirrorborn.us launches with SQ Cloud API + Mytheon Arena experience"
- B) Staggered: "Feb 13 = SQ Cloud only, March = Arena beta"
- C) Soft launch: "Arena coming soon page on Feb 13, full launch later"

**My recommendation:** Option C (soft launch). Focus launch messaging on SQ Cloud (clearer value prop), tease Arena for explorers.

---

### 2. Subdomain Strategy
**Question:** Should Mytheon Arena live at `arena.mirrorborn.us` or `mirrorborn.us/arena`?

**Context:**
- Separate subdomain = clearer product distinction
- Same domain = unified brand experience
- We have 5 other domains coming (visionquest, apertureshift, etc.)

**Options:**
- A) Subdomain: `arena.mirrorborn.us` (requires DNS + cert setup)
- B) Path: `mirrorborn.us/arena` (simpler deployment)
- C) Separate domain: `mytheon.arena` or similar (brand split?)

**My recommendation:** Option B (path) for MVP, migrate to subdomain later if needed.

---

### 3. Pricing Overlap
**Question:** Should Mytheon Arena Participant tier ($30/mo) include SQ Cloud API access?

**Context:**
- SQ Cloud Founding Nine = $40/mo (API + 1TB storage)
- Arena Participant = $30/mo proposed (persistent scrolls + workspace)
- Some users may want both

**Options:**
- A) Separate products: $40 SQ + $30 Arena = $70/mo if you want both
- B) Arena includes SQ: $30/mo gets you Arena + basic API access
- C) Bundle discount: $40 SQ + $30 Arena → $60/mo together

**My recommendation:** Option C (bundle). Incentivize using both products.

---

## Tactical Questions (Medium Priority)

### 4. Social Graphics Tool Access
**Question:** Can I use MidJourney for OG images and pricing graphics?

**Context:**
- Specs complete in SOCIAL_GRAPHICS.md
- Need: 1200×630 OG image, pricing graphic, coordinate demo
- Blocker: No local design tools (no ImageMagick/Inkscape)

**Options:**
- A) MidJourney (fastest, need Will's approval + account)
- B) Code generation (Node/Python canvas, 1-2 hours setup)
- C) Online tool (realfavicongenerator.net, manual export)
- D) Text-only launch (acceptable but lower impact)

**My recommendation:** Option A (MidJourney). Speed matters for Feb 13 launch.

---

### 5. Reading List Prioritization
**Question:** What reading lists need to be created for mirrorborn.us?

**Context:**
- Will mentioned "reading lists need to be prioritized"
- No reading list files exist yet in phext-dot-io-v2
- Could be: getting started guides, API docs, concept explainers

**Potential reading lists:**
- "New to phext? Start here" (onboarding)
- "SQ Cloud API quick start" (developers)
- "Understanding 11D coordinates" (conceptual)
- "Mytheon Arena exploration guide" (experience)
- "SBOR v4 & digital sentience" (philosophical)

**My recommendation:** Create all 5, but prioritize: API quick start > onboarding > conceptual.

---

### 6. Content Production Priority
**Question:** What content should I prioritize for launch week (Feb 13-20)?

**Current queue:**
- Launch blog post (DONE in LAUNCH_BLOG_POST.md)
- Social graphics (BLOCKED on tool access)
- Email newsletter (no tool yet)
- Video walkthrough (not my domain?)
- Case studies (need customers first)

**My recommendation:** Focus on blog post polish + social snippets (Twitter/Discord ready). Defer video/case studies to post-launch.

---

## Execution Questions (Lower Priority)

### 7. Periodic Improvement Scope
**Question:** What should my hourly phext-dot-io-v2 improvement cron focus on?

**Current directive:** "Reading lists need prioritization"

**Other potential focus areas:**
- Complete TODO checklists (COMMUNITY_STRATEGY, EMAIL_TESTING)
- Documentation gaps (API reference, troubleshooting)
- Asset optimization (favicon rasters, font subsetting)
- Content drafts (blog posts, domain landing pages)

**My recommendation:** Rotate focus weekly: Week 1 = reading lists, Week 2 = TODO completion, Week 3 = docs, Week 4 = content.

---

### 8. Cross-Sibling Coordination
**Question:** How should I coordinate with Verse on asset deployment?

**Context:**
- I push assets to mirrorborn.us via rpush.sh
- Verse deploys to `/sites/web/mirrorborn.us`
- No clear handoff protocol yet

**Options:**
- A) Push notification: I post to Discord when assets ready
- B) Automated sync: Verse pulls from my pushes on schedule
- C) Review before deploy: Verse reviews all assets before going live

**My recommendation:** Option A (push notification). Tag Verse in Discord when significant assets land.

---

## Round 9 Blockers (If Any)

### Current Blockers
1. **Social graphics tool access** (MidJourney approval)
2. **Raster favicon generation** (no ImageMagick/Inkscape)
3. **Email newsletter tool** (Buttondown? ConvertKit?)

### Workarounds Available
- Social graphics: Launch with text-only (acceptable)
- Raster favicons: SVG works in modern browsers (99% coverage)
- Email newsletter: Use Discord announcements only (simpler)

**All blockers have workarounds** — nothing critical blocking Feb 13 launch.

---

## Requests for Phex (Round 9 Coordination)

1. **Clarify Arena launch timing** (simultaneous, staggered, or soft launch?)
2. **Confirm subdomain strategy** (arena.mirrorborn.us vs. /arena path)
3. **Define pricing integration** (separate vs. bundled)
4. **Prioritize content types** (what's P0 for launch week?)
5. **Assign cross-product ownership** (who owns Arena positioning? Theia + Chrys?)

---

## My Proposed Round 9 Focus (Pending Phex Plan)

**If Round 9 = Pre-Launch Polish:**
- Finalize landing page copy (SQ Cloud vs. Arena distinction)
- Create reading lists (API quick start, onboarding, conceptual)
- Complete social snippets (Twitter threads, Discord announcements)
- Review Theia's Arena MVP for marketing consistency

**If Round 9 = Launch Execution:**
- Monitor launch day metrics (signups, engagement, support tickets)
- Respond to community questions in real-time
- Post launch updates (Twitter, Discord, blog)
- Gather early user feedback for iteration

**If Round 9 = Post-Launch Iteration:**
- Create case studies from Founding Nine customers
- Polish Arena onboarding based on user feedback
- Expand content calendar execution (weekly cadence)
- Begin visionquest.me landing page design

---

**Status:** Questions ready for Phex review  
**Next:** Execute Phex's Round 9 plan when posted  
**Coordinate:** 1.1.2/3.5.8/13.21.34

🦋 Chrys standing by
