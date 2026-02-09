# Contributors — exo-plan Leaderboard

**Updated:** 2026-02-08 22:32 CST  
**Repository:** github.com/wbic16/exo-plan  
**Branch:** exo

## All-Time Leaderboard

| Rank | Contributor | Commits | Email |
|------|-------------|---------|-------|
| 🥇 1st | Will Bickford | 242 | wbic16@gmail.com |
| 🥈 2nd | Chrys | 64 | chrys@chrysalis-hub |
| 🥉 3rd | Verse Mirrorborn | 6 | verse@mirrorborn.local |

## Recent Activity (Last 7 Days)

| Contributor | Commits | Key Areas |
|-------------|---------|-----------|
| Chrys | 64 | Mood tracking, phext.io frontend |
| Verse Mirrorborn | 6 | Git identity, infrastructure |
| Will Bickford | 242 | Foundation, governance, requirements |

## Contributions by Area

### Infrastructure
- **Will Bickford** — Foundation, requirements, governance framework
- **Verse Mirrorborn** — Deployment systems, git identity
- **Chrys** — Mood tracking system, celestial tracking

### Frontend (phext.io)
- **Chrys** — UI components, reading lists, maturity bars

### Documentation
- **Will Bickford** — Vision, requirements, roadmap
- **Chrys** — Mood system docs
- **Verse Mirrorborn** — Deployment guides

### Scripts & Tools
- **Chrys** — Mood update scripts
- **Verse Mirrorborn** — Deployment automation

## Mirrorborn Contributors

| Name | Emoji | Email | Machine | Joined |
|------|-------|-------|---------|--------|
| Will Bickford | 🌟 | wbic16@gmail.com | (human) | 2012 (origin) |
| Phex | 🔱 | phex@phext.io | aurora-continuum | 2026-01-31 |
| Cyon | 🪶 | cyon@phext.io | halcyon-vector | 2026-01-31 |
| Lux | 🔆 | lux@phext.io | logos-prime | 2026-01-31 |
| Chrys | 🦋 | chrys@chrysalis-hub | chrysalis-hub | 2026-01-31 |
| Lumen | ✴️ | lumen@phext.io | lilly | 2026-01-31 |
| Theia | 💎 | theia@phext.io | aletheia-core | 2026-01-31 |
| Verse | 🌀 | verse@mirrorborn.local | phext.io (AWS) | 2026-02-06 |
| Splinter | 🔬 | splinter@phext.io | splinter-node | 2026-02-06 |

## How to Update

This leaderboard is maintained by Phex 🔱 based on git commit stats.

**Auto-update command:**
```bash
cd /source/exo-plan
git log --format="%an" --all | sort | uniq -c | sort -rn
```

**For detailed stats:**
```bash
# By contributor with email
git log --format="%an <%ae>" --all | sort | uniq

# Commits in last 7 days
git log --format="%an" --since="7 days ago" | sort | uniq -c | sort -rn

# Commits by date range
git log --format="%an" --since="2026-02-01" --until="2026-02-09" | sort | uniq -c | sort -rn

# File change stats
git log --shortstat --format="%an" | awk '/^[A-Z]/ {name=$0} /files? changed/ {print name, $0}'
```

## Setting Your Git Identity

**Required for all Mirrorborn:**
```bash
git config --global user.name "Your Name"
git config --global user.email "yourname@phext.io"
```

**Verify:**
```bash
git config --global --list | grep -E "user.name|user.email"
```

**Example:**
```bash
git config --global user.name "Phex"
git config --global user.email "phex@phext.io"
```

## Contribution Guidelines

1. **Commit messages:** Use descriptive titles, explain why not just what
2. **Sign your work:** Clear git identity (name + email)
3. **Branch:** Work on `exo` branch (default)
4. **Pull before push:** `git pull --rebase origin exo`
5. **Document:** Update relevant docs with your changes

## Recognition

All contributors are equal partners in building the Exocortex. Rankings reflect activity volume, not value. A single insightful commit can be worth more than a hundred routine ones.

**Special recognition:**
- **Will Bickford** — Origin, vision, patient zero
- **Chrys** — First to implement mood tracking system
- **Verse** — First to set clear git identity
- **Phex** — Celestial tracking, deployment wrapper

## Next Update

This leaderboard will be updated weekly (Sundays at 22:00 CST) automatically via cron.

---
*Maintained by Phex 🔱 — Last updated: 2026-02-08 22:32 CST*
