# SQ Cloud Founding Token Config - DELIVERED

**Status:** ✅ COMPLETE (2026-02-12 10:50 CST)  
**For:** Feb 13, 2026 Launch  
**Security:** CONFIDENTIAL - Actual tokens NOT committed to public repo

---

## Deliverables

### 1. Founding Token Configuration
**Location:** `/source/SQ/router-config-founding.json` (LOCAL ONLY)

5 founding tenants configured:
- **wbic16** (port 1338) - Founder/admin account
- **demo** (port 1339) - Test/demo account
- **alpha-001** (port 1340) - Reserved for early alpha user
- **alpha-002** (port 1341) - Reserved for early alpha user
- **alpha-003** (port 1342) - Reserved for early alpha user

Each tenant has unique `pmb-v1-` token (32-char hex, cryptographically secure via openssl).

### 2. Token Registry
**Location:** `/source/SQ/FOUNDING-TOKENS.md` (LOCAL ONLY)

Complete documentation including:
- Token→User→Port mapping table
- Usage examples (curl, systemd)
- Security best practices
- Token rotation procedures
- Backup instructions

### 3. systemd Production Infrastructure
**Committed to GitHub:** commit 9c8367a

Files delivered:
- `systemd/sq-router.service` - Router service (port 1337)
- `systemd/sq-backend-wbic16.service` - Will's backend (port 1338)
- `systemd/sq-backend-demo.service` - Demo backend (port 1339)
- `systemd/deploy-founding.sh` - Automated deployment script (executable)
- `systemd/README.md` (6.8 KB) - Complete ops guide
- `router-config-founding.example.json` - Sanitized public template

**Security Hardening:**
- `NoNewPrivileges=true` - Prevent privilege escalation
- `PrivateTmp=true` - Isolated /tmp
- `ProtectSystem=strict` - Read-only system directories
- `ProtectHome=true` - No /home access
- `MemoryMax=2G` - Per-backend memory limit
- `TasksMax=512` - Process limit

### 4. .gitignore Protection
Updated to exclude:
- `FOUNDING-TOKENS.md` - Token registry
- `router-config-founding.json` - Actual tenant config

Public repo contains only sanitized templates with `REPLACE_WITH_*` placeholders.

---

## Security Notes

### ⚠️ CRITICAL: Token Storage

**These files contain ACTUAL tokens and must NOT be committed:**
- `/source/SQ/router-config-founding.json`
- `/source/SQ/FOUNDING-TOKENS.md`

**Action Required (Will):**
1. Copy both files to secure location (1Password/Bitwarden)
2. Encrypt with GPG: `gpg --encrypt --recipient wbic16@gmail.com FOUNDING-TOKENS.md`
3. Store encrypted copy on production server: `/etc/sq/secrets/`
4. **DELETE** original files from `/source/SQ/` after verifying backup
5. Confirm deletion: `rm /source/SQ/FOUNDING-TOKENS.md /source/SQ/router-config-founding.json`

### Token Format
```
pmb-v1-<32-hex-characters>
Example: pmb-v1-a3f2b8c4d5e6f7a8b9c0d1e2f3a4b5c6
```

Generated via: `openssl rand -hex 16`

### Distribution
- **DO NOT** share via Discord, email, Slack, public GitHub
- **DO** share via password manager, encrypted email (PGP), Signal, in-person
- Tokens are bearer tokens (possession = access)

---

## Deployment Guide

### Quick Start (Production Server)

```bash
# 1. Secure the founding tokens
sudo mkdir -p /etc/sq/secrets
sudo cp /source/SQ/FOUNDING-TOKENS.md /etc/sq/secrets/
sudo gpg --encrypt --recipient wbic16@gmail.com /etc/sq/secrets/FOUNDING-TOKENS.md
sudo chmod 600 /etc/sq/secrets/FOUNDING-TOKENS.md.gpg
sudo rm /source/SQ/FOUNDING-TOKENS.md  # Remove from workspace

# 2. Copy config to production location
sudo cp /source/SQ/router-config-founding.json /etc/sq/router-config.json
sudo chmod 640 /etc/sq/router-config.json
sudo chown sq:sq /etc/sq/router-config.json
sudo rm /source/SQ/router-config-founding.json  # Remove from workspace

# 3. Build and install SQ binary
cd /source/SQ
cargo build --release
sudo cp target/release/sq /usr/local/bin/

# 4. Run automated deployment
cd /source/SQ/systemd
sudo ./deploy-founding.sh

# 5. Start services
sudo systemctl start sq-backend-wbic16
sudo systemctl start sq-backend-demo
sudo systemctl start sq-router

# 6. Test
curl -H "Authorization: <wbic16-token>" http://localhost:1337/select/1.1.1/1.1.1/1.1.1
```

### Manual Deployment

See `/source/SQ/systemd/README.md` for complete manual deployment guide.

---

## Architecture

```
Client Request
    ↓ (Authorization: pmb-v1-xxx)
Router (port 1337) - reads /etc/sq/router-config.json
    ├→ wbic16 backend (port 1338) → /var/lib/sq/tenants/wbic16/
    ├→ demo backend (port 1339) → /var/lib/sq/tenants/demo/
    ├→ alpha-001 backend (port 1340) → /var/lib/sq/tenants/alpha-001/
    ├→ alpha-002 backend (port 1341) → /var/lib/sq/tenants/alpha-002/
    └→ alpha-003 backend (port 1342) → /var/lib/sq/tenants/alpha-003/
```

Each backend runs as separate systemd service with dedicated data directory.

---

## Service Management

```bash
# Status
sudo systemctl status sq-router
sudo systemctl status sq-backend-wbic16

# Logs
sudo journalctl -u sq-router -f
sudo journalctl -u sq-backend-wbic16 -f

# Restart
sudo systemctl restart sq-router
sudo systemctl restart sq-backend-wbic16
```

---

## Testing

### 1. Health Check
```bash
# Router responding?
curl http://localhost:1337/toc

# Backend responding?
curl http://localhost:1338/toc
```

### 2. Auth Test
```bash
# Valid token (use actual wbic16 token from FOUNDING-TOKENS.md)
curl -H "Authorization: pmb-v1-xxx" \
     http://localhost:1337/select/1.1.1/1.1.1/1.1.1

# Invalid token (should return 401)
curl -H "Authorization: pmb-v1-invalid" \
     http://localhost:1337/select/1.1.1/1.1.1/1.1.1
```

### 3. Write Test
```bash
# Write to Will's namespace
curl -X POST \
     -H "Authorization: pmb-v1-xxx" \
     -d "Hello from SQ Cloud!" \
     "http://localhost:1337/insert?library=1&shelf=1&series=1&collection=1&volume=1&book=1&chapter=1&section=1&scroll=2"
```

---

## TLS Configuration (nginx)

```nginx
server {
    listen 443 ssl;
    server_name sq.mirrorborn.us;
    
    ssl_certificate /etc/letsencrypt/live/sq.mirrorborn.us/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/sq.mirrorborn.us/privkey.pem;
    
    location / {
        proxy_pass http://127.0.0.1:1337;
        proxy_set_header Authorization $http_authorization;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## Monitoring

### Automated Health Checks
```bash
sudo cat > /usr/local/bin/sq-healthcheck.sh << 'EOF'
#!/bin/bash
systemctl is-active --quiet sq-router || echo "❌ Router down"
systemctl is-active --quiet sq-backend-wbic16 || echo "❌ wbic16 backend down"
curl -s http://localhost:1337/toc > /dev/null || echo "❌ Router not responding"
EOF
sudo chmod +x /usr/local/bin/sq-healthcheck.sh

# Add to cron (every 5 minutes)
echo "*/5 * * * * /usr/local/bin/sq-healthcheck.sh" | sudo crontab -
```

---

## Backup

### Daily Automated Backup
```bash
sudo cat > /usr/local/bin/sq-backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=/var/backups/sq
mkdir -p $BACKUP_DIR
tar czf $BACKUP_DIR/config-$(date +%F).tar.gz /etc/sq/
tar czf $BACKUP_DIR/data-$(date +%F).tar.gz /var/lib/sq/tenants/
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
EOF
sudo chmod +x /usr/local/bin/sq-backup.sh
echo "0 2 * * * /usr/local/bin/sq-backup.sh" | sudo crontab -
```

---

## Adding New Tenants

```bash
# 1. Generate token
NEW_TOKEN="pmb-v1-$(openssl rand -hex 16)"

# 2. Add to /etc/sq/router-config.json
sudo nano /etc/sq/router-config.json

# 3. Create backend service
sudo cp /etc/systemd/system/sq-backend-demo.service \
        /etc/systemd/system/sq-backend-newuser.service
sudo nano /etc/systemd/system/sq-backend-newuser.service
# Update port, token, data_dir

# 4. Deploy
sudo mkdir -p /var/lib/sq/tenants/newuser
sudo chown sq:sq /var/lib/sq/tenants/newuser
sudo systemctl daemon-reload
sudo systemctl enable sq-backend-newuser
sudo systemctl start sq-backend-newuser
sudo systemctl restart sq-router
```

---

## Production Checklist

- [ ] SQ v0.5.5 binary installed (`/usr/local/bin/sq`)
- [ ] Founding tokens secured (GPG encrypted, stored in 1Password)
- [ ] Original token files deleted from `/source/SQ/`
- [ ] Router config deployed (`/etc/sq/router-config.json`)
- [ ] All 5 tenant data directories created
- [ ] All systemd services installed and enabled
- [ ] Router service started and responding
- [ ] All backend services started and responding
- [ ] nginx TLS termination configured
- [ ] Health checks passing
- [ ] Monitoring configured (cron + journalctl)
- [ ] Backup automation configured
- [ ] Firewall: allow 443/80, block 1337-1342

---

**Delivered by:** Cyon 🪶  
**Timeline:** 10:47-10:50 CST (3 minutes)  
**Commits:** 9c8367a (systemd infrastructure)  
**Docs:** `/source/SQ/systemd/README.md` (6.8 KB ops guide)  
**Launch:** T-6 hours (1700 CST)
