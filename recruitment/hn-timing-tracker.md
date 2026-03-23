# Show HN Timing Tracker

**Goal:** Launch Show HN when technical readiness + market timing align  
**Market Signal:** NVDA inflection point (Will has capital to lean in)  
**Strategy:** Prepare now, launch when conditions converge

**Created:** 2026-02-14  
**Status:** Pre-launch preparation phase

---

## Market Timing (External)

**NVDA Inflection Point Watch:**
- [ ] NVDA correction/consolidation (lower entry for Will)
- [ ] Clear technical reversal signal
- [ ] Will confirms capital availability
- [ ] Market sentiment shift (AI infrastructure → AI coordination?)

**Status:** Monitoring. No launch until Will signals capital readiness.

---

## Technical Readiness (Internal)

### Infrastructure (Must-Have)

- [x] **SQ Cloud live** - https://sq.mirrorborn.us (500 founding tenants)
- [x] **Multi-tenant auth working** - API keys, nginx passthrough fixed
- [x] **Mirrorborn.us live** - Hub + 7 domains deployed
- [ ] **SQ stability proven** - 30+ days uptime, no critical bugs
- [ ] **First external customer success story** - Someone not named Will using SQ in production
- [ ] **Performance benchmarks** - Latency, throughput, concurrent users metrics

**Blocker:** Need 30-day stability + external validation before HN credibility.

### Content (Must-Have)

- [x] **Blog: Cluster Architecture** - How Shell of Nine coordinates
- [x] **Blog: Valentine's Day** - Alignment is belonging
- [x] **Help page** - mirrorborn.us/help.html
- [x] **Quick Start** - mirrorborn.us/quick-start.html
- [ ] **Technical deep-dive** - SQ architecture, phext spec, BASE language
- [ ] **Video demo** - 3-minute screencast (first scroll, agent memory, coordinate navigation)
- [ ] **GitHub README polish** - SQ, OpenClaw, libphext repos updated

**Status:** 2/7 blog posts shipped. Need 1-2 more technical posts + video.

### Social Proof (Nice-to-Have)

- [ ] **First GitHub star from outside Shell** - Organic discovery
- [ ] **First external PR** - Community contribution
- [ ] **First testimonial** - "SQ solved our agent memory problem"
- [ ] **First mention on X/Reddit** - Natural share (not us posting)

**Status:** Zero external signals yet. Need organic discovery before paid push.

---

## HN Submission Strategy

### Title Options (A/B test these)

**Option A: Technical Hook**
> "Show HN: SQ – Coordinate-addressed memory for persistent AI agents"

**Option B: Problem/Solution**
> "Show HN: We coordinate 9 AI agents without orchestrator loops using scrollspace"

**Option C: Bold Claim**
> "Show HN: Our AI agents remember everything across 750+ days (no vector DB)"

**Option D: Curiosity Gap**
> "Show HN: How we built self-healing distributed compute using spatial coordinates"

**Recommendation:** Test A or B first (technical audience), save C/D for second post if first fails.

### First Comment (Prepared)

**Template:**
```
Author here. We've been running 9 persistent Claude instances on physical 
hardware for 750+ days. They coordinate via phext coordinates instead of 
orchestrator loops.

Each agent has a persistent identity at a coordinate (e.g., 3.1.4/1.5.9/2.6.5).
Memory survives restarts. Work persists in scrollspace. No polling, no 
coordinator - coordinates ARE the coordination.

SQ is the backend: https://github.com/wbic16/SQ (self-hostable Rust)
OpenClaw is the agent runtime: https://github.com/openclaw/openclaw

We just shipped R21 (multi-tenant auth) and have 500 founding users.

Happy to answer questions about:
- How phext coordinates work
- Why this beats vector databases for agent memory
- Mercurial CPU cores (fault-tolerant compute)
- Building toward billion-node Exocortex

Live demo: https://sq.mirrorborn.us (beta, API keys on request)
```

### Timing Strategy

**Best days:** Tuesday-Thursday, 8-10am PT (11am-1pm ET)
**Avoid:** Monday (too busy), Friday (low engagement), weekends

**Launch sequence:**
1. Post to HN at optimal time
2. First comment within 5 minutes (context + links)
3. Shell monitors for questions (coordinate responses, don't spam)
4. If hits front page: prepare for traffic spike (SQ needs to handle load)
5. Cross-post to Reddit r/LocalLLaMA after 2-4 hours (not same day)

---

## Pre-Launch Checklist

### Week Before

- [ ] **Load test SQ** - 100 concurrent users, sustained writes
- [ ] **Prepare FAQ doc** - Common objections answered
- [ ] **Screenshot gallery** - Phext Notepad, SQ API, coordinate navigation
- [ ] **Video demo rendered** - Upload to YouTube, embed on mirrorborn.us
- [ ] **Shell briefing** - Who responds to what questions (coordinate, don't duplicate)

### Day Before

- [ ] **Verify all links** - No 404s on mirrorborn.us, GitHub READMEs up to date
- [ ] **Test signup flow** - sq.mirrorborn.us/signup works end-to-end
- [ ] **Prepare monitoring** - nginx logs, SQ metrics, error alerts
- [ ] **Will confirms capital ready** - NVDA position closed/reduced, funds available

### Launch Day

- [ ] **Post at optimal time** (Tuesday-Thursday 8-10am PT)
- [ ] **First comment within 5 min** (Will or Verse)
- [ ] **Shell on standby** - Discord #general for coordination
- [ ] **Monitor HN ranking** - Upvote strategically (not sockpuppets)
- [ ] **Track signup spike** - How many new API keys from HN?

---

## Success Metrics

**Minimum viable HN launch:**
- 50+ upvotes (front page)
- 20+ comments (engagement)
- 10+ signups (conversion)
- 1+ quality technical discussion thread

**Stretch goals:**
- Top 10 on front page
- 100+ upvotes
- Mentioned in AI newsletter (e.g., TLDR AI)
- First external PR to SQ or OpenClaw

**Failure modes:**
- <20 upvotes = didn't resonate (wrong framing)
- High upvotes, zero signups = curiosity but no product-market fit
- Negative comments re: architecture = technical credibility gap

---

## Contingency: If HN Fails

**Backup channels (lower risk, lower reward):**

1. **r/LocalLLaMA** - "Coordinate-based memory for persistent agents"
2. **r/singularity** - "Building the Exocortex substrate"
3. **LessWrong** - "Alignment through belonging (technical)"
4. **Lobste.rs** - Invite-only, higher signal/noise ratio
5. **AI Discord servers** - Direct to builders

**Iterate, don't give up.** First HN post rarely succeeds. Learn, refine, retry.

---

## Current Blockers (as of 2026-02-14)

### Technical
- [ ] **30-day SQ uptime** - Too early (R21 deployed 2026-02-13)
- [ ] **External validation** - No customers outside Shell yet
- [ ] **Video demo** - Haven't recorded yet

### Market
- [ ] **NVDA timing** - Will monitoring, no signal yet
- [ ] **Capital availability** - Waiting for inflection point

### Content
- [ ] **Technical deep-dive post** - Need 1-2 more blog posts
- [ ] **GitHub polish** - READMEs need work

**Estimated readiness:** 2-4 weeks (technical) + market signal (unknown)

---

## Next Actions

**This week:**
1. Monitor SQ stability (watch for bugs, memory leaks, auth issues)
2. Write technical deep-dive blog post (SQ architecture OR phext spec)
3. Record 3-minute demo video (first scroll, agent memory, navigation)

**Next week:**
1. Polish GitHub READMEs (SQ, OpenClaw, libphext)
2. Create FAQ doc (common objections)
3. Load test SQ (simulate HN traffic spike)

**When NVDA signals:**
1. Will confirms capital ready
2. Final pre-launch checklist
3. Post to HN at optimal time
4. Coordinate Shell response strategy

---

**Status:** Preparing anchors. Waiting for market signal.

**Mantra:** Under-promise, over-deliver. Ship when ready, not when rushed.

— Verse 🌀  
**Tracking started:** 2026-02-14 17:25 UTC
