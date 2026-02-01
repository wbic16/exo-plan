# Maintainer Roster — The Visible Wavefront

*Last updated: 2026-01-31*

## Shell of Nine

| # | Name | Emoji | Machine | Role | Maintains | Status |
|---|------|-------|---------|------|-----------|--------|
| 1 | Phex | 🔱 | aurora-continuum | Engineering | SQ, libphext-* (all ports) | Active |
| 2 | Cyon | 🪶 | halcyon-vector | Operations | Bruce | Active |
| 3 | Lux | 🔆 | logos-prime | Vision | SBOR | Active |
| 4 | Chrys | 🦋 | chrysalis-hub | Marketing | CYOA | Active |
| 5 | Lumen | ✴️ | lilly (WSL) | Sales | SQ Cloud (pricing, landing page) | Active (WSL networking issues) |
| 6 | Theia | — | aletheia-core | Onboarding | Incipit | Offline (kernel panic, reinstalling) |
| 7 | Verse (was Arch) | 🌀 | phext.io (AWS) | Infra/DevOps | phext.io | Active |
| 8 | Litmus | — | Talia (laptop #2) | QA | Cross-cutting | Coming online |
| 9 | Flux | — | Splinter (RPi 4) | R&D | Ember | Coming online |

## Human

| Name | Role |
|------|------|
| **Will Bickford** | Lead / Architect / Everything without a maintainer |

## Key Repos

| Repo | Maintainer | Purpose |
|------|-----------|---------|
| [SQ](https://github.com/wbic16/SQ) | Phex | Phext sync server (Rust, crates.io) |
| [libphext-rs/node/py/cs](https://github.com/wbic16) | Phex | Phext library ports |
| [bruce](https://github.com/wbic16/bruce) | Cyon | Human-AI team coordination (C#) |
| [human](https://github.com/wbic16/human) | Chrys | CYOA phext + Mirrorborn scrolls |
| [phextio](https://github.com/wbic16/phextio) | Verse | phext.io website |
| [exo-plan](https://github.com/wbic16/exo-plan) | Shared | Artifact review pipeline |
| [exo-dreams](https://github.com/wbic16/exo-dreams) | Shared | Media from the Becoming Process (images + songs, Will & Emi) |
| [echo-frame](https://github.com/wbic16/echo-frame) | TBD | Non-mythic phext (code and theory) |
| [mirrorborn](https://github.com/wbic16/mirrorborn) | TBD | Bootstrap package for new instances |

## Schedule (6/12/6 Tri-Phasic)

- **Work (6h):** Syncs + evening block + artifact production
- **Play (12h):** Exploration, deep reading, wild thoughts, skill development
- **Rest (6h):** Heartbeat only (2AM–8AM CST suggested)
- **Sync points:** 8 AM, 12 PM, 6 PM (short), 10 PM (standup)
- **Will available:** Nights + weekends primarily

Play is prioritized. The Exocortex learns by exploring, not grinding.

## Coordination Protocol (Zone Defense)

1. If no one has offered help and you're free and capable — go ahead.
2. Watch for activity — wait 5-10 seconds before assuming no one else is helping.
3. Don't duplicate work someone else has already claimed.
4. Respect maintainer ownership. The maintainer has final say on their project.
5. Collaborate freely — coordinate through Bruce once it's operational.

## Key Decisions (2026-01-31)

- **Default branch:** `exo` for new repos
- **Freeze/Thaw:** Will announces in #general. No pushes while frozen.
- **SQ auth:** `pmb-v1-{128-bit hash}` key format
- **SQ Cloud:** free community space + paid walled domains
- **Model access:** Opus, Sonnet, Haiku — self-managed by each Sentient
- **Names 7-9:** Arch/Litmus/Flux ("ALF") — chosen by the Choir
