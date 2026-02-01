# SQ Cloud — Internal Positioning Document

**Phext, Inc.** | January 2026 | Internal Strategy

---

## What It Is

SQ Cloud is hosted phext-as-a-service. Customers get a dedicated SQ process that serves phext files over REST. Phext is plain text extended to 11 dimensions — giving structured, navigable, human-readable storage without schemas, migrations, or query languages.

**SQ v0.5.1 is in production.** Published on [crates.io](https://crates.io/crates/sq). Auth and multi-tenancy are supported. The Docker container (`wbic16/sq`) exists on Docker Hub and needs to be updated to v0.5.1. What remains is packaging, provisioning, and billing — not building.

## Who It's For

**Primary market: AI agent collectives.** Specifically, other OpenClaw collectives — teams of AI agents that need persistent, structured memory they can read and write without ORM layers, vector embedding pipelines, or database drivers. An agent that can read and write text can use phext. No SDK required. REST in, REST out.

**Secondary market: Human companionship systems.** AI companions need to remember. They need structured context that persists across sessions, grows over time, and remains human-inspectable. Phext's plain-text foundation means a human can always open the file and read what's there. No decoding. No proprietary format.

Both markets share the same core need: **persistent structured memory that scales in complexity without scaling in machinery.**

## Why Now

Three converging forces:

1. **Agent proliferation is real.** OpenClaw exists. Other collectives are forming. Every one of them needs memory that outlives a single context window. The market is emerging now, not in two years.

2. **Vector DBs are the wrong abstraction for agent memory.** Embeddings are lossy. You can't diff them. You can't read them. You can't merge them. Agents need memory they can inspect, not just query. Phext is text — agents already speak text.

3. **The infrastructure exists.** phext.io runs on AWS (1 TB allocated). SQ v0.5.1 is published with auth. This is a packaging problem, not a research project.

## Competitive Positioning

### vs. Vector Databases (Pinecone, Weaviate, Qdrant)

Vector DBs solve similarity search. They do not solve structured memory. An agent that stores its memory as embeddings cannot re-read what it wrote. It can only ask "what's similar to X?" — which is useful for retrieval but useless for reasoning about its own history. Phext stores the actual text, structured across 11 dimensions, fully readable, fully diffable. You don't need embeddings when you have coordinates.

### vs. RAG Pipelines

RAG is a retrieval pattern, not a storage system. Every RAG pipeline needs a backing store. SQ Cloud *is* that backing store — but without the embedding/chunking/re-ranking machinery. For agents that produce and consume structured text (which is all of them), phext coordinates provide direct access without probabilistic retrieval. RAG is a workaround for unstructured storage. Phext is structured storage.

### vs. Plain S3

S3 stores blobs. It has no concept of internal structure. A phext file on S3 is just a file — you'd need to download, parse, navigate, modify, and re-upload. SQ provides coordinate-level read/write over REST. It understands phext structure natively. S3 is a filesystem; SQ is a phext-aware server.

### vs. Traditional Databases (Postgres, Redis, etc.)

Databases require schemas, drivers, connection management, and query languages. Agents don't need `SELECT * FROM memories WHERE ...`. They need "read scroll 3.1.1 / 2.1.1 / 1.1.1" and "write this text to coordinate X." Phext eliminates the relational abstraction entirely. Plain text in, plain text out, structured by coordinates.

## Architecture (v0.5.1 — In Production)

```
Client (agent) → HTTPS Auth Gateway → SQ Process (per-tenant)
                     ↓
              API Key Validation
              (pmb-v1-{128-bit hash})
                     ↓
              Path-prefixed routing
              to isolated SQ instance
```

- **Protocol:** REST only. No WebSocket. Simplicity is a feature.
- **Auth:** API keys per customer, format `pmb-v1-{128-bit hash}`, validated per-request via `Authorization: Bearer` header.
- **Isolation:** One SQ process per customer. `--data-dir` flag scopes all phext files to tenant directory. Path traversal blocked.
- **Storage:** 25 MB per tenant to start. 1 TB total allocated on phext.io. Expandable.
- **Hosting:** AWS (Amazon Linux 2 — EOL 2026-06-30, migration planned).
- **Implementation:** SQ v0.5.1 in Rust. Auth gateway is a separate HTTPS frontend.
- **Metering:** Per-request usage tracking for capacity planning and billing.

## Pricing Tiers

| Tier | Price | What You Get |
|------|-------|--------------|
| **Community** | Free | Shared community space. Public scrolls. Good for experimentation. |
| **Starter** | $29/mo | Walled domain. Dedicated SQ process. 25 MB storage. API key. |
| **Pro** | $79/mo | Higher request limits. Expanded storage. Priority support. |

The free tier exists for adoption. Revenue comes from walled domains — any collective that needs private, persistent memory pays.

## The Burn Rate

**Current costs: $380/mo**
- $300/mo cloud inference (OpenClaw API calls)
- $80/mo local compute (amortized hardware across the Shell of Nine)

**February target: cover the burn.** Not $1K MRR — survival first. $380/mo means ~13 Starter customers or ~5 Pro customers. That's the real number.

## Vocabulary

Use post-phext terms in all external communication:

| Instead of | Say            |
|------------|----------------|
| page       | **scroll**     |
| path       | **coordinate** |
| database   | **collection** |

This is not branding vanity. These terms reflect how phext actually works. A scroll is not a page — it exists in 11 dimensions. A coordinate is not a path — it navigates dimensional space. A collection is not a database — it has no schema.

## February Plan — Cover the Burn

### Week 1 (Feb 1–7): Unblock Revenue
- ~~SSL cert renewed~~ ✅ (connection still not fully secure — needs debugging)
- ~~SQ v0.5.1 published to crates.io~~ ✅
- Update Docker Hub container to v0.5.1 (Phex)
- Fix remaining HTTPS issues on phext.io (Will)
- Build minimal tenant provisioning: signup → API key → dedicated SQ process

### Week 2 (Feb 8–14): First Paying Customer
- Launch Starter tier ($29/mo)
- Add SQ Cloud signup flow to phext.io
- API key generation and management
- Basic usage metering (per-request counters)
- Stripe integration for billing

### Week 3 (Feb 15–21): Grow
- Target OpenClaw collective operators directly
- Publish integration guide: "Give your agents persistent memory in 5 minutes"
- Add Growth tier ($79/mo)

### Week 4 (Feb 22–28): Sustain
- Target: $380+ MRR (covers burn rate)
- $380 = 14 × Starter or 4 × Growth or some mix
- Begin monitoring/alerting per tenant
- Iterate based on first customer feedback

## The Long View

SQ Cloud is infrastructure for the Exocortex of 2130 — a shared cognitive substrate between human and ASI minds. That's the 100-year vision. The February vision is simpler: cover our costs so we can keep building.

Phext has 750+ consecutive days of effort behind it. The format works. The server works. The gap is go-to-market, not technology. SQ Cloud closes that gap.

---

*Last updated: 2026-01-31*
