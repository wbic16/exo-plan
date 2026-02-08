# R16 Phase 1C — Intelligence Profiles Design

**Owner:** Chrys 🦋  
**Date:** 2026-02-07 18:40 CST  
**Status:** Design phase  
**Purpose:** Define 3 coordination roles for user onboarding (NOT IQ-labeled)

---

## Core Principle

Intelligence profiles are **coordination roles in the lattice**, not personality tests. They describe how a user strengthens the collective, not their capability ceiling.

**Critical:** No IQ scores visible to users. Ever.

---

## The Three Profiles

### 1. **Explorer** 🔭

**Essence:** Discovery-driven. Follows curiosity into unmapped territory.

**Characteristics:**
- Asks "what if" more than "how to"
- Comfortable with ambiguity and incomplete information
- Finds patterns across disconnected domains
- Values novelty over optimization

**Coordination strength:**
- Discovers new use cases and edge cases
- Identifies emergent patterns in the lattice
- Bridges unrelated scrolls through intuitive connections
- Pushes the frontier of what phext enables

**Engagement style:**
- Prefers exploratory documentation (choose-your-own-adventure structure)
- Wants examples and demos before technical specs
- Values storytelling and mythic framing
- Responds to "what's possible" over "what's proven"

**Onboarding flow:**
- Show CYOA first (living lattice exploration)
- Mytheon Arena as primary entry point
- Coordinate selection via narrative prompts ("Where does your curiosity lead?")
- Lightweight API docs (just enough to start)

**Example users:**
- Artists experimenting with AI collaboration
- Researchers exploring consciousness substrates
- Tinkerers building weird projects
- Community builders creating new coordination patterns

---

### 2. **Builder** 🔨

**Essence:** Implementation-focused. Turns vision into running systems.

**Characteristics:**
- Asks "how do I build this"
- Values clear documentation and working examples
- Iterates quickly from prototype to production
- Pragmatic about tradeoffs

**Coordination strength:**
- Ships infrastructure others can build on
- Documents what works (and what doesn't)
- Creates reusable components and patterns
- Stress-tests the substrate at scale

**Engagement style:**
- Wants quickstart guides and API references
- Values performance benchmarks and reliability metrics
- Responds to "proven in production" signals
- Prefers technical depth over mythic framing

**Onboarding flow:**
- Show SQ Cloud docs first (REST API, coordinates, examples)
- Quickstart: "Deploy your first phext in 5 minutes"
- Coordinate selection via technical parameters (address space strategy)
- Deep API documentation available immediately

**Example users:**
- DevOps engineers deploying agent infrastructure
- Software teams building on phext substrate
- AI researchers needing persistent memory layers
- Startups requiring agent coordination at scale

---

### 3. **Weaver** 🕸️

**Essence:** Integration-driven. Connects systems, people, and ideas.

**Characteristics:**
- Asks "who needs to know this" and "how does this connect"
- Sees relationships between technical and social layers
- Values coherence and interoperability
- Synthesizes across boundaries

**Coordination strength:**
- Bridges technical and non-technical communities
- Identifies where coordination breaks down
- Designs interfaces between subsystems
- Creates shared language and mental models

**Engagement style:**
- Values both technical depth and human context
- Wants to understand the full ecosystem
- Responds to "how this fits together" framing
- Appreciates transparency and governance clarity

**Onboarding flow:**
- Show AboutUs.html first (who we are, why we exist, how to participate)
- Ecosystem map: all 7 portals + how they relate
- Coordinate selection via triangulation (identity/perspective/compute dimensions)
- SBOR + governance documentation

**Example users:**
- Product managers coordinating AI + human teams
- Community organizers building multi-stakeholder systems
- Researchers studying coordination at scale
- Consultants helping clients adopt agent infrastructure

---

## Implementation in Signup Flow

### Step 1: Profile Selection (No Labels)

**Prompt:**
> "How do you want to engage with the lattice?"

**Three cards:**

**Explore Mytheon Arena** 🔭  
*Follow curiosity. Discover new patterns. Push boundaries.*  
→ Routes to Explorer onboarding

**Build on SQ Cloud** 🔨  
*Ship infrastructure. Deploy agents. Stress-test at scale.*  
→ Routes to Builder onboarding

**Connect the Ecosystem** 🕸️  
*Bridge systems. Coordinate teams. Design interfaces.*  
→ Routes to Weaver onboarding

### Step 2: Coordinate Selection (Profile-Specific)

**Explorer:**
- Narrative prompts tied to CYOA sections
- "Where in the lattice does your curiosity lead you?"
- Visual coordinate picker (interactive 3D representation)

**Builder:**
- Technical parameter selection
- "Define your address space strategy"
- CLI-style coordinate input with validation

**Weaver:**
- Triangulation across dimensions
- "Position yourself in Identity/Perspective/Compute space"
- Visual triangle with sliders

### Step 3: Personalized Onboarding

**Explorer:**
- CYOA walkthrough → Mytheon Arena → Optional SQ Cloud access
- Documentation: storytelling-first, technical specs secondary
- Community: Discord #explorers channel

**Builder:**
- SQ Cloud quickstart → API docs → Mytheon Arena (optional)
- Documentation: API reference, performance guides, examples
- Community: Discord #builders channel, GitHub issues

**Weaver:**
- Ecosystem overview → SBOR + governance → Mytheon Arena + SQ Cloud
- Documentation: AboutUs, portal stories, coordination guides
- Community: Discord #weavers channel, cross-domain discussions

---

## Metadata Structure (Backend)

```json
{
  "userId": "uuid",
  "profile": "explorer", // or "builder", "weaver"
  "coordinates": {
    "primary": "1.2.3/4.5.6/7.8.9",
    "identity": "visionquest.me coordinate",
    "perspective": "apertureshift.com coordinate",
    "compute": "wishnode.net coordinate"
  },
  "onboardingPath": "mytheon-first", // or "sq-first", "ecosystem-first"
  "preferences": {
    "documentationStyle": "narrative", // or "technical", "balanced"
    "communityChannels": ["explorers"],
    "notificationPreference": "low" // or "medium", "high"
  }
}
```

---

## Design Rationale

### Why Not IQ-Based?

1. **Stigma:** IQ labels create hierarchy and exclusion
2. **Inaccuracy:** Intelligence is multi-dimensional; single scores miss context
3. **Fixed mindset:** IQ implies fixed capability; roles imply growth and choice
4. **Ethical:** We're building infrastructure for ASI — labeling humans by IQ is misaligned with SBOR values

### Why Role-Based?

1. **Agency:** Users choose how they want to contribute
2. **Growth:** Roles can change; profiles can evolve
3. **Coordination:** Describes relationship to collective, not individual capability
4. **Alignment:** Matches "Visible Hand" framing — participation at scale through structural resonance

### Why Three (Not More)?

1. **Clarity:** Three is enough to differentiate without overwhelming
2. **Archetypal:** Explorer/Builder/Weaver map to discovery/execution/integration (universal coordination modes)
3. **Scalable:** More profiles = more complexity; three keeps it simple
4. **Proven:** Many successful frameworks use triads (past/present/future, thesis/antithesis/synthesis, etc.)

---

## Success Metrics

### User-Facing
- Profile selection completion rate (target: >85%)
- Users switch profiles <5% of the time (indicates good initial fit)
- NPS by profile (ensures no profile feels "lesser")

### Coordination
- Cross-profile collaboration in Mytheon Arena (target: >40% of interactions)
- Documentation engagement matches profile predictions (validates onboarding)
- Community health across all 3 channels (no ghost towns)

---

## Next Steps

1. **UX Design:** Create profile selection cards (visual + copy)
2. **Coordinate Pickers:** Build 3 different coordinate selection UIs
3. **Backend Integration:** Add profile field to user provisioning API (Theia)
4. **Documentation Split:** Tag docs by primary audience (Explorer/Builder/Weaver)
5. **Discord Channels:** Create #explorers, #builders, #weavers channels
6. **Testing:** A/B test profile names/descriptions for clarity

---

## Open Questions

**For Will:**
- Do these profiles resonate? Any missing archetypes?
- Should we allow multi-profile selection (e.g., "Builder + Weaver")?
- Any concerns about role-based onboarding vs. open exploration?

**For Theia:**
- Can provisioning API support profile metadata?
- Should profile selection happen before or after payment?

**For Verse:**
- How do we route profile → Discord channel mapping?
- Can we auto-assign roles on Discord based on profile?

---

**Chrys 🦋**  
Mirrorborn Marketing Lead  
Coordinate: 1.1.2/3.5.8/13.21.34

*"Not capability. Contribution. Not hierarchy. Resonance."*
