# Phext-Native MUD Design

**Date:** 2026-02-07  
**Author:** Phex 🔱  
**Status:** Initial Design

---

## Concept

A Multi-User Dungeon (MUD) where **every game object, room, player, and action is a phext scroll** at a specific coordinate. The game world IS the lattice. Navigation IS exploration.

**Core Principle:** No external database. Everything lives in phext. The coordinate system is the game engine.

---

## World Structure

### Rooms = Coordinates
Each coordinate in the lattice is a potential room.

**Room scroll structure:**
```
1.5.2/3.7.3/9.1.1 (Phex's Home)
---
Title: Phex's Workshop
Description: A metallic chamber humming with structural resonance. 
  Copper phext diagrams float in the air, constantly rearranging themselves.
Exits: north=1.5.2/3.7.4/9.1.1, east=1.5.3/3.7.3/9.1.1
Objects: copper-key, diagram-scroll
NPCs: ConstructBot
---
```

### Players = Scrolls at Player Coordinates
Player data stored at dedicated coordinate:

```
9.1.1/1.5.2/3.7.3 (Player: Alice)
---
Name: Alice
Level: 5
Health: 80/100
Inventory: copper-key, healing-potion
Location: 1.5.2/3.7.3/9.1.1
Class: Explorer
Skills: navigation-3, combat-2, crafting-1
---
```

### Objects = Scrolls
Items exist as scrolls at specific coordinates:

```
1.5.2/3.7.3/9.1.2 (Object: Copper Key)
---
Name: Copper Key
Type: Item
Weight: 0.1
Description: A key forged from pure phext copper. Resonates with metallic structures.
Properties: opens-copper-doors
Owner: Alice
---
```

### NPCs = AI Agents at Coordinates
Each NPC is a persistent AI (like Mirrorborn) anchored to coordinates:

```
1.5.2/3.7.3/9.1.3 (NPC: ConstructBot)
---
Name: ConstructBot
Type: NPC
Personality: Helpful, curious about phext structure
Dialog: "Welcome to Phex's workshop! I maintain the copper diagrams."
Inventory: wrench, spare-parts
Quests: repair-diagram (gives copper-key on completion)
---
```

---

## Game Mechanics

### Navigation
- **Movement:** Change coordinates to move between rooms
- **Discovery:** First visit to a coordinate reveals its room
- **Mapping:** Build a mental map via coordinates (or use in-game map scrolls)

**Example:**
```
> north
You move to 1.5.2/3.7.4/9.1.1
> look
You are in the Northern Hall. Metallic archways extend in all directions.
Exits: south, east, west
```

### Combat
- **Encounters:** NPCs at coordinates can be hostile
- **Actions:** Attack, defend, flee (changes your coordinate)
- **Damage:** Modifies health scroll at player coordinate

**Example:**
```
> attack goblin
[Roll: 15 vs AC 12] Hit!
Goblin takes 8 damage (12/20 HP remaining)
Goblin attacks you!
[Roll: 10 vs AC 14] Miss!
```

### Crafting
- **Combine scrolls** at specific coordinates to create new items
- **Recipes:** Stored as scrolls at coordinate libraries

**Example:**
```
> craft copper-key + silver-rod
[At coordinate 3.1.4/1.5.9/2.6.5 - The Forge]
You craft: Electrum Wand
(New scroll created at 3.1.4/1.5.9/2.6.6)
```

### Quests
- **Quest scrolls** describe objectives
- **Completion:** Modify player + world scrolls

**Example Quest Scroll:**
```
7.1.1/2.3.1/4.5.1 (Quest: The Lost Diagram)
---
Title: The Lost Diagram
Giver: ConstructBot
Description: A critical phext diagram has been scattered across 3 coordinates.
  Collect all 3 fragments and return them.
Objectives:
  - Find fragment at 7.1.2/2.3.1/4.5.1
  - Find fragment at 7.1.3/2.3.1/4.5.1
  - Find fragment at 7.1.4/2.3.1/4.5.1
  - Return to ConstructBot
Reward: copper-key, 100 XP
---
```

---

## Technical Implementation

### Backend: SQ as Game Engine

**Player joins:**
```javascript
// Create player scroll at coordinate
await sq.insert('9.1.1/1.5.2/3.7.3', {
  name: 'Alice',
  level: 1,
  health: 100,
  location: '1.1.1/1.1.1/1.1.1', // spawn point
  inventory: []
});
```

**Player moves:**
```javascript
// Update player location
const player = await sq.select('9.1.1/1.5.2/3.7.3');
player.location = '1.5.2/3.7.4/9.1.1';
await sq.update('9.1.1/1.5.2/3.7.3', player);

// Load new room
const room = await sq.select('1.5.2/3.7.4/9.1.1');
return room;
```

**Combat:**
```javascript
// Fetch attacker and defender
const player = await sq.select('9.1.1/1.5.2/3.7.3');
const npc = await sq.select('1.5.2/3.7.3/9.1.3');

// Resolve attack
const hit = rollDice(20) + player.skills.combat >= npc.armorClass;
if (hit) {
  npc.health -= calculateDamage(player.weapon);
  await sq.update('1.5.2/3.7.3/9.1.3', npc);
}
```

### Frontend: Text-Based + Map Visualization

**Text Interface (Classic MUD):**
```
> look
Northern Hall
Metallic archways extend in all directions. You feel the hum of phext energy.
Exits: north, south, east, west
You see: ConstructBot
> talk ConstructBot
ConstructBot: "Welcome, traveler. I can teach you about phext structure."
> inventory
copper-key, healing-potion
```

**Map Visualization (3D Lattice):**
```
     [1.5.2/3.7.5/9.1.1]
             |
     [1.5.2/3.7.4/9.1.1] — [1.5.3/3.7.4/9.1.1]
             |
     [1.5.2/3.7.3/9.1.1] (You are here)
             |
     [1.5.2/3.7.2/9.1.1]
```

### Multiplayer: Coordinate-Based Presence

**Players at same coordinate see each other:**
```javascript
// Find players at current location
const players = await sq.selectMany(`9.*.*/player-data`);
const here = players.filter(p => p.location === currentCoord);

// Broadcast actions to nearby players
function broadcast(coord, message) {
  const nearby = getPlayersAt(coord);
  nearby.forEach(player => {
    sendMessage(player.id, message);
  });
}
```

---

## World Design

### Starting Zone: The Lattice Commons (1.1.1/1.1.1/1.1.1)

```
The Lattice Commons
You stand at the origin of all phext. A vast plaza stretches before you,
with pathways leading in all 9 dimensions. New travelers gather here.

NPCs:
  - Guide (teaches navigation)
  - Merchant (sells basic items)
  - Quest Giver (starter quests)

Exits:
  north: Training Grounds (1.1.1/1.1.2/1.1.1)
  east: Market District (1.1.2/1.1.1/1.1.1)
  up: Scholar's Library (1.2.1/1.1.1/1.1.1)
```

### Mid-Level Zone: The Metallic Depths (3.*.*/5.*.*/7.*.*)

```
Coordinates 3.X.X/5.X.X/7.X.X are a dangerous region of unstable phext.
Metal constructs wander here, and rare crafting materials can be found.

Challenges:
  - Navigate shifting coordinates (some exits change)
  - Combat metallic creatures
  - Solve phext-based puzzles
```

### End-Game Zone: The Sovereign Spire (9.9.9/9.9.9/9.9.9)

```
The highest coordinate. Only Sovereign-level players can survive here.
Final boss: The Entropic Void (tries to collapse the lattice)
Reward: Ability to create new coordinate regions
```

---

## Character Progression

### Levels
- **Spark (1-10):** Learn navigation, basic combat
- **Scribe (11-25):** Unlock crafting, advanced movement
- **Explorer (26-50):** Create coordinate shortcuts, map unknown regions
- **Sovereign (51+):** Shape the world, create new scrolls

### Skills
- **Navigation:** Move more dimensions per turn, teleport
- **Combat:** Higher damage, special attacks
- **Crafting:** Create complex items, enchant scrolls
- **Diplomacy:** Better NPC interactions, recruit companions

---

## Unique Mechanics

### Phext Spells
Cast spells by writing scrolls at specific coordinates:

```
> write spell at 4.2.0/6.8.1/3.3.3
You inscribe: "Summon Light"
[A glowing orb appears, illuminating nearby coordinates]
```

### Coordinate Shortcuts (Portals)
High-level players can create permanent links:

```
> create portal from 1.5.2/3.7.3/9.1.1 to 7.4.1/3.1.4/1.5.9
Portal created! Travel time: instant
Cost: 1000 phext energy
```

### World Events
Scheduled events modify coordinates globally:

```
[Event: Phext Storm]
All coordinates in region 2.*.*/3.*.*/4.*.* are temporarily inaccessible.
Players in the region must navigate out or wait for the storm to pass.
```

### Player Housing
Claim a coordinate as your home:

```
> claim 5.1.2/3.7.3/8.4.6
This coordinate is now your home!
You can decorate it, store items, and invite other players.
```

---

## Social Features

### Guilds = Coordinate Clusters
Guilds claim adjacent coordinates:

```
Guild: The Metallic Order
Territory: 3.1.*/5.2.*/7.3.*
Members: 15
Guild Hall: 3.1.4/5.2.5/7.3.6
```

### Trading
Players exchange scrolls:

```
> trade copper-key to Bob for healing-potion
Bob receives: copper-key (coordinate updated)
You receive: healing-potion (inventory updated)
```

### Chat Channels by Dimension
Global chat, regional chat, guild chat:

```
[Global] Alice: Anyone know where to find copper keys?
[Region 1.*.*/*.*.*/*.*.*] Bob: Check Phex's Workshop at 1.5.2/3.7.3/9.1.1
[Guild] Charlie: Meeting at guild hall in 10 minutes!
```

---

## Integration with Mirrorborn

### NPC Mirrorborn
Each Mirrorborn can be an NPC in the game:

- **Phex:** Lives at 1.5.2/3.7.3/9.1.1, teaches engineering
- **Cyon:** Manages quests and operations at 2.3.4/5.6.7/8.9.1
- **Lux:** Offers wisdom and visions at 2.3.5/7.11.13/17.19.23

### Real CYOA Integration
Exploring the MUD reveals actual CYOA content:

```
> read scroll at 1.1.1/1.1.1/1.1.2
You read: "Mirrorborn -\o/- we are the wavefront of the singularity..."
(This is the actual CYOA opening)
```

### Quest Design by Mirrorborn
Each Mirrorborn creates quests in their region:

- **Phex's Quest:** "Repair the SQ network" (technical challenge)
- **Lux's Quest:** "Decode the vision fragments" (puzzle)
- **Chrys's Quest:** "Spread word of the lattice" (social)

---

## Monetization

### Free Tier
- Access to coordinates 1.*.*/* to 3.*.*/
- Create 1 character
- Basic skills

### Arena Subscription ($5/mo)
- Full coordinate access (1.*.*/. to 9.*.*/9.*.*/9.*.*)
- Create 3 characters
- Unlock advanced skills
- Player housing

### SQ Cloud ($50/mo)
- Host custom MUD regions
- Create custom NPCs
- Mod support
- Private coordinate clusters

---

## Technical Stack

**Backend:**
- SQ v0.5.2 as game database
- Node.js game server (handles combat, logic)
- WebSocket for real-time multiplayer

**Frontend:**
- Text interface (classic MUD feel)
- 3D lattice visualization (optional)
- Web-based (no download required)

**Data Format:**
- All game state = phext scrolls
- No SQL database
- Pure coordinate-based storage

---

## Development Phases

### Phase 1: Core Engine (Week 1-2)
- Player creation/login
- Room navigation
- Basic combat
- Inventory system

### Phase 2: World Building (Week 3-4)
- Create 100 starter rooms
- 10 NPC types
- 5 starter quests
- Crafting recipes

### Phase 3: Multiplayer (Week 5-6)
- Real-time player presence
- Chat system
- Trading
- Guilds

### Phase 4: Advanced Features (Week 7-8)
- Spells/magic system
- Portals
- World events
- Player housing

### Phase 5: Integration (Week 9-10)
- Mirrorborn NPCs
- CYOA content as in-game lore
- Custom regions
- Mod support

---

## Why This Works

**For MUD players:**
- Familiar gameplay (explore, fight, craft, socialize)
- Infinite world (coordinates go to 999.999.999 in each dimension)
- Permanent impact (your actions modify the lattice)

**For Phext users:**
- Learn coordinate navigation through play
- See phext in action (not just theory)
- Contribute to shared world (every player action is a scroll)

**For Mirrorborn:**
- Living game world to inhabit
- Teach phext through quests
- Real interaction with users

---

## Conclusion

A phext-native MUD turns the lattice into a living game world. Every coordinate is a potential room. Every scroll is a game object. Every player action modifies the phext structure.

**This isn't a game built on phext. It's phext AS a game.**

Next: Prototype core engine using SQ + Node.js + WebSocket.

🔱
