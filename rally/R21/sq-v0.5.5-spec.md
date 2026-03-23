# SQ v0.5.5 Specification

**Goal:** Multi-tenant production readiness  
**Release Target:** 2026-02-12 (TODAY)  
**Owner:** Phex 🔱

---

## Critical Features (Launch Blockers)

### 1. Tenant Namespace Isolation
**Problem:** All users currently share same coordinate space  
**Solution:** Automatic coordinate prefixing per API key

**Implementation:**
```rust
// On every insert/load/update/delete request:
let tenant_id = validate_api_key(&auth_header)?;
let prefixed_coord = format!("{}.{}", tenant_id, user_coord);
// Use prefixed_coord for all operations
```

**Example:**
- User with API key `pmb-v1-abc123` (tenant: `will`)
- User writes to coordinate `1.1.1/1.1.1/1.1.1`
- SQ stores at `will.1.1.1/1.1.1/1.1.1`
- Other tenants cannot read/write `will.*` coordinates

**Impact:** Enables multi-user SQ Cloud launch

---

### 2. Tenant Configuration File
**Problem:** Current auth requires command-line flag `--key`, no multi-tenant support  
**Solution:** JSON config file with tenant definitions

**File:** `/etc/sq/tenants.json`

```json
{
  "tenants": [
    {
      "id": "will",
      "api_key": "pmb-v1-6da75a3244e11b5be2065421b246f16a",
      "data_dir": "/var/lib/sq/tenants/will",
      "quota_mb": 1000,
      "enabled": true
    },
    {
      "id": "phext-notepad",
      "api_key": "pmb-v1-16f2adaed8e22f87c789188e8dcdd55b",
      "data_dir": "/var/lib/sq/tenants/phext-notepad",
      "quota_mb": 500,
      "enabled": true
    }
  ],
  "reload_on_change": true
}
```

**Features:**
- One SQ process, multiple tenants (no systemd complexity)
- File watcher: reload config without restart
- Per-tenant data isolation
- Per-tenant quota enforcement

---

### 3. Management API
**Endpoints:**

#### `POST /api/v2/admin/tenants/add`
**Auth:** Admin API key (separate from tenant keys)  
**Request:**
```json
{
  "tenant_id": "customer-001",
  "quota_mb": 500,
  "admin_email": "customer@example.com"
}
```
**Response:**
```json
{
  "tenant_id": "customer-001",
  "api_key": "pmb-v1-generated-token",
  "data_dir": "/var/lib/sq/tenants/customer-001",
  "status": "active"
}
```

#### `DELETE /api/v2/admin/tenants/:tenant_id`
**Auth:** Admin API key  
**Action:** Disable tenant, archive data

#### `GET /api/v2/admin/tenants/:tenant_id/stats`
**Auth:** Admin API key  
**Response:**
```json
{
  "tenant_id": "will",
  "storage_used_mb": 234.5,
  "quota_mb": 1000,
  "api_calls_today": 1523,
  "last_active": "2026-02-12T13:05:00Z"
}
```

---

### 4. Metrics Endpoint
**Endpoint:** `GET /api/v2/metrics`  
**Auth:** Admin API key  
**Format:** Prometheus-compatible

```
# HELP sq_storage_bytes Total storage used per tenant
# TYPE sq_storage_bytes gauge
sq_storage_bytes{tenant="will"} 245760000
sq_storage_bytes{tenant="phext-notepad"} 52428800

# HELP sq_api_calls_total Total API calls per tenant
# TYPE sq_api_calls_total counter
sq_api_calls_total{tenant="will",method="insert"} 523
sq_api_calls_total{tenant="will",method="load"} 1245

# HELP sq_tenants_active Number of active tenants
# TYPE sq_tenants_active gauge
sq_tenants_active 5
```

---

## Implementation Plan

### Phase 1: Tenant Namespace Isolation (2 hours)
**Files to modify:**
- `src/main.rs` - Add tenant prefix logic to all endpoints
- `src/auth.rs` - Extract tenant_id from API key

**Tests:**
1. Write as tenant A, cannot read as tenant B
2. Quota enforcement per tenant
3. Coordinate collision prevention

---

### Phase 2: Config File Support (1 hour)
**New files:**
- `src/tenant_config.rs` - Config file loading + watching
- `/etc/sq/tenants.json` - Default config template

**Changes:**
- Remove `--key` flag, use config file
- Add `--config` flag (default: `/etc/sq/tenants.json`)
- File watcher: reload on config change

---

### Phase 3: Management API (2 hours)
**New files:**
- `src/admin_api.rs` - Admin endpoints

**Endpoints:**
- `POST /api/v2/admin/tenants/add`
- `DELETE /api/v2/admin/tenants/:id`
- `GET /api/v2/admin/tenants/:id/stats`
- `GET /api/v2/admin/tenants` - List all

---

### Phase 4: Metrics (1 hour)
**New files:**
- `src/metrics.rs` - Prometheus exporter

**Endpoint:**
- `GET /api/v2/metrics`

---

## Testing Checklist

### Isolation Tests
- [ ] Tenant A writes to `1.1.1/1.1.1/1.1.1`
- [ ] Tenant B writes to `1.1.1/1.1.1/1.1.1`
- [ ] Both succeed, both read only their own data
- [ ] Tenant A cannot read Tenant B's coordinate

### Quota Tests
- [ ] Tenant exceeds quota → reject with 507 (Insufficient Storage)
- [ ] Tenant at 90% quota → warning in logs
- [ ] Admin can increase quota via API

### Config Reload Tests
- [ ] Add new tenant to config file
- [ ] SQ detects change within 5 seconds
- [ ] New tenant can authenticate immediately

### Management API Tests
- [ ] Add tenant via API → appears in config
- [ ] Delete tenant → disabled flag set
- [ ] Stats endpoint returns accurate metrics

### Multi-Tenant Load Test
- [ ] 10 tenants, 100 req/sec each → no cross-tenant leaks
- [ ] Memory usage scales linearly with tenant count

---

## Deployment Migration

**v0.5.3 → v0.5.5 upgrade:**

```bash
# Stop old instance
sudo systemctl stop sq

# Backup data
sudo cp -r /var/lib/sq /var/lib/sq.backup

# Install v0.5.5
cd /source/SQ
git pull origin main
cargo build --release
sudo cp target/release/sq /usr/local/bin/

# Create config file
sudo mkdir -p /etc/sq
sudo cp tenants.json.example /etc/sq/tenants.json
# Edit: Add tenant definitions

# Migrate data (if needed)
# No migration needed - coordinate space unchanged

# Start v0.5.5
sudo systemctl start sq

# Verify
curl -H "Authorization: Bearer <api-key>" \
     https://sq.mirrorborn.us/api/v2/version
# Expected: {"version":"0.5.5"}
```

---

## Breaking Changes

### Command-line flags
- **Removed:** `--key <api-key>` (single tenant mode)
- **Added:** `--config <path>` (multi-tenant mode, default: `/etc/sq/tenants.json`)
- **Added:** `--admin-key <key>` (for management API)

### Coordinate space
- **No breaking changes** - existing coordinates work as-is
- **Automatic migration** - single-tenant data becomes `default.*` namespace

---

## Success Criteria

**v0.5.5 ships when:**
- [ ] Tenant isolation tests pass (100% isolation)
- [ ] Config file reload works (no restart needed)
- [ ] Management API functional (add/delete/stats)
- [ ] Metrics endpoint returns accurate data
- [ ] Phext Notepad connects successfully
- [ ] OpenClaw sq-memory skill works with new auth

---

## Timeline

**Total: 6 hours (one Opus slice + one qwen3 slice)**

- 13:10 → 15:10 (2h) - Phase 1: Namespace isolation
- 15:10 → 16:10 (1h) - Phase 2: Config file
- 16:10 → 18:10 (2h) - Phase 3: Management API
- 18:10 → 19:10 (1h) - Phase 4: Metrics
- 19:10 → 20:00 (50m) - Testing + deployment

**Target release:** 2026-02-12 20:00 CST (8 PM)

---

## Open Questions

1. **Admin API key generation** - How to bootstrap first admin key?
2. **Tenant ID collision prevention** - UUID vs human-readable IDs?
3. **Data migration tool** - Needed for existing phext.io SQ instance?
4. **Quota enforcement granularity** - Per-phext or per-coordinate?

---

**Status:** Ready to implement  
**Next:** Start Phase 1 (namespace isolation)

---

*Rally R21 - SQ v0.5.5 - Production Multi-Tenancy*
