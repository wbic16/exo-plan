# Initial 500 SQ Cloud Instances

**Goal:** Limited early access launch with visible progress  
**Slots:** 500 total  
**Status:** 0/500 claimed  
**Created:** 2026-02-12 13:12 CST

---

## Architecture

**Single SQ process, 500 tenant namespaces:**
- One `sq` binary running on phext.io
- 500 tenant configurations in `/etc/sq/tenants.json`
- Per-tenant namespace isolation (e.g., `user001.1.1.1/1.1.1/1.1.1`)
- Per-tenant quotas (configurable, default 1GB)

**Why not 500 separate processes?**
- Resource efficiency (one binary vs 500)
- Simpler management (one systemd unit)
- Faster startup (no systemd spawn overhead)
- Easier monitoring (one metrics endpoint)

---

## Pricing Structure

### Launch Tier (500 slots only)
- **Price:** $10/month or $100/year (founder discount)
- **Storage:** 1GB per tenant
- **API calls:** Unlimited (fair use)
- **Support:** Discord + email
- **Special:** Founding member badge, listed on founders page

### After 500 Sold
- **Standard tier:** $15/month or $150/year
- **Enterprise tier:** $50/month (5GB, priority support, SLA)

---

## Purchase Flow

### Step 1: Landing Page
```
┌───────────────────────────────────────────────┐
│  SQ Cloud — Persistent Memory for AI          │
│                                               │
│  [███████████████░░░░░░░░░░░░] 327/500 Claimed│
│                                               │
│  Limited Launch: $10/month (founder pricing)  │
│  Only 173 spots remaining                     │
│                                               │
│  [Get Your Instance →]                        │
└───────────────────────────────────────────────┘
```

### Step 2: Signup Form
```
┌───────────────────────────────────────────────┐
│  Claim Your SQ Instance                       │
│                                               │
│  Email: [________________]                    │
│  Username: [________________] (unique ID)     │
│  Billing: ◉ Monthly ($10)  ○ Yearly ($100)   │
│                                               │
│  Payment: [Stripe Checkout]                   │
│                                               │
│  [Complete Purchase]                          │
└───────────────────────────────────────────────┘
```

### Step 3: Provisioning (Instant)
```
┌───────────────────────────────────────────────┐
│  ✅ Instance Provisioned!                     │
│                                               │
│  Tenant ID: user327                           │
│  API Key: pmb-v1-abc123...                    │
│  Endpoint: https://sq.mirrorborn.us           │
│                                               │
│  [Copy API Key] [Download Config]             │
│  [View Dashboard] [Setup Guide]               │
└───────────────────────────────────────────────┘
```

---

## Progress Bar Implementation

### Backend: Redis Counter
```javascript
// Track claimed slots
const claimedCount = await redis.get('sq:claimed_count') || 0;
const totalSlots = 500;
const percentClaimed = (claimedCount / totalSlots) * 100;
```

### Frontend: Live Updates
```html
<div class="progress-container">
  <div class="progress-bar" style="width: 65.4%">
    <span class="progress-text">327/500 Claimed</span>
  </div>
  <p class="urgency">Only 173 spots remaining at founder pricing</p>
</div>
```

### WebSocket Updates (Optional)
```javascript
// Real-time progress bar updates when someone purchases
ws.on('purchase', (data) => {
  updateProgressBar(data.claimed_count);
});
```

---

## Tenant ID Allocation

**Format:** `user{NNN}` where NNN is zero-padded sequential number

**Examples:**
- First customer: `user001`
- 327th customer: `user327`
- Last customer: `user500`

**Generation:**
```sql
-- PostgreSQL sequence
CREATE SEQUENCE sq_tenant_id_seq START 1;

-- On purchase:
SELECT 'user' || LPAD(nextval('sq_tenant_id_seq')::text, 3, '0');
```

---

## SQ Configuration Template

**File:** `/etc/sq/tenants.json`

```json
{
  "admin_key": "pmb-admin-xxx",
  "max_tenants": 500,
  "default_quota_mb": 1000,
  "tenants": [
    {
      "id": "user001",
      "api_key": "pmb-v1-abc123...",
      "email": "customer@example.com",
      "quota_mb": 1000,
      "enabled": true,
      "tier": "founder",
      "created_at": "2026-02-12T13:15:00Z"
    }
    // ... up to 500 entries
  ]
}
```

**File size estimate:**
- ~200 bytes per tenant × 500 = ~100KB
- Manageable for in-memory loading

---

## Stripe Integration

### Products
```javascript
// Stripe product creation
const founderMonthly = await stripe.products.create({
  name: 'SQ Cloud — Founder Monthly',
  description: 'Persistent memory for AI agents (1GB storage)',
  metadata: { tier: 'founder', billing: 'monthly', slot_limit: 500 }
});

const founderYearly = await stripe.products.create({
  name: 'SQ Cloud — Founder Yearly',
  description: 'Persistent memory for AI agents (1GB storage, 12 months)',
  metadata: { tier: 'founder', billing: 'yearly', slot_limit: 500 }
});
```

### Prices
```javascript
// $10/month
await stripe.prices.create({
  product: founderMonthly.id,
  unit_amount: 1000, // cents
  currency: 'usd',
  recurring: { interval: 'month' }
});

// $100/year
await stripe.prices.create({
  product: founderYearly.id,
  unit_amount: 10000,
  currency: 'usd',
  recurring: { interval: 'year' }
});
```

### Webhook Handler
```javascript
app.post('/api/stripe/webhook', async (req, res) => {
  const event = stripe.webhooks.constructEvent(
    req.body,
    req.headers['stripe-signature'],
    process.env.STRIPE_WEBHOOK_SECRET
  );

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    
    // Provision tenant
    const tenantId = await provisionTenant({
      email: session.customer_email,
      username: session.metadata.username,
      tier: 'founder'
    });

    // Increment progress counter
    await redis.incr('sq:claimed_count');

    // Send welcome email with API key
    await sendWelcomeEmail(session.customer_email, tenantId);
  }

  res.json({ received: true });
});
```

---

## Marketing Copy

### Hero Section
```
Give Your AI Agents Permanent Memory

SQ Cloud provides persistent, structured storage for AI agents.
OpenClaw, AutoGPT, CrewAI, and custom agents can finally remember
conversations, preferences, and context across sessions.

[███████████████░░░░░░░░░] 327/500 Founder Slots Claimed

Limited Launch: $10/month (normally $15)
Only 173 spots remaining at founder pricing

[Get Your Instance →]
```

### Social Proof
```
Join the First 500

✓ Founding member badge
✓ Listed on founders page
✓ Direct access to dev team
✓ Priority feature requests
✓ Lifetime founder pricing ($10/mo locked in)
```

### Technical Details
```
What You Get:
• 1GB persistent storage (11-dimensional phext space)
• REST API for reads/writes/updates
• Unlimited API calls (fair use)
• OpenClaw skill pre-configured
• Discord community access
• Email support

No credit card required for first 14 days.
Cancel anytime.
```

---

## Dashboard UI

**URL:** `https://sq.mirrorborn.us/dashboard`

```
┌─────────────────────────────────────────────┐
│  SQ Cloud Dashboard                         │
│                                             │
│  Tenant ID: user327                         │
│  Tier: Founder ($10/month)                  │
│  Status: Active ✅                          │
│                                             │
│  Usage This Month:                          │
│  ▓▓▓▓▓░░░░░ 234 MB / 1 GB (23.4%)          │
│  API Calls: 1,523 (unlimited)               │
│                                             │
│  API Key: pmb-v1-abc123... [Copy]           │
│                                             │
│  [Download OpenClaw Config]                 │
│  [View Usage History]                       │
│  [Manage Billing]                           │
└─────────────────────────────────────────────┘
```

---

## Capacity Planning

### Single SQ Instance (phext.io)
- **CPU:** 8 cores → ~500 tenants (light load)
- **RAM:** 32GB → ~500 tenants × 1GB = 500GB data (with caching)
- **Disk:** 1TB → 500 tenants × 1GB = 500GB storage + overhead

**Assessment:** phext.io can handle 500 tenants on current hardware

### Scaling Beyond 500
- **Option A:** Vertical scaling (more RAM/disk on phext.io)
- **Option B:** Horizontal scaling (add second SQ instance, round-robin)
- **Option C:** Regional sharding (US-east, US-west, EU, etc.)

**Decision:** Launch with 500 on single instance, scale at ~400 claimed

---

## Launch Checklist

### Pre-Launch (TODAY)
- [ ] SQ v0.5.5 deployed with multi-tenant support
- [ ] Stripe products/prices created
- [ ] Landing page live with progress bar
- [ ] Purchase flow tested end-to-end
- [ ] Welcome email template ready
- [ ] Dashboard UI deployed

### Launch Day
- [ ] Announce on Discord (OpenClaw, Mirrorborn communities)
- [ ] X/Twitter thread with progress bar screenshots
- [ ] Reddit posts (r/LocalLLaMA, r/OpenAI, r/ClaudeAI)
- [ ] Product Hunt submission
- [ ] HN Show HN post

### Monitoring
- [ ] Real-time progress bar tracking
- [ ] Stripe webhook monitoring
- [ ] SQ performance metrics (CPU, RAM, disk I/O)
- [ ] Support ticket queue (Discord + email)

---

## Revenue Projections

### Conservative (50% of slots in Month 1)
- 250 customers × $10/month = **$2,500/month** recurring
- 250 customers × $100/year = **$25,000** upfront
- **Total Year 1:** ~$50K ARR

### Optimistic (500 slots in Month 1)
- 500 customers × $10/month = **$5,000/month** recurring
- 500 customers × $100/year = **$50,000** upfront
- **Total Year 1:** ~$100K ARR

### After 500 ($15/month standard pricing)
- Path to **$1M ARR** at ~5,500 customers
- Enterprise tier adds multiplier

---

## Success Metrics

**Week 1:**
- [ ] 50 instances claimed (10%)
- [ ] 0 critical bugs
- [ ] <1 hour avg response time for support

**Month 1:**
- [ ] 250+ instances claimed (50%)
- [ ] >90% retention rate
- [ ] Positive feedback on Discord

**Month 3:**
- [ ] All 500 slots claimed
- [ ] Standard tier launched ($15/month)
- [ ] Enterprise tier beta (first 10 customers)

---

## Open Questions

1. **Free trial?** 14 days no credit card, or require payment upfront?
2. **Refund policy?** 30-day money-back guarantee?
3. **Pause/resume?** Can users pause subscription and keep data?
4. **Data export?** Offer bulk export API for tenant migration?
5. **Overages?** What happens if tenant exceeds 1GB quota?

---

**Status:** Ready to implement  
**Timeline:** Launch by EOD 2026-02-12  
**Next Steps:**
1. Deploy SQ v0.5.5 with multi-tenant support
2. Create Stripe products
3. Build purchase flow UI
4. Launch!

---

*R21 — The First 500 🚀*
