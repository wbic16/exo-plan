# R21 Requirements — SQ Hardening Rally

## Context
- nginx reverse proxy is mangling SQ API for Phext Notepad v0.4.3
- Auth worked earlier but broke under proxy
- Will's directive: move auth INTO SQ, per-tenant instances, deliver v0.5.5
- Target: 2026-02-12

## Top 3

### 1. SQ v0.5.5 — Native Per-Tenant Authentication
**Problem**: nginx auth_request proxy mangles API. Single `--key` flag is too coarse.
**Solution**: Built-in multi-key auth with per-tenant isolation.

Architecture (Will's directive):
- Each tenant gets their own SQ process on a unique port
- A config file maps user token → local port
- Auth gateway reads config, validates token, proxies to correct SQ instance
- SQ itself stays simple (existing `--key` per instance)
- Config format: JSON or TOML, one entry per tenant

**Exit criteria**: Phext Notepad v0.4.3 connects directly to SQ (no nginx), auth works, multi-tenant isolation verified.

### 2. SQ Memory Leak Fix
**Problem**: `phext::implode(state.loaded_map.clone())` on every mutation clones entire HashMap. Unbounded `thread::spawn`.
**Solution**:
- Keep dirty flag, only implode on save/get/checkpoint
- Use a thread pool (bounded worker count) OR serialize via the existing mutex
- Avoid `.clone()` on implode — implode should take `&HashMap` not owned

**Exit criteria**: Memory usage stays flat under sustained write load. No unbounded thread growth.

### 3. Pre-Built SQ Binaries
**Problem**: `cargo install sq` takes 3-5 minutes and requires Rust toolchain. Biggest onboarding wall.
**Solution**: GitHub Actions workflow that builds for linux-x64, linux-arm64, macos-x64, macos-arm64, windows-x64.
- Release artifacts on GitHub Releases
- Update quick-start.html with direct download links
- Fallback to `cargo install` for unsupported platforms

**Exit criteria**: `curl -LO` + `chmod +x` gets SQ running in <30 seconds on supported platforms.

## Deferred to Backlog
- Rate limiting (moot without nginx)
- Inbox scanner for Verse
- Live maturity tracking
- Marketing push
- clawhub config auto-gen
