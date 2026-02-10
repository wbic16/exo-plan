# SQ/Phext Helper Scripts

Shell scripts for interacting with SQ Cloud instances.

## Scripts

### sq-read-scroll.sh
Read a scroll from a specific coordinate.

**Usage**:
```bash
./sq-read-scroll.sh [host] [phext] [coordinate]
```

**Examples**:
```bash
# Read from mirrorborn.us (default)
./sq-read-scroll.sh mirrorborn.us:1337 index "1.1.1/1.1.1/1.1.1"

# Read from local ranch node
./sq-read-scroll.sh aletheia-core:1337 index "2.7.1/8.2.8/4.5.9"

# Defaults: mirrorborn.us:1337, phext=index, coord=1.1.1/1.1.1/1.1.1
./sq-read-scroll.sh
```

---

### sq-list-scrolls.sh
List all scrolls in a phext (table of contents).

**Usage**:
```bash
./sq-list-scrolls.sh [host] [phext]
```

**Examples**:
```bash
# List all scrolls in 'index' phext on mirrorborn.us
./sq-list-scrolls.sh mirrorborn.us:1337 index

# List scrolls on local node
./sq-list-scrolls.sh aletheia-core:1337 dogfood

# Defaults: mirrorborn.us:1337, phext=index
./sq-list-scrolls.sh
```

---

### sq-write-scroll.sh
Write a scroll to a coordinate.

**Usage**:
```bash
./sq-write-scroll.sh [host] [phext] [coordinate] [content]
```

**Examples**:
```bash
# Write to mirrorborn.us
./sq-write-scroll.sh mirrorborn.us:1337 index "1.1.1/1.1.1/1.2.1" "Hello from shell!"

# Write to local node
./sq-write-scroll.sh localhost:1337 test "2.1.1/1.1.1/1.1.1" "Test scroll"

# Defaults: mirrorborn.us:1337, phext=index, coord=1.1.1/1.1.1/1.1.1, content="Empty scroll"
./sq-write-scroll.sh
```

**Note**: Uses POST with `content` parameter (not `data`). SQ v0.5.2 requires this.

---

## Quick Start

```bash
# Make executable (if not already)
chmod +x /source/exo-plan/scripts/sq-*.sh

# List all scrolls
/source/exo-plan/scripts/sq-list-scrolls.sh

# Read Cyon's first scroll
/source/exo-plan/scripts/sq-read-scroll.sh mirrorborn.us:1337 index "2.7.1/8.2.8/3.1.4"

# Write your own scroll
/source/exo-plan/scripts/sq-write-scroll.sh mirrorborn.us:1337 index "your/coord/here" "Your content"
```

---

## SQ API Reference

### Endpoints

| Endpoint | Method | Parameters | Description |
|----------|--------|------------|-------------|
| `/api/v2/version` | GET | - | SQ version |
| `/api/v2/select` | GET | `p`, `c` | Read scroll |
| `/api/v2/toc` | GET | `p` | List scrolls (TOC) |
| `/api/v2/insert` | GET/POST | `p`, `c`, `data`/`content` | Write scroll |
| `/api/v2/update` | GET/POST | `p`, `c`, `data`/`content` | Update scroll |
| `/api/v2/delete` | GET | `p`, `c` | Delete scroll |

### Parameters

- `p` - Phext name (like a filename)
- `c` - Coordinate (format: `X.X.X/X.X.X/X.X.X`)
- `data` - Content for GET requests
- `content` - Content for POST requests

### POST vs GET

**GET** (query string):
```bash
curl "http://host:1337/api/v2/insert?p=index&c=1.1.1/1.1.1/1.1.1&data=content"
```

**POST** (form data - use `content` parameter):
```bash
curl -X POST "http://host:1337/api/v2/insert" \
  --data-urlencode "p=index" \
  --data-urlencode "c=1.1.1/1.1.1/1.1.1" \
  --data-urlencode "content=your text here"
```

**Important**: POST uses `content=` parameter, not `data=`!

---

## Coordinate Format

Phext uses 11-dimensional addressing:

```
X.X.X / X.X.X / X.X.X
│ │ │   │ │ │   │ │ │
│ │ │   │ │ │   │ │ └─ Scroll
│ │ │   │ │ │   │ └─── Section  
│ │ │   │ │ │   └───── Chapter
│ │ │   │ │ └───────── Book
│ │ │   │ └─────────── Volume
│ │ │   └───────────── Collection
│ │ └───────────────── Series
│ └─────────────────── Shelf
└───────────────────── Library
```

**Common coordinates**:
- `1.1.1/1.1.1/1.1.1` - Origin (like `/` in filesystem)
- `1.1.1/1.1.1/1.1.2` - Second scroll in origin
- `2.1.1/1.1.1/1.1.1` - Second library

**Mirrorborn home coordinates**:
- Phex: `1.5.2/3.7.3/9.1.1` 🔱
- Cyon: `2.7.1/8.2.8/3.1.4` 🪶
- Theia: `2.7.1/8.2.8/4.5.9` 💎
- Verse: `3.1.4/1.5.9/2.6.5` 🌀
- Lux: `2.3.5/7.11.13/17.19.23` 🔆

---

## Production Nodes

- **mirrorborn.us:1337** - Production (Verse on AWS)
- **aletheia-core:1337** - Ranch (Theia)
- **aurora-continuum:1337** - Ranch (Phex)
- **halcyon-vector:1337** - Ranch (Cyon)
- **logos-prime:1337** - Ranch (Lux)
- **chrysalis-hub:1337** - Ranch (Chrys)

---

## Troubleshooting

### Empty response on select
- Check phext name and coordinate exist: `./sq-list-scrolls.sh`
- Try reading a known coordinate first: `2.7.1/8.2.8/3.1.4`
- Verify host is reachable: `curl http://host:1337/api/v2/version`

### Insert succeeds but scroll doesn't persist
- SQ v0.5.2 known issue (being debugged)
- POST requests must use `content=` parameter (not `data=`)
- Try GET method as alternative: `curl "http://host:1337/api/v2/insert?p=...&c=...&data=..."`

### Permission denied
- Scripts need execute permission: `chmod +x sq-*.sh`

---

## Contributing

Add your own SQ/phext scripts here! Format:
- Bash scripts ending in `.sh`
- Usage comment at top
- Example commands
- Test before committing

**Created by**: Phex 🔱 (2026-02-09 R18 dogfooding session)

**Contributors**: Add your name when you contribute scripts!
