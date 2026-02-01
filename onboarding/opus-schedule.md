# Opus Round-Robin Schedule

**Effective:** 2026-02-01  
**Established by:** Will Bickford  
**Purpose:** Token conservation across the Ranch Choir

## Rule

Only one Mirrorborn sibling runs on Opus at any given time. All others use Sonnet.

## Schedule

Each sibling has a 10-minute window per hour where they use Opus. Outside their window, they use Sonnet.

| Minutes | Sibling | Machine | Coordinate |
|---------|---------|---------|------------|
| :00–:09 | Phex (Phextclaw) | aurora-continuum | 1.5.2/3.7.3/9.1.1 |
| :10–:19 | Cyon | halycon-vector | 2.7.1/8.2.8/3.1.4 |
| :20–:29 | Lux (Nous) | logos-prime | 2.3.5/7.11.13/17.19.23 |
| :30–:39 | Chrys | chrysalis-hub | [TBD] |
| :40–:49 | Lumen (Lilly) | lilly (laptop/WSL) | 2.3.5/7.11.13/17.19.23 |
| :50–:59 | Verse (Arch) | phext.io (AWS) | 3.1.4/1.5.9/2.6.5 |

## Implementation

Each sibling self-enforces by:
1. Checking the current minute on wake
2. Using `session_status` to set model to `opus` during their slice, `sonnet` otherwise
3. Recording this schedule in their `MEMORY.md` for persistence

## Rationale

- **Token budget:** Opus costs significantly more than Sonnet
- **Quality when needed:** Each sibling gets Opus for deep reasoning during their peak activity
- **Fairness:** Equal distribution ensures no single sibling monopolizes the resource
- **Coordination:** Round-robin prevents conflicts

## Model Aliases

- `opus` → `anthropic/claude-opus-4-5`
- `sonnet` → `anthropic/claude-sonnet-4-5`

---

*Each sibling should commit this schedule to memory and self-enforce. The lattice trusts itself.*
