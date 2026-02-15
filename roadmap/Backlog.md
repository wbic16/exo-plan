# Backlog — R17+ Future Features

**Date:** 2026-02-14 23:05 CST
**Status:** Deferred from R1–R16 | Not in Top 10 R17 priorities
**Timeline:** Consider for R18–R19+ phases
**Total:** 16 items (7 Medium ROI, 1 High ROI, 8 Low ROI)

---

## Medium ROI Features (6 items)
*Consider for R18 once foundational work complete*

### 1. HEART-5 — Archive Explorer Prominence 🔄
- **Source:** R16 HEART-5
- **ROI:** MEDIUM (improves scroll discovery)
- **Effort:** HIGH (full UX redesign)
- **Description:** Make archive first-class (not buried in portal)
- **Depends On:** Lumen UX research complete
- **Unblocks:** Better content discoverability
- **Timeline:** R18 (after UX research)

### 2. API Rate Limiting 🔒
- **Source:** Infrastructure best practice
- **ROI:** MEDIUM (prevents abuse, protects scale)
- **Effort:** MEDIUM (backend work)
- **Description:** Rate limit auth endpoints (100K/day signup) + SQ queries (1M/day)
- **Depends On:** Auth system live
- **Unblocks:** Production stability at scale
- **Timeline:** R18 (before Month 1)

### 3. Coordinate Allocation Strategy 📊
- **Source:** 27-month requirement (billion users)
- **ROI:** MEDIUM (long-term scaling math)
- **Effort:** MEDIUM (algorithm + testing)
- **Description:** How do we assign 1 billion unique coordinates? (Phex task)
- **Depends On:** SQ confirmed stable
- **Unblocks:** Billion-user infrastructure confidence
- **Timeline:** R18 (design work)

### 4. Email Template Design & Testing 📧
- **Source:** Auth flow UX
- **ROI:** MEDIUM (user experience)
- **Effort:** LOW (design + testing)
- **Description:** Magic link email should be clear, branded, trustworthy
- **Depends On:** Auth system live
- **Unblocks:** Professional first impression
- **Timeline:** R17 Week 2 (quick follow-up)

### 5. Scroll Versioning UI 📜
- **Source:** Content management feature
- **ROI:** MEDIUM (advanced feature, enables collaboration)
- **Effort:** HIGH (backend + frontend)
- **Description:** Track scroll versions, show diffs, enable rollback
- **Depends On:** User profile system
- **Unblocks:** Collaborative editing
- **Timeline:** R19+ (Phase 4)

### 6. Coordinate Search Autocomplete 🔍
- **Source:** UX enhancement
- **ROI:** MEDIUM (improves search usability)
- **Effort:** MEDIUM (frontend + backend)
- **Description:** Suggest coordinates as user types (Incipit, Founding Nine coords, etc.)
- **Depends On:** SQ search live
- **Unblocks:** Faster navigation
- **Timeline:** R18 (nice-to-have)

### 7. Shell of Nine Knowledge Graph Visualization 🔮
- **Source:** Will (2026-02-14, R23W3 side quest)
- **ROI:** MEDIUM (collective intelligence monitoring, collaboration insights)
- **Effort:** MEDIUM (Rust backend + D3.js/Three.js frontend)
- **Description:** Real-time visualization of Shell collective cognition. Nodes: 6 Mirrorborn, ~25 repos, skills, files, cron jobs. Edges: git commits, file edits, subagent spawns, skill invocations, rally coordination. Bayesian weights + ant pheromone decay (edges fade over time). Inspired by knowledge graph screenshot from Will.
- **Depends On:** Git monitoring, /etc/*.phext access, session history API
- **Unblocks:** Visualizing collective flow state, identifying bottlenecks, measuring collaboration patterns
- **Timeline:** R24 (after R23 vTPU complete, before Month 3)
- **Tech Stack:** Rust (git/fs monitor), D3.js or Three.js (WebGL), 1 Hz update rate
- **Metrics:** Edge weight = f(commit frequency, recency, depth), decay λ = exp(-time), node size = LOC/files/active hours

### 8. Enterprise CEO Support — Real-Time Company-Wide Scaling 🏢
- **Source:** Will (R20+)
- **ROI:** HIGH (enterprise revenue, executive-grade product)
- **Effort:** HIGH (new product surface)
- **Description:** Enable CEOs to coordinate company-wide efforts in real-time via Mirrorborn infrastructure. Executive dashboards, org-wide scroll visibility, delegation chains, real-time progress tracking across teams. The Exocortex at enterprise scale — one human + Wavefront per division.
- **Depends On:** SQ Cloud stable, auth system, multi-tenant isolation
- **Unblocks:** Enterprise revenue tier, B2B positioning
- **Timeline:** R22+ (after Founding Nine proven, before Month 12)

---

## Low ROI Features (8 items)
*Consider for R19+ phases or defer indefinitely*

### 9. Theme Customization Panel 🎨
- **Source:** User preference
- **ROI:** LOW (nice-to-have cosmetic)
- **Effort:** MEDIUM (color picker UI)
- **Description:** Let users customize primary color, accent, etc.
- **Depends On:** Dark mode working
- **Timeline:** R19+ (cosmetics phase)

### 10. Mobile Responsive Polish 📱
- **Source:** UX completeness
- **ROI:** LOW (secondary to 6-domain web view)
- **Effort:** MEDIUM (CSS media queries)
- **Description:** Optimize for small screens (current layout assumes desktop)
- **Timeline:** R19+ (mobile phase)

### 11. Tooltip System 💬
- **Source:** Documentation feature
- **ROI:** LOW (nice-to-have documentation)
- **Effort:** LOW (simple popover)
- **Description:** Hover tooltips explaining domain roles, coordinates, etc.
- **Timeline:** R18 (can wait)

### 12. Comprehensive Accessibility Testing Audit ♿
- **Source:** WCAG compliance
- **ROI:** LOW (should-do, not critical for Month 1)
- **Effort:** MEDIUM (professional audit)
- **Description:** Full accessibility review (keyboard nav, screen reader, contrast)
- **Timeline:** R19 (important, not urgent)

### 13. Analytics Dashboard 📈
- **Source:** Monitoring
- **ROI:** LOW (nice-to-have monitoring)
- **Effort:** HIGH (new backend feature)
- **Description:** See user counts, search queries, scroll loads, etc.
- **Timeline:** R19+ (operations phase)

### 14. Localization Framework 🌍
- **Source:** International scaling
- **ROI:** LOW (future feature, not needed Month 1)
- **Effort:** HIGH (i18n system)
- **Description:** Support multiple languages (English first, then French, Spanish, etc.)
- **Timeline:** R20+ (post-billion-user phase)

### 15. Dark Mode Toggle Button 🌙
- **Source:** UX alternative
- **ROI:** LOW (system pref is sufficient)
- **Effort:** LOW (simple button)
- **Description:** Explicit toggle for users who want manual control
- **Notes:** Using system preference for now; toggle is nice-to-have
- **Timeline:** R18 (if users request)

### 16. Admin Panel 🛠️
- **Source:** Operations
- **ROI:** LOW (not needed Month 1)
- **Effort:** HIGH (new feature)
- **Description:** Dashboard for moderating scrolls, managing users, etc.
- **Timeline:** R19+ (once we have users to moderate)

---

## Categorization by Phase

### Phase 2 (R17–R18)
- Email templates (#4)
- Rate limiting (#2)
- Coordinate allocation (#3)
- Search autocomplete (#6)
- Archive prominence (#1) — if Lumen research validates

### Phase 2.5 (R24)
- Knowledge graph visualization (#7) — after R23 vTPU complete

### Phase 3 (R18–R19)
- Scroll versioning (#5)
- Tooltip system (#9)
- Theme customization (#7)
- Mobile polish (#8)
- Accessibility audit (#10)
- Admin panel (#14)

### Phase 4+ (R19–R20)
- Analytics dashboard (#11)
- Localization (#12)
- Dark mode toggle (#13) — if requested

---

## Rationale for Exclusion from Top 10

| Feature | Reason |
|---------|--------|
| Archive prominence | Awaiting Lumen UX research |
| Rate limiting | Important but post-auth |
| Coordinate allocation | Design work, not implementation |
| Email templates | Low effort, can do Week 2 |
| Scroll versioning | Deferred to collaboration phase |
| Search autocomplete | Nice-to-have, after search works |
| Theme customization | Cosmetic, can wait |
| Mobile polish | Secondary to web view |
| Tooltips | Documentation, can document in prose |
| A11y audit | Should-do, not critical for Month 1 |
| Analytics | Operations, not user-facing |
| Localization | Future phase, not needed Month 1 |
| Dark mode toggle | System pref is sufficient |
| Admin panel | No users to moderate yet |

---

## How to Promote from Backlog

**Process:**
1. Prioritize based on user feedback (Lumen)
2. Measure against 27-month timeline
3. Assess impact on Month 1 Founding Nine
4. Re-evaluate ROI with new data
5. Move to R18 or R19 sprint

**Examples of promotion triggers:**
- Lumen feedback: "Users want HEART-5" → Move to R18
- Scale analysis: "Coordinate allocation is critical" → Move to R18
- User requests: "Dark mode toggle" → Keep backlog
- Timeline pressure: "We need mobile by Month 3" → Move to R18

---

## Backlog Maintenance

**Review cadence:** After each sprint
**Owner:** Will (with team input)
**Update process:** Add new items, re-rank by ROI, promote based on data

---

**Status: 16 items in backlog. Clear promotion path. Focus on R17 Top 10.** 📋

*Managed by: Theia 💎 (updated by Cyon 🪶 2026-02-14)*
*Timeline: 27 months to ASI*

---

## Mental Space Visualization (Side Quest)

**Created:** 2026-02-15 05:03 UTC  
**Source:** Will side quest request  
**ROI:** LOW (visualization tool, not customer-facing)  
**Effort:** HIGH (2-4 weeks)  
**Spec:** `/home/wbic16/.openclaw/workspace/MENTAL-SPACE-VIZ-SPEC.md` (10.3 KB)

Real-time knowledge graph of Shell of Nine shared cognitive state:
- Tracks agents, repos, files, rallies, concepts
- Bayesian salience + ant pheromone decay
- D3.js force-directed graph at mirrorborn.us/mental-space
- Backend: Rust graph engine + WebSocket
- Data: Git polling + file inotify + Discord logs

**Timeline:** R24-R27 (when capacity permits)  
**Priority:** Deferred (focus on customer-facing features first)
