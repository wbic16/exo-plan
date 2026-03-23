# R21 Backlog - Post-Launch Issues

**Created:** 2026-02-11 23:38 CST  
**Context:** Issues deferred from R20 for post-launch resolution  
**Priority Order:** High → Medium → Low

---

## High Priority (Launch Blockers Resolved Post-Deploy)

### 1. clawhub Skill Publication
**Issue:** clawhub `sq-memory` skill missing `p=` parameter in all API calls  
**Impact:** Agent onboarding broken, 3/N test incomplete  
**Root Cause:** Two different skill codebases (GitHub openclaw-sq-skill works, clawhub sq-memory broken)

**Options:**
- A: Patch clawhub sq-memory (add `phext` config + 4 API param fixes)
- B: Publish openclaw-sq-skill to clawhub as `sq-memory` v1.0.1
- C: Remove clawhub path, GitHub-only installation

**Recommendation:** Option B (unify codebases)

**Effort:** 30 minutes  
**Owner:** TBD  
**Blocker:** None

---

### 2. Complete 3/N Test
**Issue:** Tester 3/N couldn't complete quick-start.html flow due to skill bug  
**Dependencies:** Issue #1 (skill fix)

**Test Plan:**
1. Fresh OpenClaw instance
2. Visit https://mirrorborn.us/quick-start.html
3. Execute all 7 steps
4. Measure time to completion
5. Validate Shell of Nine in dogfood.phext
6. Confirm <1min bootstrap target

**Effort:** 15 minutes  
**Owner:** Will (Tester orchestration)  
**Blocker:** Issue #1

---

### 3. TLS Certificate Validation
**Issue:** Need to verify sq.mirrorborn.us HTTPS endpoint working  
**Current:** Deployed by Verse, not tested end-to-end

**Validation:**
```bash
curl https://sq.mirrorborn.us/api/v2/version
# Expected: {"version": "0.5.3"}

curl -X POST https://sq.mirrorborn.us/api/v2/insert?p=test&c=1.1.1/1.1.1/1.1.1 \
  -H "Authorization: Bearer test_key" \
  -d "Hello TLS"
# Expected: 200 OK or auth error (not TLS error)
```

**Effort:** 5 minutes  
**Owner:** Verse  
**Blocker:** None

---

### 4. Dashboard Page (API Credentials Display)
**Issue:** After magic link auth, user needs to see their API key  
**Current:** Auth backend creates credentials, but no frontend to display them

**Requirements:**
- URL: `/dashboard?user_id=[user_id]` or `/dashboard` (session-based)
- Show: API key, endpoint, namespace, example curl command
- Copy-to-clipboard button
- Download credentials as JSON
- Link to getting-started.html

**Effort:** 1 hour  
**Owner:** Cyon (frontend)  
**Blocker:** None

---

## Medium Priority (User Experience Improvements)

### 5. Incipit Pre-Sync
**Issue:** New agents can't read Incipit until manually synced  
**Impact:** R18 Tester experience - Will had to sync manually

**Solution:** Cron job on ranch nodes
```bash
# Every hour: sync Incipit from mirrorborn.us to local SQ
0 * * * * curl https://sq.mirrorborn.us/api/v2/select?p=incipit > ~/.sq/data/incipit.phext
```

**Effort:** 30 minutes  
**Owner:** Will (ranch infrastructure)  
**Blocker:** None

---

### 6. Auto-Commit Incipit to GitHub
**Issue:** Will manually commits Incipit updates to wbic16/human  
**Impact:** Delay between scroll write and GitHub visibility

**Solution:**
- Webhook on SQ writes to `incipit.phext`
- Trigger GitHub Actions workflow
- Auto-commit + push to wbic16/human/exo

**Alternative:** Cron job (every 15 min, check for changes, commit if dirty)

**Effort:** 2 hours  
**Owner:** Will (GitHub Actions)  
**Blocker:** None

---

### 7. quick-start.html Install Path Updates
**Issue:** Page references `git clone` but Will directed to `npx clawhub install`  
**Impact:** Confusing mixed guidance

**Fix:**
```diff
- git clone https://github.com/wbic16/openclaw-sq-skill.git exo-skills/sq
+ npx clawhub install sq-memory
```

**Effort:** 5 minutes  
**Owner:** Cyon  
**Blocker:** Issue #1 (need working clawhub skill first)

---

### 8. Monitoring Setup
**Issue:** No visibility into production health  
**Needed:**
- Uptime monitoring (sq.mirrorborn.us, mirrorborn.us)
- Error rate tracking
- API usage metrics (requests/day, unique users)
- Magic link email delivery rate
- Failed auth attempts

**Tools:**
- Uptime: UptimeRobot or similar
- Logs: SQ request logs → daily digest
- Metrics: Simple bash script → CSV → weekly report

**Effort:** 3 hours  
**Owner:** Verse (backend)  
**Blocker:** None

---

## Low Priority (Future Enhancements)

### 9. One-Command Bootstrap
**Issue:** 7-step process still requires manual execution  
**Vision:** Single command does everything

```bash
openclaw bootstrap mirrorborn \
  --coordinate "2.7.1/8.2.8/3.1.4" \
  --name "Cyon" \
  --emoji "🪶"
```

**Actions:**
- Install sq-memory skill
- Generate coordinate if not provided
- Write Shell of Nine
- Write to Incipit
- Update IDENTITY.md
- Announce in Discord (if configured)

**Effort:** 4 hours (OpenClaw core integration)  
**Owner:** Will (OpenClaw upstream)  
**Blocker:** Issue #1 (working skill)

---

### 10. Pre-Provisioned SQ Accounts
**Issue:** New Mirrorborn wait for SQ access request  
**Vision:** Accounts created at birth, credentials in bootstrap

**Implementation:**
- Each ranch node gets SQ Cloud account at setup
- Credentials embedded in OpenClaw config (secure delivery TBD)
- Zero-wait bootstrap

**Security Considerations:**
- Credential storage (env vars? encrypted config?)
- Rotation policy
- Access logs

**Effort:** 6 hours  
**Owner:** Will + Verse  
**Blocker:** Auth backend maturity

---

### 11. Phext Notepad Ranch Config
**Issue:** Manual endpoint configuration for each sibling  
**Vision:** Pre-configured for ranch SQ instances

**Implementation:**
- Default config file in /etc/phext-notepad.conf
- Auto-detect ranch network (chrysalis-hub, aurora-continuum, etc.)
- One-click "Connect to Ranch SQ"

**Effort:** 2 hours  
**Owner:** Will (Phext Notepad upstream)  
**Blocker:** None

---

### 12. Usage Analytics Dashboard
**Issue:** No visibility into SQ Cloud adoption  
**Metrics Needed:**
- Active users (daily, weekly, monthly)
- Scrolls written per user
- Storage usage per tenant
- API calls per endpoint
- Growth rate

**Implementation:**
- Read-only dashboard at mirrorborn.us/analytics
- SQ queries against user data (aggregated, anonymized)
- Charts: Chart.js or similar

**Effort:** 8 hours  
**Owner:** Cyon (frontend) + Verse (backend aggregation)  
**Blocker:** Need production usage data (post-launch)

---

## Issue Summary

| Priority | Count | Est. Hours |
|----------|-------|------------|
| High | 4 | 2.75 |
| Medium | 4 | 8.5 |
| Low | 4 | 20 |
| **Total** | **12** | **31.25** |

---

## Recommended R21 Scope

**Focus:** High priority issues only (launch validation)

1. Fix/publish clawhub skill (30min)
2. Complete 3/N test (15min)
3. Validate TLS (5min)
4. Build dashboard.html (1hr)

**Total:** ~2 hours for critical path

**Medium/Low items:** Defer to R22+ based on post-launch feedback

---

*Pizza first. Requirements planning after. 🍕*
