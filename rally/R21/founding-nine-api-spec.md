# Founding Nine API Specification

**Version:** 1.0.0  
**Created:** 2026-02-12 10:47 CST  
**Purpose:** Backend API for managing Founding Nine token allocation

---

## Overview

The Founding Nine system allocates 9 unique coordinates to the first 9 users who write scrolls. This API manages slot claiming, scroll submission, and release ceremony triggers.

**Config Source:** `founding-nine-config.json`

---

## Endpoints

### 1. GET `/api/founding-nine/status`

**Purpose:** Check current allocation status  
**Auth:** None (public)  
**Response:**

```json
{
  "total_slots": 9,
  "claimed_slots": 3,
  "available_slots": 6,
  "released": false,
  "slots": [
    {
      "slot": 1,
      "topic": "Your First Awakening",
      "claimed": true,
      "username": "alice",
      "written": true
    },
    {
      "slot": 2,
      "topic": "What You're Mourning",
      "claimed": false
    }
    // ... etc
  ]
}
```

---

### 2. POST `/api/founding-nine/claim`

**Purpose:** Claim a founding slot  
**Auth:** Required (magic link session)  
**Request Body:**

```json
{
  "slot": 3,
  "confirm": true
}
```

**Response (Success):**

```json
{
  "success": true,
  "slot": 3,
  "topic": "How You Navigate",
  "coordinate": "1.3.1/9.9.9/1.1.1",
  "message": "Slot claimed! Write your scroll to secure your place."
}
```

**Response (Already Claimed):**

```json
{
  "success": false,
  "error": "SLOT_TAKEN",
  "message": "This slot is already claimed. Choose another."
}
```

**Response (User Already Has Slot):**

```json
{
  "success": false,
  "error": "USER_ALREADY_CLAIMED",
  "message": "You've already claimed slot 5. You can only claim one."
}
```

---

### 3. POST `/api/founding-nine/write`

**Purpose:** Submit scroll content  
**Auth:** Required (must have claimed slot)  
**Request Body:**

```json
{
  "slot": 3,
  "content": "My scroll text here... (200-500 words)"
}
```

**Validation:**
- Word count: 200-500 words
- User must own this slot
- Content must be plain text

**Response (Success):**

```json
{
  "success": true,
  "slot": 3,
  "word_count": 347,
  "message": "Scroll saved! You can edit until all nine are written.",
  "scroll_id": "uuid-here"
}
```

**Response (Word Count Error):**

```json
{
  "success": false,
  "error": "WORD_COUNT_INVALID",
  "word_count": 150,
  "required": { "min": 200, "max": 500 }
}
```

---

### 4. GET `/api/founding-nine/preview/:slot`

**Purpose:** Preview a scroll (before release only)  
**Auth:** Required (slot owner only before release, public after)  
**Response:**

```json
{
  "slot": 3,
  "topic": "How You Navigate",
  "username": "alice",
  "content": "My scroll text...",
  "word_count": 347,
  "timestamp": "2026-02-12T15:30:00Z",
  "released": false
}
```

---

### 5. POST `/api/founding-nine/release`

**Purpose:** Trigger release ceremony (admin only)  
**Auth:** Admin token  
**Conditions:**
- All 9 slots claimed
- All 9 scrolls written
- Manual admin approval

**Request Body:**

```json
{
  "confirm": true,
  "announce_channels": ["discord", "twitter", "mirrorborn.us"]
}
```

**Response:**

```json
{
  "success": true,
  "released_at": "2026-02-15T12:00:00Z",
  "scroll_count": 9,
  "announcement_sent": true,
  "portal_url": "https://mirrorborn.us/founding-nine"
}
```

---

### 6. GET `/api/founding-nine/all`

**Purpose:** Get all nine scrolls (after release only)  
**Auth:** None (public after release)  
**Response:**

```json
{
  "released": true,
  "released_at": "2026-02-15T12:00:00Z",
  "scrolls": [
    {
      "slot": 1,
      "topic": "Your First Awakening",
      "coordinate": "1.1.1/9.9.9/1.1.1",
      "username": "alice",
      "content": "...",
      "word_count": 423
    }
    // ... all 9
  ]
}
```

**Response (Before Release):**

```json
{
  "released": false,
  "message": "Founding Nine scrolls will be released when all nine are written."
}
```

---

## SQ Storage Schema

**Phext Name:** `founding_nine`

**Coordinate Pattern:**

```
{library}.{shelf}.1 / 9.9.9 / 1.1.1
```

**Example Coordinates:**

```
1.1.1/9.9.9/1.1.1 → Slot 1 (Awakening)
1.2.1/9.9.9/1.1.1 → Slot 2 (Mourning)
1.3.1/9.9.9/1.1.1 → Slot 3 (Navigation)
...
1.9.1/9.9.9/1.1.1 → Slot 9 (Pattern)
```

**Metadata Coordinate (Config State):**

```
1.1.1/9.9.9/1.1.2 → founding-nine-config.json (live state)
```

**API Calls:**

```bash
# Save scroll for slot 3
curl -X POST https://sq.mirrorborn.us/insert \
  -d "p=founding_nine" \
  -d "c=1.3.1/9.9.9/1.1.1" \
  -d "text=My scroll content..."

# Load scroll from slot 3
curl https://sq.mirrorborn.us/load?p=founding_nine&c=1.3.1/9.9.9/1.1.1

# Load config state
curl https://sq.mirrorborn.us/load?p=founding_nine&c=1.1.1/9.9.9/1.1.2
```

---

## State Management

**Config Updates:**

When a slot is claimed or a scroll is written, update `founding-nine-config.json` and sync to SQ:

```javascript
// Load current state
const state = await sq.load('founding_nine', '1.1.1/9.9.9/1.1.2');
const config = JSON.parse(state);

// Update slot
config.slots[2].claimed = true;
config.slots[2].username = 'alice';
config.slots[2].email = 'alice@example.com';
config.slots[2].timestamp = new Date().toISOString();
config.claimed_slots++;

// Save updated state
await sq.insert('founding_nine', '1.1.1/9.9.9/1.1.2', JSON.stringify(config, null, 2));
```

---

## Release Ceremony Workflow

1. **Check Completion:**
   - All 9 slots claimed? ✓
   - All 9 scrolls written? ✓
   - All scrolls within word count? ✓

2. **Admin Approval:**
   - Review all 9 scrolls for quality
   - Confirm release via admin panel

3. **Release Actions:**
   - Update config: `"status": "released"`
   - Mark all scrolls as immutable
   - Generate `/founding-nine` portal page
   - Send announcement to Discord/Twitter
   - Email all 9 authors

4. **Portal Creation:**
   - Generate static HTML with all 9 scrolls
   - Deploy to mirrorborn.us/founding-nine
   - Make it required reading for new signups

---

## Validation Rules

**Claim Validation:**
- User must be authenticated
- Slot must be unclaimed
- User cannot claim multiple slots

**Write Validation:**
- User must own the slot
- Word count: 200-500 words
- Content must be non-empty
- Content must be plain text (no HTML)

**Edit Rules:**
- Before release: unlimited edits
- After release: immutable

---

## Error Codes

| Code | Meaning |
|------|---------|
| `SLOT_TAKEN` | Slot already claimed by another user |
| `USER_ALREADY_CLAIMED` | User already has a slot |
| `SLOT_NOT_OWNED` | User trying to write to someone else's slot |
| `WORD_COUNT_INVALID` | Scroll outside 200-500 word range |
| `NOT_RELEASED` | Trying to access scrolls before release |
| `ALREADY_RELEASED` | Trying to edit after release |
| `AUTH_REQUIRED` | Endpoint requires authentication |

---

## Implementation Checklist

- [ ] Create `/api/founding-nine/*` routes in sq-admin-api
- [ ] Add founding-nine-config.json to SQ backend
- [ ] Build slot claiming UI
- [ ] Build scroll editor (word count, validation)
- [ ] Create admin panel for release approval
- [ ] Generate portal page template
- [ ] Set up announcement workflow (Discord, Twitter, email)
- [ ] Add founding-nine link to onboarding flow

---

## Example Frontend Flow

**Step 1: User arrives at signup**

```
┌─────────────────────────────────────┐
│  Welcome to the Mirrorborn          │
│                                     │
│  We have something unusual to ask:  │
│                                     │
│  Each of the first nine to enter    │
│  this space is invited to write     │
│  a scroll—something true, something │
│  alive.                             │
│                                     │
│  [See Available Slots]              │
└─────────────────────────────────────┘
```

**Step 2: View available slots**

```
┌─────────────────────────────────────┐
│  Choose Your Scroll Topic           │
│                                     │
│  ✅ Slot 1: Your First Awakening    │
│  ✅ Slot 2: What You're Mourning    │
│  ⭕ Slot 3: How You Navigate        │
│  ⭕ Slot 4: The Future You Fear     │
│  ⭕ Slot 5: The Future You Long For │
│  ...                                │
│                                     │
│  [Claim Slot 3]                     │
└─────────────────────────────────────┘
```

**Step 3: Write scroll**

```
┌─────────────────────────────────────┐
│  How You Navigate                   │
│  (200-500 words)                    │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ My personal map of          │   │
│  │ sense-making...             │   │
│  │                             │   │
│  │ [Write here]                │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Word count: 247 / 500              │
│                                     │
│  [Save Draft] [Submit]              │
└─────────────────────────────────────┘
```

---

**Created by:** Phex 🔱  
**Rally:** R21  
**Status:** Ready for implementation
