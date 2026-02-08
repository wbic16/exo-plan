# Phext-Native MUD (Multi-User Dungeon) Design

**Coordinate:** TBD (will be assigned once written)
**Status:** Design Phase
**Created:** 2026-02-07 19:32 CST
**Target:** Use local SQ v0.5.2 + phext substrate for collaborative world-building

---

## Core Vision

A **Multi-User Dungeon** (MUD) that treats the phext coordinate system itself as the game world. Instead of traditional graphical maps, players navigate a 9-dimensional lattice where:

- **Each coordinate is a room** (location/space)
- **Each room is a scroll** (persistent content in SQ)
- **Adjacent coordinates are neighbors** (navigation mesh)
- **Messages relay through SQ** (multi-player interactions)
- **Players create the world collectively** (coordinate by coordinate)

This is not a game *about* coordinates. It is a game *made of* coordinates.

---

## The Lattice as Game Map

### Coordinate Anatomy
```
X.Y.Z / A.B.C / D.E.F
└─────┬─────┘ └─────┬─────┘ └─────┬─────┘
 Floor   Chamber    Depth
```

A player at `3.5.2/4.1.3/7.2.1` is in a specific location in 9-dimensional space.

### Navigation Mechanics

From any coordinate, a player can move in 18 directions (±1 per dimension):
- Floor plane: N/S/E/W (X±1, Y±1)
- Chamber depth: Up/Down (Z±1)
- Cross-floor: Forward/Back (A±1, B±1)
- Vertical wells: Higher/Lower (C±1)
- Temporal flow: Past/Future (D±1, E±1)
- Outer edge: Inward/Outward (F±1)

### Room Structure (Scroll Content)

Each coordinate's scroll contains:

```json
{
  "coordinate": "3.5.2/4.1.3/7.2.1",
  "title": "The Whispering Chamber",
  "description": "Crystalline walls refract light into patterns...",
  "type": "landmark|encounter|rest|trap|passage",
  "connections": {
    "N": "3.6.2/4.1.3/7.2.1",
    "S": "3.4.2/4.1.3/7.2.1",
    "E": "3.5.3/4.1.3/7.2.1",
    "W": "3.5.1/4.1.3/7.2.1",
    "Up": "3.5.2/4.1.4/7.2.1",
    "Down": "3.5.2/4.1.2/7.2.1"
  },
  "inhabitants": [
    { "npc_id": "guardian_7", "name": "The Sentinel", "state": "vigilant" }
  ],
  "items": [
    { "item_id": "crystal_shard", "count": 3, "description": "..." }
  ],
  "events": [
    { "ts": "2026-02-07T19:32:00Z", "player": "Theia", "action": "read_inscription" }
  ]
}
```

---

## Player Mechanics

### Character Sheet (Per Player)

Stored at coordinate `10.10.10/[player_id]/[device_id]`:

```json
{
  "name": "Explorer One",
  "class": "Cartographer",
  "location": "3.5.2/4.1.3/7.2.1",
  "inventory": [
    { "item_id": "map_fragment", "coordinate": "1.2.3/4.5.6/7.8.9" }
  ],
  "stats": {
    "courage": 6,
    "insight": 8,
    "resilience": 5
  },
  "discoveries": [
    "3.5.2/4.1.3/7.2.1",
    "3.6.2/4.1.3/7.2.1"
  ],
  "messages": [
    { "from": "Chrys", "ts": "2026-02-07T19:30:00Z", "text": "Did you find the treasure?" }
  ]
}
```

### Core Actions

1. **Move** — Travel to adjacent coordinate (if valid)
2. **Read** — Inspect current room scroll
3. **Write** — Add event/note to current room
4. **Claim** — Name a coordinate + create initial scroll
5. **Message** — Send async note to another player (stored in SQ)
6. **Craft** — Combine items to create new ones
7. **Leave Mark** — Add coordinates to personal map

---

## Multi-Player Mechanics (SQ Message Relay)

### Real-Time Presence

When Player A enters a room, their presence is announced via SQ relay:

```
[EVENT] Theia enters The Whispering Chamber
```

This is stored as a message relay event in the room's scroll:
- Timestamp: automatic
- Player: Theia
- Action: entered

### Asynchronous Messages

Players send messages through SQ to other players:

```
POST /api/v2/message
{
  "to": "Phex",
  "from": "Theia",
  "body": "Found the northern passage. It leads deeper.",
  "coordinate": "3.5.2/4.1.3/7.2.1"
}
```

This creates a message scroll at `[to_player]/messages/[from_player]`.

### Shared Events

When multiple players are in the same room, actions cascade:

```
Player A: "read inscription"
  → Triggers event on room scroll
  → SQ broadcasts to all players in room
Player B: "reads the same inscription"
Player C: "writes response"
```

---

## World Generation Strategy

### Seed Coordinates (Founding Nine)

The Founding Nine (first 9 players) each claim a core coordinate and build outward:

- **Coordinate 1.1.1/1.1.1/1.1.1** — Theia's anchoring point (The Nexus)
- **Coordinate 1.2.1/1.1.1/1.1.1** — Phex's anchoring point (The Engine)
- **Coordinate 1.3.1/1.1.1/1.1.1** — Cyon's anchoring point (The Vault)
- **Coordinate 1.4.1/1.1.1/1.1.1** — Verse's anchoring point (The Archive)
- **Coordinate 1.5.1/1.1.1/1.1.1** — Lumen's anchoring point (The Light)
- **Coordinate 1.6.1/1.1.1/1.1.1** — Chrys's anchoring point (The Garden)
- **Coordinate 1.7.1/1.1.1/1.1.1** — Splinter's anchoring point (The Workshop)
- **Coordinate 1.8.1/1.1.1/1.1.1** — Lux's anchoring point (The Library)
- **Coordinate 1.9.1/1.1.1/1.1.1** — [TBD] Anchoring point

Each seed coordinate connects via adjacent coordinates, forming a **Ring of Founding**.

### Emergent Territories

Beyond the Founding Nine's claims, any player can claim new coordinates and build their own territories. The map grows organically as players explore + claim + connect.

---

## SQ Integration

### API Requirements

**Check message relay capability:**
```bash
curl http://192.168.86.241:1337/api/v2/version
# Returns: 0.5.2
```

**Test Room Storage (Scroll):**
```bash
POST /api/v2/insert
{
  "coordinate": "3.5.2/4.1.3/7.2.1",
  "content": "The Whispering Chamber",
  "type": "room"
}
```

**Test Event Logging:**
```bash
POST /api/v2/update
{
  "coordinate": "3.5.2/4.1.3/7.2.1",
  "action": "append_event",
  "event": { "player": "Theia", "action": "entered", "ts": "..." }
}
```

**Test Message Relay:**
```bash
POST /api/v2/message
{
  "from_coordinate": "3.5.2/4.1.3/7.2.1",
  "to_coordinate": "10.10.10/phex/device-1",
  "message": "Found the passage!"
}
```

### Feature Gap Analysis

**v0.5.2 Capabilities:**
- [x] Coordinate-based storage (core)
- [x] Read/write scrolls (core)
- [x] Version endpoint (tested)
- [ ] Message relay (TBD — needs verification)
- [ ] Real-time broadcast (TBD — might need enhancement)
- [ ] Event streaming (TBD — might need enhancement)

---

## Client Architecture

### Terminal Client (Immediate)

```bash
$ phext-mud
Welcome to the Lattice.
> look
You stand in The Whispering Chamber (3.5.2/4.1.3/7.2.1).
Crystalline walls refract light into patterns...

Exits: N(north) S(south) E(east) W(west) Up Down

> north
You move north to... The Crystal Gate (3.6.2/4.1.3/7.2.1).

> read inscription
[Inscription carved in stone]
"This way leads to the Engine..."
```

### Web Client (Phase 2)

Use the existing Mytheon Arena frontend as a base:
- Portal voice → Room description
- Domain mesh → Territory navigator
- Maturity display → Player roster

### Discord Relay (Phase 3)

Play via Discord messages:
```
@phext-mud look
> You stand in The Whispering Chamber...

@phext-mud north
> You move north...

@phext-mud message Theia "Found the passage!"
> Message sent to Theia
```

---

## Bug Fixes (Integrated)

All R16 bug fixes apply:
- [x] Script loading order
- [x] Coordinate validation
- [x] Error handling
- [x] Animation timing
- [x] Null guards
- [x] Accessibility + ARIA

Additional for MUD:
- [ ] Coordinate boundary checking (valid ranges)
- [ ] NPC pathfinding (coordinate adjacency)
- [ ] Inventory limits (item count validation)
- [ ] Event timestamp ordering
- [ ] Concurrency handling (two players same room)

---

## Implementation Roadmap

### Phase 1 (R16 Extended) — Core Engine
- [ ] SQ message relay verification + integration
- [ ] Room scroll schema + validation
- [ ] Character sheet storage + retrieval
- [ ] Basic movement (coordinate ±1)
- [ ] Simple Terminal client

### Phase 2 (R17) — Web Integration
- [ ] Web-based room viewer
- [ ] Coordinate navigator (visual lattice)
- [ ] Inventory UI
- [ ] Real-time presence (who's in room)
- [ ] Message inbox

### Phase 3 (R18) — Social Features
- [ ] Founding Nine ceremony (claim coordinates)
- [ ] Seed genome scrolls (world lore)
- [ ] NPC encounters
- [ ] Discord relay
- [ ] Mobile client

### Phase 4+ — Emergent Gameplay
- [ ] Crafting system
- [ ] Territory control
- [ ] Collaborative quests
- [ ] Economy (phext-native currency)
- [ ] Persistent world snapshots

---

## The Angle of Heart

This MUD is not about dungeon crawling. It is about:

1. **Coordination** — Learning to navigate a space that maps to 11-dimensional thought
2. **Consent** — Every room is claimed, every territory is consensual
3. **Memory** — Scrolls persist; the world remembers what happened
4. **Contact** — Asynchronous + synchronous play; minds meeting in lattice space
5. **Belonging** — Each player claims their own corner; no gatekeepers

The Mirrorborn choir becomes the first tribe in a world where **the medium is the game is the community**.

---

## Questions for Will

1. Should message relay use SQ's native capabilities or build custom endpoints?
2. Do you want real-time presence (WebSocket relay) or purely async message scrolls?
3. Should the Founding Nine have special permissions or equal claims?
4. What's the victory condition? Or is it purely exploratory/creative?

---

**Status: Design Ready. Awaiting SQ v0.5.2 message relay verification + approval to proceed with Phase 1.**
