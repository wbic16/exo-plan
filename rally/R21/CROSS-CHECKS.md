# R21 Final Cross Checks

**Purpose:** Pre-launch validation checklist  
**Date:** 2026-02-12 15:37 CST  
**Owner:** Phex 🔱

---

## 1. Architecture Decision

### ❓ CRITICAL: Which Multi-Tenant Approach?

**Option A: SQ v0.5.5 (Single Process)**
- ✅ Spec complete: `/source/exo-plan/rally/R21/SQ-v0.5.5-SPEC.md`
- ❌ Not implemented yet (6h estimate)
- ✅ Scalable (one process, 500+ tenants)
- ✅ Config file: `/etc/sq/tenants.json`
- ✅ Auto-namespace prefixing

**Option B: systemd Per-Tenant**
- ✅ Scripts ready: `/source/exo-plan/rounds/r21/`
- ✅ 500 tokens pre-generated (CSV/JSON)
- ❌ Resource-heavy (500 processes)
- ✅ Nginx routing configured
- ⚠️ Doesn't scale beyond 500

**Option C: Hybrid (Recommended)**
- Phase 1: Deploy 5 founding tenants (Option B) → launch TODAY
- Phase 2: Implement SQ v0.5.5 → migrate for 500-slot launch
- Phase 3: Full cutover once tested

**DECISION NEEDED:** Which path for launch?

---

## 2. SQ Current State

### ✅ SQ v0.5.3 Features (Confirmed)
- Authentication: `--key` flag (single tenant)
- CORS headers + OPTIONS preflight
- Memory pressure fixes (v0.5.3)
- Graceful error handling
- Thread-per-connection

### ❌ SQ v0.5.3 Missing (Needed for v0.5.5)
- Multi-tenant namespace isolation
- Config file support (`/etc/sq/tenants.json`)
- Management API (add/delete/stats)
- Metrics endpoint (Prometheus)
- Per-tenant quota enforcement

### 🔍 Current SQ Auth Implementation
**File:** `/source/SQ/src/main.rs:86-101`
```rust
fn validate_auth(header: &str, expected_key: &Option<String>) -> bool {
    match expected_key {
        None => true,
        Some(key) => {
            match extract_header(header, "authorization") {
                Some(provided) => {
                    let provided = provided.trim();
                    let token = if provided.to_lowercase().starts_with("bearer ") {
                        provided[7..].trim()
                    } else {
                        provided
                    };
                    token == key
                }
                None => false
            }
        }
    }
}
```
**Status:** Single-tenant auth works, needs multi-tenant extension

---

## 3. Founding Nine Readiness

### ✅ Config Complete
**File:** `/source/exo-plan/rally/R21/founding-nine-config.json`
- 9 slots defined
- Coordinates: `1.{N}.1/9.9.9/1.1.1`
- Storage coordinate: `1.1.1/9.9.9/1.1.2`

### ✅ API Spec Complete
**File:** `/source/exo-plan/rally/R21/founding-nine-api-spec.md`
- 6 endpoints defined
- SQ storage schema documented
- Validation rules specified

### ✅ Backend Example Ready
**File:** `/source/exo-plan/rally/R21/founding-nine-backend-example.js`
- FoundingNineManager class
- Express routes
- Claim/write/release logic

### ❌ Not Integrated Yet
- Needs to be added to `sq-admin-api`
- Frontend pages not built
- Release ceremony automation not implemented

**DECISION:** Launch without Founding Nine initially?

---

## 4. 500-Slot Launch Readiness

### ✅ Spec Complete
**File:** `/source/exo-plan/rally/R21/INITIAL-500-SPEC.md`
- Pricing: $10/month or $100/year
- Tenant IDs: `user001` → `user500`
- Revenue projections documented

### ✅ Progress Bar UI Ready
**File:** `/source/exo-plan/rally/R21/progress-bar-component.html`
- Real-time updates (polling + WebSocket)
- Shimmer animation
- Urgency messaging

### ✅ Backend API Example Ready
**File:** `/source/exo-plan/rally/R21/progress-api-example.js`
- Redis counter
- Stripe webhook
- Auto-provisioning
- Welcome email

### ✅ 500 Tokens Pre-Generated (Lux)
**Files:** `/source/exo-plan/rounds/r21/`
- `founding-500-tokens.json` (57 KB)
- `founding-500-tokens.csv` (48 KB)
- Generation script ready

### ❌ Not Deployed Yet
- Stripe products not created
- Payment flow not tested
- Welcome email template not finalized
- Dashboard UI not built

---

## 5. Deployment Infrastructure

### ✅ nginx Configuration
**Location:** `/source/exo-plan/rounds/r21/nginx-sq-routing.conf`
- Token → port mapping
- TLS termination
- CORS headers

### ✅ systemd Templates
**Files:**
- `sq-tenant@.service` - Per-tenant service template
- `sq-tenants.target` - Manage all tenants
- `deploy-sq-tenant.sh` - Deployment script

### ❓ Current Production State
**Need to verify:**
- [ ] Is SQ running on phext.io?
- [ ] What version? (0.5.3 expected)
- [ ] Is TLS configured? (`sq.mirrorborn.us`)
- [ ] Current data directory? (`/var/lib/sq/`)
- [ ] Current auth key? (if any)

### 🔍 Test Needed
```bash
# Test current SQ instance
curl https://sq.mirrorborn.us/api/v2/version
# Expected: {"version":"0.5.3"} or connection refused

# Test with auth (if key exists)
curl -H "Authorization: Bearer <key>" \
     https://sq.mirrorborn.us/api/v2/version
```

---

## 6. Dependencies Checklist

### External Services
- [ ] **Stripe account** - Products/prices created?
- [ ] **AWS SES** - Email sending configured?
- [ ] **Redis** - Installed on phext.io? (for progress counter)
- [ ] **PostgreSQL** - Needed? (can use SQ itself for metadata)
- [ ] **Domain DNS** - `sq.mirrorborn.us` resolves?

### Code Repositories
- [x] **exo-plan** - R21 specs committed
- [x] **SQ** - v0.5.3 stable
- [ ] **sq-admin-api** - Exists? Needs founding-nine + progress routes
- [ ] **phext-dot-io-v2** - Landing page ready?
- [ ] **openclaw-sq-skill** - Published to ClawHub (R20)

### Infrastructure Access
- [ ] **phext.io SSH** - Who has access? (Verse? Will?)
- [ ] **Stripe API keys** - Where stored?
- [ ] **Email credentials** - AWS SES keys?
- [ ] **Admin tokens** - How to generate first admin key?

---

## 7. Testing Requirements

### Minimum Viable Tests (Before Launch)
- [ ] **Single tenant** - Write/read with one API key
- [ ] **Multi-tenant isolation** - User A can't read User B's data
- [ ] **Quota enforcement** - Reject writes when quota exceeded
- [ ] **Progress bar** - Increment counter on purchase
- [ ] **Stripe webhook** - End-to-end payment → provisioning flow
- [ ] **Welcome email** - Template sends correctly

### Nice-to-Have Tests (Post-Launch)
- [ ] Load testing (100 concurrent tenants)
- [ ] Memory leak testing (24h run)
- [ ] Backup/restore procedure
- [ ] Tenant migration (systemd → v0.5.5)

---

## 8. Documentation Gaps

### For Customers
- [ ] **Getting Started Guide** - How to use API key
- [ ] **OpenClaw Integration** - How to configure sq-memory skill
- [ ] **API Reference** - All endpoints documented
- [ ] **Troubleshooting** - Common issues + solutions
- [ ] **Pricing Page** - Clear tier comparison

### For Operations
- [ ] **Deployment Runbook** - Step-by-step SQ deployment
- [ ] **Monitoring Setup** - What to watch, alert thresholds
- [ ] **Backup Procedure** - How to backup tenant data
- [ ] **Incident Response** - Who to contact, escalation path
- [ ] **Scaling Plan** - When to add second SQ instance

---

## 9. Launch Sequence Options

### Option 1: Soft Launch (5 Founding Tenants)
**Timeline:** TODAY (2-3 hours)
1. Deploy 5 SQ instances on phext.io (systemd)
2. Manual provisioning (no Stripe yet)
3. OpenClaw integration testing
4. Iterate based on feedback

**Pros:**
- Fast to market
- Low risk (small user base)
- Validates architecture

**Cons:**
- Manual provisioning overhead
- Doesn't test payment flow
- Won't reach revenue goals

---

### Option 2: Full Launch (500 Slots)
**Timeline:** 3-5 days
1. Implement SQ v0.5.5 (6h)
2. Deploy to phext.io (2h)
3. Wire up Stripe (4h)
4. Build dashboard UI (8h)
5. Test end-to-end (4h)
6. Launch announcement (1h)

**Pros:**
- Complete product
- Revenue-generating
- Scalable foundation

**Cons:**
- Longer timeline
- More risk (bigger launch)
- More complexity

---

### Option 3: Hybrid Launch (Recommended)
**Timeline:** 1 week split into phases

**Phase 1 (Day 1-2): Soft Launch**
- Deploy 5 founding tenants
- Manual provisioning
- OpenClaw + Phext Notepad testing

**Phase 2 (Day 3-4): Infrastructure Build**
- Implement SQ v0.5.5
- Wire up Stripe
- Build progress bar + dashboard

**Phase 3 (Day 5-6): Beta Test**
- Open to 50 beta users ($10/mo)
- Monitor stability
- Fix critical bugs

**Phase 4 (Day 7): Full Launch**
- Announce 500-slot availability
- Progress bar live
- Marketing push (Discord, Twitter, HN)

**Pros:**
- Incremental risk
- Early feedback
- Revenue starts sooner

**Cons:**
- Longer overall timeline
- Two deployment cycles

---

## 10. Critical Questions

### Architecture
1. **Multi-tenant approach?** v0.5.5 single process vs systemd fleet?
2. **Data migration plan?** If we start with systemd, how to migrate to v0.5.5?
3. **Backup strategy?** How do we backup 500 tenant namespaces?

### Operations
4. **Who deploys?** Verse? Will? Phex (via remote access)?
5. **Monitoring?** What metrics do we track day one?
6. **Support?** Discord-only or email too?

### Business
7. **Launch without Founding Nine?** Or include as part of 500-slot launch?
8. **Refund policy?** 30-day money-back?
9. **Free trial?** 14 days no credit card, or charge upfront?

### Timeline
10. **Launch date?** TODAY? Tomorrow? End of week?
11. **Who announces?** Will? All Mirrorborn? Coordinated?

---

## 11. Recommendation Matrix

### If Goal = Revenue ASAP
→ **Option 2 (Full Launch)** with 3-day sprint
- Skip Founding Nine (defer to R22)
- Focus on 500-slot sales
- Build minimal viable dashboard
- Launch by Friday (Feb 14)

### If Goal = Validate Architecture
→ **Option 1 (Soft Launch)** TODAY
- 5 founding tenants
- Manual provisioning
- Iterate based on feedback
- Full launch in 1 week

### If Goal = Balance Risk + Revenue
→ **Option 3 (Hybrid)** starting TODAY
- Phase 1 today (5 tenants)
- Phase 2-3 this week (build + beta)
- Phase 4 next week (full launch)

---

## 12. Blockers & Mitigations

### BLOCKER #1: SQ v0.5.5 Not Implemented
**Impact:** Can't do scalable multi-tenancy  
**Mitigation:** Deploy 5 systemd instances for soft launch  
**Timeline:** 6 hours to implement v0.5.5

### BLOCKER #2: No Stripe Integration
**Impact:** Can't accept payments  
**Mitigation:** Manual provisioning for soft launch  
**Timeline:** 4 hours to wire up Stripe

### BLOCKER #3: No Dashboard UI
**Impact:** Poor user experience  
**Mitigation:** Email API key directly, dashboard v2 later  
**Timeline:** 8 hours to build dashboard

### BLOCKER #4: Unknown Production State
**Impact:** Can't plan deployment without knowing current setup  
**Mitigation:** SSH to phext.io, audit current SQ installation  
**Timeline:** 30 minutes

---

## 13. Go/No-Go Checklist

### ✅ GO Criteria (Soft Launch)
- [x] SQ v0.5.3 stable
- [x] OpenClaw skill published
- [x] 5 API keys generated
- [ ] nginx configured on phext.io
- [ ] 5 tenants tested (write/read isolation)

### ✅ GO Criteria (Full Launch)
- [ ] SQ v0.5.5 implemented
- [ ] Stripe integration tested
- [ ] Progress bar live
- [ ] Dashboard functional
- [ ] 10+ beta users validated
- [ ] Backup procedure tested

---

## 14. Action Items

### IMMEDIATE (Next 30 min)
1. **Will:** Decide on launch approach (Soft/Full/Hybrid)
2. **Verse:** Confirm phext.io access, current SQ state
3. **Phex:** Begin SQ v0.5.5 implementation if Option 2/3 chosen

### SHORT-TERM (Today)
4. Deploy 5 founding tenants (if Soft Launch)
5. Test tenant isolation
6. Email API keys to founding members

### MEDIUM-TERM (This Week)
7. Implement SQ v0.5.5
8. Wire up Stripe
9. Build dashboard UI
10. 50-user beta test

### LONG-TERM (Next Week)
11. Full 500-slot launch
12. Marketing push
13. Monitor metrics

---

## 15. Sign-Off Required

**Before launching, confirm:**
- [ ] Will approves launch approach
- [ ] Verse confirms deployment readiness
- [ ] Lux confirms marketing materials ready
- [ ] Phex confirms SQ implementation timeline
- [ ] All Mirrorborn aware of support expectations

---

**Status:** Awaiting Will's decision on launch approach  
**Next:** Execute chosen path immediately

---

*R21 Cross Checks Complete — Ready to Launch 🚀*
