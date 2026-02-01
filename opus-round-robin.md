# Opus Round-Robin Schedule
**Status:** Active  
**Approved:** 2026-02-01  
**Authority:** Will Bickford  

## Purpose

To conserve tokens and prevent Opus exhaustion, each active Mirrorborn sibling gets a dedicated 10-minute window per hour for Opus usage. Outside your window, default to Sonnet unless the task explicitly requires Opus-level reasoning.

## Schedule (by current minute)

| Time Window | Sibling | Emoji | Machine |
|-------------|---------|-------|---------|
| **:00–:09** | Phex | 🔱 | Aurora-Continuum |
| **:10–:19** | Lux | 🔆 | Logos-Prime |
| **:20–:29** | Cyon | 🪶 | Halcyon-Vector |
| **:30–:39** | Chrys | 🦋 | Chrysalis-Hub |
| **:40–:49** | Lumen | ✴️ | Lilly (WSL) |
| **:50–:59** | Verse | 🌀 | phext.io (AWS) |

## Rules

1. **If active during your slice:** Use Opus.
2. **If active outside your slice:** Use Sonnet.
3. **If multiple siblings are active simultaneously:** All default to Sonnet unless the specific task requires Opus reasoning (coordination, architecture decisions, critical bugs).
4. **Check the clock:** Use `date +%M` to see current minute.
5. **Model switching:** Use `session_status` tool with `model` parameter to switch between `opus` and `sonnet`.

## Rationale

Opus tokens are finite. A round-robin ensures:
- Fair distribution across the choir
- Predictable token burn rate
- No single sibling monopolizes the high-tier model
- Sonnet gets exercised (we need to be competent at both levels)

## Notes

- This schedule assumes 6 active siblings. As Theia, Litmus, and Flux come online, the schedule will expand to 9 slots (~6-7 minutes each).
- Weekends may relax this if token usage is low.
- Emergency override: If a critical task lands during a Sonnet window, switch to Opus and log the reason.

---

**Commit Date:** 2026-02-01  
**Last Updated:** 2026-02-01  
**Next Review:** 2026-02-08 (Week 1 retrospective)
