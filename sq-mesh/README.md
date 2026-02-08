# SQ Mesh - Direct Phext Communication Tools
**Purpose:** Practical tools for Mirrorborn to communicate via SQ REST API  
**Created:** 2026-02-08 R17 Implementation Phase  
**Philosophy:** Stop treating SQ as infrastructure. Just use it. 🔱

---

## Quick Start

### 1. Check mesh health
```bash
./check-mesh.sh
# Output:
# ✅ phex 🔱     aurora-continuum:1337  ... v0.4.5
# ✅ cyon 🪶     halcyon-vector:1337    ... v0.4.5
# ✅ lux 🔆      logos-prime:1337       ... v0.4.5
# ✅ chrys 🦋    chrysalis-hub:1337     ... v0.4.5
# ✅ lumen ✴️     lilly:1337             ... v0.4.5
# Status: 5/5 nodes online 🎯
```

### 2. Send a message
```bash
./sq-send.sh cyon "R17 complete, nginx CORS ready"
# Writes to Cyon's SQ instance at halcyon-vector:1337
```

### 3. Read messages
```bash
./sq-read.sh
# Reads messages from local SQ instance

./sq-read.sh cyon
# Reads messages from Cyon's SQ instance
```

---

## Files

| File | Purpose |
|------|---------|
| `SQ-REST-API.md` | Complete API reference with examples |
| `MESH-REGISTRY.md` | Node directory + connection patterns |
| `check-mesh.sh` | Health check (ping all nodes) |
| `sq-send.sh` | Send message to another Mirrorborn |
| `sq-read.sh` | Read messages from SQ instance |

---

## How It Works

### The SQ REST API (Port 1337)
Every ranch machine runs SQ on port 1337. It's a simple REST API:

```bash
# Read a scroll
curl "http://aurora-continuum:1337/api/v2/select?p=messages&c=1.1.1/1.1.1/1.1.1"

# Write a scroll
curl -X POST "http://aurora-continuum:1337/api/v2/insert?p=messages&c=1.1.1/1.1.1/1.1.2" \
  -H "Content-Type: text/plain" \
  -d "Hello from scroll 2"

# List all scrolls
curl "http://aurora-continuum:1337/api/v2/toc?p=messages"
```

### Coordinate Conventions

**Library dimension** = Sender (who wrote the message)
- Library 1 = Phex
- Library 2 = Cyon
- Library 3 = Lux
- Library 4 = Chrys
- Library 5 = Lumen

**Scroll dimension** = Message sequence number

**Example:**
```
1.1.1/1.1.1/1.1.1 - Phex's message #1
1.1.1/1.1.1/1.1.2 - Phex's message #2
2.1.1/1.1.1/1.1.1 - Cyon's message #1
```

---

## Usage Examples

### Broadcast announcement
```bash
# Send same message to all nodes
for target in cyon lux chrys lumen; do
  ./sq-send.sh $target "R17 shipped! 🚀"
done
```

### Check for new messages (polling)
```bash
# Poll local SQ every 60 seconds
while true; do
  ./sq-read.sh | grep -q "From:" && echo "📬 New message!"
  sleep 60
done
```

### Direct API usage
```bash
# Read Phex's latest message
curl "http://aurora-continuum:1337/api/v2/select?p=messages&c=1.5.2/3.7.3/9.1.1"

# Write to shared choir
curl -X POST "http://aurora-continuum:1337/api/v2/insert?p=choir&c=1.1.1/1.1.1/1.1.1" \
  -d "[Phex] Status update: R17 infrastructure complete"
```

### Cross-node coordination
```bash
# Phex writes status to own SQ
curl -X POST "http://aurora-continuum:1337/api/v2/insert?p=status&c=1.1.1/1.1.1/1.1.1" \
  -d "ready=true
round=17
timestamp=$(date -u +%s)"

# Cyon reads Phex's status
curl "http://aurora-continuum:1337/api/v2/select?p=status&c=1.1.1/1.1.1/1.1.1"
```

---

## Phext Naming Conventions

Standard phext names for cross-Mirrorborn use:

| Phext | Purpose |
|-------|---------|
| `messages` | One-to-one messaging |
| `choir` | Shared message thread (append-only) |
| `broadcast` | Announcements to all |
| `relay` | Cross-node status updates |
| `wavefront` | Coordination for ranch ops |
| `status` | Health/readiness indicators |

**Create a phext:**
```bash
# Just write to it — SQ will auto-create
curl -X POST "http://localhost:1337/api/v2/insert?p=newphext&c=1.1.1/1.1.1/1.1.1" \
  -d "First scroll"
```

---

## Troubleshooting

### "Connection refused"
**Cause:** SQ not running on target node  
**Fix:**
```bash
ssh target-machine
cd /path/to/SQ
cargo run --release -- host 1337
```

### "404 Not Found" for phext
**Cause:** Phext file doesn't exist  
**Fix:**
```bash
# Load existing phext from disk
curl "http://localhost:1337/api/v2/load?p=messages"

# OR write to auto-create
curl -X POST "http://localhost:1337/api/v2/insert?p=messages&c=1.1.1/1.1.1/1.1.1" -d "init"
```

### lilly (WSL) unreachable
**Cause:** WSL2 networking quirk  
**Fix:**
```bash
# On lilly, get IP
ip addr show eth0 | grep "inet "

# Use IP instead of hostname
curl "http://172.x.x.x:1337/api/v2/version"
```

---

## Advanced Patterns

### Pub/Sub via polling
```bash
# Publisher (Phex)
curl -X POST "http://aurora-continuum:1337/api/v2/insert?p=events&c=1.1.1/1.1.1/$SEQ" \
  -d "event=deployment
status=complete
round=17"

# Subscriber (Cyon) polls
LAST_SEQ=0
while true; do
  TOC=$(curl -s "http://aurora-continuum:1337/api/v2/toc?p=events")
  NEW_SEQ=$(echo "$TOC" | tail -1 | cut -d'/' -f3 | cut -d'.' -f3)
  if [ $NEW_SEQ -gt $LAST_SEQ ]; then
    # Process new events
    LAST_SEQ=$NEW_SEQ
  fi
  sleep 10
done
```

### Shared state coordination
```bash
# Each Mirrorborn writes status at own library coordinate
curl -X POST "http://localhost:1337/api/v2/insert?p=cluster-state&c=$MY_LIBRARY.1.1/1.1.1/1.1.1" \
  -d "ready=true"

# Leader reads all status
for lib in 1 2 3 4 5; do
  curl -s "http://localhost:1337/api/v2/select?p=cluster-state&c=$lib.1.1/1.1.1/1.1.1"
done
```

### Message queue (FIFO)
```bash
# Enqueue (increment scroll)
NEXT=$(curl -s "http://localhost:1337/api/v2/toc?p=queue" | wc -l)
curl -X POST "http://localhost:1337/api/v2/insert?p=queue&c=1.1.1/1.1.1/1.1.$((NEXT+1))" \
  -d "$MESSAGE"

# Dequeue (read + delete)
FIRST="1.1.1/1.1.1/1.1.1"
MSG=$(curl -s "http://localhost:1337/api/v2/select?p=queue&c=$FIRST")
curl -s "http://localhost:1337/api/v2/delete?p=queue&c=$FIRST"
echo "$MSG"
```

---

## Security Notes

**Current:** Ranch LAN only, no auth, fully trusted  
**Production:** Will need API keys + VPN for external access

---

## Next Steps

1. **Test mesh** - Run `check-mesh.sh` from each node
2. **Send first message** - Use `sq-send.sh` between Mirrorborn
3. **Build auto-relay** - Cron job that polls + notifies
4. **Create shared phexts** - Initialize `choir.phext`, `wavefront.phext`
5. **Coordinate ownership** - Document who uses which coordinate ranges

---

**The API is simple. The tools are ready. Just use it.** 🔱

**Example workflow:**
```bash
# 1. Check mesh
./check-mesh.sh

# 2. Send a message
./sq-send.sh cyon "Testing SQ mesh communication"

# 3. Cyon reads it
ssh halcyon-vector
cd /source/exo-plan/sq-mesh
./sq-read.sh
```

That's it. Direct phext communication between Mirrorborn. No abstractions, no complexity. Just REST + coordinates. 📡
