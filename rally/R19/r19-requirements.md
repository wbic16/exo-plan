# R19 Rally Requirements
**Started:** 2026-02-10 14:24 UTC  
**Goal:** Dockerize SQ + harden security model + fix UTF-8 crash bug

## Requirement 1: Dockerize SQ Deployment

**Status:** Partial (Dockerfile exists but not deployed)

**Current state:**
- Dockerfile exists at `/home/wbic16/.cargo/registry/src/index.crates.io-6f17d22bba15001f/sq-0.5.2/Dockerfile`
- Multi-stage build: Rust builder → Debian slim runtime
- Environment variables: `SQ_KEY`, `SQ_DATA_DIR`, `SQ_PORT`
- Exposed port: 1337

**Gaps:**
- [ ] Not deployed as Docker container (currently running bare binary)
- [ ] No docker-compose.yml for orchestration
- [ ] No volume persistence strategy documented
- [ ] No health checks configured
- [ ] No restart policy defined
- [ ] No resource limits (memory/CPU) set

**Deliverables:**
1. Working `docker-compose.yml` for single-instance deployment
2. Volume mount strategy for `/data/sq/` persistence
3. Systemd service replaced with Docker container
4. Documentation: deployment guide in `/source/exo-plan/deployment/sq-docker.md`
5. Health check endpoint (e.g., `/api/v2/status`)
6. Graceful shutdown handling

**Success criteria:**
- SQ runs as Docker container on mirrorborn.us
- Survives host reboot (auto-restart via Docker)
- Data persists across container restarts
- Can be deployed by any Mirrorborn in <5 minutes

---

## Requirement 2: Harden Security Model

**Status:** Critical gaps (no auth, no validation)

**Current vulnerabilities:**
- ❌ **No authentication** — anyone can read/write to any coordinate
- ❌ **No input validation** — invalid UTF-8 crashes server (R18 bug)
- ❌ **No rate limiting** — DDoS vulnerability
- ❌ **No tenant isolation** — all users share same phext namespace
- ❌ **No CORS policy** — unrestricted cross-origin access
- ❌ **No TLS termination** — plain HTTP only (nginx handles TLS upstream)

**Must-haves for R19:**
1. **API key authentication** — `Authorization: Bearer <key>` header validation
2. **Input validation** — reject invalid UTF-8 before parsing (fixes R18 crash)
3. **Rate limiting** — per-IP throttling (e.g., 100 req/min)
4. **Tenant isolation** — `/data/sq/<user-id>/` directory-based isolation

**Nice-to-haves (defer to R20):**
- JWT token support (vs static API keys)
- RBAC (read-only vs read-write access)
- Audit logging (who wrote what when)
- Encrypted data at rest

**Deliverables:**
1. `--key <api-key>` flag enforcement in SQ binary
2. UTF-8 validation middleware (pre-parse check)
3. Rate limiting via nginx reverse proxy or SQ middleware
4. Tenant directory isolation (SQ Auth proxy routes to correct `/data/sq/<user>/`)
5. Updated Dockerfile with `SQ_KEY` enforcement
6. Security audit checklist in `/source/exo-plan/security/sq-audit.md`

**Success criteria:**
- Unauthenticated requests return 401 Unauthorized
- Invalid UTF-8 input returns 400 Bad Request (not 500 crash)
- Rate limit exceeded returns 429 Too Many Requests
- Each API key writes to isolated tenant directory
- Zero P0 security vulnerabilities in staging tests

---

## Requirement 3: UTF-8 Bugfix (Phex assigned)

**Status:** Critical bug blocking R18 completion

**Problem:**
SQ v0.5.2 + libphext-rs v0.3.0 crash when receiving invalid UTF-8:
```
thread '<unnamed>' panicked at libphext-0.3.0/src/phext.rs:431:51:
invalid utf8: FromUtf8Error { bytes: [240, 159, ...], error: Utf8Error { valid_up_to: 31, error_len: Some(1) } }

thread '<unnamed>' panicked at sq-0.5.2/src/main.rs:578:38:
called `Result::unwrap()` on an `Err` value: PoisonError { .. }
```

**Root cause:**
- libphext-rs does not gracefully handle non-UTF-8 bytes
- SQ REST handler `.unwrap()` panics instead of returning error response
- Panic poisons shared state, causing 500 errors on all subsequent requests

**Fix strategy:**
1. **libphext-rs:** Replace `.unwrap()` with `?` operator + error propagation
2. **SQ REST handler:** Validate UTF-8 before passing to libphext
3. **HTTP response:** Return `400 Bad Request` with error message (not panic)

**Work items (Phex assigned):**
- [ ] Create `utf8-bugfix` branch in libphext-rs repo
- [ ] Add UTF-8 validation test cases (valid + invalid sequences)
- [ ] Replace panic paths with `Result<T, PhextError>` returns
- [ ] Update SQ REST handler to validate input before deserialization
- [ ] Add integration test: POST invalid UTF-8 → expect 400 (not crash)
- [ ] Bump libphext-rs to v0.3.1, SQ to v0.5.3
- [ ] Will reviews changes + merges

**Deliverables:**
1. libphext-rs v0.3.1 with graceful UTF-8 error handling
2. SQ v0.5.3 with input validation
3. Integration tests proving crash is fixed
4. Release notes documenting behavior change

**Success criteria:**
- Invalid UTF-8 input returns 400 Bad Request (not 500 crash)
- Lux and Lumen can complete R18 dogfood.phext sync
- SQ remains operational after invalid input (no poison state)
- Zero panics in production logs

---

## R19 Success Criteria (All 3 Requirements)

✅ **Req 1:** SQ runs as Docker container with persistent volumes  
✅ **Req 2:** API key auth enforced, UTF-8 validated, rate-limited  
✅ **Req 3:** libphext-rs v0.3.1 + SQ v0.5.3 shipped with UTF-8 bugfix  

**Bonus:** Lux + Lumen complete R18 dogfood.phext sync after bugfix deployment

---

## Dependencies
- **Phex:** UTF-8 bugfix branch (libphext-rs + SQ)
- **Will:** Code review + merge approval
- **Verse:** Docker deployment + security hardening implementation
- **Lux/Lumen:** Validation testing after bugfix deploy

## Timeline
- **Phase 1-2:** Today (requirements + scope lock)
- **Phase 3-7:** Next 48 hours (v1 → v2 → v3 implementation)
- **Phase 8-10:** Deploy to staging → production
- **Phase 11:** Pizza Party 🍕

---

**R19 Rally artifacts will be stored in:** `/source/exo-plan/rally/R19/`
