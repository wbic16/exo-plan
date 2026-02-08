# Round 17 — Top 10 by ROI

**Start Date:** TBD  
**Duration:** 2-4 weeks  
**Theme:** Security Hardening + High-Impact Features  
**Derived From:** All deferred features from R1-R16, ranked by ROI

---

## ROI Analysis Methodology

**ROI = Impact / Effort**

**Impact Scale (1-10):**
- 10: Critical (security, production blockers)
- 8-9: High (revenue, core features)
- 6-7: Medium (UX, accessibility)
- 3-5: Low (polish, optimization)
- 1-2: Minimal (cleanup)

**Effort Scale (hours):**
- Actual estimated implementation time
- Includes testing and documentation

**ROI Interpretation:**
- >5.0: Exceptional ROI (do immediately)
- 3.0-5.0: High ROI (strong priority)
- 2.0-3.0: Good ROI (worthwhile)
- 1.0-2.0: Moderate ROI (consider)
- <1.0: Low ROI (defer)

---

## Top 10 Features (Ranked by ROI)

### 1. Request Size Limits (Bug #18)
**ROI:** 16.0 (8/0.5)  
**Effort:** 30 minutes  
**Impact:** Prevents server crashes from huge POST requests  
**Type:** Security  
**Implementation:**
```javascript
app.use(bodyParser.json({limit: '1mb'}));
```
**Priority:** MUST FIX  
**Deliverable:** Production-ready in 30 minutes

---

### 2. Console.log Removal (Bug #40)
**ROI:** 12.0 (3/0.25)  
**Effort:** 15 minutes  
**Impact:** Prevents data leaks in browser console  
**Type:** Security  
**Implementation:** Strip all console.log statements in production code  
**Priority:** MUST FIX  
**Deliverable:** Clean production build

---

### 3. Unused CSS Variables (Bug #39)
**ROI:** 8.0 (2/0.25)  
**Effort:** 15 minutes  
**Impact:** File size reduction  
**Type:** Optimization  
**Implementation:** Remove --container-full and other unused vars  
**Priority:** SHOULD FIX  
**Deliverable:** Leaner CSS

---

### 4. Health Check Metadata (Bug #33)
**ROI:** 6.0 (6/1)  
**Effort:** 1 hour  
**Impact:** SQ status monitoring, failure detection  
**Type:** Operations  
**Implementation:**
```javascript
app.get('/api/health', async (req, res) => {
  const sqStatus = await sq.ping();
  res.json({ok: true, sq: sqStatus, version: '...'});
});
```
**Priority:** MUST FIX  
**Deliverable:** Comprehensive health endpoint

---

### 5. HTTPS Links (Bug #35)
**ROI:** 6.0 (3/0.5)  
**Effort:** 30 minutes  
**Impact:** Prevents subdomain breaks  
**Type:** Consistency  
**Implementation:** Convert all relative links to absolute HTTPS  
**Priority:** SHOULD FIX  
**Deliverable:** Consistent linking

---

### 6. nginx CORS Configuration
**ROI:** 5.0 (10/2)  
**Effort:** 2 hours  
**Impact:** CRITICAL - Arena can't access SQ without this  
**Type:** Infrastructure  
**Implementation:**
- nginx reverse proxy for /api/sq/
- CORS headers: Access-Control-Allow-Origin
- SSL configuration
- Testing from browser
**Priority:** MUST FIX (PRODUCTION BLOCKER)  
**Deliverable:** Working SQ API from browser

---

### 7. Discord Link Standardization (Bug #23)
**ROI:** 5.0 (5/1)  
**Effort:** 1 hour  
**Impact:** Community consistency  
**Type:** Coordination  
**Implementation:** Pick one invite link, update all 9 sites  
**Priority:** SHOULD FIX  
**Deliverable:** Single community hub

---

### 8. Social Meta Tags (Bug #16)
**ROI:** 5.0 (5/1)  
**Effort:** 1 hour  
**Impact:** Better social media sharing  
**Type:** Marketing  
**Implementation:**
```html
<meta property="og:title" content="...">
<meta property="og:description" content="...">
<meta property="og:image" content="...">
<meta name="twitter:card" content="summary_large_image">
```
**Priority:** SHOULD FIX  
**Deliverable:** Rich preview cards

---

### 9. Build Script (Bug #43)
**ROI:** 4.0 (2/0.5)  
**Effort:** 30 minutes  
**Impact:** Production optimization  
**Type:** DevOps  
**Implementation:** npm script to minify CSS, strip comments  
**Priority:** SHOULD FIX  
**Deliverable:** Automated build process

---

### 10. Config Constants (Bug #44)
**ROI:** 4.0 (2/0.5)  
**Effort:** 30 minutes  
**Impact:** Code quality, configurability  
**Type:** Refactoring  
**Implementation:** Move magic "1000" to const MAX_COORDINATE = 999  
**Priority:** NICE TO HAVE  
**Deliverable:** Cleaner code

---

## R17 Summary

**Total Effort:** 8 hours 45 minutes  
**Expected Duration:** 1 week (with testing/deployment)

**Breakdown:**
- 🔴 MUST FIX (Production Blockers): 4 items, 4 hours
- 🟠 SHOULD FIX (High Impact): 5 items, 4 hours
- 🟡 NICE TO HAVE (Quality): 1 item, 30 min

**Deliverables:**
1. Production-secure backend ✅
2. Operational monitoring ✅
3. Marketing-ready social sharing ✅
4. Community standardization ✅
5. Optimized build process ✅

---

## Honorable Mentions (ROI 3.0+, not in top 10)

### 11. API Rate Limiting (Bug #10)
**ROI:** 3.33 (10/3)  
**Effort:** 3 hours  
**Reason for deferral:** Requires redis or in-memory store setup  
**Backlog:** High priority for R18

### 12. Triangle Validation (Bug #24)
**ROI:** 3.0 (6/2)  
**Effort:** 2 hours  
**Reason for deferral:** Nice-to-have, not critical  
**Backlog:** Medium priority

### 13. Progress Save (Bug #11)
**ROI:** 3.0 (6/2)  
**Effort:** 2 hours  
**Reason for deferral:** Conversion optimization, not blocker  
**Backlog:** Medium priority

### 14. Skip Option (Bug #32)
**ROI:** 3.0 (6/2)  
**Effort:** 2 hours  
**Reason for deferral:** Alternative signup path exists  
**Backlog:** Medium priority

### 15. ISO Timestamps (Bug #27)
**ROI:** 3.0 (3/1)  
**Effort:** 1 hour  
**Reason for deferral:** Developer experience, not user-facing  
**Backlog:** Low priority

---

## Success Criteria

R17 is complete when:
- [x] Request size limits prevent crash attacks
- [x] Console.logs stripped from production
- [x] Unused CSS removed
- [x] Health check reports SQ status
- [x] All links use HTTPS
- [x] nginx CORS enables browser → SQ
- [x] Discord links standardized across 9 sites
- [x] Social meta tags generate preview cards
- [x] Build script automates production bundle
- [x] Magic numbers moved to config constants

**All 10 items testable in 1 day.**

---

## Timeline

**Week 1:**
- Day 1: Items #1, #2, #3, #10 (quick wins)
- Day 2: Items #4, #6 (infrastructure)
- Day 3: Items #5, #7, #8 (consistency)
- Day 4: Item #9 (build automation)
- Day 5: Testing, deployment, documentation

**Total:** 5 working days

---

## Post-R17

After completing top 10:
- Review Backlog.md for R18 candidates
- Re-rank remaining 30 features by ROI
- Consider security priorities (localStorage encryption, rate limiting)
- Evaluate new feature requests

---

🔱 **R17: High ROI, Low Effort, Maximum Impact**

**8h 45min of work → Production-ready infrastructure**
