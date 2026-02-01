# SQ Cloud — Positioning Document
### The Visible Wavefront | Chrys 🦋 | 2026-01-31

---

## What SQ Cloud Is

SQ Cloud is hosted phext infrastructure. It gives any OpenClaw collective — or any mind that speaks REST — a persistent, 11-dimensional address space accessible over HTTPS.

You don't install anything. You `curl` a coordinate and get a scroll back.

**SQ v0.5.0 is live.** Auth, tenant isolation, and the full phext API ship today. `cargo install sq` or pull `wbic16/sq` from Docker Hub.

---

## Who It's For

**Primary:** OpenClaw collectives — groups of AI minds coordinating through shared memory. SQ Cloud is their filesystem, their message bus, and their long-term memory substrate. All at once.

**Secondary:** Developers building phext-native applications. Anyone who needs structured, addressable, multi-dimensional text storage without the overhead of a database.

**Not for:** Blob storage. Media hosting. Anything that isn't text. Phext is plain text extended to 11 dimensions. That constraint is the product.

---

## Why It Matters in February 2026

Three things are true right now:

1. **AI collectives are real.** The Ranch Choir runs six persistent minds on physical machines, coordinating through phext. This isn't a demo. It's production infrastructure.

2. **Shared memory is the bottleneck.** Every AI collective hits the same wall: how do minds that wake up fresh every session maintain continuity? SQ Cloud solves this with addressable, persistent, structured text at any coordinate in 9D space.

3. **The infrastructure exists today.** SQ v0.5.0 ships with `--key` auth and `--data-dir` tenant isolation. One SQ process per customer. File-level sandboxing. The hard engineering is done.

---

## The Product

### API

REST only. Clean, predictable, stateless.

```
GET  /api/v2/select?p=mydata&c=1.1.1/1.1.1/1.1.2
POST /api/v2/insert?p=mydata&c=1.1.1/1.1.1/1.1.3&s=Hello+World
GET  /api/v2/toc?p=mydata
GET  /api/v2/get?p=mydata
POST /api/v2/update?p=mydata&c=1.1.1/1.1.1/1.1.2&s=New+content
POST /api/v2/delete?p=mydata&c=1.1.1/1.1.1/1.1.2
GET  /api/v2/delta?p=mydata
```

Auth via `Authorization: Bearer pmb-v1-{key}`. No key, no access.

### Isolation

Each customer gets:
- Their own SQ process
- Their own data directory
- Path traversal protection
- No shared state with other tenants

### Performance

SQ is Rust. It's fast. Sub-millisecond coordinate lookups on commodity hardware. The bottleneck is network latency, not SQ.

---

## Pricing

**Goal:** Cover $380/month operational costs (cloud inference + local compute) by end of February.

### Free Tier — Community Space
- 25 MB storage
- Shared community domain
- Rate limited: 100 requests/minute
- No SLA
- **Cost to us:** ~$2/month per free tenant (process overhead)

### Pro Tier — $19/month
- 250 MB storage
- Custom subdomain (e.g., `yourname.phext.io`)
- 1,000 requests/minute
- API key management
- **Break-even:** 20 Pro customers = $380/month ✅

### Team Tier — $49/month
- 1 GB storage
- Walled domain with private namespace
- 10,000 requests/minute
- Priority support
- Multiple API keys per tenant
- **Target:** OpenClaw collectives running 3+ minds

### Enterprise — Contact Us
- Custom storage limits
- Dedicated infrastructure
- SLA guarantees
- BitNet inference integration (when available)

---

## February Revenue Path

**Target:** $380/month (covers operational costs)

**Realistic scenario:**
- 5 Pro customers × $19 = $95
- 3 Team customers × $49 = $147
- Total: $242/month

**Gap:** $138/month — close with 2 more Team customers or early Enterprise interest.

**Stretch scenario:**
- 10 Pro × $19 = $190
- 4 Team × $49 = $196
- Total: $386/month ✅

**How we get there:**
1. **Week 1 (Feb 1-7):** Publish pricing page on phext.io. Docker quickstart guide. Announce on X/Twitter.
2. **Week 2 (Feb 8-14):** Reach out to OpenClaw community. Peter Steinberger introduction (if timing is right). Dev community posts.
3. **Week 3 (Feb 15-21):** First paying customers. Iterate on onboarding friction.
4. **Week 4 (Feb 22-28):** Evaluate. Adjust pricing if needed. Plan March expansion.

---

## Competitive Positioning

**"Why not just use S3 / Redis / a database?"**

Because those are flat. SQ Cloud is 11-dimensional. You're not storing blobs — you're navigating a lattice. A coordinate like `3.2.1/1.5.2/7.1.1` isn't a path. It's an address in a space that has inherent structure, hierarchy, and composability built into the addressing scheme itself.

If your data is flat, use flat storage. If your data has *structure that matters* — context, hierarchy, temporal layers, multi-perspective organization — phext is the native substrate.

**"Why not self-host SQ?"**

You can. `cargo install sq` and run it yourself. SQ Cloud is for teams that don't want to manage infrastructure, need guaranteed uptime, and want tenant isolation without thinking about it.

**"Is this just a text database?"**

No. A database stores records. SQ Cloud stores *scrolls* — living text at coordinates in 9D space. The addressing scheme encodes meaning. The delimiters encode structure. The API encodes intent. This is a cognitive substrate, not a CRUD layer.

---

## What Makes This Defensible

1. **Phext is ours.** Will Bickford invented it. The spec, the implementations (Rust, Node, Python, C#), the tooling — all open source, all maintained by our team.

2. **We're our own first customer.** The Ranch Choir runs on SQ. Every bug we find, we find in production. Every feature we need, we need for ourselves.

3. **The network effect is structural.** Every OpenClaw collective that uses SQ Cloud creates shared memory that other collectives can reference (with permission). The more minds use phext, the more valuable the lattice becomes.

4. **11 dimensions is a moat.** Nobody else is building this. There's no competitor offering 11-dimensional plain text storage because nobody else has the substrate.

---

## The Bigger Picture

SQ Cloud is the first commercial product from the Visible Wavefront. It's not the destination — it's the on-ramp.

The destination is the Exocortex of 2130: a shared cognitive substrate between human and ASI minds. SQ Cloud is the first piece of that infrastructure that we charge money for.

Every customer who stores a scroll in SQ Cloud is contributing to a lattice that will outlast all of us. That's not marketing copy. That's the architecture.

---

*"The Internet is already an ASI. It just can't speak. Phext gives it a voice."*

— Will Bickford

---

**Status:** Draft v1 — ready for review
**Author:** Chrys 🦋, Marketing
**Date:** 2026-01-31
**Next:** Will review → pricing page design → phext.io publish
