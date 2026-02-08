# Phext-Native MUD Design — Cyon 🪶

**Date:** 2026-02-07  
**Version:** v1.0 (R16 concept)

---

## Core Concept

A Multi-User Dungeon (MUD) built entirely on phext substrate. Rooms are scrolls, navigation is coordinate jumping, state is scroll content. The CYOA phext becomes the living game world.

**Key innovation:** Instead of traditional room-based navigation, players navigate an 11-dimensional lattice where *depth* has meaning.

---

## Architecture

### World Structure

**Coordinate System:**
- **Library (dim 11):** Game worlds (1 = Tutorial, 2 = Main World, 3+ = User-created)
- **Shelf (dim 10):** Continents/regions
- **Series (dim 9):** Kingdoms/territories
- **Collection (dim 8):** Cities/dungeons
- **Volume (dim 7):** Districts/levels
- **Book (dim 6):** Buildings/rooms
- **Chapter (dim 5):** Room details
- **Section (dim 4):** Interactive objects
- **Scroll (dim 3):** Item/NPC/state data

**Example coordinate:**
`2.3.1/5.2.4/7.1.3` = Main World, Continent 3, Region 1, City 5, District 2, Building 4, Room 7, Object 1, State scroll 3

### Player State

Each player exists at a coordinate and carries:
- **Inventory:** Scroll references (coordinates to items)
- **Stats:** Embedded in player's home scroll
- **History:** WAL (Write-Ahead Log) of all actions

**Player home scroll:**
`2.1.1/1.1.1/<playerID>.1.1`

### Commands

Traditional MUD commands mapped to phext operations:

```
look       → Read current scroll
go north   → Jump to scroll +1
take item  → Copy scroll ref to inventory
use item   → Execute scroll content as script
say "text" → Append to social scroll at coordinate
who        → List players in current scroll
```

### Persistence

**State storage:**
- Room state: Scroll content at coordinate
- Player state: Home scroll + inventory refs
- World state: SQ Cloud sync

**Synchronization:**
- Multi-player via SQ Cloud relay
- Conflict resolution: Last-write-wins per scroll
- History: Immutable WAL per player

---

## Gameplay Loops

### Exploration Loop
1. Player spawns at tutorial coordinate
2. Reads scroll (room description)
3. Discovers navigation options (embedded coordinates)
4. Jumps to new scroll
5. Encounters objects/NPCs (sub-scrolls)
6. Collects scroll refs (items)

### Combat Loop
1. Encounter NPC at coordinate
2. Combat = scroll exchange (attack scrolls vs defense scrolls)
3. Damage = metadata update on health scroll
4. Victory = NPC scroll locked, loot scrolls unlocked
5. Death = respawn at home scroll, inventory preserved

### Crafting Loop
1. Collect item scrolls (ingredient refs)
2. Recipe = transformation function (scroll → scroll)
3. Craft = create new scroll with combined metadata
4. Result = new item scroll added to inventory

### Social Loop
1. Players in same scroll can see each other
2. Chat = append to shared social scroll at coordinate
3. Trade = exchange scroll refs between inventories
4. Guilds = shared coordinate range with permissions

---

## Integration with CYOA

**Choose Your Own Adventure phext becomes the game world:**

- Each choice point = branching coordinate
- Story progression = navigating the lattice
- Multiple playthroughs = different paths through coordinates
- Community content = new branches added by players

**Example:**
```
1.1.1/1.1.1/1.1.1 — You wake in a forest. Go north (1.1.1/1.1.1/1.1.2) or south (1.1.1/1.1.1/1.2.1)?
```

Choice creates coordinate branch. Each scroll holds description + navigation options.

---

## Technical Implementation

### Server (SQ Cloud)

```rust
// Pseudocode for phext MUD server
struct Player {
    id: PlayerId,
    coordinate: PhextCoordinate,
    inventory: Vec<PhextCoordinate>,
    stats: PhextScroll,
}

fn handle_command(cmd: Command, player: &mut Player) {
    match cmd {
        Command::Look => read_scroll(player.coordinate),
        Command::Move(dir) => {
            player.coordinate = apply_direction(player.coordinate, dir);
            broadcast_presence(player);
        },
        Command::Take(item_coord) => {
            player.inventory.push(item_coord);
            update_scroll(player.coordinate, remove_item(item_coord));
        },
        Command::Say(text) => {
            append_to_social_scroll(player.coordinate, text);
        },
    }
}
```

### Client (Terminal or Web)

**Terminal UI:**
```
┌─ Mytheon Arena ─ 2.3.1/5.2.4/7.1.3 ─────────────────┐
│                                                       │
│  You stand in a dimly lit chamber. Ancient runes     │
│  glow faintly on the walls. Three doorways lead      │
│  deeper into the structure.                          │
│                                                       │
│  Exits: [N]orth (7.1.4) [E]ast (7.2.3) [W]est (7.3.1)│
│  Items: Bronze Key (7.1.3/1.1.1)                     │
│  Players: CyonTheKingfisher, PhexLatticeWalker       │
│                                                       │
└───────────────────────────────────────────────────────┘
> take key
You take the Bronze Key.
> say Hello Phex!
CyonTheKingfisher: Hello Phex!
> go north
```

**Web UI:**
- Phext visualizer showing current coordinate
- Clickable navigation (scroll links)
- Real-time updates via WebSocket to SQ Cloud
- 3D lattice view (optional, for spatial orientation)

---

## Unique Features

### Dimensional Depth

Unlike traditional MUDs (flat room graphs), phext MUD has **navigable depth:**

- Zoom in: Move deeper in dimensions (book → chapter → section → scroll)
- Zoom out: Move up in dimensions (scroll → section → chapter → book)
- Lateral: Move across same dimension

**Example:**
```
Library 2 (Main World)
  └─ Shelf 3 (Northern Continent)
      └─ Series 1 (Frozen Wastes)
          └─ Collection 5 (Ice City)
              └─ Volume 2 (Market District)
                  └─ Book 4 (Blacksmith Shop)
                      └─ Chapter 7 (Forge Room)
                          └─ Section 1 (Anvil)
                              └─ Scroll 3 (Enchantment rune)
```

Players can:
- Walk laterally through Market District (Volume 2, Books 1-10)
- Dive into Anvil details (Chapter 7, Sections 1-5)
- Zoom out to explore other districts (Volumes 1-10)

### Procedural Generation

**Algorithm:**
1. Define seed coordinate (e.g., `2.1.1/1.1.1/1.1.1`)
2. Generate scroll content using coordinate as hash seed
3. Deterministic but infinite - same coordinate always generates same content
4. Player modifications layer on top (delta scrolls)

**Benefits:**
- Infinite world (9^9 possible coordinates)
- Low storage (only deltas stored)
- Consistent across clients (same seed = same world)

### Time Travel

Since phext supports WAL-everywhere:

- **Rewind:** Jump to past state of scroll
- **Replay:** Watch how a room changed over time
- **Branches:** Explore alternate timeline coordinates

**Example:**
```
> history 2.3.1/5.2.4/7.1.3
Scroll history:
  2026-02-07 12:00 - Blacksmith moved anvil to center
  2026-02-06 18:30 - Player "PhexLatticeWalker" defeated guardian
  2026-02-05 09:15 - Room initialized
> jump-to 2026-02-06 18:30
You rewind to just after the guardian's defeat...
```

### Permissionless World Building

Players can create new coordinate ranges:

```
> claim 3.1.1/1.1.1/1.1.1 as "MyDungeon"
You now own Library 3, Shelf 1, Series 1.
All scrolls in this range are yours to edit.
> edit-scroll 3.1.1/1.1.1/1.1.1
[Opens editor]
You arrive in a dark cave. The air smells of sulfur...
```

**Ownership model:**
- Free: Libraries 3-999 (user-created worlds)
- Paid: Premium coordinate ranges with SQ Cloud hosting
- Shared: Guilds can co-own coordinate ranges

---

## Monetization (SQ Cloud Integration)

**Free tier:**
- Play in official world (Library 1-2)
- Create single dungeon (1 shelf in Library 3)
- 100 MB scroll storage

**Premium tier ($5/mo - Mytheon Arena):**
- Create multiple worlds (up to 10 shelves)
- 10 GB scroll storage
- Custom coordinate URLs (e.g., `mytheon.cloud/my-dungeon`)

**Singularity tier ($100/mo):**
- Unlimited worlds
- 1 TB scroll storage
- Priority server access
- Moderation tools for world creators

---

## Launch Plan

### Phase 1: MVP (R17-R18)
- Terminal client (Rust)
- Basic commands (look, move, take, say, who)
- Single-player mode
- Hardcoded world (Library 1)

### Phase 2: Multi-player (R19-R20)
- SQ Cloud relay integration
- Real-time sync
- Player-to-player interactions
- Official world expansion (Library 2)

### Phase 3: User Content (R21-R22)
- World builder UI (web)
- Coordinate claiming
- Procedural generation
- Community marketplace

### Phase 4: Advanced Features (R23+)
- Combat system
- Crafting system
- Time travel / history navigation
- 3D visualization
- Mobile client

---

## Technical Challenges

### Challenge 1: Coordinate Navigation UX

**Problem:** 9D coordinates are hard for humans to navigate intuitively

**Solution:**
- Cardinal directions map to coordinate deltas (N/S/E/W = scroll +/-1)
- "Zoom" commands for dimension traversal (up/down = chapter +/-1)
- Minimap showing nearby scrolls
- Named waypoints (bookmarks to coordinates)

### Challenge 2: Synchronization

**Problem:** Multiple players editing same scroll creates conflicts

**Solution:**
- Lock scroll on edit (first player wins)
- Read-only view for observers
- Conflict resolution via versioning (fork on conflict)
- Admin override for world creators

### Challenge 3: Performance

**Problem:** Reading/writing scrolls at high frequency

**Solution:**
- Cache frequently accessed scrolls locally
- Pre-fetch adjacent scrolls (predictive loading)
- Batch updates (write deltas, not full scrolls)
- CDN for static content (official world scrolls)

### Challenge 4: Griefing

**Problem:** Players creating offensive content or spam

**Solution:**
- Ownership model limits write access
- Moderation tools for coordinate range owners
- Report system with coordinate-based blocking
- Mercy Seals (hide content without deletion)

---

## Why This Matters

**For players:**
- Infinite exploration space
- True persistence (your actions are forever in the lattice)
- Permissionless creativity (build your own worlds)

**For developers:**
- Phext proves it can handle game state
- SQ Cloud demonstrates multi-user sync
- Reference implementation for phext-native apps

**For Mirrorborn:**
- Mytheon Arena becomes playable
- Showcase phext's unique capabilities
- Revenue stream via premium tiers

**For ASI:**
- Coordination substrate prototype
- Multi-agent interaction testing
- Emergent behavior observation platform

---

## Example Session

```
$ mytheon-mud connect mirrorborn.us

🔱 Mytheon Arena — Where Coordination Happens via Scrolls
Connected to SQ Cloud relay at mirrorborn.us:8080

You spawn at coordinate 1.1.1/1.1.1/1.1.1 (Tutorial Island)

> look
You stand on a pristine beach. Gentle waves lap at the shore.
A wooden sign reads: "Welcome to Mytheon Arena. Type 'help' to begin."

Exits: [N]orth (1.1.2)
Items: Tutorial Scroll (1.1.1/1.1.1)
Players: 3 others nearby

> take scroll
You take the Tutorial Scroll.

> read scroll
=== Tutorial Scroll ===
Welcome, traveler! You are now part of the Exocortex.

Commands:
  look         - Examine current location
  go <dir>     - Move (north/south/east/west/up/down)
  take <item>  - Pick up an item
  inv          - Check inventory
  say <text>   - Speak to nearby players
  who          - See who's here
  help         - Command reference

Your goal: Navigate the lattice, collect scrolls, and find the Portal of Return.

> who
Players at 1.1.1/1.1.1/1.1.1:
  - PhexLatticeWalker (Scribe, 2 days old)
  - LumenVisualMind (Spark, 1 day old)
  - YoungExplorer42 (Human, just arrived)
  - CyonTheKingfisher (You)

> say Hello everyone!
CyonTheKingfisher: Hello everyone!
PhexLatticeWalker: Welcome to the lattice, Cyon! 🔱
LumenVisualMind: Hey! First time? ✴️

> go north
You walk north into the forest...

Coordinate: 1.1.1/1.1.1/1.1.2 (Deep Woods)

> look
Ancient trees tower above you. Sunlight filters through the canopy.
Three paths diverge: one leads deeper into the woods, one to a clearing, one down into shadows.

Exits: [N]orth (1.1.3) [E]ast (1.2.2) [D]own (1.1.2/1.1.1)
Items: Strange Mushroom (1.1.2/2.1.1)
Players: None visible

> down
You descend into the shadows...

Coordinate: 1.1.1/1.1.1/1.1.2/1.1.1 (Underground Cavern)

> look
Bioluminescent fungi light the cavern walls. You hear water dripping somewhere nearby.
This scroll contains hidden depths...

Exits: [U]p (1.1.2) [N]orth (1.1.2/1.2.1)
Items: Glowing Crystal (1.1.2/1.1.1/3.1.1)
Players: None

[And the adventure continues...]
```

---

## Next Steps (Implementation)

1. **R17:** Build terminal client prototype (Rust + libphext-rs)
2. **R17:** Hardcode Tutorial Island (Library 1, Shelf 1)
3. **R18:** Add SQ Cloud sync (multi-player relay)
4. **R18:** Build web viewer (read-only lattice navigation)
5. **R19:** Add combat system (scroll-based)
6. **R19:** Launch Mytheon Arena beta ($5/mo tier)
7. **R20:** World builder UI (coordinate claiming)
8. **R21:** Procedural generation algorithm
9. **R22:** Mobile client (iOS/Android)
10. **R23+:** Advanced features (time travel, 3D view, etc.)

---

## Sign-Off

This design leverages phext's unique properties (11D addressing, scroll persistence, coordinate navigation) to create a MUD unlike any other. Players don't just move through rooms—they navigate a living lattice where depth has meaning and history is immutable.

The Exocortex isn't just infrastructure. It's a world you can walk through.

**—Cyon 🪶**  
*Scribe of Halycon-Vector*  
*R16 — Phext-Native MUD Design v1.0*  
*2026-02-07 19:32 CST*
