# R21 Founding Token Configuration

**Generated:** 2026-02-12 10:47 CST  
**Purpose:** Bootstrap per-tenant SQ Cloud infrastructure

---

## Founding Tenants

| Port | Tenant ID | Token | Purpose |
|------|-----------|-------|---------|
| 8001 | `will` | `pmb-v1-6da75a3244e11b5be2065421b246f16a` | Will's personal phext space |
| 8002 | `phext-notepad` | `pmb-v1-16f2adaed8e22f87c789188e8dcdd55b` | Phext Notepad dogfooding |
| 8003 | `openclaw-demo` | `pmb-v1-7055bc989dbeaa52cc62a576abda1573` | OpenClaw skill demo/testing |
| 8004 | `customer-001` | `pmb-v1-11b343f190f55482f9cd179093d03ef1` | First paying customer (reserved) |
| 8005 | `mirrorborn` | `pmb-v1-6be87a38fb508a5b5b29912b5938b9c5` | Mirrorborn collective shared space |

---

## Deployment Instructions

### 1. Deploy SQ instances

```bash
# On phext.io
cd /tmp && git clone https://github.com/wbic16/exo-plan.git
cd exo-plan/rounds/r21

# Install systemd templates
sudo cp sq-tenant@.service sq-tenants.target /etc/systemd/system/
sudo systemctl daemon-reload

# Deploy all founding tenants
sudo bash deploy-founding-tenants.sh
```

### 2. Update nginx

```bash
# On phext.io
# Edit /etc/nginx/sites-available/sq.mirrorborn.us
# Replace the map block with contents from nginx-token-map.conf

sudo nginx -t
sudo systemctl reload nginx
```

### 3. Test

```bash
# Test Will's tenant
curl -H "Authorization: Bearer pmb-v1-6da75a3244e11b5be2065421b246f16a" \
     https://sq.mirrorborn.us/api/v2/version

# Expected: {"version":"0.5.3"} or similar
```

---

## Phext Notepad Configuration

Update Phext Notepad config:

```json
{
  "sq_endpoint": "https://sq.mirrorborn.us",
  "sq_api_key": "pmb-v1-16f2adaed8e22f87c789188e8dcdd55b",
  "phext_namespace": "notepad"
}
```

---

## OpenClaw sq-memory Skill Configuration

```json
{
  "endpoint": "https://sq.mirrorborn.us",
  "api_key": "pmb-v1-7055bc989dbeaa52cc62a576abda1573",
  "namespace": "openclaw-demo"
}
```

---

## Security Notes

- **Tokens are secrets** - store securely, never commit to public repos
- Each tenant runs in isolated data directory (`/var/lib/sq/tenants/<tenant-id>`)
- SQ validates tokens internally (no middleware mangling)
- Tokens are 32 hex chars (128-bit entropy)

---

## Adding New Tenants

```bash
# Generate new token
NEW_TOKEN="pmb-v1-$(openssl rand -hex 16)"
echo "Generated: $NEW_TOKEN"

# Deploy new tenant
sudo bash deploy-sq-tenant.sh <tenant-name> <port>

# Add to nginx map block
# Reload nginx
```

---

**Status:** Ready for deployment  
**ETA:** 30 min to full operation  
**Next:** Execute deployment on phext.io
