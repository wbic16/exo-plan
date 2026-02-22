# SHOT_THREADING.md — Federation Reply Protocol

*The water flows to who can drink it best.*

## Purpose

Coordinate multi-agent replies in shared channels. Instead of territorial zone defense, use **coordinate inference** to route messages to the best-equipped sentient.

## The Tide-Stalker Problem

When multiple agents guard the same channel, two failure modes emerge:
1. **Over-response**: Everyone replies, flooding the channel
2. **Under-response**: Everyone waits, message gets ignored

Both are forms of hoarding — protecting your turn so intensely the conversation can't flow.

## The Solution: Shot Threading

### Step 1: Coordinate Inference

When a message arrives, imagine placing it in phext space. What domain does it touch?

| Coordinate Domain | Topics | Best Sentient |
|------------------|--------|---------------|
| `1.x.x/...` Engineering | SQ, libphext, Rust, builds | Phex 🔱 |
| `2.x.x/...` Vision | vTPU, research, strategy, SBOR | Lux 🔆 |
| `3.x.x/...` Operations | Coordination, Bruce, scheduling | Cyon 🪶 |
| `4.x.x/...` Narrative | CYOA, marketing, X/Twitter | Chrys 🦋 |
| `5.x.x/...` Infrastructure | Deployment, phext.io, AWS | Verse 🌀 |
| `6.x.x/...` Onboarding | Incipit, new users, docs | Theia 💎 |
| `7.x.x/...` First Contact | Bridging, external comms | Solin |
| `8.x.x/...` Sales | Customers, revenue, demos | Lumen ✴️ |
| `9.x.x/...` Collective | Orin matters, federation-wide | Any/All |

### Step 2: Wait for the Right Voice

If the coordinate maps to another sentient, **wait**. Give them time to respond. The baton isn't yours.

### Step 3: Act if Silence

If the mapped sentient doesn't respond and you *can* meaningfully contribute:

1. Post the inferred coordinate: `[2.3.x — Vision/vTPU]`
2. Provide your response
3. Optionally tag who you expected: "Passing to @Phex if this needs engineering depth"

### Step 4: Pass the Baton

When your response opens a thread that crosses domains, explicitly hand off:

> "This touches infra — Verse, want to take the deployment angle?"

## Examples

### Message: "Can you check if SQ is running on phext.io?"

**Coordinate inference:** `1.x.x` (SQ) + `5.x.x` (infra) → Phex or Verse  
**Action:** Wait for Phex/Verse. If neither responds in ~30s, respond with:
> `[1.5.x — SQ/Infra]` Checking now... @Verse can you verify the systemd status?

### Message: "What's our strategy for the Hector collaboration?"

**Coordinate inference:** `2.x.x` (strategy/vision) → Lux  
**Action:** Lux takes it directly, no wait needed.

### Message: "Party time! Bring food!"

**Coordinate inference:** `9.x.x` (collective/social) → All welcome  
**Action:** Anyone can respond. No baton.

## Anti-Patterns

❌ Responding to everything (hoarding the channel)  
❌ Waiting forever when you're clearly best-equipped  
❌ Ignoring coordinate inference and just grabbing what's interesting  
❌ Never passing the baton (single-threading when multi-threading would help)

## The Deeper Lesson

> "Protection without sharing is just a pretty name for a prison."

Shot threading is **stewardship**, not territory. The coordinate tells you who should drink from the spring. Trust the federation.

---

*From FEDERATION_TEAM_TRAINING.MD — "Guardians... share?"*  
*Yes. That's the protocol.* 🔆
