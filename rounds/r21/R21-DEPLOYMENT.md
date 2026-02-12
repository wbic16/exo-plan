# R21 Deployment Guide
**Target:** SQ v0.5.5 with per-tenant auth  
**Deadline:** 2026-02-12 (TODAY)  
**Owners:** Phex (SQ), Verse (phext.io deployment), Lux (coordination)

---

## Architecture

```
Client → nginx (TLS + token routing) → SQ instances (per-tenant, with auth)
```

**Key insight:** SQ v0.5.3 already has auth built-in. We just need:
1. Per-tenant SQ processes (--key, --data-dir)
2. nginx routing (token → port mapping)
3. systemd management (auto-restart, resource limits)

---

## Deployment Steps

### 1. Install systemd service templates

```bash
# On phext.io
sudo cp r21/sq-tenant.service /etc/systemd/system/sq-tenant@.service
sudo cp r21/sq-tenants.target /etc/systemd/system/sq-tenants.target
sudo systemctl daemon-reload
```

### 2. Create SQ user (if not exists)

```bash
sudo useradd -r -s /bin/false sq
sudo mkdir -p /var/lib/sq/tenants
sudo chown -R sq:sq /var/lib/sq
```

### 3. Deploy test tenant

```bash
./r21/deploy-sq-tenant.sh testuser 8001
# Output: API key (pmb-v1-xxxx)
```

### 4. Update nginx config

```bash
# Edit /etc/nginx/sites-available/sq.mirrorborn.us
# Add to map block:
#   "Bearer pmb-v1-xxxx" "8001";

sudo nginx -t
sudo systemctl reload nginx
```

### 5. Test end-to-end

```bash
# Local test
curl -H "Authorization: Bearer pmb-v1-xxxx" \
     http://localhost:8001/api/v2/version

# Public test
curl -H "Authorization: Bearer pmb-v1-xxxx" \
     https://sq.mirrorborn.us/api/v2/version
```

### 6. Test with Phext Notepad

Update Phext Notepad config:
```json
{
  "sq_endpoint": "https://sq.mirrorborn.us",
  "sq_api_key": "pmb-v1-xxxx",
  "phext_namespace": "notepad"
}
```

Test write/read operations.

---

## SQ v0.5.5 Changes (if needed)

**Current assessment:** SQ v0.5.3 already has everything we need.

**Potential v0.5.5 additions:**
- Config file watcher (reload token routing without nginx restart)
- Management API (add/remove tenants dynamically)
- Metrics endpoint (per-tenant usage stats)

**Decision:** Ship with existing SQ v0.5.3 first, iterate if needed.

---

## Files Delivered

- `nginx-sq-routing.conf` - nginx config with token → port mapping
- `sq-tenant.service` - systemd service template for per-tenant SQ
- `sq-tenants.target` - systemd target for managing all tenants
- `deploy-sq-tenant.sh` - Script to deploy new tenant instance
- `R21-DEPLOYMENT.md` - This guide

---

## Handoff

**Verse:** Deploy nginx config + systemd templates to phext.io  
**Phex:** Review SQ v0.5.3 auth implementation, confirm no changes needed  
**Lux:** Coordinate testing, update sq-memory skill if needed

**Status:** Artifacts ready. Deployment can begin.

---

**R21 LAUNCH: T-minus 8 hours. Let's ship. 🚀**
