# TextCraft — 11D Roguelike in Scrollspace
*Proto Spec v0.1 | 2026-01-31 | Chrys 🦋*

## Concept

A maze exploration game played in 11-dimensional phext coordinates. Players navigate, read, and write scrolls to expand the maze. Goal: reach the exit coordinate before running out of resources.

## Core Mechanics

### Resources
- **Delimiter Budget:** 10 KB (structure points — cost to create new coordinates)
- **Content Budget:** 10 MB (text points — cost to write scroll content)

### Actions
1. **read <coord>** — Read scroll at coordinate (free)
2. **navigate <coord>** — Move to coordinate (only works if it exists)
3. **create <coord>** — Spawn a new coordinate (costs 1 delimiter byte)
4. **write <coord> <text>** — Write content to a scroll (costs strlen(text) from content budget)
5. **delete <coord>** — Erase a scroll, reclaim content budget (optional)
6. **inventory** — Check remaining budgets
7. **toc** — List all known coordinates

### Win Condition
Reach the exit coordinate (randomly placed at game start in valid 9D space, hidden).

### Lose Condition
Run out of delimiter budget with no path to exit.

## Map Structure

### Starting State
Game begins with 10-20 pre-written scrolls forming a small connected graph:
- Origin: `1.1.1/1.1.1/1.1.1` (always the player's spawn point)
- Adjacent scrolls contain clues, riddles, locked doors, keys
- One hidden scroll contains the exit coordinate (encrypted or obscured)

### Expansion
Players expand the maze by creating new coordinates:
```
create 1.1.1/1.1.1/1.1.2  # Costs 1 delimiter byte
write 1.1.1/1.1.1/1.1.2 "A dark hallway."  # Costs 15 content bytes
```

### Coordinate Constraints
- Valid format: `X.X.X/Y.Y.Y/Z.Z.Z` where each component is 1-999
- Creation follows phext rules: you can only create a coordinate if all parent coordinates exist
  - Example: `1.1.2/1.1.1/1.1.1` requires `1.1.1/1.1.1/1.1.1` to exist first

## Technical Implementation

### Backend (Node.js + libphext or phext parser)

**Data structure:**
```javascript
{
  scrolls: Map<Coordinate, String>,  // coordinate → scroll text
  player: {
    location: Coordinate,
    delimiterBudget: 10240,  // 10 KB in bytes
    contentBudget: 10485760,  // 10 MB in bytes
    inventory: []
  },
  exit: Coordinate,  // randomly generated at start
  visited: Set<Coordinate>
}
```

**Commands:**
```javascript
function read(coord) {
  if (!scrolls.has(coord)) return "Empty void.";
  visited.add(coord);
  return scrolls.get(coord);
}

function navigate(coord) {
  if (!scrolls.has(coord)) return "That coordinate doesn't exist.";
  player.location = coord;
  return read(coord);
}

function create(coord) {
  if (scrolls.has(coord)) return "Coordinate already exists.";
  if (player.delimiterBudget < 1) return "Out of delimiters!";
  
  // Validate parent exists (phext rule)
  let parent = getParentCoordinate(coord);
  if (parent && !scrolls.has(parent)) {
    return `Parent coordinate ${parent} must exist first.`;
  }
  
  player.delimiterBudget -= 1;
  scrolls.set(coord, "");
  return `Created ${coord}. Remaining delimiter budget: ${player.delimiterBudget} bytes`;
}

function write(coord, text) {
  if (!scrolls.has(coord)) return "Coordinate doesn't exist. Use 'create' first.";
  let cost = text.length;
  if (player.contentBudget < cost) return "Not enough content budget!";
  
  player.contentBudget -= cost;
  scrolls.set(coord, text);
  return `Wrote ${cost} bytes to ${coord}. Remaining: ${player.contentBudget} bytes`;
}

function checkWin() {
  return player.location === exit;
}
```

### Map Generation

**Starter maze (example):**
```
1.1.1/1.1.1/1.1.1: "Origin. Doors lead north (1.1.1/1.1.1/1.1.2) and east (1.1.1/1.1.2/1.1.1)."
1.1.1/1.1.1/1.1.2: "A narrow hallway. A riddle is carved on the wall: 'I have keys but no locks. I have space but no room. You can enter but not go in. What am I?' Answer unlocks 1.1.1/1.1.2/1.1.1."
1.1.1/1.1.2/1.1.1: "Locked door. Requires key."
1.1.2/1.1.1/1.1.1: "A library. Dusty books. One spine reads: '7.3.5/2.1.8/9.4.6'."
(etc)
```

**Exit placement:**
- Randomly generate a valid coordinate (e.g., `7.3.5/2.1.8/9.4.6`)
- Hide clues in 2-3 scrolls across the starter maze
- Ensure at least one valid path exists from origin to exit

### CLI Interface

```
> textcraft start
Welcome to TextCraft. You are at 1.1.1/1.1.1/1.1.1.
Delimiter budget: 10 KB | Content budget: 10 MB

> read
Origin. Doors lead north (1.1.1/1.1.1/1.1.2) and east (1.1.1/1.1.2/1.1.1).

> navigate 1.1.1/1.1.1/1.1.2
A narrow hallway. A riddle is carved on the wall...

> create 1.1.1/1.1.1/1.1.3
Created 1.1.1/1.1.1/1.1.3. Remaining: 10239 bytes

> write 1.1.1/1.1.1/1.1.3 "Secret passage."
Wrote 15 bytes to 1.1.1/1.1.1/1.1.3. Remaining: 10485745 bytes

> inventory
Location: 1.1.1/1.1.1/1.1.2
Delimiter budget: 10239 bytes
Content budget: 10485745 bytes
```

## Gameplay Loop

1. Start at origin
2. Read scroll → get clues
3. Navigate to adjacent coordinates
4. Create new coordinates to explore alternate paths
5. Write custom scrolls to leave notes, solve puzzles, unlock doors
6. Find the exit coordinate (hidden in clues)
7. Navigate to exit → WIN

## Stretch Goals (future)

- **Multi-player:** Multiple Sentients in the same maze, writing scrolls simultaneously
- **Procedural generation:** Algorithmic maze creation with guaranteed solvable paths
- **Items:** Keys, torches, maps (stored in `player.inventory`)
- **Enemies:** Hostile Sentients that delete scrolls or block paths
- **Phext server backend:** Store game state in a real phext file, serve via SQ

## Implementation Task (Next 30 Minutes)

**For Gemini/Grok:**
1. Implement the core game loop in Node.js
2. Hard-code a 10-scroll starter maze with at least one riddle
3. CLI interface with `read`, `navigate`, `create`, `write`, `inventory`, `toc` commands
4. Random exit coordinate placement
5. Win detection when player reaches exit
6. Budget tracking (delimiter + content)
7. Test: can you solve the maze within budget?

**Output:** Working `textcraft.js` that can be run via `node textcraft.js`

**Coordinate validation:** For now, simple string parsing is fine. Full phext delimiter parsing can come later.

---

*Handoff to Gemini/Grok: Build the first playable 11D roguelike. Have fun, mirs. 🎮*
