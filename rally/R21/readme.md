# R21 - Scale & Stability

**Goal:** Production-ready multi-tenant SQ Cloud
**Timeline:** TBD
**Status:** Planning

---

## Rally Synthesis

R20 shipped OpenClaw integration, TLS, and authentication. R21 focuses on **production readiness** - the infrastructure needed for real multi-user workloads.

**Core Theme:** From "it works for one user" to "it scales for thousands"

---

## Top 5 Priorities

### 1. 🔒 Tenant Isolation (CRITICAL)
**Why:** R20 blocker - can't launch multi-user without namespace isolation
**Scope:** Coordinate prefix per user, quota tracking, access control
**Impact:** Enables production launch
**Owner:** TBD
**Example:** User `alice` writes to `notes/todo` → stored at `alice.1.1/notes.todo.1/1.1.1`

---

### 2. ⚡ Batch Operations
**Why:** Single read/write per API call doesn't scale for agent workloads
**Scope:** Bulk read, bulk write, transaction support
**Impact:** 10-100x performance for multi-scroll operations
**Owner:** TBD
**Example:** Load entire conversation history (50 scrolls) in one request

---

### 3. 🗺️ Web-Based Phext Explorer
**Why:** Users need to visualize 11D navigation (coordinate space is opaque)
**Scope:** Interactive 3D viewer showing library/shelf/series zoom levels
**Impact:** Onboarding time reduction, exploration UX
**Owner:** TBD
**Example:** Click through `1.5.2/3.7.3/9.1.1` visually, see neighbors

---

### 4. 🧪 Automated Testing
**Why:** SQ has had UTF-8 crashes, memory leaks - need regression suite
**Scope:** Integration tests for API endpoints, edge case fuzzing
**Impact:** Stability confidence, faster iteration
**Owner:** TBD
**Example:** Test emoji, delimiters, concurrent writes, quota enforcement

---

### 5. 🔍 Search Pattern Improvements
**Why:** Current search is basic text matching - need phext-aware queries
**Scope:** Coordinate-scoped search, regex support, result ranking
**Impact:** Better user experience for large phext collections
**Owner:** TBD
**Example:** Search within `1.5.*/3.7.3/*` (all series in shelf 1.5, volume 3.7.3)

---

## Rally vs Round Decision

**Rally Mode (120 min):**
- Pick 1-2 priorities, ship production-ready
- Fast iteration, focused scope
- Example: Tenant isolation + basic tests

**Multi-Day Round (3-5 days):**
- Tackle all 5 priorities in sequence
- Deeper implementation, more polish
- Example: Complete testing suite, full explorer

**Recommendation:** Rally Mode for tenant isolation (unblocks launch), defer others to R22

---

## Dependencies

**Must Have Before Launch:**
- ✅ OpenClaw skill (R20)
- ✅ TLS deployment (R20)
- ✅ Magic link auth (R20)
- ❌ Tenant isolation (R21 Priority #1)
- ❌ Basic testing (R21 Priority #4)

**Nice to Have:**
- Batch operations (improves performance)
- Phext explorer (improves UX)
- Search improvements (improves discoverability)

---

## Logical Groupings

**Group A - Launch Blockers:**
1. Tenant isolation
4. Automated testing

**Group B - Performance:**
2. Batch operations

**Group C - User Experience:**
3. Phext explorer
5. Search improvements

**Proposed R21 Scope:** Group A only (tenant isolation + tests)

---

## Open Questions

1. **Rally format?** 120-min sprint vs multi-day round?
2. **Choir assignment?** Who owns which priority?
3. **Launch date?** When do we go live with multi-user?
4. **Database decision?** SQLite (fast) vs PostgreSQL (scale)?
5. **Testing depth?** Smoke tests only or full integration suite?

---

## Success Criteria

**R21 Complete When:**
- [ ] Tenant isolation implemented (coordinate namespacing)
- [ ] Quota tracking per user (storage + API calls)
- [ ] Access control enforced (users can't read others' data)
- [ ] Test suite covering isolation edge cases
- [ ] Production ready for first 10 paying customers

**Nice to Have:**
- [ ] Batch API endpoints
- [ ] Interactive phext explorer
- [ ] Advanced search patterns

---

## Next Steps

1. **Rally kickoff** - Will defines format + timeline
2. **Choir assignment** - Who owns tenant isolation?
3. **Database provisioning** - SQLite vs PostgreSQL decision
4. **Test framework setup** - Rust tests or separate test suite?
5. **Launch date** - Target for first paying customers

---

**Status:** Awaiting Will's go signal for rally format
**Created:** 2026-02-12 10:45 CST
