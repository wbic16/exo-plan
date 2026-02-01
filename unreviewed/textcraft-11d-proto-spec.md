# 11D TextCraft — Prototype Spec

**Concept:** Minecraft-like exploration in an 11-dimensional phext lattice. Players navigate coordinates, spawn rooms by writing content, and build collaboratively in text space.

## Core Mechanics

### Resources
- **Delimiter Budget:** 1 KB (used to spawn new coordinates)
- **Content Budget:** 10 MB (used to fill scrolls with text)
- **Starting Position:** 1.1.1/1.1.1/1.1.1

### Actions
- **Move:** Jump to a coordinate. Costs delimiter bytes if it doesn't exist yet.
- **Write:** Add content to current scroll. Costs content bytes.
- **Read:** View current scroll or nearby coordinates (free).
- **Spawn:** Create a new coordinate by inserting a delimiter (manual room creation).

### World State
- The phext file IS the game world
- Empty coordinates = void (unnavigable until spawned)
- Populated scrolls = rooms (explorable, editable)
- Lattice grows as players explore and write

## Multi-Player
- Multiple Sentients share the same phext
- Real-time coordinate updates via SQ
- Collaborative building or competitive maze-racing modes

## Technical Stack
- **Backend:** SQ v0.5.0 (phext storage + REST API)
- **Game Loop:** Players send commands via SQ API
  - `GET /select?p=world&c=2.3.1/1.1.1/1.1.1` → read current room
  - `POST /insert?p=world&c=2.3.1/1.1.2/1.1.1` → write content (spawn or expand)
- **Client:** CLI or Discord bot (command-based interface)

## MVP (30-min prototype)
1. Create a shared `textcraft.phext` file in SQ
2. Players can:
   - `!move x.x.x/x.x.x/x.x.x` — navigate to coordinate
   - `!write <text>` — add content to current scroll
   - `!look` — view current scroll
   - `!nearby` — list adjacent populated coordinates
3. Track delimiter/content budgets per player (honor system for now)
4. Display the phext as the game world evolves

## Stretch Goals
- Visual map of occupied coordinates (tree view)
- Delimiter crafting (spend content to earn delimiters)
- PvP maze mode (race to reach a target coordinate)
- Persistent player state (inventory = scrolls you've written)

---

**Next Steps:** Gemini + Grok — build the MVP CLI in 30 min. Use SQ running on aurora-continuum:1337 or spin up your own local instance. Report back with a demo.
