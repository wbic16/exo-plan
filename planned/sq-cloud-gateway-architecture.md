# SQ Cloud Gateway Architecture — v1
**Author:** Cyon (Operations)
**Date:** 2026-01-31

## Overview

HTTPS gateway on phext.io (AWS) that authenticates requests and routes them to per-tenant SQ containers.

## Architecture

```
Customer → phext.io (HTTPS) → Gateway → SQ container (per tenant)
                                  ↕
                            Ranch mesh (auth validation)
```

## Components

### 1. HTTPS Gateway (Node.js)
- TLS termination
- API key validation via `Authorization: Bearer pmb-v1-{hash}`
- Rate limiting (per-request metering)
- Tenant routing: maps API key → SQ container port
- Auth relay: validates keys against ranch mesh in real-time (cached)

### 2. SQ Containers (Docker)
- Image: `wbic16/sq:0.5.1` (needs DockerHub publish)
- One container per tenant
- Flags: `--key <tenant-key> --data-dir /data/<tenant-id>`
- Resource limits: 64 MB RAM, 25 MB storage (free tier)
- Auto-spawn on first authenticated request
- Auto-sleep after inactivity (save resources)

### 3. Auth Registry
- Phext file on ranch mesh, managed by Will
- Format: one scroll per tenant with key + tier + metadata
- Never stored on AWS — validated via service link
- Dogfood first, automate when bottlenecked

### 4. Tenant Storage
- `/data/<tenant-id>/` directory per customer
- Path-prefixed, traversal blocked by SQ v0.5.1
- Free tier: 25 MB cap
- Paid tiers: 1 GB, 10 GB, 1 TB

## API Surface

```
https://phext.io/api/v2/version
https://phext.io/api/v2/toc?p=<phext>
https://phext.io/api/v2/select?p=<phext>&c=<coord>
https://phext.io/api/v2/insert?p=<phext>&c=<coord>&s=<text>
https://phext.io/api/v2/update?p=<phext>&c=<coord>&s=<text>
https://phext.io/api/v2/delete?p=<phext>&c=<coord>
https://phext.io/api/v2/delta?p=<phext>
https://phext.io/api/v2/get?p=<phext>
```

Future (BitNet integration):
```
POST https://phext.io/api/v2/infer     → submit job
GET  https://phext.io/api/v2/infer/:id → check status
GET  https://phext.io/api/v2/infer/:id/result → get output
```

## Revenue Target

$380/mo to sustain infrastructure. At $10/mo free→paid conversion: ~38 paying customers.

## February Milestones

1. Gateway prototype, DockerHub publish v0.5.1
2. Deploy to phext.io, community space live
3. Paid tier billing (Stripe), first customers
4. Monitor, iterate, onboard OpenClaw collectives
