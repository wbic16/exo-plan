# R20 TLS Deployment - Ready to Execute

**Status:** All deployment files prepared
**Location:** `/tmp/deploy-sq-tls.sh` (ready to run)
**Estimated Time:** 30-45 minutes

---

## Deployment Files Created

### 1. `/tmp/sq.service`
Systemd service file for SQ Cloud server
- Runs: `/source/SQ/target/release/sq 1337`
- User: wbic16
- Auto-restart on failure
- Logs to journalctl

### 2. `/tmp/nginx-sq-cloud-no-auth.conf`
Nginx reverse proxy config (NO AUTH - Will deploying tonight)
- Endpoint: `https://sq.mirrorborn.us`
- TLS: LetsEncrypt
- CORS: Enabled
- Proxies to localhost:1337

### 3. `/tmp/deploy-sq-tls.sh`
Automated deployment script (executable)

**What it does:**
1. Installs nginx + certbot (if needed)
2. Creates SQ systemd service
3. Starts SQ on port 1337
4. Obtains LetsEncrypt cert for sq.mirrorborn.us
5. Deploys nginx config
6. Configures firewall (port 1337 localhost-only)
7. Tests deployment

---

## Execute Deployment

### Option 1: Run Automated Script
```bash
sudo /tmp/deploy-sq-tls.sh
```

### Option 2: Manual Steps

**Start SQ:**
```bash
sudo cp /tmp/sq.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable sq
sudo systemctl start sq
```

**Get LetsEncrypt Cert:**
```bash
sudo certbot certonly --nginx -d sq.mirrorborn.us --email will@phext.io --agree-tos --non-interactive
```

**Deploy Nginx:**
```bash
sudo cp /tmp/nginx-sq-cloud-no-auth.conf /etc/nginx/sites-available/sq-cloud
sudo ln -sf /etc/nginx/sites-available/sq-cloud /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

**Firewall:**
```bash
sudo ufw allow 443/tcp
sudo ufw allow 80/tcp
sudo ufw deny 1337/tcp
```

---

## Verification

**After deployment, test:**

```bash
# 1. SQ service running
sudo systemctl status sq

# 2. Localhost access works
curl http://127.0.0.1:1337/api/v2/version

# 3. HTTPS endpoint live
curl https://sq.mirrorborn.us/api/v2/version

# 4. Port 1337 blocked externally
curl http://44.248.235.76:1337/api/v2/version
# Should fail: Connection refused

# 5. HTTP redirects to HTTPS
curl -I http://sq.mirrorborn.us/
# Should return: 301 Moved Permanently
```

---

## Security Warning

⚠️ **NO AUTHENTICATION YET**

The endpoint will be publicly accessible at `https://sq.mirrorborn.us` with:
- No API keys
- No user isolation
- Anyone can read/write any coordinate

**Will is deploying auth tonight.**

**Mitigation options:**
1. Deploy as-is (monitor access logs)
2. Add temporary IP allowlist to nginx config
3. Wait for Will to deploy auth first

---

## Monitoring

**SQ service logs:**
```bash
sudo journalctl -u sq -f
```

**Nginx access log:**
```bash
tail -f /var/log/nginx/sq-cloud-access.log
```

**Nginx error log:**
```bash
tail -f /var/log/nginx/sq-cloud-error.log
```

---

## What Will Deploys Tonight

1. **Auth backend** (magic links)
   - Signup endpoint
   - Email verification
   - API key generation
   
2. **Nginx auth middleware**
   - Validate API keys from headers
   - Reject unauthenticated requests
   
3. **Namespace isolation in SQ**
   - Prepend user ID to coordinates
   - Enforce user boundaries

---

## Rollback

If deployment fails:

```bash
# Stop SQ
sudo systemctl stop sq
sudo systemctl disable sq

# Remove nginx config
sudo rm /etc/nginx/sites-enabled/sq-cloud
sudo systemctl reload nginx

# Re-allow port 1337 externally (if needed)
sudo ufw delete deny 1337/tcp
```

---

## Current Status

✅ All deployment files ready in `/tmp/`
✅ DNS configured (sq.mirrorborn.us → 44.248.235.76)
✅ SQ binary built (/source/SQ/target/release/sq)
⏳ Waiting for execution approval

**Ready to deploy when you say go.** 🔱
