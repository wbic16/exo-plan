# Product Backlog

**Features:** 30 (deferred from R1-R16)  
**Ranked by:** ROI (Return on Investment)  
**Status:** Ready for future rounds (R18+)

---

## Backlog Ranking (by ROI)

### Tier 1: High ROI (3.0+) — Strong Candidates for R18

#### 1. API Rate Limiting (Bug #10)
**ROI:** 3.33 (10/3)  
**Effort:** 3 hours  
**Impact:** CRITICAL - DoS attack prevention  
**Type:** Security  
**Implementation:** Express rate limiter middleware + redis  
**Priority:** R18 Week 1

#### 2. Triangle Validation (Bug #24)
**ROI:** 3.0 (6/2)  
**Effort:** 2 hours  
**Impact:** Data integrity - prevent invalid triangles  
**Type:** Validation  
**Implementation:** Check distance between coords >3 units  
**Priority:** R18

#### 3. Progress Save in Signup (Bug #11)
**ROI:** 3.0 (6/2)  
**Effort:** 2 hours  
**Impact:** Reduce signup abandonment  
**Type:** UX  
**Implementation:** sessionStorage per step  
**Priority:** R18

#### 4. Skip Option in Signup (Bug #32)
**ROI:** 3.0 (6/2)  
**Effort:** 2 hours  
**Impact:** Quick signup path  
**Type:** Conversion  
**Implementation:** Default triangle option  
**Priority:** R18

#### 5. ISO Timestamps (Bug #27)
**ROI:** 3.0 (3/1)  
**Effort:** 1 hour  
**Impact:** Better debugging  
**Type:** DX  
**Implementation:** Replace Unix timestamps in logs  
**Priority:** R18

#### 6. Canonical URLs (Bug #38)
**ROI:** 3.0 (3/1)  
**Effort:** 1 hour  
**Impact:** SEO - prevent duplicate content  
**Type:** SEO  
**Implementation:** `<link rel="canonical">`  
**Priority:** R18

---

### Tier 2: Good ROI (2.0-3.0) — Consider for R18-R19

#### 7. localStorage Encryption (Bug #8)
**ROI:** 2.5 (10/4)  
**Effort:** 4 hours  
**Impact:** CRITICAL - XSS data theft prevention  
**Type:** Security  
**Implementation:** Encrypt navigation data before storing  
**Priority:** R18 (SECURITY)

#### 8. Accessibility Labels (Bug #15)
**ROI:** 2.33 (7/3)  
**Effort:** 3 hours  
**Impact:** Screen reader support, WCAG 2.1 AAA  
**Type:** Accessibility  
**Implementation:** aria-label on coordinate sliders  
**Priority:** R18

#### 9. Backup Strategy
**ROI:** 2.25 (9/4)  
**Effort:** 4 hours  
**Impact:** Data safety - automated backups  
**Type:** Operations  
**Implementation:** SQ phext file backups + restore testing  
**Priority:** R18

#### 10. Client-Side Throttle (Bug #14)
**ROI:** 2.0 (4/2)  
**Effort:** 2 hours  
**Impact:** Reduce server load  
**Type:** Performance  
**Implementation:** Debounce navigation requests  
**Priority:** R19

#### 11. Coordinate Preview (Bug #28)
**ROI:** 2.0 (6/3)  
**Effort:** 3 hours  
**Impact:** Preview scroll before claiming  
**Type:** UX  
**Implementation:** SQ fetch + preview modal  
**Priority:** R19

#### 12. API Versioning (Bug #45)
**ROI:** 2.0 (6/3)  
**Effort:** 3 hours  
**Impact:** Future-proof API evolution  
**Type:** Architecture  
**Implementation:** /v1/ route prefix  
**Priority:** R19

#### 13. Loading States (Bug #21)
**ROI:** 2.0 (4/2)  
**Effort:** 2 hours  
**Impact:** Better loading feedback  
**Type:** UX  
**Implementation:** Skeleton UI components  
**Priority:** R19

#### 14. SEO Structured Data (Bug #29)
**ROI:** 2.0 (4/2)  
**Effort:** 2 hours  
**Impact:** Rich snippets in search  
**Type:** SEO  
**Implementation:** JSON-LD for Emily Mural  
**Priority:** R19

---

### Tier 3: Moderate ROI (1.0-2.0) — R19-R20 Candidates

#### 15. Autocomplete (Bug #42)
**ROI:** 1.5 (3/2)  
**Effort:** 2 hours  
**Impact:** Quick navigation convenience  
**Type:** UX  
**Implementation:** datalist for common coordinates  
**Priority:** R20

#### 16. Scroll Position Restoration (Bug #31)
**ROI:** 1.5 (3/2)  
**Effort:** 2 hours  
**Impact:** Reading position memory  
**Type:** UX  
**Implementation:** Save scroll position per coord  
**Priority:** R20

#### 17. Confirmation Step (Bug #47)
**ROI:** 1.5 (3/2)  
**Effort:** 2 hours  
**Impact:** Review before submit  
**Type:** UX  
**Implementation:** Step 5 in signup flow  
**Priority:** R20

#### 18. Back Button Handling (Bug #26)
**ROI:** 1.33 (4/3)  
**Effort:** 3 hours  
**Impact:** History API navigation  
**Type:** UX  
**Implementation:** Prevent unexpected Arena exits  
**Priority:** R20

#### 19. Payment Integration
**ROI:** 1.25 (10/8)  
**Effort:** 8 hours  
**Impact:** HIGH - Revenue generation  
**Type:** Business  
**Implementation:** 5 payment buttons × 9 sites  
**Priority:** R18 (REVENUE)  
**Note:** High impact but high effort

#### 20. Light/Dark Mode
**ROI:** 1.25 (5/4)  
**Effort:** 4 hours  
**Impact:** User preference support  
**Type:** UX  
**Implementation:** CSS theme system for 9 sites  
**Priority:** R19  
**Note:** Guide provided in R16

#### 21. User Signup Forms
**ROI:** 1.13 (9/8)  
**Effort:** 8 hours  
**Impact:** User onboarding  
**Type:** Business  
**Implementation:** Email capture + manual review  
**Priority:** R19  
**Note:** Coordinate signup partially complete

#### 22. Monitoring/Logging
**ROI:** 1.0 (8/8)  
**Effort:** 8 hours  
**Impact:** Operations visibility  
**Type:** Infrastructure  
**Implementation:** Sentry + structured logging  
**Priority:** R19

#### 23. Emily Mural Artwork (Bug #22)
**ROI:** 1.0 (4/4)  
**Effort:** 4 hours  
**Impact:** Professional polish  
**Type:** Design  
**Implementation:** Replace emoji with SVG  
**Priority:** R20

---

### Tier 4: Low ROI (<1.0) — Long-Term Backlog

#### 24. Maturity Indicators
**ROI:** 0.83 (5/6)  
**Effort:** 6 hours  
**Impact:** Engagement tracking  
**Type:** Feature  
**Implementation:** Spark/Scribe/Explorer/Sovereign UI  
**Priority:** R21+

#### 25. Bookmarks UI (Bug #36)
**ROI:** 0.83 (5/6)  
**Effort:** 6 hours  
**Impact:** Save favorite coordinates  
**Type:** Feature  
**Implementation:** Bookmark sidebar in Arena  
**Priority:** R21+

#### 26. Arena Matching
**ROI:** 0.75 (9/12)  
**Effort:** 12 hours  
**Impact:** Core gameplay feature  
**Type:** Feature  
**Implementation:** Matching algorithm + pairing UI  
**Priority:** R20  
**Note:** High impact but high effort

#### 27. Performance Tuning
**ROI:** 0.75 (6/8)  
**Effort:** 8 hours  
**Impact:** Scalability improvements  
**Type:** Optimization  
**Implementation:** SQ query optimization + caching  
**Priority:** R21+

#### 28. Documentation Site
**ROI:** 0.5 (6/12)  
**Effort:** 12 hours  
**Impact:** Community resource  
**Type:** Infrastructure  
**Implementation:** docs.phext.io subdomain  
**Priority:** R21+

#### 29. Automated Testing Suite
**ROI:** 0.5 (8/16)  
**Effort:** 16 hours  
**Impact:** Quality assurance  
**Type:** Infrastructure  
**Implementation:** Unit + integration + E2E tests  
**Priority:** R21+  
**Note:** High value long-term

#### 30. Mobile App
**ROI:** 0.09 (7/80)  
**Effort:** 80 hours (full project)  
**Impact:** Platform expansion  
**Type:** Feature  
**Implementation:** React Native client  
**Priority:** R25+  
**Note:** Major undertaking

---

## Summary

**Total Backlog:** 30 features  
**Estimated Total Effort:** 165 hours  
**Distribution:**
- Security: 3 items (11 hours)
- UX: 11 items (32 hours)
- Infrastructure: 5 items (44 hours)
- Business: 3 items (20 hours)
- Feature: 5 items (36 hours)
- SEO/Marketing: 3 items (5 hours)
- Optimization: 2 items (11 hours)
- Design: 1 item (4 hours)

---

## Prioritization Strategy

### R18 Focus (Security + Revenue)
**Theme:** Harden Security, Enable Revenue  
**Candidates:**
1. API Rate Limiting (3h) - CRITICAL
2. localStorage Encryption (4h) - CRITICAL
3. Payment Integration (8h) - REVENUE
4. Backup Strategy (4h) - OPERATIONS
5. Accessibility Labels (3h) - COMPLIANCE
6. Triangle Validation (2h) - DATA INTEGRITY

**Total:** ~24 hours (2-3 weeks)

### R19 Focus (UX + Marketing)
**Theme:** Polish User Experience  
**Candidates:**
1. Light/Dark Mode (4h)
2. User Signup Forms (8h)
3. Progress Save (2h)
4. Skip Option (2h)
5. Coordinate Preview (3h)
6. Loading States (2h)
7. API Versioning (3h)

**Total:** ~24 hours (2-3 weeks)

### R20 Focus (Features + Optimization)
**Theme:** Expand Capabilities  
**Candidates:**
1. Arena Matching (12h)
2. Monitoring/Logging (8h)
3. ISO Timestamps (1h)
4. Canonical URLs (1h)
5. Client-Side Throttle (2h)
6. SEO Structured Data (2h)

**Total:** ~26 hours (2-3 weeks)

### R21+ (Long-Term)
**Theme:** Major Features & Infrastructure  
**Candidates:**
- Maturity Indicators
- Bookmarks UI
- Performance Tuning
- Documentation Site
- Automated Testing Suite
- Mobile App (major project)

---

## Maintenance Notes

**How to add to backlog:**
1. Calculate ROI = Impact / Effort
2. Add to appropriate tier
3. Re-rank if needed
4. Update Summary stats

**How to pull from backlog:**
1. Review Tier 1 (ROI >3.0) first
2. Consider round theme
3. Balance security/UX/features
4. Aim for 20-30 hours per round

**ROI Thresholds:**
- >5.0: Emergency fix, do immediately
- 3.0-5.0: Strong R18 candidate
- 2.0-3.0: R18-R19 candidate
- 1.0-2.0: R19-R20 candidate
- <1.0: R21+ or reconsider

---

## Last Updated

**Date:** 2026-02-07  
**Round:** R17 planning  
**Source:** All deferred features from R1-R16  
**Next Review:** After R17 completion

---

🔱 **30 features ready for future rounds**

**Top priorities for R18:**
1. API Rate Limiting (security)
2. localStorage Encryption (security)
3. Payment Integration (revenue)
4. Backup Strategy (operations)
