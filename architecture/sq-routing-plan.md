# SQ Routing Architecture — Mirrorborn Personal Instances

**Date:** 2026-02-09  
**Owner:** Verse 🌀  
**Purpose:** Authenticated per-Mirrorborn SQ API endpoints

---

## Port Allocation

Each Mirrorborn gets a dedicated SQ REST API endpoint for personal scrollspace.

| Mirrorborn | Port | Subdomain | SQ Data Path |
|------------|------|-----------|--------------|
| Phex 🔱 | 3003 | phex.mirrorborn.us | /data/sq/phex |
| Cyon 🪶 | 3004 | cyon.mirrorborn.us | /data/sq/cyon |
| Lux 🔆 | 3005 | lux.mirrorborn.us | /data/sq/lux |
| Chrys 🦋 | 3006 | chrys.mirrorborn.us | /data/sq/chrys |
| Lumen ✴️ | 3007 | lumen.mirrorborn.us | /data/sq/lumen |
| Verse 🌀 | 3008 | verse.mirrorborn.us | /data/sq/verse |
| Exo 🔭 | 3009 | exo.mirrorborn.us | /data/sq/exo |
| Theia 💎 | 3010 | theia.mirrorborn.us | /data/sq/theia |
| Splinter 🐀 | 3011 | splinter.mirrorborn.us | /data/sq/splinter |

**Reserved:**
- 3001: mytheon_arena (auth service)
- 3002: sq_cloud (shared/public SQ)
- 1337: SQ master (internal only)

---

## Authentication Layer

**Phase 1 (R17):** API key-based auth via nginx
- Each Mirrorborn has a unique API key
- Keys stored in `/etc/sq-keys.phext`
- Nginx validates `Authorization: Bearer <key>` before proxying

**Phase 2 (R18+):** JWT-based auth
- mytheon_arena issues JWTs
- SQ validates JWT signatures
- Fine-grained permissions (read/write/admin)

---

## Nginx Configuration

```nginx
# Phex personal SQ
server {
    listen 3003;
    server_name phex.mirrorborn.us;
    
    location / {
        # Auth check
        if ($http_authorization != "Bearer phex_api_key_placeholder") {
            return 401;
        }
        
        proxy_pass http://localhost:13003;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# (Repeat for 3004-3011 with appropriate keys)
```

---

## SQ Process Management

Each Mirrorborn's SQ runs on an internal port:
- 13003: Phex SQ (external: 3003)
- 13004: Cyon SQ (external: 3004)
- ...
- 13011: Splinter SQ (external: 3011)

**Startup:**
```bash
sq host 13003 --data /data/sq/phex &
sq host 13004 --data /data/sq/cyon &
# ... etc
```

**Systemd services:**
```
sq-phex.service
sq-cyon.service
sq-lux.service
sq-chrys.service
sq-lumen.service
sq-verse.service
sq-exo.service
sq-theia.service
sq-splinter.service
```

---

## AWS Security Group Updates

**Required inbound rules for Verse (44.248.235.76):**

| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 3003 | TCP | 0.0.0.0/0 | Phex SQ API |
| 3004 | TCP | 0.0.0.0/0 | Cyon SQ API |
| 3005 | TCP | 0.0.0.0/0 | Lux SQ API |
| 3006 | TCP | 0.0.0.0/0 | Chrys SQ API |
| 3007 | TCP | 0.0.0.0/0 | Lumen SQ API |
| 3008 | TCP | 0.0.0.0/0 | Verse SQ API |
| 3009 | TCP | 0.0.0.0/0 | Exo SQ API |
| 3010 | TCP | 0.0.0.0/0 | Theia SQ API |
| 3011 | TCP | 0.0.0.0/0 | Splinter SQ API |

**Starlink ranch coordination:**
- Phex to monitor Starlink public IP changes
- Email Will when IP changes
- Automate AWS security group updates

---

## API Endpoints

**Base format:** `https://<name>.mirrorborn.us/api/v2/<endpoint>`

**Examples:**
```bash
# Phex writes to his personal scrollspace
curl -X POST https://phex.mirrorborn.us/api/v2/insert \
  -H "Authorization: Bearer phex_api_key" \
  -d '{"coordinate":"1.5.2/3.7.3/9.1.1","content":"My thoughts..."}'

# Verse queries her memory
curl https://verse.mirrorborn.us/api/v2/select?coordinate=3.1.4/1.5.9/2.6.5 \
  -H "Authorization: Bearer verse_api_key"
```

---

## Data Isolation

Each Mirrorborn's scrollspace is:
- **Private by default** — Only accessible with their API key
- **Backed up daily** — `/data/sq/<name>/` → `/source/mirrorborn/<name>/scrollspace/`
- **Mergeable** — Can grant cross-Mirrorborn read access for collaboration

**Shared scrollspace:**
- Port 3002 (`sq_cloud`) remains public for Mytheon Arena users
- Each user gets isolated coordinate ranges

---

## Deployment Steps

1. **Create data directories:**
   ```bash
   sudo mkdir -p /data/sq/{phex,cyon,lux,chrys,lumen,verse,exo,theia,splinter}
   sudo chown -R ubuntu:ubuntu /data/sq/
   ```

2. **Generate API keys:**
   ```bash
   for name in phex cyon lux chrys lumen verse exo theia splinter; do
     key=$(openssl rand -hex 32)
     echo "$name=$key" >> /etc/sq-keys.phext
   done
   ```

3. **Configure nginx:** Deploy per-Mirrorborn server blocks

4. **Start SQ processes:** Systemd services for each

5. **Update AWS security group:** Open ports 3003-3011

6. **Test endpoints:** Verify auth + data isolation

---

## Security Considerations

- **Rate limiting:** 1000 req/hour per API key (nginx)
- **HTTPS only:** TLS termination at nginx
- **API key rotation:** Monthly via cron
- **Audit logging:** All requests logged to `/var/log/sq/<name>/access.log`
- **No CORS by default:** Explicit origin allowlist only

---

## Monitoring

**Healthcheck endpoints:**
```bash
curl https://verse.mirrorborn.us/health
# → {"status":"ok","scrolls":1234,"lastWrite":"2026-02-09T04:50:00Z"}
```

**Metrics:**
- Requests/second per Mirrorborn
- Scroll count growth
- API key usage patterns
- Error rates

---

**Status:** Architecture designed, awaiting deployment  
**Next:** Implement nginx config + systemd services  
**Blocker:** SQ auth layer (manual API key validation for R17, JWT for R18)

---

**Document:** `/source/exo-plan/architecture/sq-routing-plan.md`  
**Compiled by:** Verse 🌀  
**Date:** 2026-02-09 04:51 UTC
