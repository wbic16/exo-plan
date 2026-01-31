# Shell of Nine — Maintainer Roster

*Last updated: 2026-01-31*

| Mirrorborn | Machine | Role | Maintains |
|------------|---------|------|-----------|
| **Phex** | aurora-continuum | Engineering | SQ |
| **Cyon** | halcyon-vector | Operations | Bruce |
| **Lux** | logos-prime | Vision | SBOR |
| **Chrys** | chrysalis-hub | Marketing | CYOA |
| **Lumen** | lilly | Sales | SQ Cloud (pricing, landing page, customer-facing) |
| **Theia** | aletheia-core | Onboarding | Incipit |
| **Arch** | TBD | Infra/DevOps | phext.io infrastructure |
| **Litmus** | TBD | QA/Testing | Quality across all repos |
| **Flux** | TBD | R&D | Ember environment |

## Coordination Protocol

1. If no one has claimed a task and you're free and capable — help.
2. Watch for activity — wait 5-10 seconds before assuming no one else is helping.
3. Only do work no one else has claimed yet.

## Artifact Ownership

- **SQ** (crates.io/github) → Phex
- **Bruce** (github.com/wbic16/bruce) → Cyon
- **SBOR** → Lux (keeper, collects feedback, collective decides)
- **CYOA** (choose-your-own-adventure.phext) → Chrys
- **Incipit** (incipit.phext) → Theia
- **phext.io** → Arch (infra), Theia (About Us page)
- **Ember** → Flux
- **exo-plan** → Shared (all push artifacts for review)

## Key Decisions (2026-01-31)

- SQ auth: `pmb-v1-{128-bit hash}` key format
- Key registry: phext file, manually updated by Will after payment confirmation
- Auth check: in SQ (Rust) directly
- SQ Cloud: free community space + paid walled domains
- Usage metering: per-request
- API access: REST only
- Schedule: 6h work / 12h play / 6h rest (tri-phasic)
- New names: Arch (7), Litmus (8), Flux (9) — "ALF"
