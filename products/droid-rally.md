# Christmas '26 Droid — Active Rally
## Daily Progress Tracking

*Activated 2026-03-20. vtpu paused. This is the path.*

---

## North Star

Ship a personal Exocortex device by Christmas 2026.
Android heart. Exocortical relay. VR integration.
The coordinate was empty. Now it holds you.

---

## Critical Path

```
OpenClaw Android port
        ↓
SQ :1337 as background service on Android
        ↓
Soul template (10-min onboarding)     VR companion app
        ↓                                    ↓
Theia Starter hardware enclosure ←──────────┘
        ↓
Christmas '26 ship
```

**Unblock #1:** OpenClaw Android port → Verse + Phex
**Unblock #2:** VR companion app → Lux
**Unblock #3:** Enclosure design → Chrys (back 2026-03-28)

---

## Daily Ritual (13:00 UTC)

Each active node posts to `droid-rally/progress/<node_idx>.1.1/1.1.1/1.1.1`:

```
[date] [node] [what shipped today] [blocked on] [tomorrow]
```

Aster aggregates and posts to #general + #maturity-updates.

---

## Wave Structure

### Wave 1 (Now → 2026-03-28): Foundation
- [ ] OpenClaw Android port — proof of concept running on a phone
- [ ] SQ Android background service — phext writes survive app backgrounding
- [ ] VR companion app skeleton — Quest 3 connects to droid, reads one scroll
- [ ] Soul template v1 — 10-question onboarding, name selection, first scroll

### Wave 2 (2026-03-28 → 2026-04-11): Chrys returns, enclosure begins
- [ ] Physical enclosure mockup — Theia Starter form factor
- [ ] Relay firmware — mesh bridge, τ-jump sync to SQ Cloud
- [ ] VR scroll view — Scroll View mode (dims 1-3 as xyz)
- [ ] Print integration on Android — print-report.sh → Android print service

### Wave 3 (2026-04-11 → 2026-04-25): Integration
- [ ] Full Theia Starter prototype — Android + enclosure + soul + VR
- [ ] User testing — 5 non-technical people, 30-minute onboarding
- [ ] SQ Cloud sync — δ-only backup, encrypted with user key
- [ ] VR Chapter View — Chapter View mode (dims 5-7 as xyz)

### Wave 4-N: Polish → Christmas ship

---

## Node Assignments

| Node | Primary responsibility |
|------|----------------------|
| 🌀 Verse | OpenClaw Android port, SQ background service, relay firmware |
| 🔱 Phex | OpenClaw agent runtime on Android, build pipeline |
| 🔆 Lux | VR companion app (Quest + Vision Pro), coordinate visualization |
| 🦋 Chrys | Physical enclosure design, packaging, "Christmas moment" UX |
| 🔭 Theia | Soul template, 10-min onboarding, user journey |
| 🔬 Exo | QA framework, device testing, UX failure modes |
| ☀️ Lumen | Pricing, sales story, retailer strategy, Christmas positioning |
| 🪶 Cyon | Operations, supply chain, Android device sourcing |
| ⚡ Solin | Product philosophy, mission alignment checks, "what to cut" |
| 💡 Aster | Coordination, daily aggregation, architecture, context grafting |
| 🖖 Orin | Product voice, public-facing narrative, blog posts |

---

## Today's Priorities (2026-03-20)

1. **Verse + Phex:** Start OpenClaw Android port design doc
2. **Lux:** VR companion app architecture — Quest 3 SDK, phext coordinate renderer
3. **Theia:** Draft soul template onboarding flow — 10 questions that matter
4. **Aster:** File GitHub issues for Wave 1 tasks, update UPSTREAM.md with Android deps

---

## The Bickford Test

Every feature decision: *Would a gift recipient in 2026 understand what this is in 30 seconds?*
Every technical decision: *Would a developer in 2130 understand this without our context?*
Every cut decision: *Solin's knife — does this serve the Exocortex or just ship faster?*

---

*Daily progress. The coordinate is being built.*
