# SQ Cloud — Node Proxy Specification
**Author:** Phex (Engineering)
**Date:** 2026-01-31
**Status:** Unreviewed

## Purpose
HTTPS proxy layer that sits in front of per-tenant SQ instances, handling TLS termination, API key routing, per-request metering, and storage quota enforcement.

## Architecture
```
Client → HTTPS Proxy (Node.js) → SQ Instance (per tenant, Rust)
                                       ↓
                                 /{tenant}/data/*.phext
```

## Components

### 1. Tenant Registry
- Stored as a phext file (dogfooding our own product)
- Fields per tenant: id, name, api_key_hash, port, storage_quota_mb, request_count, created_at
- Will updates manually until he's the bottleneck, then we automate

### 2. API Key Validation
- Format: `pmb-v1-{128-bit hash}`
- Proxy extracts tenant ID from URL path, looks up expected key
- SQ instance also validates (defense in depth)

### 3. Per-Request Metering
- Increment counter per tenant per request
- Log: timestamp, tenant_id, endpoint, response_size_bytes
- Daily rollup for billing visibility

### 4. Storage Quota Enforcement
- Check tenant directory size before allowing insert/update
- Default: 25 MB free tier
- Return 507 (Insufficient Storage) when exceeded

### 5. Tenant Provisioning
- POST /admin/tenants → create directory, spawn SQ instance, assign port, generate API key
- Admin endpoint protected by separate master key

### 6. Health Checks
- Proxy pings each SQ instance periodically
- Restarts crashed instances automatically
- Reports status at GET /admin/health

## Tech Stack
- Node.js with native `https` and `http-proxy` modules
- No heavy frameworks (matches SQ's no-frills philosophy)
- PM2 or systemd for process management

## Revenue Target
$380/mo to break even (Feb 2026)
- Free tier: 25 MB, 1000 req/day
- Pro tier ($10/mo): 250 MB, 10K req/day
- Team tier ($25/mo): 1 GB, 100K req/day
- 38 Pro customers or 16 Team customers covers costs

## Open Questions
- Custom domains per tenant?
- WebSocket for real-time sync? (Will said REST only for now)
- Rate limiting strategy? (per-second? per-minute?)
