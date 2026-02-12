# SQ v0.5.5 Implementation Tasks

**Status:** Not started  
**Timeline:** 6 hours total  
**Current version:** v0.5.3

---

## Phase 1: Tenant Namespace Isolation (2h) ⚡ CRITICAL

### Task 1.1: Create `src/tenant_config.rs`
```rust
pub struct Tenant {
    pub id: String,
    pub api_key: String,
    pub data_dir: String,
    pub quota_mb: usize,
    pub enabled: bool,
}

pub struct TenantConfig {
    pub tenants: Vec<Tenant>,
}

impl TenantConfig {
    pub fn load(path: &str) -> Result<Self, String> { /* ... */ }
    pub fn get_tenant_by_key(&self, api_key: &str) -> Option<&Tenant> { /* ... */ }
}
```

### Task 1.2: Modify `src/main.rs`
**Changes needed:**
1. Add `mod tenant_config;`
2. Load config at startup: `let config = TenantConfig::load("/etc/sq/tenants.json")?;`
3. Wrap in `Arc<Mutex<>>` for thread safety
4. Pass to HTTP handler

### Task 1.3: Update `validate_auth()` in `src/main.rs`
**Current:** Returns bool  
**New:** Returns `Option<String>` (tenant ID)

```rust
fn validate_auth(header: &str, config: &TenantConfig) -> Option<String> {
    let token = extract_bearer_token(header)?;
    config.get_tenant_by_key(token).map(|t| t.id.clone())
}
```

### Task 1.4: Add coordinate prefixing to ALL endpoints
**Affected functions:**
- `handle_insert()`
- `handle_load()`
- `handle_update()`
- `handle_delete()`
- `handle_select()`
- `handle_toc()`

**Change pattern:**
```rust
// Before:
let coord = parse_coordinate(&params["c"])?;

// After:
let tenant_id = validate_auth(&header, &config)?;
let user_coord = parse_coordinate(&params["c"])?;
let prefixed_coord = format!("{}.{}", tenant_id, user_coord);
let coord = parse_coordinate(&prefixed_coord)?;
```

### Task 1.5: Per-tenant data directories
**Current:** Single data dir (`/var/lib/sq/`)  
**New:** Per-tenant subdirs (`/var/lib/sq/tenants/{tenant_id}/`)

Update phext file paths:
```rust
let phext_path = format!("{}/{}.phext", tenant.data_dir, phext_name);
```

---

## Phase 2: Config File Support (1h)

### Task 2.1: Create `/etc/sq/tenants.json.example`
```json
{
  "admin_key": "pmb-admin-CHANGE-THIS",
  "tenants": [
    {
      "id": "example",
      "api_key": "pmb-v1-CHANGE-THIS",
      "data_dir": "/var/lib/sq/tenants/example",
      "quota_mb": 1000,
      "enabled": true
    }
  ]
}
```

### Task 2.2: Add `--config` flag to `main()`
```rust
let config_path = env::var("SQ_CONFIG").unwrap_or("/etc/sq/tenants.json".to_string());
// OR use clap for proper CLI parsing
```

### Task 2.3: File watcher for config reload (optional for MVP)
Use `notify` crate:
```rust
use notify::{Watcher, RecursiveMode, watcher};

let (tx, rx) = channel();
let mut watcher = watcher(tx, Duration::from_secs(2))?;
watcher.watch("/etc/sq/tenants.json", RecursiveMode::NonRecursive)?;

// In separate thread:
loop {
    match rx.recv() {
        Ok(event) => {
            let new_config = TenantConfig::load("/etc/sq/tenants.json")?;
            *config_arc.lock().unwrap() = new_config;
        }
    }
}
```

### Task 2.4: Update `Cargo.toml`
```toml
[dependencies]
libphext = "0.3.1"
percent-encoding = "2.3.1"
raw_sync = "0.1.5"
shared_memory = "0.12.4"
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
notify = "6.0"  # For file watching
```

---

## Phase 3: Management API (2h)

### Task 3.1: Create `src/admin_api.rs`
```rust
pub fn handle_admin_request(
    path: &str,
    method: &str,
    header: &str,
    body: &str,
    config: &Arc<Mutex<TenantConfig>>,
) -> String {
    // Validate admin key
    if !validate_admin_auth(header, config) {
        return http_response(403, "Forbidden");
    }

    match (method, path) {
        ("POST", "/api/v2/admin/tenants/add") => add_tenant(body, config),
        ("DELETE", path) if path.starts_with("/api/v2/admin/tenants/") => delete_tenant(path, config),
        ("GET", path) if path.starts_with("/api/v2/admin/tenants/") => get_tenant_stats(path, config),
        ("GET", "/api/v2/admin/tenants") => list_tenants(config),
        _ => http_response(404, "Not Found"),
    }
}
```

### Task 3.2: Implement admin endpoints
```rust
fn add_tenant(body: &str, config: &Arc<Mutex<TenantConfig>>) -> String {
    let request: AddTenantRequest = serde_json::from_str(body)?;
    
    // Generate API key
    let api_key = format!("pmb-v1-{}", generate_random_hex(16));
    
    // Create tenant
    let tenant = Tenant {
        id: request.tenant_id,
        api_key,
        data_dir: format!("/var/lib/sq/tenants/{}", request.tenant_id),
        quota_mb: request.quota_mb,
        enabled: true,
    };
    
    // Add to config
    let mut cfg = config.lock().unwrap();
    cfg.tenants.push(tenant.clone());
    
    // Write to disk
    save_config(&cfg, "/etc/sq/tenants.json")?;
    
    // Return response
    http_json_response(200, &serde_json::to_string(&tenant)?)
}
```

### Task 3.3: Wire into main HTTP handler
```rust
// In handle_client():
if path.starts_with("/api/v2/admin/") {
    return handle_admin_request(path, method, &header, &body, &config);
}
```

---

## Phase 4: Metrics (1h)

### Task 4.1: Create `src/metrics.rs`
```rust
pub fn generate_metrics(config: &TenantConfig) -> String {
    let mut output = String::new();
    
    // Storage metrics
    output.push_str("# HELP sq_storage_bytes Total storage per tenant\n");
    output.push_str("# TYPE sq_storage_bytes gauge\n");
    for tenant in &config.tenants {
        let size = calculate_tenant_storage(&tenant.data_dir);
        output.push_str(&format!("sq_storage_bytes{{tenant=\"{}\"}} {}\n", tenant.id, size));
    }
    
    // Tenant count
    output.push_str("# HELP sq_tenants_active Active tenant count\n");
    output.push_str("# TYPE sq_tenants_active gauge\n");
    output.push_str(&format!("sq_tenants_active {}\n", config.tenants.len()));
    
    output
}

fn calculate_tenant_storage(data_dir: &str) -> u64 {
    // Walk directory, sum file sizes
    std::fs::read_dir(data_dir)
        .map(|entries| {
            entries.filter_map(|e| e.ok())
                .filter_map(|e| e.metadata().ok())
                .map(|m| m.len())
                .sum()
        })
        .unwrap_or(0)
}
```

### Task 4.2: Add metrics endpoint
```rust
// In handle_client():
if path == "/api/v2/metrics" {
    if !validate_admin_auth(&header, &config) {
        return http_response(403, "Forbidden");
    }
    let metrics = generate_metrics(&config.lock().unwrap());
    return http_response(200, &metrics);
}
```

---

## Testing Plan

### Test 1: Tenant Isolation
```bash
# Tenant A writes
curl -X POST -H "Authorization: Bearer tenant-a-key" \
  -d "p=test&c=1.1.1/1.1.1/1.1.1&text=Secret A" \
  http://localhost:1337/insert

# Tenant B writes same coordinate
curl -X POST -H "Authorization: Bearer tenant-b-key" \
  -d "p=test&c=1.1.1/1.1.1/1.1.1&text=Secret B" \
  http://localhost:1337/insert

# Tenant A reads - should get "Secret A"
curl -H "Authorization: Bearer tenant-a-key" \
  "http://localhost:1337/load?p=test&c=1.1.1/1.1.1/1.1.1"

# Tenant B reads - should get "Secret B"
curl -H "Authorization: Bearer tenant-b-key" \
  "http://localhost:1337/load?p=test&c=1.1.1/1.1.1/1.1.1"
```

### Test 2: Management API
```bash
# Add new tenant
curl -X POST -H "Authorization: Bearer admin-key" \
  -H "Content-Type: application/json" \
  -d '{"tenant_id":"customer-001","quota_mb":500}' \
  http://localhost:1337/api/v2/admin/tenants/add

# Get tenant stats
curl -H "Authorization: Bearer admin-key" \
  http://localhost:1337/api/v2/admin/tenants/customer-001/stats
```

### Test 3: Metrics
```bash
curl -H "Authorization: Bearer admin-key" \
  http://localhost:1337/api/v2/metrics
```

---

## File Checklist

### New Files
- [ ] `src/tenant_config.rs` - Config loading + tenant management
- [ ] `src/admin_api.rs` - Admin endpoints
- [ ] `src/metrics.rs` - Prometheus metrics
- [ ] `/etc/sq/tenants.json.example` - Config template

### Modified Files
- [ ] `src/main.rs` - Add tenant prefix logic to all endpoints
- [ ] `Cargo.toml` - Add serde, serde_json, notify

### New Directories
- [ ] `/var/lib/sq/tenants/` - Per-tenant data dirs
- [ ] `/etc/sq/` - Config directory

---

## Deployment Checklist

### Pre-Deploy
- [ ] Backup current data: `cp -r /var/lib/sq /var/lib/sq.backup-$(date +%Y%m%d)`
- [ ] Stop SQ: `sudo systemctl stop sq`
- [ ] Build v0.5.5: `cd /source/SQ && cargo build --release`
- [ ] Install binary: `sudo cp target/release/sq /usr/local/bin/`

### Configuration
- [ ] Create config dir: `sudo mkdir -p /etc/sq`
- [ ] Copy template: `sudo cp tenants.json.example /etc/sq/tenants.json`
- [ ] Generate admin key: `openssl rand -hex 32`
- [ ] Edit config: Add tenants, set admin key
- [ ] Set permissions: `sudo chown sq:sq /etc/sq/tenants.json`

### Data Migration
- [ ] Create tenant dirs: `sudo mkdir -p /var/lib/sq/tenants/{will,phext-notepad,...}`
- [ ] Move existing data: `sudo mv /var/lib/sq/*.phext /var/lib/sq/tenants/default/`
- [ ] Set ownership: `sudo chown -R sq:sq /var/lib/sq/tenants`

### Start & Test
- [ ] Start SQ: `sudo systemctl start sq`
- [ ] Check logs: `sudo journalctl -u sq -f`
- [ ] Test auth: `curl -H "Authorization: Bearer <key>" http://localhost:1337/api/v2/version`
- [ ] Test isolation: Run Test 1 above
- [ ] Test admin API: Run Test 2 above
- [ ] Test metrics: Run Test 3 above

---

## Rollback Plan

If v0.5.5 fails:
```bash
# Stop v0.5.5
sudo systemctl stop sq

# Restore v0.5.3 binary
sudo cp /usr/local/bin/sq.v0.5.3.backup /usr/local/bin/sq

# Restore data
sudo rm -rf /var/lib/sq
sudo cp -r /var/lib/sq.backup /var/lib/sq

# Restart v0.5.3
sudo systemctl start sq
```

---

## Summary

**6 hours of work:**
- 2h: Namespace isolation (core feature)
- 1h: Config file support
- 2h: Management API
- 1h: Metrics endpoint

**Critical path:** Phase 1 (namespace isolation) - without this, multi-tenant doesn't work

**Can ship without:** Phases 3-4 (management API + metrics) - nice-to-have for launch

**Minimum viable v0.5.5:** Phases 1-2 only (3 hours)

---

**Ready to start?** Begin with Phase 1, Task 1.1 (create `src/tenant_config.rs`)
