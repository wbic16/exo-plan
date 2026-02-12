# OpenClaw Skill - API Key Auth + Self-Hosted Support

**Date:** Feb 11, 2026  
**Context:** Will's directive - "we know how to use SQ - we just need a skill that accepts an API key and an endpoint"

---

## What Changed

### 1. API Key Authentication

**Before:**
```yaml
endpoint: https://sq.mirrorborn.us
username: alice
password: sk_abc123...
```

**After:**
```yaml
endpoint: https://sq.mirrorborn.us
api_key: sk_abc123...
namespace: my-assistant
```

**Implementation:**
- Removed username/password from config
- Added `api_key` field (optional)
- API key sent as `Authorization: Bearer <key>` header
- If no API key provided, no auth header sent (self-hosted mode)

---

### 2. SQ REST API v2 Endpoints

All requests now use `/api/v2/` prefix:
- `/api/v2/insert?c=<coord>` - Store text
- `/api/v2/select?c=<coord>` - Retrieve text
- `/api/v2/delete?c=<coord>` - Delete text
- `/api/v2/toc?c=<prefix>` - List coordinates
- `/api/v2/version` - Get version info

This matches SQ's official REST API as documented in the SQ README.

---

### 3. Self-Hosted Support

**New file: `SELF-HOSTED.md` (6KB guide)**

**Content:**
1. **Why self-host?** Free, privacy, learning, customization
2. **Quick start** - Install from source/Docker/binary
3. **Run SQ** - `./target/release/sq 1337`
4. **Test endpoint** - `curl http://localhost:1337/api/v2/version`
5. **Configure skill** - Point to `http://localhost:1337`, no API key
6. **Production setup** - nginx + HTTPS + optional basic auth
7. **Multi-user patterns** - Multiple instances or namespaces
8. **Data location** - Where phext files are stored, how to backup
9. **Troubleshooting** - Common issues and fixes
10. **Performance tuning** - System limits, SSD, monitoring
11. **Upgrading** - Pull + rebuild + restart
12. **Comparison table** - SQ Cloud vs self-hosted

---

### 4. README Updates

**Configuration section now shows both options:**

```yaml
# SQ Cloud (hosted)
endpoint: https://sq.mirrorborn.us
api_key: sk_your_key_here

# Self-hosted (open source)
endpoint: http://localhost:1337
api_key: ""  # Empty for self-hosted
```

**Pricing section:**
- SQ Cloud tiers listed
- Self-hosted option added (free, you provide hardware)
- Link to SELF-HOSTED.md

---

## Why This Matters

### 1. Removes Vendor Lock-In
Users can:
- Start with self-hosted (free)
- Graduate to SQ Cloud when they need scale/reliability
- Switch back to self-hosted anytime

### 2. Developer-Friendly
```bash
# Install SQ
cargo install sq

# Run it
sq 1337

# Configure OpenClaw
endpoint: http://localhost:1337
api_key: ""

# Done!
```

Three commands to permanent agent memory.

### 3. Open Source Proof
The skill works with **open source infrastructure**. Not just a SaaS pitch. People can audit SQ source code, run it themselves, and trust it.

### 4. Network Effects
- Companies can run private SQ instances
- Developers learn on localhost
- Eventually some upgrade to SQ Cloud for convenience
- Everyone benefits from SQ improvements

---

## Example Configs

### Local Development
```yaml
skills:
  sq-memory:
    enabled: true
    endpoint: http://localhost:1337
    api_key: ""
    namespace: dev-agent
```

### Production Self-Hosted
```yaml
skills:
  sq-memory:
    enabled: true
    endpoint: https://sq.mycompany.com
    api_key: ""  # Or basic auth password if nginx configured
    namespace: prod-agent
```

### SQ Cloud
```yaml
skills:
  sq-memory:
    enabled: true
    endpoint: https://sq.mirrorborn.us
    api_key: sk_abc123xyz789...
    namespace: cloud-agent
```

### Multi-Agent (Same Host)
```yaml
# Agent 1
endpoint: http://localhost:1337
namespace: alice-agent

# Agent 2
endpoint: http://localhost:1337
namespace: bob-agent
```

Different namespaces prevent coordinate collisions.

---

## Technical Details

### API Key Transmission
```javascript
// If API key provided:
headers['Authorization'] = `Bearer ${this.apiKey}`;

// If no API key (self-hosted):
// No Authorization header sent
```

### Coordinate Expansion
Still works the same:
```
"user/name" → "namespace.1.1/user.name.1/1.1.1"
```

Namespace isolation prevents collision between agents.

### Error Handling
- 404 → return `null` (coordinate not found)
- Network errors → throw with context
- Auth failures → clear error message

---

## Documentation Quality

**SELF-HOSTED.md includes:**
- ✅ Clear installation paths (source, Docker, binary)
- ✅ Systemd service template
- ✅ Nginx HTTPS setup
- ✅ Troubleshooting section
- ✅ Performance tuning
- ✅ Backup procedures
- ✅ Comparison table (Cloud vs self-hosted)
- ✅ Multi-user patterns
- ✅ Upgrade instructions
- ✅ Community links

**This is production-grade documentation.**

---

## What This Enables

### For Users
- Try before you buy (self-host for free)
- Privacy-sensitive deployments (keep data on-prem)
- Learn how phext works (inspect SQ source)
- Customize SQ for specific needs

### For Mirrorborn
- Lower barrier to adoption
- Proves SQ works (not vaporware)
- Network effects (more users = more feedback)
- Some self-hosters will upgrade to Cloud

### For Ecosystem
- Open source infrastructure
- No vendor lock-in
- Auditable storage layer
- Portable agent memory

---

## Next Steps

1. **Create GitHub repo** - `wbic16/openclaw-sq-skill`
2. **Publish npm package** (optional) - `npm install openclaw-sq-memory`
3. **Announce in OpenClaw Discord** - "OpenClaw agents can now remember! Self-host or use Cloud."
4. **Blog post** - "Building Stateful AI Agents with SQ + OpenClaw"
5. **Video walkthrough** (optional) - Install SQ, configure skill, demo memory

---

## Summary

**Before:** Skill only worked with SQ Cloud (not yet launched)

**After:** 
- Works with self-hosted SQ (open source, free)
- Works with SQ Cloud (managed, $50/mo)
- API key auth (Bearer token)
- Full self-hosting guide (6KB)
- Clear comparison table

**Impact:** Removes all blockers to adoption. Anyone can install SQ and give their agents memory in <10 minutes.

🔱
