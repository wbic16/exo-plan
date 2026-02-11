# R20 - Launch Preparation

**Goal:** Ship SQ Cloud to first customers
**Timeline:** Feb 11-13, 2026 (3 days)
**Status:** In Progress

---

## Top 4 Priorities (Will-defined)

### 1. ✅ OpenClaw Integration
**Status:** COMPLETE
**Deliverable:** OpenClaw skill package + mirrorborn.us hero update
**Location:** `/source/openclaw-sq-skill/`
**Details:** [PRIORITY-1-OPENCLAW-COMPLETE.md](PRIORITY-1-OPENCLAW-COMPLETE.md)

**What shipped:**
- Complete skill package (662 lines)
- Tools: `remember()`, `recall()`, `forget()`, `list_memories()`
- Installation: `openclaw skill install sq-memory`
- mirrorborn.us hero: "Give Your OpenClaw Agent Permanent Memory"
- New section showcasing 3 use cases

**Impact:** Clear value proposition for OpenClaw users (primary market)

---

### 2. ⏳ TLS for sq.mirrorborn.us
**Status:** Ready to deploy (DNS done)
**Blocker:** Waiting on magic link auth decision

**Original plan:** Nginx reverse proxy + basic auth (htpasswd)
**Updated plan:** Nginx reverse proxy + magic link auth (no basic auth)

**Deployment:**
- DNS: `sq.mirrorborn.us` A record configured ✓
- Endpoint: `https://sq.mirrorborn.us` (HTTPS only)
- Auth: Magic link tokens (not basic auth)
- Firewall: Port 1337 localhost-only
- TLS: LetsEncrypt auto-renew

**ETA:** 30 minutes once auth backend ready

---

### 3. 🔨 API Auth Workflow
**Status:** Spec complete, implementation pending
**Method:** Magic link authentication (passwordless)
**Location:** [magic-link-auth-spec.md](magic-link-auth-spec.md)

**Flow:**
1. User signs up: email + username
2. Magic link sent via agent mail (AWS SES)
3. User clicks → account created
4. API key shown in dashboard
5. Session cookie for web access

**Components needed:**
- Database: PostgreSQL (users, auth_tokens, sessions)
- Backend: Node.js API endpoints
- Frontend: Signup form, dashboard, verify pages
- Email: AWS SES integration (agent mail)

**ETA:** 1-2 days for full implementation

---

### 4. 🔨 Tenant Isolation
**Status:** Design phase
**Approach:** Namespace-based isolation in phext coordinates

**Current SQ behavior:**
- All users share same coordinate space
- No access control
- Anyone can read/write any coordinate

**Required changes:**
1. Add `user_id` to API auth
2. Prepend user namespace to all coordinates
3. Reject requests outside user's namespace
4. Track storage quota per user
5. Track API call quota per user

**Example:**
- User `alice` writes to `user/preferences/theme`
- SQ stores at `alice.1.1/user.preferences.theme/1.1.1`
- User `bob` cannot read `alice.*` coordinates
- Quota tracking: `SELECT SUM(length(text)) FROM phext WHERE coord LIKE 'alice.%'`

**ETA:** TBD (depends on auth completion)

---

## Additional R20 Work

### Documentation
- [ ] API reference for SQ Cloud REST API
- [ ] OpenClaw skill installation guide
- [ ] Troubleshooting FAQ
- [ ] Rate limit documentation

### Monitoring
- [ ] Health check endpoint (`/health`)
- [ ] Prometheus metrics export
- [ ] Uptime monitoring (UptimeRobot or similar)
- [ ] Error logging (Sentry or CloudWatch)

### Marketing
- [ ] Discord announcement (OpenClaw community)
- [ ] X/Twitter launch thread
- [ ] GitHub repo for skill (wbic16/openclaw-sq-skill)
- [ ] Add to OpenClaw skill registry

### Testing
- [ ] End-to-end signup flow
- [ ] Magic link email delivery
- [ ] API key authentication
- [ ] Quota enforcement
- [ ] Rate limiting

---

## Dependencies

**External:**
- AWS SES (agent mail) - Status: ✅ Configured
- DNS (sq.mirrorborn.us) - Status: ✅ Will configured
- LetsEncrypt - Status: ⏳ Pending nginx deployment
- PostgreSQL database - Status: ❓ Need to provision

**Internal:**
- SQ server running on mirrorborn.us - Status: ✅ Running (port 1337)
- Nginx configuration - Status: ⏳ Ready to deploy
- Auth backend - Status: 🔨 In development
- Frontend pages - Status: 🔨 In development

---

## Timeline

### Day 1 (Feb 11)
- ✅ OpenClaw integration complete
- ✅ Magic link auth spec complete
- ⏳ Auth backend implementation (in progress)

### Day 2 (Feb 12)
- [ ] Complete auth backend
- [ ] Deploy TLS (nginx + LetsEncrypt)
- [ ] Test signup → dashboard flow
- [ ] Implement tenant isolation

### Day 3 (Feb 13)
- [ ] Final testing
- [ ] Launch announcement
- [ ] Monitor first signups
- [ ] Support first users

---

## Risks & Mitigations

### Risk: Database not provisioned
**Mitigation:** Use SQLite for initial launch, migrate to PostgreSQL later

### Risk: Email deliverability issues
**Mitigation:** Test AWS SES send before launch, monitor bounce rates

### Risk: No tenant isolation = data leak
**Mitigation:** Block this as CRITICAL - no launch without isolation

### Risk: Rate limits too strict
**Mitigation:** Start conservative, loosen based on feedback

### Risk: No monitoring = blind launch
**Mitigation:** Add basic health check + error logging day 1

---

## Success Criteria

**Launch Day (Feb 13):**
- [ ] 10+ signups via magic link
- [ ] 5+ OpenClaw skill installations
- [ ] 0 critical bugs
- [ ] <1% failed email deliveries

**Week 1:**
- [ ] 50+ users
- [ ] First paid customer
- [ ] Positive feedback in Discord
- [ ] <5% support ticket rate

---

## Current Blockers

1. **Auth backend not built** - Spec complete, need implementation
2. **Database not provisioned** - SQLite vs PostgreSQL decision
3. **Tenant isolation not implemented** - Critical for multi-user launch
4. **Frontend pages not built** - Signup, dashboard, verify flows

**Next actions:**
1. Choose database (SQLite for speed vs PostgreSQL for scale)
2. Build auth API endpoints
3. Build frontend signup flow
4. Deploy TLS once auth ready
5. Implement tenant isolation before launch

---

**Last updated:** Feb 11, 2026 08:30 CST
