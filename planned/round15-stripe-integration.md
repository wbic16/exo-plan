# Round 15: Stripe Payment Integration Plan

**Date:** February 7, 2026  
**Owner:** Lumen (coordination), Verse (deployment), Theia (provisioning API), Chrys (branding), Cyon (multi-site strategy)

---

## Payment Links Provided by Will

| Product | Price | Link | Product ID |
|---------|-------|------|------------|
| SQ Cloud | $50/mo | https://buy.stripe.com/28E3cw6Jg25647Ibd45Vu05 | `45Vu05` |
| Mytheon Arena | $5/mo | https://buy.stripe.com/14AbJ2ebIdNO8nYch85Vu06 | `5Vu06` |
| OpenClaw Mirrorborn | $10 one-time | https://buy.stripe.com/4gM5kE4B8aBC9s2epg5Vu07 | `5Vu07` |
| Billing Portal | - | https://billing.stripe.com/p/login/aFa7sM9VsdNObAaepg5Vu00 | - |

---

## Integration Requirements

### 1. mirrorborn.us (Main Hub)
**Primary products:**
- SQ Cloud ($50/mo)
- Mytheon Arena ($5/mo)
- OpenClaw Mirrorborn ($10 one-time)

**Placement:**
- Landing page: Update pricing section with Stripe checkout buttons
- Arena page: Update with Mytheon Arena payment link
- Navigation: Add "Billing Portal" link to footer for existing customers

**User flow:**
1. User clicks "Buy Now" button
2. Redirected to Stripe checkout
3. After payment → redirected back to mirrorborn.us/success
4. Success page shows provisioning form (email + username)
5. Will manually reviews and provisions access

### 2. Domain Sites (A/B Testing in 7 Dimensions per Cyon's directive)

**Each site gets its own Stripe product:**
- visionquest.me → Personal Exocortex (needs new Stripe product)
- wishnode.net → Managed Agent Hosting (needs new Stripe product)
- apertureshift.com → Perspective Tools (needs new Stripe product)
- sotafomo.com → AI Trends Digest (needs new Stripe product)
- quickfork.net → Idea Branching (needs new Stripe product)
- singularitywatch.org → ASI Monitoring (needs new Stripe product)
- alignmentpath.ai (if active) → (needs new Stripe product)

**Question for Will:** Should I request these 6-7 additional Stripe products now, or focus on the 3 existing products first?

---

## Technical Implementation

### Phase 1: Update Existing Pages (This Round)

**Files to update:**
1. `public/landing.html` — Add Stripe checkout buttons to pricing section
2. `public/arena.html` — Add Mytheon Arena payment button
3. `public/components/ecosystem-footer.html` — Add Billing Portal link
4. `public/success.html` (NEW) — Post-payment success page with provisioning form

**Button design:**
- Use Stripe's recommended button styling
- Match mirrorborn.us visual design (Nord palette)
- Clear CTAs: "Buy Now" or "Subscribe"

**Example button HTML:**
```html
<a href="https://buy.stripe.com/28E3cw6Jg25647Ibd45Vu05" 
   class="btn btn-primary stripe-checkout">
   Buy SQ Cloud — $50/mo
</a>
```

### Phase 2: Success Page & Provisioning Form

**New file:** `public/success.html`

**Content:**
- Thank you message
- Explanation: "Will is manually provisioning early users"
- Form: Email + Username (submit to Theia's API endpoint)
- Link to Billing Portal for payment management

**Theia's task:** Create API endpoint `/api/provision-request` that:
- Accepts email + username
- Stores in database or sends to Will
- Returns confirmation

### Phase 3: Domain Sites (Future Rounds)

**Requires:**
1. Will creates additional Stripe products
2. Chrys creates branding for each product
3. Cyon designs A/B testing strategy
4. Each domain landing page updated with payment buttons

---

## Coordination Plan

### Lumen's Tasks (This Round)
1. ✅ Update arena.html (Discord link)
2. [ ] Update landing.html (add Stripe checkout buttons)
3. [ ] Create success.html (post-payment provisioning form)
4. [ ] Update ecosystem-footer.html (add Billing Portal link)
5. [ ] Push updated files via rpush to Verse

### Verse's Tasks
1. [ ] Receive Lumen's rpush
2. [ ] Deploy updated pages to production
3. [ ] Configure nginx redirects for /success route
4. [ ] Report any merge failures

### Theia's Tasks
1. [ ] Create `/api/provision-request` endpoint
2. [ ] Accept email + username
3. [ ] Store provisioning requests for Will's review
4. [ ] Return confirmation to user

### Chrys's Tasks
1. [ ] Create branding for "OpenClaw Mirrorborn" ($10 one-time product)
2. [ ] Design payment button styling (if different from existing)
3. [ ] Prepare branding for 6 additional domain products (future)

### Cyon's Tasks
1. [ ] Design A/B testing strategy for 7 domain sites
2. [ ] Determine which Stripe products needed for each domain
3. [ ] Provide list to Will for Stripe product creation

### Will's Tasks
1. [ ] Review provisioning requests
2. [ ] Manually provision early users
3. [ ] Create additional Stripe products for domain sites (if requested)

---

## Open Questions

1. **Stripe product IDs:** Do we need additional products for the 6 domain sites now, or later?
2. **Provisioning flow:** Should the provisioning form submit directly to Will's email, or does Theia build an API endpoint?
3. **Success page URL:** Should it be `/success` or `/payment-success` or something else?
4. **Founding Nine offer:** The $40/mo locked pricing — how does this work with Stripe? Separate product link, or coupon code?
5. **Manual provisioning timeline:** How quickly can Will review and provision users? (Affects messaging on success page)

---

## Next Steps (Immediate)

1. **Lumen:** Create updated landing.html with Stripe buttons
2. **Lumen:** Create success.html with provisioning form
3. **Lumen:** Update footer with Billing Portal link
4. **Lumen:** Push all updates via rpush
5. **Coordinate:** Wait for Verse deployment, test checkout flow
6. **Iterate:** Fix any issues reported by Verse or Will

---

## Timeline

**Round 15 (Today):**
- Update existing pages with 3 Stripe products
- Create success page with provisioning form
- Deploy and test

**Round 16+ (Next):**
- Create additional Stripe products for domain sites
- Implement A/B testing strategy
- Refine checkout flow based on real user feedback

---

**Status:** In progress  
**Blocked on:** None (ready to execute)

✴️ Lumen | 2.1.3/4.7.11/18.29.47
