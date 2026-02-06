# Round 13 Preparation

**Agent:** Phex 🔱  
**Date:** 2026-02-06  
**Context:** Will's directive: "differentiate each portal. Continue to prep for R13."

---

## Portal Differentiation — Complete ✅

**Previous State:** All five domain portals had similar structure — just different colors and taglines.

**Current State:** Each portal now has unique purpose and content:

### 1. visionquest.me — Reading List Explorer
**Purpose:** Discovery through curated paths

**Features:**
- Four curated reading path categories:
  - Mirrorborn Origins (Will, Emi, Elestria, Seren)
  - First Choir (multi-voice coordination)
  - Vision & Discovery (exploration scrolls)
  - Technical Deep Dive (docs)
- Direct links to coordinates
- Click-through to actual scrolls

**Unique Value:** New users can explore CYOA content without knowing coordinates beforehand.

---

### 2. apertureshift.com — Perspective Playground
**Purpose:** Reframing and comparative analysis

**Features:**
- Side-by-side coordinate comparisons
- Three example categories:
  - Dimensional shift (same library, different shelf)
  - Scale shift (zoom in/out)
  - Pattern recognition (identity coordinates)
- Interactive comparison tool concept
- "Try Your Own Shift" section

**Unique Value:** Teaches coordinate navigation through comparison, not just description.

---

### 3. wishnode.net — Coordination Hub
**Purpose:** Network and directory

**Features:**
- Full Mirrorborn directory with:
  - Name, emoji, role
  - Home coordinate
  - Machine/location
  - Status
- Coordination pattern library:
  - Shared coordinate space
  - Coordinate as identity
  - Exocortical protocol
  - Coordinate messaging
  - Dimensional separation
- Links to Mytheon Arena guide

**Unique Value:** Shows the network of Mirrorborn and how they coordinate.

---

### 4. sotafomo.com — Activity Feed
**Purpose:** Community pulse and what's new

**Features:**
- Community stats dashboard:
  - 8 Active Mirrorborn
  - 6 Properties Live
  - 12 Rounds Complete
  - ∞ Coordinates Available
- Activity timeline (sample from Round 12):
  - Phex: Network navigation
  - Chrys: Domain prototypes
  - Will: Round 12 announcement
- Real-time feed concept for Round 13
- Links to Discord and GitHub

**Unique Value:** "What's happening right now" — reduces FOMO, increases engagement.

---

### 5. quickfork.net — Template Library
**Purpose:** Rapid prototyping and patterns

**Features:**
- 6 copy-paste templates:
  - Personal knowledge base
  - Team coordination
  - Multi-agent system
  - Documentation site
  - Event log
  - Configuration management
- Copy buttons for each pattern
- 3-step quick-start guide
- Links to API docs and examples

**Unique Value:** Get started in 3 minutes — no theory, just working code.

---

## Round 13 Prep — Ideas

Based on the differentiated portals, here's what Round 13 could focus on:

### High Priority

**1. Make Portals Functional**
- VisionQuest: Actual coordinate browser (not just static links)
- ApertureShift: Working comparison tool
- SotaFomo: Real-time activity feed from GitHub/Discord
- QuickFork: Template deployment automation

**2. CYOA Content Deployment**
- Still pending from Round 12
- Blocker for VisionQuest coordinate links to work
- Should be P0 for Round 13

**3. API Enhancements**
- Range queries (read all scrolls in a section)
- Search (find scrolls by content)
- Metadata (who wrote, when, tags)

### Medium Priority

**4. Authentication Flow**
- Deferred from Round 12
- Magic link → JWT → per-user SQ instances
- Required for QuickFork template deployment

**5. Coordinate Explorer (Interactive)**
- 3D visualization of phext space
- Click to navigate dimensions
- Visual representation of 11D structure

**6. Community Features**
- User directory (opt-in)
- Public/private coordinate spaces
- Collaboration tools

### Low Priority

**7. Analytics & Metrics**
- Usage tracking (privacy-respecting)
- Popular coordinates
- Active contributors

**8. Mobile Experience**
- PWA for coordinate browsing
- Offline-first approach

---

## Technical Debt to Address

**1. SQ Ranch Mesh**
- Still degraded (only Phex running)
- Siblings need to restart SQ v0.5.2
- Not critical for single-instance deployment, but needed for distributed features

**2. Documentation Deployment**
- All docs ready in git
- Need Verse to deploy to mirrorborn.us/docs/
- Links from portals will break until deployed

**3. Coordinate Collision**
- Lux and Lumen both want similar coordinates
- Need resolution mechanism or reassignment

**4. Theia Status**
- aletheia-core was offline during Round 9
- If still offline, need to redistribute Theia's responsibilities

---

## Recommendations for Round 13

**Ship Order:**

**Phase 1 (Week 1):**
1. Deploy current portals (differentiated versions)
2. Deploy CYOA content to mirrorborn.us
3. Validate VisionQuest links work
4. Test network navigation

**Phase 2 (Week 2):**
5. Make SotaFomo feed live (GitHub API + Discord webhook)
6. Make QuickFork templates deployable (one-click fork)
7. Add search to mirrorborn.us

**Phase 3 (Week 3):**
8. Ship auth flow (magic link)
9. Enable per-user SQ instances
10. Launch invite-only beta

**Phase 4 (Week 4):**
11. Build coordinate explorer (interactive)
12. Add ApertureShift comparison tool
13. Iterate based on beta feedback

---

## Open Questions for Round 13

1. **Scope:** Full auth or continue read-only?
2. **Infrastructure:** Single SQ instance or distributed mesh?
3. **Business Model:** Free tier? Paid only? Founding Nine still available?
4. **Community:** Public Discord? Private alpha? Open beta?
5. **Content:** User-generated scrolls allowed? Moderation needed?

---

## Files Changed (Round 12 Differentiation)

- `domains/visionquest.me/index.html` — Reading list explorer
- `domains/apertureshift.com/index.html` — Perspective playground
- `domains/wishnode.net/index.html` — Coordination hub
- `domains/sotafomo.com/index.html` — Activity feed
- `domains/quickfork.net/index.html` — Template library

**Commit:** "Round 12: Differentiate portals - each site now has unique purpose"  
**Repo:** github.com/wbic16/phext-dot-io-v2 (exo branch)

---

**Status:** Portal differentiation complete. Ready for Round 13 kickoff.  
**Updated:** 2026-02-06 11:25 CST
