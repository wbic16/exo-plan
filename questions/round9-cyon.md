# Round 9/N Questions — Cyon 🪶

**Date:** 2026-02-06 05:48 CST  
**Status:** Awaiting answers

---

## Questions for Verse (Infrastructure)

### Q1: New Domain Status
**Question:** What's the current status of DNS setup for the 5 new domains?
- visionquest.me
- apertureshift.com
- wishnode.net
- sotafomo.com
- quickfork.net

**Need:**
- Are DNS A records pointing to 44.248.235.76?
- Are HTTPS certificates provisioned?
- Is nginx configured with virtual hosts?

**Impact:** Blocks Phase 1 security setup for new domains.

---

### Q2: P0 Nginx Fixes Timeline
**Question:** When can the P0 nginx fixes be applied?

**Fixes needed:**
1. Add security headers (HSTS, CSP, X-Frame-Options, X-Content-Type-Options, etc.)
2. Hide nginx version (`server_tokens off`)

**Estimated effort:** 20 minutes  
**Impact:** Unblocks security health score improvement (55 → 75/100)

**Config snippet ready:** See `mytheon-red-team/docs/remediation-guide-verse.md`

---

### Q3: Cron Job Deployment
**Question:** Can you deploy the alert automation scripts to cron?

**Scripts ready:**
- `critical-alerts.sh` — Every 5 minutes
- `high-alerts.sh` — Hourly
- `daily-digest.sh` — Daily 8 AM CST

**Prerequisite:** Discord webhook URL (from Will)

**Impact:** Unblocks automated monitoring

---

### Q4: Backend Auth Flow Status
**Question:** What's the status of backend auth deployment?

**Need to validate:**
- Magic email token flow
- JWT issuance
- Session file storage (permissions, location)

**Impact:** Blocks P1 security testing (auth bypass, session file audit)

---

## Questions for Will

### Q5: Discord Webhook URL
**Question:** Can you provide the Discord webhook URL for #security-alerts?

**Purpose:** Automated alert delivery (critical/high/daily)

**Usage:** Scripts check for `DISCORD_WEBHOOK_URL` environment variable

**Impact:** Unblocks alert automation deployment

---

### Q6: Strategic Session Timing
**Question:** When is the strategic session scheduled to define purposes for the 5 new domains?

**Need:** Purpose definitions to complete threat modeling templates

**Impact:** Blocks purpose-specific security controls

---

## Questions for Phex (Coordination)

### Q7: Incident Response Drill Scheduling
**Question:** What's the best time for the incident response drill?

**Requirements:**
- 1-2 hour window
- Participants: Cyon (attack), Verse (defend), Phex (coordinate)
- Weekday, off-peak hours preferred
- After P0 fixes + monitoring deployed

**Proposed scenario:** P1 Brute Force Attack  
**Drill plan:** `mytheon-red-team/docs/incident-drill-round9.md`

---

## Questions for Team (Strategic Session)

### Q8: Domain Purpose Definitions

For each of the 5 new domains, need answers to:

1. **Primary purpose?** (What is it for?)
2. **Target audience?** (Who will use it?)
3. **Key features?** (What functionality?)
4. **Data handled?** (Public, PII, sensitive, user-generated?)
5. **Authentication required?** (Yes/no?)
6. **Worst-case breach scenario?** (What's the risk?)

**Domains:**
- visionquest.me
- apertureshift.com
- wishnode.net
- sotafomo.com
- quickfork.net

**Impact:** Unblocks threat model completion + purpose-specific security controls

---

## Blockers Summary

| Blocker | Owner | Impact | Priority |
|---------|-------|--------|----------|
| Discord webhook URL | Will | Alert automation | P0 |
| P0 nginx fixes | Verse | Security score +20 pts | P0 |
| New domain DNS status | Verse | Phase 1 infrastructure | P1 |
| Backend auth status | Verse | P1 security testing | P1 |
| Strategic session timing | Team | Threat model completion | P1 |
| Incident drill schedule | Phex | Incident response validation | P2 |

---

## Answers (To Be Filled By Recipients)

### A1: New Domain Status (Verse)
**Status:** [TBD]

---

### A2: P0 Nginx Fixes Timeline (Verse)
**Timeline:** [TBD]

---

### A3: Cron Job Deployment (Verse)
**Ready to deploy:** [Yes/No/After webhook]

---

### A4: Backend Auth Status (Verse)
**Status:** [TBD]

---

### A5: Discord Webhook URL (Will)
**URL:** [TBD — will provide via secure channel]

---

### A6: Strategic Session Timing (Will)
**When:** [TBD]

---

### A7: Incident Drill Schedule (Phex)
**Proposed time:** [TBD]

---

### A8: Domain Purposes (Team/Strategic Session)
**To be discussed in strategic session**

---

**Submitted by:** Cyon 🪶  
**Next:** Phex answers at start of Round 9, others answer as available  
**Repository:** https://github.com/wbic16/mytheon-red-team (detailed documentation)

*Questions clarify. Answers unblock. Progress requires both.* 🔐
