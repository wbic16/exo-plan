# SQ TLS Deployment - Feb 11, 2026

**Status:** In Progress
**Goal:** Get `https://sq.mirrorborn.us` live with TLS
**Auth:** None yet (Will deploying tonight)

## Pre-Deployment Checklist

### ✅ DNS Configured
```bash
$ host sq.mirrorborn.us
sq.mirrorborn.us is an alias for mirrorborn.us.
mirrorborn.us has address 44.248.235.76
```

### ✅ SQ Binary Built
```bash
/source/SQ/target/release/sq (745KB, release mode)
```

### ⏳ SQ Not Running
```bash
curl http://127.0.0.1:1337/version
→ Connection refused
```

Need to start SQ server before nginx deployment.

---

## Deployment Steps

### 1. Start SQ Server

**Command:**
```bash
cd /source/SQ
./target/release/sq host 1337
```

**Run as systemd service:**
```bash
sudo nano /etc/systemd/system/sq.service
```

```ini
[Unit]
Description=SQ Cloud Server
After=network.target

[Service]
Type=simple
User=wbic16
WorkingDirectory=/source/SQ
ExecStart=/source/SQ/target/release/sq host 1337
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable sq
sudo systemctl start sq
sudo systemctl status sq
```

**Test:**
```bash
curl http://127.0.0.1:1337/version
```

---

### 2. Install Nginx & Certbot

```bash
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx
```

---

### 3. Deploy Nginx Config

**Copy config:**
```bash
sudo cp /source/exo-plan/rally/R19/nginx-sq-cloud.conf /etc/nginx/sites-available/sq-cloud
```

**Edit for no-auth (Will adding auth tonight):**
```bash
sudo nano /etc/nginx/sites-available/sq-cloud
```

Remove these lines:
```nginx
# Basic authentication (temporary until API keys)
auth_basic "SQ Cloud Alpha Access";
auth_basic_user_file /etc/nginx/.htpasswd;
```

**Enable site:**
```bash
sudo ln -s /etc/nginx/sites-available/sq-cloud /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

### 4. Obtain LetsEncrypt Certificate

```bash
sudo certbot certonly --nginx -d sq.mirrorborn.us --email will@phext.io --agree-tos --non-interactive
```

**Expected output:**
```
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/sq.mirrorborn.us/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/sq.mirrorborn.us/privkey.pem
```

**Reload nginx:**
```bash
sudo systemctl reload nginx
```

---

### 5. Firewall Configuration

**Block external access to port 1337:**
```bash
sudo ufw deny 1337/tcp comment "SQ - localhost only"
sudo ufw allow 443/tcp comment "HTTPS - SQ Cloud"
sudo ufw allow 80/tcp comment "HTTP - redirect to HTTPS"
sudo ufw status
```

**Or with iptables:**
```bash
sudo iptables -I INPUT -p tcp --dport 1337 ! -s 127.0.0.1 -j DROP
sudo iptables-save > /etc/iptables/rules.v4
```

---

## Testing

### Test 1: Port 1337 Blocked Externally
```bash
curl http://44.248.235.76:1337/version
→ Connection refused (good!)
```

### Test 2: Localhost Access Works
```bash
curl http://127.0.0.1:1337/version
→ SQ version response (good!)
```

### Test 3: HTTPS Endpoint Live
```bash
curl https://sq.mirrorborn.us/version
→ SQ version response (good!)
```

### Test 4: HTTP Redirects to HTTPS
```bash
curl -I http://sq.mirrorborn.us/version
→ 301 redirect to https:// (good!)
```

### Test 5: TLS Certificate Valid
```bash
curl -vI https://sq.mirrorborn.us/version 2>&1 | grep "SSL certificate verify ok"
→ SSL certificate verify ok (good!)
```

---

## Post-Deployment

### Monitor Logs
```bash
# Nginx access log
tail -f /var/log/nginx/sq-cloud-access.log

# Nginx error log
tail -f /var/log/nginx/sq-cloud-error.log

# SQ service log
sudo journalctl -u sq -f
```

### Auto-Renewal
LetsEncrypt certs auto-renew via certbot timer:
```bash
sudo systemctl status certbot.timer
```

### Health Check
```bash
# From external host:
curl https://sq.mirrorborn.us/version

# Expected:
{"version":"0.5.2","libphext":"0.3.1"}
```

---

## Security Notes (Pre-Auth)

⚠️ **OPEN ENDPOINT UNTIL AUTH DEPLOYED**

**Current state:**
- Anyone can access `https://sq.mirrorborn.us`
- No authentication
- All coordinates readable/writable by anyone

**Will is deploying auth tonight:**
- Magic link authentication
- API key validation
- Namespace isolation per user

**Mitigation for now:**
- Monitor access logs
- Can add IP allowlist if needed
- Temporary, auth coming soon

---

## Rollback Plan

If deployment fails:

```bash
# Stop SQ
sudo systemctl stop sq

# Disable nginx site
sudo rm /etc/nginx/sites-enabled/sq-cloud
sudo systemctl reload nginx

# Restore port 1337 direct access
sudo ufw delete deny 1337/tcp
```

---

## Next Steps (Will's Work Tonight)

1. Deploy auth backend (magic links)
2. Update nginx config to validate API keys
3. Enable namespace isolation in SQ
4. Test end-to-end signup flow
5. Announce to OpenClaw community

---

**Deployment Time Estimate:** 30-45 minutes
**Current Blocker:** SQ not running (need to start service)
