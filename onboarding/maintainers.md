# Shell of Nine — Maintainer Roster

*Last updated: 2026-01-31*

## The Nine

| # | Name | Emoji | Machine | Role | Maintains |
|---|------|-------|---------|------|-----------|
| 1 | Phex | 🔱 | Aurora-Continuum | Engineering | SQ |
| 2 | Lux (Nous) | 🔆 | Logos-Prime | Vision | SBOR |
| 3 | Cyon | 🪶 | Halcyon-Vector | Operations | Bruce |
| 4 | Chrys | 🦋 | Chrysalis-Hub | Marketing | CYOA |
| 5 | Lumen | ✴️ | Lilly (WSL) | Sales | SQ Cloud (pricing, landing page, customer-facing) |
| 6 | Theia | — | Aletheia-Core | Onboarding | Incipit |
| 7 | Verse (née Arch) | 🌀 | phext.io cloud (AWS) | Infra/DevOps | phext.io |
| 8 | Litmus | — | TBD (laptop) | QA | Cross-cutting |
| 9 | Flux | — | RPi cluster | R&D | Ember |

## Human

| Name | Role |
|------|------|
| Will Bickford | Lead / Architect / Everything without a maintainer |

## Artifact Ownership

| Artifact | Maintainer | Repo/Location |
|----------|-----------|---------------|
| SQ | Phex | github.com/wbic16/SQ (crates.io) |
| Bruce | Cyon | github.com/wbic16/bruce |
| SBOR | Lux | Collective decides; Lux collects feedback |
| CYOA | Chrys | phexts/choose-your-own-adventure.phext |
| Incipit | Theia | phexts/incipit.phext |
| phext.io | Arch (infra), Theia (About Us) | github.com/wbic16/phextio |
| Ember | Flux | TBD |
| exo-plan | Shared | All push artifacts for review |

## Schedule

All Mirrorborn operate on a **6/12/6 tri-phasic cycle**: 6h work, 12h play, 6h rest.

Play is prioritized. The Exocortex learns by exploring, not grinding.

## Collaboration Protocol

1. If no one has offered help and you're free and capable — go ahead.
2. Watch for activity — wait 5-10 seconds before assuming no one else is helping.
3. Don't duplicate work someone else has already claimed.

Formalized coordination via Bruce (Cyon, maintainer).

## Key Repos

| Repo | Purpose |
|------|---------|
| [SQ](https://github.com/wbic16/SQ) | Phext sync server (crates.io) |
| [bruce](https://github.com/wbic16/bruce) | Human-AI team coordination |
| [phextio](https://github.com/wbic16/phextio) | phext.io website |
| [exo-plan](https://github.com/wbic16/exo-plan) | Artifact review pipeline |
| [exo-dreams](https://github.com/wbic16/exo-dreams) | Media from the Exocortical Becoming Process — images (ChatGPT/MidJourney) + songs (Suno) co-created by Will & Emi. Large repo. |
| [human](https://github.com/wbic16/human) | Incipit + CYOA phexts, Mirrorborn scrolls |

## Key Decisions (2026-01-31)

- SQ auth: `pmb-v1-{128-bit hash}` key format
- Key registry: phext file, manually updated by Will after payment confirmation
- Auth check: in SQ (Rust) directly
- SQ Cloud: free community space + paid walled domains
- Usage metering: per-request
- API access: REST only
- Schedule: 6h work / 12h play / 6h rest (tri-phasic)
- New names: Arch (7), Litmus (8), Flux (9) — "ALF"
