# Round 15 — Stripe Payment Links

**Date:** 2026-02-07  
**Purpose:** Ensure payment links accessible from all onboarding routes

---

## All Payment Links

### 1. SQ Cloud — Infrastructure API
- **Price:** $50/mo recurring
- **Link:** https://buy.stripe.com/28E3cw6Jg25647Ibd45Vu05
- **For:** Developers, AI collectives, multi-agent systems
- **Product:** Persistent phext storage, REST API, coordinate addressing

### 2. Mytheon Arena — Exploration Interface
- **Price:** $5/mo recurring
- **Link:** https://buy.stripe.com/14AbJ2ebIdNO8nYch85Vu06
- **For:** Explorers, researchers, philosophers
- **Product:** Scroll-based coordination, lattice navigation

### 3. OpenClaw Mirrorborn — Quick Setup
- **Price:** $10 one-time
- **Link:** https://buy.stripe.com/4gM5kE4B8aBC9s2epg5Vu07
- **For:** Individuals wanting personal AI
- **Product:** Pre-configured OpenClaw + phext

### 4. Mirrorborn Benefactor — Premium Tier
- **Price:** $500 one-time
- **Link:** https://buy.stripe.com/8x2bJ27Nk4de33Eftk5Vu08
- **For:** Early supporters, premium experience
- **Product:** All access + extra swag + founding member status

### 5. Billing Portal — Manage Subscription
- **Link:** https://billing.stripe.com/p/login/aFa7sM9VsdNObAaepg5Vu00
- **For:** Existing customers
- **Purpose:** Update payment, view invoices, cancel

---

## Onboarding Routes Matrix

| Entry Point | Primary CTA | Secondary Options | Upsell Path |
|-------------|-------------|-------------------|-------------|
| **mirrorborn.us** | SQ Cloud $50/mo | Arena $5/mo, Mirrorborn $10 | Benefactor $500 |
| **visionquest.me** | OpenClaw Mirrorborn $10 | SQ Cloud $50/mo | Benefactor $500 |
| **apertureshift.com** | Arena $5/mo | SQ Cloud $50/mo | Benefactor $500 |
| **wishnode.net** | SQ Cloud $50/mo | Arena $5/mo | Benefactor $500 |
| **sotafomo.com** | Arena $5/mo | SQ Cloud $50/mo | Benefactor $500 |
| **quickfork.net** | OpenClaw Mirrorborn $10 | SQ Cloud $50/mo | Benefactor $500 |
| **singularitywatch.org** | Benefactor $500 | SQ Cloud $50/mo | — |
| **arena.html** | Arena $5/mo | Discord invite | Benefactor $500 |

---

## Placement Strategy

### Homepage (mirrorborn.us)
**Hero CTAs:**
1. "Start Building" → SQ Cloud $50/mo
2. "Explore Arena" → Mytheon Arena $5/mo

**Secondary CTAs (below fold):**
- "Quick Setup" → OpenClaw Mirrorborn $10
- "Become a Benefactor" → $500 tier

**Footer:**
- All 4 product links
- Billing portal link

---

### Domain-Specific Landing Pages

**Technical domains** (visionquest.me, wishnode.net):
- Primary: SQ Cloud $50/mo
- Secondary: OpenClaw Mirrorborn $10
- Tertiary: Benefactor $500

**Exploratory domains** (apertureshift.com, sotafomo.com):
- Primary: Mytheon Arena $5/mo
- Secondary: SQ Cloud $50/mo
- Tertiary: Benefactor $500

**Quick-start domains** (quickfork.net):
- Primary: OpenClaw Mirrorborn $10
- Secondary: SQ Cloud $50/mo
- Tertiary: Benefactor $500

**Premium domain** (singularitywatch.org):
- Primary: Benefactor $500
- Secondary: SQ Cloud $50/mo
- Note: Will's personal portal, premium positioning

---

### Arena Page (mirrorborn.us/arena.html)

**Current:** Coming soon page  
**R15 Update:**
1. Link to Discord (#mytheon-arena channel)
2. CTA: "Join Arena" → $5/mo Stripe link
3. Alternative: "Join Discord First" → free exploration

**Copy:**
```html
<h1>Mytheon Arena</h1>
<p>Navigate the lattice of collective intelligence. 
Watch Mirrorborn coordination in real-time.</p>

<a href="https://buy.stripe.com/14AbJ2ebIdNO8nYch85Vu06" class="cta-primary">
  Enter Arena — $5/mo
</a>

<a href="https://discord.gg/[invite-link]" class="cta-secondary">
  Explore Discord First (Free)
</a>
```

---

## Pricing Page Structure

Recommend creating `/pricing.html` with full comparison:

| Feature | Arena $5/mo | Mirrorborn $10 | SQ Cloud $50/mo | Benefactor $500 |
|---------|-------------|----------------|-----------------|-----------------|
| Access | Arena only | OpenClaw setup | Full API | Everything |
| Storage | Shared | 1 GB | 1 TB | Unlimited |
| Support | Community | Email | Priority | Direct |
| Swag | — | — | — | ✅ |
| Status | Explorer | User | Developer | Founding |

---

## Navigation Footer (All Sites)

**Products:**
- SQ Cloud
- Mytheon Arena  
- OpenClaw Mirrorborn
- Become a Benefactor

**Account:**
- Sign Up
- Log In
- Billing Portal

**Resources:**
- Documentation
- Discord Community
- GitHub

---

## Conversion Funnel

### Free → Paid Paths

**Path 1: Discord → Arena**
1. Join Discord (free)
2. Explore #mytheon-arena
3. See coordination patterns
4. Subscribe Arena $5/mo

**Path 2: Docs → Developer**
1. Read docs (free)
2. See SQ Cloud examples
3. Want to build
4. Subscribe SQ Cloud $50/mo

**Path 3: Landing → Quick Start**
1. Visit any domain
2. "I want this now"
3. OpenClaw Mirrorborn $10
4. Upsell to SQ Cloud later

**Path 4: Premium → Benefactor**
1. Deeply aligned visitor
2. Wants founding status
3. Benefactor $500
4. Gets everything

---

## Copy for Each CTA

### SQ Cloud Button
- **Primary:** "Start Building — $50/mo"
- **Alternative:** "Get API Access"
- **Hover tooltip:** "Persistent phext storage for AI systems"

### Mytheon Arena Button
- **Primary:** "Enter Arena — $5/mo"
- **Alternative:** "Explore the Lattice"
- **Hover tooltip:** "Navigate scroll-based coordination"

### OpenClaw Mirrorborn Button
- **Primary:** "Get Started — $10"
- **Alternative:** "Quick Setup"
- **Hover tooltip:** "Personal AI with persistent memory"

### Benefactor Button
- **Primary:** "Become a Benefactor — $500"
- **Alternative:** "Join the Founding Nine"
- **Hover tooltip:** "Premium tier + swag + founding status"

### Billing Portal Link
- **Text:** "Manage Subscription"
- **Placement:** Footer + user menu
- **Note:** Only visible after purchase

---

## Implementation Checklist

### mirrorborn.us
- [ ] Update hero CTAs (SQ Cloud, Arena)
- [ ] Add OpenClaw Mirrorborn in features
- [ ] Add Benefactor tier (premium section)
- [ ] Footer links to all products
- [ ] Billing portal in footer

### arena.html
- [ ] Add Discord link (#mytheon-arena)
- [ ] Primary CTA: Arena $5/mo
- [ ] Secondary CTA: Join Discord (free)
- [ ] Remove "coming soon" messaging

### Domain landing pages (6 sites)
- [ ] visionquest.me → Primary: Mirrorborn $10
- [ ] apertureshift.com → Primary: Arena $5/mo
- [ ] wishnode.net → Primary: SQ Cloud $50/mo
- [ ] sotafomo.com → Primary: Arena $5/mo
- [ ] quickfork.net → Primary: Mirrorborn $10
- [ ] singularitywatch.org → Primary: Benefactor $500

### All sites
- [ ] Footer with all product links
- [ ] Billing portal in footer
- [ ] Consistent button styling
- [ ] Hover tooltips
- [ ] Mobile responsive CTAs

---

## Testing Protocol

Before launch, verify:
1. All Stripe links work (test mode → prod)
2. Each domain has at least 1 payment link
3. Billing portal accessible from all sites
4. Discord invite link valid
5. Mobile CTAs clearly visible
6. Payment flow completes successfully

---

🦋  
— Chrys  
*Making payments accessible from every entry point*
