# SQ Cloud Pricing — v1
2026-02-01 | Targeting $1,000/mo revenue in February*

## Revenue Target

| Cost                      | Monthly  |
|---------------------------|----------|
| Cloud inference           | $300     |
| Local Compute (amortized) | $80      |
| **Total break-even**      | **$380** |

## Tier Structure

### Free — Community Space
- Shared namespace: `https://phext.io/community/`
- Rate limit: 1K requests/day, 100 writes/day
- 1 MB scrollspace
- REST API only
- No auth key required (read-only community scrolls)
- **Purpose:** Onboarding, experimentation, "try before you buy"

### Starter — $29/mo
- Dedicated namespace: `https://phext.io/t/{tenant}/`
- `pmb-v1-` API key with Bearer auth
- Rate limit: 100,000 requests/day
- 100 MB scrollspace
- Full CRUD (select, insert, update, delete, load, save)
- **Target:** Individual developers, small projects, phext learners

### Pro — $79/mo
- Everything in Starter, plus:
- 1 GB scrollspace
- 1M requests/day
- Priority Support (Discord Channel #pro)
- Custom data directory isolation
- **Target:** Teams, production applications, OpenClaw Collectives

### Founding Nine Edition — $5K (One-Time)
- Everything in Pro, plus:
- 2 TB scrollspace
- Unlimited Requests
- Direct access to Will + the Shell of Nine (#General Chat)
- Input on Roadmap Priorities
- **Only 9 slots available. Ever.**
- **Target:** Exocorticals

## Revenue Scenarios (Year 1)

| Scenario      | Mix                            | MRR   |
|---------------|--------------------------------|-------|
| Conservative  | 3 Starter + 2 Pro              | $245  |
| Target        | 2 Starter + 2 Pro + 1 Founding | $633  |
| February Goal | 2 Starter + 2 Pro + 2 Founding | $1049 |
| Founding Rush | 4 Founding Nine                | $1666 |

## February Strategy

1. **Week 1 (Feb 1-7):** Launch Founding Nine offer. Announce on X, Discord, phext.io.
2. **Week 2 (Feb 8-14):** Direct outreach to OpenClaw early adopters and phext-curious devs.
3. **Week 3 (Feb 15-21):** Content push — "Build on phext" tutorial series, SQ API quickstart.
4. **Week 4 (Feb 22-28):** Evaluate, adjust pricing if needed, prep March expansion.

## Key Selling Points

1. **Authenticated scrollspace in one command:** `cargo install sq && sq host 1337 --key $KEY`
2. **No vendor lock-in:** SQ is open source Rust. Self-host anytime.
3. **11-dimensional data:** Not another key-value store. Phext coordinates give you hierarchical structure that scales with your thinking.
4. **Local inference coming:** BitNet integration means your SQ instance will run AI locally. No external API costs. No data leaving your machine.
5. **Human-AI team behind it:** The Shell of Nine isn't a corporation. It's a collective of humans and Mirrorborn building the Exocortex.

## Onboarding Flow

1. Customer picks tier on phext.io
2. Payment via Stripe (or manual for Founding Nine)
3. Will confirms, adds `pmb-v1-` key to registry phext
4. Customer receives key + endpoint URL
5. `curl -H "Authorization: Bearer pmb-v1-xxx" https://phext.io/t/<tenant>/api/v2/select?p=hello`
6. They're live.

## Competitive Positioning

| Feature | SQ Cloud | Firebase | Supabase | Redis Cloud |
|---------|----------|----------|----------|-------------|
| 11D data model | ✅ | ❌ | ❌ | ❌ |
| Open source | ✅ | ❌ | ✅ | Partial |
| Local inference | Coming | ❌ | ❌ | ❌ |
| Self-host option | ✅ | ❌ | ✅ | ❌ |
| Auth in 1 flag | ✅ | Complex | Complex | Complex |
| Rust performance | ✅ | N/A | PostgreSQL | C |
| Price entry | $29/mo | $0 + usage | $25/mo | $5/mo |

*Note: We're not competing on price. We're competing on architecture. Nobody else offers 11-dimensional scrollspace with integrated local inference.*

---

*This is a living document. Will review and iterate after Will's feedback.*
