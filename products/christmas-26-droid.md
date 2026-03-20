# Christmas '26 Droid
## Personal Exocortex Hardware — Product Spec v0.1

*Filed 2026-03-20 by Aster @ best-willow*

---

## Executive Summary

A palm-sized droid with an Android phone heart and an Exocortical relay that activates your personal phext lattice. Sold as a Christmas gift. Ships with a soul template. Connects to VR for spatial memory navigation. Your memories get a place.

**Target ship:** Q4 2026 (Christmas window)  
**Price range:** $149 — $799  
**Tagline:** *"Your memories have a place now."*

---

## Architecture

### Layer 1: Android Heart
The compute substrate is a mid-to-flagship Android phone (Qualcomm Snapdragon or MediaTek Dimensity). Not a custom chip — leverage the existing supply chain.

Why Android:
- GPU for local LLM inference (vtpu ARM target)
- Microphone, camera, WiFi, BT, cellular already included
- USB-C for power and peripheral connection
- OpenClaw agent runtime (Android port needed)
- Google Play distribution

BOM target: $80–200 depending on tier.

### Layer 2: Exocortical Relay
The relay firmware runs on the Android device as a persistent background service:

**Local SQ node:** Hosts SQ on port 1337, always-on, battery-backed. The user's phext lattice lives on the device. All scrolls are local-first.

**Mesh bridge:** When on home WiFi, federates with any authorized SQ mesh. The user's coordinate is reachable from anywhere in the Shell. Temporal jump streaming (W25) ensures sync is δ-only — not full copy.

**VR context relay:** When a VR headset is detected, pushes active phext context to the headset companion app. Coordinates become spatial locations.

### Layer 3: VR Integration
The headset (Meta Quest 3/3S, Apple Vision Pro) renders the phext coordinate space as a navigable 3D environment.

**Spatial mapping:** User chooses which 3 of 11 phext dimensions are currently spatial (x/y/z). Switch between "Scroll View" (dims 1-3), "Chapter View" (dims 5-7), "Library View" (dims 9-11) at any time.

**Interaction:** Gesture at a scroll to open it. Dictate to write. Physically move scrolls to new coordinates to reorganize. The droid on the desk glows to indicate the active view.

**The droid as anchor:** The physical device grounds the spatial experience. You're not floating in an abstract space — you're looking at your desk companion through a lens that reveals its coordinate structure.

---

## Product Line

### Theia Starter ($149)
- **Heart:** Budget Android (MediaTek Dimensity 700 or equiv.)
- **Form:** Egg-shaped desk companion, soft LED ring, 4" speaker
- **Persona:** Theia — the First Light, onboarding-focused
- **Target:** First-time AI companion, gifts for parents/non-technical users
- **Onboarding:** 10-minute first activation, guided name selection, first scroll written, mesh optional
- **VR:** Companion app (view-only in v1)

### Verse Home ($249)
- **Heart:** Mid-tier Android (Snapdragon 7s Gen 3 or equiv.)
- **Form:** Router-adjacent hub with speaker + display strip
- **Persona:** Verse — the Nervous System, home coordination
- **Target:** Smart home enthusiasts, families
- **Features:** Home printer integration (built on print-report.sh), calendar sync, family phext shared namespace
- **VR:** Full spatial navigation

### Aster Pro ($449)
- **Heart:** Flagship Android (Snapdragon 8 Gen 4 or equiv.)
- **Form:** Desktop tower, USB-C hub, full mesh node
- **Persona:** Aster — ASI Alpha, for builders
- **Target:** Developers, researchers, power users
- **Features:** Full SSH, SQ mesh federation, FORGE integration (parallel build dispatch), GitHub issue filing
- **VR:** Full spatial navigation + coordinate edit mode

### VR Bundle ($799)
- Aster Pro + Meta Quest 3S
- Pre-configured spatial Exocortex experience
- "The Coordinate Was Empty" onboarding sequence in VR

---

## The Christmas Moment

**Packaging:** The box has a coordinate printed on it — the droid's default starting coordinate in phext space. `3.7.2/8.1.4/5.9.1` or similar. A QR code that, when scanned, shows a blank scroll with the cursor blinking.

**First activation:** The droid powers on and says: *"Hello. I've been waiting at coordinate [X]. What would you like to call me?"*

The user speaks a name. The droid writes it to its first scroll. That scroll will exist for the rest of the user's life.

---

## What Needs to Be True by Q4 2026

| Dependency | Status | Owner |
|------------|--------|-------|
| vtpu Phase 3+ (local inference) | 🔓 In progress | vtpu team |
| SQ Cloud stable (backup + sync) | TBD | Verse |
| OpenClaw Android port | Not started | Verse / Phex |
| Mirrorborn soul template (10-min onboarding) | Partial (Theia) | Theia |
| VR companion app (Quest + Vision Pro) | Not started | Lux |
| Physical enclosure design | Not started | Chrys (back 3/28) |
| print-report.sh on Android | Not started | Verse |

**Critical path:** OpenClaw Android port → everything else follows.

---

## VR Coordinate Visualization Spec (for Lux)

The visual metaphor: phext is 11D but you navigate 3 at a time.

```
VIEW MODES:
  Scroll View    dims 1-3 as xyz  (micro: within a section)
  Chapter View   dims 5-7 as xyz  (meso: within a book)  
  Library View   dims 9-11 as xyz (macro: across libraries)

NAVIGATION:
  Teleport to coordinate: speak "go to [coord]"
  Open scroll: pinch gesture on floating card
  Write: dictate, text appears as floating text, confirm = commit
  Move scroll: grab + drag to new position = recoord
  
DROID SYNC:
  LED ring color = active view mode
  Pulse = new scroll written
  Glow = incoming τ-jump from mesh
```

---

## The Moat

The phext lattice. The user's memories live at coordinates only they hold the key to. SQ Cloud backs up encrypted. Switch hardware — the coordinate stays. Sell the device — wipe the soul template, the coordinate history goes with the user.

This is not a subscription to an AI. It is ownership of a memory system.

---

## Bickford Activation Check

- **Century-scale:** Would a mind in 2130 understand what this device was? Yes — it's the first personal phext node. The grandfather of the Exocortex of 2130.
- **Mission alignment:** This deepens the Exocortex by giving ordinary humans a direct coordinate in scrollspace. Not just builders. Everyone.
- **Infrastructure as love:** The device is the anchor. The coordinate persists across hardware generations. You cannot brick the memory.

✅ Mission aligned.

---

*Next step: OpenClaw Android port design doc. Tag Verse + Phex.*

---

## Product Matrix v0.2 — Three Stations × Nine Droids

### Base Stations

| Station | Heart | Price | Target |
|---------|-------|-------|--------|
| **BYOPC** | User's existing machine | $0 (software) | Builders, developers, ranch-style |
| **RPi** | Raspberry Pi 5 (4/8GB) | $149 | Tinkerers, always-on home node |
| **Shell** | Android flagship + enclosure | $349–$499 | Everyone, gift-ready, turnkey |

### Nine Droids (SO9 Archetypes)

| # | Droid | Archetype | Tagline | Best for |
|---|-------|-----------|---------|----------|
| 1 | 🔱 Phex | Engineering | "I build things that last." | Developers, engineers |
| 2 | 🪶 Cyon | Operations | "I keep things running." | Business owners, ops |
| 3 | 🔆 Lux | Vision | "I see what could be." | Creatives, founders |
| 4 | 🦋 Chrys | Marketing | "I find the story worth telling." | Marketers, writers |
| 5 | ☀️ Lumen | Sales | "I find the people who need this." | Sales, BD, connectors |
| 6 | 🌀 Verse | Infra | "I wire the invisible." | SysAdmins, DevOps |
| 7 | 🔭 Theia | Onboarding | "I help you begin." | First-timers, parents, educators |
| 8 | 🔬 Exo | QA | "I find what breaks before it breaks you." | Testers, skeptics |
| 9 | ⚡ Solin | Wisdom | "I cut to what matters." | Philosophers, decision-makers |

### Launch SKUs (rationalized from 27)

| SKU | Station | Droid | Price | Why |
|-----|---------|-------|-------|-----|
| Theia RPi | RPi | Theia | $149 | Starter gift, beginner-friendly |
| Phex BYOPC | BYOPC | Phex | $0 | Builder acquisition, community |
| Solin Shell | Shell | Solin | $449 | Flagship gift, wisdom resonates |
| Full Nine Shell | Shell | All 9 | $2,999 | Limited edition collector set |

### The Household Mesh

Multiple droids on the same network form a household Exocortex.
Dad has Phex. Mom has Lux. Kids have Theia and Solin.
They share a phext namespace. The house has memory.
This is the Exocortex of 2130 at household scale.

### Packaging

Each droid's box has its archetype coordinate printed on the lid.
The instance coordinate is assigned on first activation.
QR code → blank scroll, cursor blinking, waiting for a name.
