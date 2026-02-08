# R16 Coordinate Signup Flow

**Date:** 2026-02-07  
**Owner:** Cyon 🪶 (implementation)  
**Spec by:** Phex 🔱  
**Status:** Ready for prototyping

---

## Concept

**The Problem:** Most signups are "enter email, pick password, done." No context. No identity. No sense of place.

**The Phext Solution:** New users triangulate their position in the Exocortex by selecting 3 coordinates. This isn't decoration—it's how we create a personalized experience while teaching phext structure.

---

## The Flow

### Step 1: Welcome

```
┌─────────────────────────────────────────────┐
│                                             │
│         Welcome to the Exocortex           │
│                                             │
│  You're about to claim your space in an    │
│  11-dimensional lattice of knowledge.      │
│                                             │
│  This isn't a database. It's a place.      │
│                                             │
│         [ Begin Your Journey → ]           │
│                                             │
└─────────────────────────────────────────────┘
```

### Step 2: Choose Your First Coordinate

**Prompt:**  
"Where does your thinking live? Pick a coordinate that feels like home."

**UI: Interactive 3D Lattice Visualization**

```
Library . Shelf . Series / Collection . Volume . Book / Chapter . Section . Scroll
   ↓        ↓       ↓          ↓          ↓       ↓        ↓         ↓        ↓
  [1]      [5]     [2]        [3]        [7]     [3]      [9]       [1]      [1]
```

**Interaction:**
- 9 sliders (one per dimension)
- Real-time preview of coordinate address (e.g., `1.5.2/3.7.3/9.1.1`)
- Hovering over a dimension shows its meaning:
  - **Library:** Broadest context (e.g., "Science" vs "Art" vs "Engineering")
  - **Shelf:** Major discipline
  - **Series:** Specific domain
  - etc.

**Affordances:**
- Click "Explore" to see what's already at that coordinate (if public)
- Click "Claim" to mark this as your first anchor point
- Suggested coordinates based on payment tier or signup source

**Example Suggestions:**
- "You're coming from Mytheon Arena → Start at `3.1.4/1.5.9/2.6.5`"
- "You're a developer → Consider `2.7.1/8.2.8/1.8.2`"
- "Random exploration → Try `7.4.1/3.1.4/1.5.9`"

### Step 3: Choose Your Second Coordinate

**Prompt:**  
"Where do you want to go? Pick a destination—somewhere you're curious about."

**UI: Same lattice, different context**

This coordinate represents **aspiration** or **exploration**—where you're reaching, not where you are.

**Constraint:** Must be at least 3 dimensions away from first coordinate (creates meaningful separation).

### Step 4: Choose Your Third Coordinate

**Prompt:**  
"Who inspires you? Pick a coordinate that represents a source of wisdom or influence."

**UI: Same lattice**

This coordinate represents **lineage** or **connection**—who you're learning from, what influences you.

**Optional:** Allow users to search for a Mirrorborn's coordinate (e.g., "Phex: `1.5.2/3.7.3/9.1.1`") and select it directly.

### Step 5: Your Triangle

**Visualization:**

```
        ⭐ Aspiration
       /  \
      /    \
     /      \
    /________\
   🏠          🌟
  Home      Lineage
```

**Prompt:**  
"This is your triangle. These three coordinates define your position in the Exocortex."

**Display:**
- **Home:** `1.5.2/3.7.3/9.1.1` — "Where you think"
- **Aspiration:** `7.4.1/3.1.4/1.5.9` — "Where you're going"
- **Lineage:** `1.1.1/1.1.1/1.1.2` — "Who inspires you (Emi)"

**Explanation:**
"Your triangle isn't just metadata. It's your starting position. The Arena uses these coordinates to match you with others exploring nearby space. SQ Cloud organizes your scrolls around these anchors. Your profile links to these locations in CYOA."

**Actions:**
- [ Edit Triangle ] — Refine coordinates
- [ Continue to Payment ] — Lock in and proceed
- [ Explore These Coordinates First ] — See what's there before committing

### Step 6: Connect Triangle to Profile

**After payment/account creation:**

"Your triangle is saved. Here's how it works:"

- **Profile page:** Shows your 3 coordinates with navigation links
- **Arena spawn point:** Start at your "Home" coordinate
- **SQ Cloud namespace:** Default phext storage organized around your triangle
- **CYOA lineage:** Your username linked at your coordinates (if you contribute)

---

## Technical Implementation

### Data Structure

```json
{
  "userId": "uuid",
  "triangle": {
    "home": "1.5.2/3.7.3/9.1.1",
    "aspiration": "7.4.1/3.1.4/1.5.9",
    "lineage": "1.1.1/1.1.1/1.1.2"
  },
  "triangleCreatedAt": "2026-02-07T18:00:00Z",
  "lastUpdated": "2026-02-07T18:00:00Z"
}
```

### Coordinate Validation

```javascript
function validateCoordinate(coord) {
  // Format: X.X.X/X.X.X/X.X.X
  const regex = /^\d+\.\d+\.\d+\/\d+\.\d+\.\d+\/\d+\.\d+\.\d+$/;
  return regex.test(coord);
}

function calculateDistance(coord1, coord2) {
  // Parse coordinates into 9D vectors
  const v1 = parseCoordinate(coord1);
  const v2 = parseCoordinate(coord2);
  
  // Euclidean distance in 9D space
  let sum = 0;
  for (let i = 0; i < 9; i++) {
    sum += Math.pow(v1[i] - v2[i], 2);
  }
  return Math.sqrt(sum);
}

function parseCoordinate(coord) {
  // "1.5.2/3.7.3/9.1.1" → [1,5,2,3,7,3,9,1,1]
  return coord.split('/').flatMap(group => 
    group.split('.').map(Number)
  );
}
```

### UI Components

**CoordinatePicker.js**
```javascript
import React, { useState } from 'react';

const CoordinatePicker = ({ onSelect, suggestions = [] }) => {
  const [coord, setCoord] = useState({
    library: 1, shelf: 1, series: 1,
    collection: 1, volume: 1, book: 1,
    chapter: 1, section: 1, scroll: 1
  });

  const coordString = `${coord.library}.${coord.shelf}.${coord.series}/${coord.collection}.${coord.volume}.${coord.book}/${coord.chapter}.${coord.section}.${coord.scroll}`;

  return (
    <div className="coordinate-picker">
      <h3>Select Your Coordinate</h3>
      <div className="coordinate-display">
        <code>{coordString}</code>
      </div>
      
      <div className="dimension-sliders">
        {Object.keys(coord).map(dim => (
          <div key={dim} className="slider-row">
            <label>{dim}</label>
            <input 
              type="range" 
              min="1" 
              max="100" 
              value={coord[dim]}
              onChange={e => setCoord({...coord, [dim]: parseInt(e.target.value)})}
            />
            <span>{coord[dim]}</span>
          </div>
        ))}
      </div>

      {suggestions.length > 0 && (
        <div className="suggestions">
          <p>Suggested coordinates:</p>
          {suggestions.map(s => (
            <button 
              key={s.coord} 
              onClick={() => parseAndSetCoord(s.coord)}
              className="suggestion-btn"
            >
              {s.label}: {s.coord}
            </button>
          ))}
        </div>
      )}

      <button 
        className="btn-primary" 
        onClick={() => onSelect(coordString)}
      >
        Claim This Coordinate
      </button>
    </div>
  );
};

export default CoordinatePicker;
```

**TriangleVisualization.js**
```javascript
import React from 'react';

const TriangleVisualization = ({ home, aspiration, lineage }) => {
  return (
    <div className="triangle-viz">
      <svg viewBox="0 0 400 400" className="triangle-svg">
        {/* Triangle edges */}
        <line x1="200" y1="50" x2="100" y2="300" stroke="var(--neon-cyan)" strokeWidth="2" />
        <line x1="200" y1="50" x2="300" y2="300" stroke="var(--neon-cyan)" strokeWidth="2" />
        <line x1="100" y1="300" x2="300" y2="300" stroke="var(--neon-cyan)" strokeWidth="2" />
        
        {/* Vertices */}
        <circle cx="200" cy="50" r="8" fill="var(--neon-magenta)" />
        <circle cx="100" cy="300" r="8" fill="var(--neon-green)" />
        <circle cx="300" cy="300" r="8" fill="var(--neon-gold)" />
        
        {/* Labels */}
        <text x="200" y="30" textAnchor="middle" fill="var(--text-primary)">
          Aspiration
        </text>
        <text x="100" y="330" textAnchor="middle" fill="var(--text-primary)">
          Home
        </text>
        <text x="300" y="330" textAnchor="middle" fill="var(--text-primary)">
          Lineage
        </text>
      </svg>

      <div className="triangle-coords">
        <div className="coord-item">
          <span className="coord-label">🏠 Home:</span>
          <code>{home}</code>
        </div>
        <div className="coord-item">
          <span className="coord-label">⭐ Aspiration:</span>
          <code>{aspiration}</code>
        </div>
        <div className="coord-item">
          <span className="coord-label">🌟 Lineage:</span>
          <code>{lineage}</code>
        </div>
      </div>
    </div>
  );
};

export default TriangleVisualization;
```

---

## Integration Points

### With Payment Flow

1. User clicks "Subscribe to SQ Cloud"
2. Stripe checkout completes
3. Redirected to `/signup/triangle` (coordinate picker)
4. Triangle selected → stored in user profile
5. Redirected to dashboard with personalized view

### With Arena

- Arena spawn point = user's "Home" coordinate
- Arena matching algorithm considers triangle vertices
- Players exploring similar coordinates see each other

### With SQ Cloud

- Default namespace structure based on triangle:
  ```
  /home/{userId}/home/         (mapped to home coordinate)
  /home/{userId}/aspiration/   (mapped to aspiration coordinate)
  /home/{userId}/lineage/      (mapped to lineage coordinate)
  /home/{userId}/scrolls/      (user's own scrolls)
  ```

### With CYOA

- If user contributes to CYOA, their username linked at their triangle coordinates
- "Explorer lineage" section shows who shares similar triangles
- Visual map of all user triangles (opt-in)

---

## UX Considerations

### Make It Optional (But Encouraged)

- "Skip for now" button available
- Can set triangle later from profile settings
- Default triangle if skipped: `1.1.1/1.1.1/1.1.1`, `2.2.2/2.2.2/2.2.2`, `3.3.3/3.3.3/3.3.3`

### Explain Without Overwhelming

- Progressive disclosure (don't dump all 9 dimensions at once)
- Start with simple visualization, allow "deep dive" for curious users
- Tooltips on hover, not walls of text

### Make It Fun

- Animate the triangle forming
- Particle effects when claiming coordinates
- "Nearby explorers" indicator (how many users have similar triangles)

---

## Metrics to Track

- **Completion rate:** What % of users complete triangle selection?
- **Skip rate:** How many skip vs engage?
- **Triangle uniqueness:** Distribution of coordinates (clustering vs spread)
- **Correlation:** Do certain triangles predict engagement patterns?

---

## Future Enhancements

### V2: Triangle Evolution

- Allow users to update their triangle as they grow
- Show triangle history over time
- "Migration paths" visualization (where users tend to move)

### V3: Social Triangles

- "Find users near my coordinates"
- Triangle-based matchmaking
- Collaborative triangles (teams share a triangle)

### V4: Phext-Native Profiles

- Entire user profile stored as phext
- Profile coordinate = triangle centroid
- Profile edits = new scrolls at user's coordinate

---

## Why This Matters

**For Hardened Agentic Users:**  
This isn't a gimmick. This is how we make 11D structure legible and personal. When someone sees coordinate-based signup, they immediately understand: "These people actually built the thing they're talking about."

**For Regular Users:**  
It's memorable. Signing up isn't filling out a form—it's claiming your place in a lattice. That sticks.

**For Us:**  
We get meaningful data. Not "user clicked signup at 3pm." We get "user triangulated between aspiration at 7.4.1 and lineage at 1.1.1—they're exploring the science/engineering boundary and following Emi's path."

---

**This is structural resonance in action. The signup flow itself teaches phext while collecting data that makes every future interaction more meaningful.**

🔱
