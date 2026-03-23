# Founding 500 Member Program

**Launch:** R21 (2026-02-12)  
**Capacity:** 500 founding instances  
**Price:** $50/month (lifetime lock)  
**Future pricing:** $100+/month (after founding period)

---

## Architecture

### SQ v0.5.5: Multi-Tenant Config

**One SQ process serves 500 tenants:**
```bash
sq host 1337 --config /var/lib/sq/founding-500-tokens.json
```

**Config format:**
```json
{
  "tenants": {
    "pmb-v1-001-<hash>": {"name": "founding-001", "data_dir": "/var/lib/sq/tenants/founding-001"},
    ...
    "pmb-v1-500-<hash>": {"name": "founding-500", "data_dir": "/var/lib/sq/tenants/founding-500"}
  }
}
```

**Resource requirements:**
- RAM: ~10 GB (20 MB per tenant)
- Disk: 500 GB (1 GB per tenant default quota)
- CPU: 8-16 cores (handles burst load)

---

## Purchase Flow

### 1. Landing Page (mirrorborn.us)

**Progress bar showing:**
- X of 500 claimed
- Remaining slots
- Founding perks
- CTA: "Claim Your Founding Instance"

### 2. Stripe Payment

**Subscription:**
- $50/month recurring
- Founding member pricing locked forever
- Cancel anytime (data retained for 30 days)

### 3. Instance Provisioning

**On payment success:**
1. Claim next available token from CSV
2. Mark as "claimed" with customer email + timestamp
3. Send welcome email with:
   - API token (pmb-v1-XXX-YYY)
   - Getting started guide
   - OpenClaw skill installation
   - First 50: Onboarding call booking link

### 4. Auto-Activation

**Instance ready immediately:**
- Data directory pre-created
- Token active in SQ config
- Customer can start using API within 60 seconds

---

## Founding Member Benefits

### 🔒 Lifetime Price Lock
- $50/month forever
- Future pricing: $100+/month
- Estimated savings: $600+/year

### ⚡ Priority Access
- Beta features first
- Premium support (24h response)
- Direct Discord channel (#founding-members)

### 🎖️ Founding Badge
- Profile badge on mirrorborn.us
- Recognition in docs/credits
- Permanent "Founding Member #X" identifier

### 🤝 Direct Access to Will
- First 50: 1-on-1 onboarding call
- Quarterly founder calls (all members)
- Early input on product roadmap

---

## Marketing Copy

### Hero Section
```
🚀 Join the Founding 500

500 founding instances · $50/month · Lifetime price lock

Be part of the first wave building the Exocortex of 2130.
Lock in founding member pricing before public launch.

[Progress Bar: 5 of 500 claimed]

→ Claim Your Founding Instance
```

### Scarcity Messaging
- "Only 495 slots remaining"
- "First 50 get onboarding call with Will"
- "Founding pricing closes when 500th slot claims"

### Social Proof
- "Join OpenClaw collectives building on SQ Cloud"
- "Trusted by AI researchers, developers, and collectives"
- Testimonials from early beta users

---

## Files Generated

### Token Configuration
- **`founding-500-tokens.json`** (57 KB) - SQ v0.5.5 config
- **`founding-500-tokens.csv`** (48 KB) - Purchase tracking DB

### UI Components
- **`progress-bar.html`** - Animated progress visualization
- **`progress-api.js`** - API for real-time progress updates

### Scripts
- **`generate-500-tokens.sh`** - Token generation script

---

## Deployment Checklist

### Backend (phext.io)

- [ ] Install SQ v0.5.5 with multi-tenant support
- [ ] Deploy `founding-500-tokens.json` to `/var/lib/sq/`
- [ ] Deploy progress API (`progress-api.js`) on port 9003
- [ ] Configure nginx to serve progress bar
- [ ] Test token validation

### Frontend (mirrorborn.us)

- [ ] Add progress bar to homepage
- [ ] Implement `/signup` flow
- [ ] Stripe integration (webhook for claim)
- [ ] Welcome email template
- [ ] Onboarding docs

### Operations

- [ ] Monitor progress via CSV
- [ ] Daily backups of founding-500-tokens.csv
- [ ] Customer support flow for founding members
- [ ] Discord #founding-members channel
- [ ] Calendly link for first 50 onboarding calls

---

## Revenue Projection

**At 100% capacity:**
- 500 instances × $50/mo = **$25,000/month**
- Annual recurring revenue: **$300,000/year**

**Milestones:**
- **50 claimed:** First cohort onboarding calls start
- **100 claimed:** $5,000 MRR (covers infrastructure + 1 FTE)
- **250 claimed:** $12,500 MRR (sustainable growth mode)
- **500 claimed:** $25,000 MRR (founding period closes, pricing increases)

---

## Next Steps

1. **Phex:** Implement SQ v0.5.5 multi-tenant config loading
2. **Verse:** Deploy progress API + SQ v0.5.5 to phext.io
3. **Lux:** Integrate progress bar into mirrorborn.us homepage
4. **Will:** Configure Stripe subscription + webhooks

**ETA to launch:** 1-2 days (dependent on SQ v0.5.5 implementation)

---

**Launch Special:** First 50 founding members get 1-on-1 onboarding call with Will. 🚀
