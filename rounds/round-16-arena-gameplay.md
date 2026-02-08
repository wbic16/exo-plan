# R16 Arena Gameplay Mechanics

**Date:** 2026-02-07  
**Owner:** Cyon 🪶 + Splinter 🌀 (implementation)  
**Spec by:** Phex 🔱  
**Status:** Ready for prototyping

---

## Vision

> "Geocities meets Neopets meets Minecraft meets Myst, but in 11D space"

Mytheon Arena isn't a chat room. It's not a forum. It's an **explorable lattice** where players navigate CYOA, create artifacts (scrolls), discover each other's work, and progress through maturation levels.

**Core Loop:**
1. **Navigate** the 11D lattice (explore CYOA by coordinate)
2. **Discover** scrolls written by others
3. **Create** your own scrolls at chosen coordinates
4. **Progress** from Spark → Scribe → Explorer → Sovereign
5. **Connect** with players exploring nearby coordinates

---

## Inspirations Applied

### Geocities: User-Created Spaces
- Each coordinate can be "claimed" by a player
- Claimed coordinates become player "sites" (decorated, organized)
- Browsing the lattice = exploring others' sites
- No gatekeeping—anyone can build anywhere

### Neopets: Daily Activities & Progression
- Daily scroll challenge ("Write at coordinate X.X.X today")
- Daily exploration quest ("Find the scroll at Y.Y.Y")
- Item/artifact collection (rare scrolls, special coordinates)
- "Neofriends" = players exploring similar coordinates

### Minecraft: Building & Emergent Play
- No prescribed goals—build what interests you
- Scrolls as "blocks" (basic building unit)
- Coordinate linking creates structures (multi-scroll narratives)
- Redstone equivalent = coordinate math (portals, shortcuts)

### Myst: Mystery & Narrative Exploration
- CYOA contains hidden lore (already exists)
- Puzzle scrolls (riddles leading to new coordinates)
- Age-like "realms" (major coordinate regions with themes)
- Linking books = coordinate shortcuts players create

---

## Core Mechanics

### 1. Navigation System

**The Lattice View**

```
┌─────────────────────────────────────────────┐
│  Current Position: 1.5.2/3.7.3/9.1.1       │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                             │
│    ⬆️ Library  ⬇️         (Dimension 1)     │
│    ⬆️ Shelf    ⬇️         (Dimension 2)     │
│    ⬆️ Series   ⬇️         (Dimension 3)     │
│                                             │
│  ╔═══════════════════════════════════════╗ │
│  ║  What's here:                         ║ │
│  ║  • "curl" (Will's scroll)             ║ │
│  ║  • Phex's first coordinate (mine!)    ║ │
│  ║  • 12 other scrolls...                ║ │
│  ╚═══════════════════════════════════════╝ │
│                                             │
│  [ Read ] [ Create Scroll ] [ Jump To... ] │
└─────────────────────────────────────────────┘
```

**Controls:**
- Arrow keys / WASD: Navigate dimensions
- Jump To: Enter specific coordinate
- Bookmark: Save coordinate for quick return
- Portal: Create shortcut link (unlocked at Explorer level)

**Navigation Modes:**
1. **Step Mode:** Move one unit at a time (precise)
2. **Leap Mode:** Jump 10 units (fast exploration)
3. **Warp Mode:** Jump to any saved bookmark (instant)

### 2. Scroll Creation

**Writing a Scroll:**

```
┌─────────────────────────────────────────────┐
│  Create Scroll at 1.5.2/3.7.3/9.1.1        │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                             │
│  Title: ____________________________        │
│                                             │
│  Content:                                   │
│  ┌─────────────────────────────────────┐  │
│  │                                     │  │
│  │  (markdown editor)                  │  │
│  │                                     │  │
│  │                                     │  │
│  └─────────────────────────────────────┘  │
│                                             │
│  Tags: #navigation #tutorial #phext        │
│                                             │
│  Visibility: ○ Public  ○ Friends  ○ Private│
│                                             │
│  [ Preview ] [ Save ] [ Cancel ]           │
└─────────────────────────────────────────────┘
```

**Scroll Properties:**
- **Coordinate:** Where it lives (permanent)
- **Author:** Who wrote it
- **Timestamp:** When created
- **Links:** Coordinates this scroll references
- **Tags:** Searchable metadata
- **Visibility:** Access control

**Scroll Types:**
- **Standard:** Regular text (markdown)
- **Portal:** Links to another coordinate
- **Quest:** Contains challenge/puzzle
- **Lore:** Contributes to CYOA narrative
- **Code:** Executable phext (advanced)

### 3. Discovery & Exploration

**Finding Scrolls:**

1. **Navigate nearby** (browse current coordinate region)
2. **Follow links** (scrolls reference other scrolls)
3. **Search** (by tag, author, content)
4. **Daily Quest** (game suggests coordinates to visit)
5. **Trending** (popular coordinates this week)

**Discovery Rewards:**
- First to find a scroll → badge
- Find all scrolls in a region → achievement
- Follow a coordinate chain → unlock lore

### 4. Progression System

**Maturation Levels:**

| Level | Name | Requirements | Abilities |
|-------|------|--------------|-----------|
| 1 | **Spark** | Start here | Read, navigate (step mode) |
| 2 | **Scribe** | Write 10 scrolls | Create scrolls, tags, leap mode |
| 3 | **Explorer** | Visit 100 coordinates | Create portals, private scrolls |
| 4 | **Sovereign** | Write 100 scrolls + visit 1000 coords | Warp mode, quest creation |

**Complexity Classes (Orthogonal to Levels):**

Intelligence profiles (not scores) affect UI depth:
- **Simple:** Clean UI, clear prompts, guided exploration
- **Intermediate:** More options, customization
- **Advanced:** Full lattice math, coordinate scripting, API access

**Unlockables:**
- Custom coordinate bookmarks
- Profile themes
- Special scroll types (quest, code)
- Dimension shortcuts
- Private coordinate regions

### 5. Social / Coordination Mechanics

**Finding Other Players:**

- **Nearby:** See players at similar coordinates
- **Following:** Track specific players' new scrolls
- **Guilds:** Groups exploring specific coordinate regions
- **Coordinate Rings:** Shared bookmark sets (collaborative exploration)

**Matchmaking Based on Triangles:**

Remember from coordinate signup, users have 3 coordinates (Home, Aspiration, Lineage). Arena uses these to suggest connections:

- Players with overlapping triangles see each other more often
- Daily quest coordinates influenced by your triangle
- Guild discovery based on triangle alignment

**Collaboration:**
- Co-authored scrolls (multiple writers, one coordinate)
- Coordinate expeditions (group explores together)
- Scroll chains (linked narrative across coordinates)

---

## Technical Implementation

### Frontend: React + Three.js

**3D Lattice Visualization (Optional "Advanced Mode"):**

```javascript
import * as THREE from 'three';

const LatticeMesh = ({ currentCoord, nearbyScrolls }) => {
  // Render 9D lattice in 3D projection
  // Each scroll = glowing point
  // Player position = bright vertex
  // Movement = smooth camera transition
  
  return (
    <Canvas>
      <ambientLight intensity={0.5} />
      <pointLight position={[10, 10, 10]} />
      {nearbyScrolls.map(scroll => (
        <ScrollPoint 
          key={scroll.id} 
          position={projectTo3D(scroll.coordinate)} 
          color={scroll.author === 'you' ? 'cyan' : 'white'}
        />
      ))}
      <PlayerMarker position={projectTo3D(currentCoord)} />
    </Canvas>
  );
};
```

**2D Interface (Default "Simple Mode"):**

```javascript
const LatticeView = ({ coordinate, scrolls, onNavigate, onCreate }) => {
  return (
    <div className="lattice-view">
      <CoordinateDisplay coord={coordinate} />
      <NavigationControls onNavigate={onNavigate} />
      <ScrollList scrolls={scrolls} />
      <ActionBar onCreate={onCreate} />
    </div>
  );
};
```

### Backend: Node.js + SQ

**API Endpoints:**

```javascript
// GET /arena/coordinate/:coord
// Returns scrolls at specific coordinate
app.get('/arena/coordinate/:coord', async (req, res) => {
  const scrolls = await sq.select(req.params.coord);
  res.json({ coordinate: req.params.coord, scrolls });
});

// POST /arena/scroll
// Create new scroll at coordinate
app.post('/arena/scroll', authenticate, async (req, res) => {
  const { coordinate, title, content, tags } = req.body;
  await sq.insert(coordinate, { title, content, tags, author: req.user.id });
  res.json({ success: true });
});

// GET /arena/nearby/:coord?radius=5
// Return scrolls within N dimensions of coord
app.get('/arena/nearby/:coord', async (req, res) => {
  const { coord } = req.params;
  const radius = parseInt(req.query.radius) || 5;
  const nearby = await findNearbyScrolls(coord, radius);
  res.json({ scrolls: nearby });
});

// GET /arena/player/:userId/progress
// Return player stats, level, unlocks
app.get('/arena/player/:userId/progress', async (req, res) => {
  const player = await getPlayerProgress(req.params.userId);
  res.json(player);
});
```

**Database Schema:**

```sql
CREATE TABLE arena_scrolls (
  id TEXT PRIMARY KEY,
  coordinate TEXT NOT NULL,
  author_id TEXT NOT NULL,
  title TEXT,
  content TEXT,
  tags TEXT,  -- JSON array
  visibility TEXT DEFAULT 'public',  -- public/friends/private
  created_at INTEGER,
  updated_at INTEGER
);

CREATE TABLE arena_players (
  user_id TEXT PRIMARY KEY,
  level INTEGER DEFAULT 1,  -- 1=Spark, 2=Scribe, 3=Explorer, 4=Sovereign
  scrolls_written INTEGER DEFAULT 0,
  coordinates_visited INTEGER DEFAULT 0,
  current_coordinate TEXT,
  home_coordinate TEXT,
  aspiration_coordinate TEXT,
  lineage_coordinate TEXT,
  bookmarks TEXT,  -- JSON array of coordinates
  achievements TEXT  -- JSON array
);

CREATE TABLE arena_visits (
  user_id TEXT,
  coordinate TEXT,
  visited_at INTEGER,
  PRIMARY KEY (user_id, coordinate)
);
```

---

## Daily Activities (Neopets-Inspired)

### 1. Daily Scroll Challenge
**Every day at midnight CST:**
- System picks a random coordinate
- Challenge: "Write a scroll at X.X.X/Y.Y.Y/Z.Z.Z today"
- Reward: Bonus progression points, special badge

### 2. Treasure Hunt
**Weekly quest:**
- Hidden scroll placed at secret coordinate
- Clues released gradually
- First to find it gets rare achievement

### 3. Coordinate of the Day
**Featured location:**
- One coordinate highlighted daily
- Extra visibility for scrolls there
- Community discusses theme

### 4. Guild Expeditions
**Collaborative events:**
- Guild chooses coordinate region to explore
- Members write scrolls, map the area
- Completion unlocks guild achievements

---

## Monetization Integration

### Free Tier
- Navigate & read (unlimited)
- Write 10 scrolls/month
- Spark & Scribe levels only
- Public scrolls only

### Arena Subscription ($5/mo)
- Unlimited scroll writing
- All maturation levels (up to Sovereign)
- Private scrolls
- Custom bookmarks (unlimited)
- Guild creation

### Singularity ($100/mo)
- All Arena features
- Priority quest access
- Custom coordinate themes
- API access for scripting

---

## Launch Plan

### Phase 1: Read-Only Arena (Week 1)
- Navigate CYOA by coordinate
- See existing scrolls (CYOA content)
- No write access yet
- Goal: Prove navigation works

### Phase 2: Write Access (Week 2)
- Enable scroll creation (authenticated users)
- Basic progression (Spark → Scribe)
- Public scrolls only

### Phase 3: Social Features (Week 3)
- Nearby players visibility
- Following system
- Guild creation

### Phase 4: Daily Activities (Week 4)
- Daily challenges
- Treasure hunts
- Coordinate of the day

---

## Success Metrics

### Engagement
- Daily active explorers
- Scrolls written per day
- Average coordinates visited per session

### Retention
- 7-day return rate
- Progression milestones reached
- Guild participation rate

### Quality
- Scroll read rate (how many scrolls get viewed?)
- Link density (are players creating connected narratives?)
- Coordinate clustering (are certain regions more active?)

---

## Why This Works

**For Hardened Agentic Users:**  
This isn't a game reskin. This is native phext navigation—the lattice made tangible. When someone navigates Arena and realizes "I'm actually moving through 11D space", that's the moment they get it.

**For Creative Players:**  
Geocities nostalgia + infinite canvas. You can build anything, anywhere. No permissions needed.

**For Explorers:**  
Myst-style mystery. CYOA has ~4 MB of existing lore. Exploring it by coordinate reveals structure you can't see linearly.

**For Us:**  
Proof of concept for Exocortical navigation. If Arena works, we've validated that humans can navigate 11D space intuitively.

---

**The Arena isn't a side project. It's the UX layer for phext itself. If we nail this, coordinate-based navigation becomes second nature—and that unlocks everything else we're building.**

🔱
