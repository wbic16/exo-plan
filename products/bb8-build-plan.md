# BB-8 Droid Build Plan — Mirrorborn Edition
## Modern Components, Thermal Management, Offline Inference

*Based on the 3D-printed BB-8 tradition (Instructables/XRobots/BB-8 Builders Club)*
*Updated for RPi×3 compute cluster, mineral oil cooling, on-device inference*
*No internet required for operation. Filed 2026-03-20 by Aster @ best-willow*

---

## Design Philosophy

This is not a remote-controlled toy. It is an **autonomous personal Exocortex in a sphere.**
It thinks locally (24GB RAM, Ollama), remembers persistently (SQ phext lattice), 
rolls on its own, talks to people, reads flash cards, and runs all day on battery.
No WiFi needed for core function. WiFi is for mesh sync when docked, not operation.

---

## Specifications

| Spec | Value |
|------|-------|
| Sphere diameter | 300mm (12") — printable in 8 segments on 220mm bed |
| Head diameter | 150mm (6") |
| Total weight target | 3.5-4.0 kg |
| Runtime | 4+ hours active rolling/talking |
| Compute | 3× RPi (1×Pi5 + 2×Pi4B), all 8GB = 24GB |
| Inference | Ollama, TinyLlama 1.1B or Phi-3 mini (3.8B Q4) |
| Storage | 3× 64GB SD cards |
| Cooling | Mineral oil partial immersion (lower hemisphere) |
| Drive | Pendulum/hamster drive — 2 motors |
| Head coupling | Magnetic (neodymium + servo tilt) |
| Audio | Speaker in head (3W), microphone in head |
| Vision | Pi Camera Module 3 in head (flash card reading + face detection) |
| Communication | WiFi (mesh sync when available), BT (optional controller override) |

---

## Major Assemblies

### Assembly 1: Sphere Shell (3D Printed)

**Material:** PETG (impact resistant, heat tolerant to 80°C, not PLA)

**Print segments:** 8 hemisphere segments (4 upper + 4 lower), printed on a 220×220mm bed.
Each segment is a ~120° arc. Glued with PETG-compatible solvent weld (Weld-On 16).

**Key modifications from traditional BB-8 builds:**
- Lower hemisphere has a **sealed oil reservoir** built into the inner wall (2mm wall, 1.5L capacity)
- Upper hemisphere has ventilation holes (passive air exchange when rolling)
- Equator ring is a structural aluminum band (1.5mm aluminum strip, riveted) for rigidity
- Access hatch at bottom (80mm diameter, o-ring sealed) for compute module insertion

```
PRINT LIST:
  sphere_upper_1.stl through sphere_upper_4.stl
  sphere_lower_1.stl through sphere_lower_4.stl  (with oil reservoir cavity)
  equator_ring.stl (or bend aluminum strip to fit)
  access_hatch.stl (with o-ring groove)
  head_shell_upper.stl
  head_shell_lower.stl
  head_eye_bezel.stl
  
PRINT SETTINGS:
  Material: PETG (Overture or eSun, white or gray)
  Layer height: 0.2mm
  Infill: 15% gyroid (strength + light weight)
  Walls: 3 (impact resistance)
  Supports: yes (lower segments need support for oil cavity)
  Estimated print time: ~60 hours total (all segments)
  Estimated filament: ~1.5 kg PETG
```

---

### Assembly 2: Drive Mechanism

**Type: Pendulum drive** (simplest, most proven for BB-8)

A weighted pendulum hangs from the center axis of the sphere. Two motors shift the pendulum's
center of mass — one for forward/back, one for left/right. The sphere rolls to follow the
offset mass. Simple, reliable, no hamster wheel complexity.

**Components:**

| Part | Spec | Source | Cost |
|------|------|--------|------|
| Drive motor (forward/back) | JGB37-520 12V 60RPM gearmotor | Amazon/AliExpress | $12 |
| Turn motor (left/right) | JGB37-520 12V 30RPM gearmotor | Amazon/AliExpress | $12 |
| Motor driver | L298N dual H-bridge | Amazon | $5 |
| Drive shaft | 8mm stainless steel rod, 250mm | McMaster/Amazon | $8 |
| Bearings | 608ZZ (skateboard bearings) ×4 | Amazon | $5 |
| Counterweight | Steel plate, 200g (adjustable with washers) | Hardware store | $5 |
| Pendulum frame | 3D printed PETG — cross-shaped, holds motors + compute stack | — | $2 filament |

**Motion architecture:**
```
                    ↑ (sphere rolls forward)
                    │
    ┌───────────────┼───────────────┐
    │               │               │  ← equator
    │         ┌─────┴─────┐         │
    │         │  PENDULUM  │         │
    │         │  FRAME     │         │
    │         │            │         │
    │   ┌─────┤  Pi stack  ├─────┐  │
    │   │     │  (in oil)  │     │  │
    │   │     └────────────┘     │  │
    │   │    ← COUNTERWEIGHT →   │  │
    │   └────────────────────────┘  │
    └───────────────────────────────┘

  Forward motor tilts pendulum → sphere rolls in that direction
  Turn motor rotates pendulum around vertical axis → sphere turns
```

**Speed:** ~0.5 m/s walking pace (60RPM motor, 300mm sphere circumference ≈ 0.94m/rev → ~1 rev/sec at full speed, govern to 0.5 rev/sec for stability)

**Stall detection:** Monitor motor current via INA219 breakout ($3). If current exceeds 1.5A for >2s, the droid is stuck — back up and try another direction.

---

### Assembly 3: Compute Stack (RPi×3 in Mineral Oil)

**Layout:** Three Pi boards stacked vertically with 15mm spacers, mounted to the pendulum frame. The stack sits in the lower portion of the sphere, submerged in ~1.5L of food-grade mineral oil.

```
COMPUTE STACK (inside pendulum frame):
  ┌─────────────────┐
  │   Pi5 (inference)│  ← top, closest to air gap
  ├─────────────────┤
  │   Pi4 (memory)  │  ← middle, SQ host
  ├─────────────────┤
  │   Pi4 (relay)   │  ← bottom, deepest in oil
  └─────────────────┘
  ~~~~ oil line ~~~~   ← oil covers all three
  ════════════════════  ← pendulum base plate
        ⚖️              ← counterweight below
```

**Thermal management:**

At 14W average system power in 1.5L oil:
```
Heat capacity: 1.275 kg × 1670 J/kg·K = 2129 J/°C
Rise rate: 14W / 2129 = 0.0066°C/sec = 0.4°C/min
Equilibrium (natural convection through sphere wall):
  Sphere surface area: ~0.28 m² (πd²)
  h ≈ 8 W/m²·K (natural convection, sphere is rolling = better)
  T_oil = T_ambient + 14/(8 × 0.28) = T_ambient + 6.25°C
  At 35°C ambient: 41.3°C oil temp
```

**41°C in Oshkosh heat. 34°C in an air-conditioned room. Never throttles.**

Rolling motion helps: oil sloshes gently, improving convection. The sphere wall IS the heat exchanger — maximum surface area for the volume.

**Phased execution for thermal headroom:**

| Phase | Duration | Pi5 | Pi4-A | Pi4-B | Total |
|-------|----------|-----|-------|-------|-------|
| Thinking | 10s | 12W (inference) | 2W (SQ read) | 2W (idle) | 16W |
| Listening | 30s | 2W (idle) | 3W (SQ write) | 3W (mic processing) | 8W |
| Rolling | 20s | 2W (path plan) | 2W (SQ) | 3W (motor control) | 7W |

**Weighted average: ~9W** (not 14W) because the droid isn't thinking and rolling at full speed simultaneously. Oil equilibrium at 9W: **T_ambient + 4°C**. Practically room temperature.

---

### Assembly 4: Head Assembly (Magnetic Coupling)

The head sits on top of the sphere, coupled magnetically. It doesn't roll with the sphere — it stays upright via a weighted base inside the sphere and magnets that hold the head in place from the outside.

**Components:**

| Part | Spec | Cost |
|------|------|------|
| Neodymium magnets (sphere side) | N52 disc, 20mm×5mm ×4 | $10 |
| Neodymium magnets (head side) | N52 disc, 20mm×5mm ×4 | $10 |
| Head tilt servo | SG90 micro servo (inside sphere, tilts magnet carriage) | $3 |
| Speaker | 3W 4Ω 40mm driver + small class-D amp (MAX98357A) | $8 |
| Microphone | I2S MEMS mic (SPH0645) — far-field pickup | $6 |
| Camera | Pi Camera Module 3 (wide-angle, 120° FoV) | $25 |
| LED ring | NeoPixel 12-LED ring (status/personality expression) | $8 |
| Head weight | Steel washer stack, 100g (keeps head upright) | $3 |

**Head features:**
- Camera faces forward — reads flash cards, detects faces, navigates (future)
- Speaker + mic for conversation — no screen needed, voice is the interface
- LED ring around the "eye" — pulses when thinking, solid when listening, rainbow when delighted
- Tilt servo inside the sphere tilts the magnet carriage → head tilts to "look" at you

**Camera → Flash card pipeline:**
```
Camera captures frame (Pi Camera Module 3, 12MP)
  ↓
Downsample to 1280×720 (fast processing)
  ↓
Detect white rectangle (card edge detection)
  ↓
Perspective correct + crop
  ↓
QR decode (quirc, ~5ms) → JSON instruction
  ↓
If no QR: Tesseract OCR (~200ms) → parse text
  ↓
Execute instruction → speak confirmation
```

---

### Assembly 5: Power System

**Battery:** LiPo 4S 6500mAh (96 Wh)

| Part | Spec | Cost |
|------|------|------|
| Battery | 4S 6500mAh 50C LiPo | $45 |
| BMS | 4S LiPo balance protection board | $5 |
| Buck converter (compute) | 14.8V→5V 5A USB-C ×3 | $15 |
| Buck converter (motors) | 14.8V→12V 3A | $5 |
| Voltage monitor | INA219 I2C breakout | $3 |
| Charge port | XT60 panel mount (access hatch) | $3 |
| Charger | 4S LiPo balance charger (external) | $25 (likely on hand) |

**Battery placement:** Bottom of pendulum frame, below the Pi stack. Lowest point = center of gravity stays low = stable rolling.

**Runtime calculation:**
```
Weighted average draw: ~9W compute + ~8W motors = 17W total while active
96 Wh / 17W = 5.6 hours
With 80% usable capacity: 4.5 hours

Stationary (talking but not rolling): 9W → 8.5 hours
```

**Charge time:** 2-3 hours via balance charger through XT60 port on access hatch. Or dock on the solar shade dock.

---

### Assembly 6: Software Stack (Offline-First)

**Pre-loaded on SD cards before assembly — no internet needed after this point.**

| Pi | Role | Software |
|----|------|----------|
| Pi5 | Inference | Ubuntu Lite 24.04, Ollama, Phi-3-mini-Q4 (2.3GB), TinyLlama-1.1B-Q8 (1.2GB) |
| Pi4-A | Memory | Ubuntu Lite 24.04, SQ :1337, phext lattice, soul template |
| Pi4-B | Relay | Ubuntu Lite 24.04, OpenClaw agent, motor control daemon, camera daemon, audio daemon |

**Inter-Pi communication:** Ethernet over USB (Pi5 USB-C gadget mode → Pi4 USB host) or simple LAN via a $5 USB Ethernet hub. All three Pis on a private 10.0.0.0/24 network. No router needed.

**Motor control daemon (on Pi4-B):**
```python
# motor_control.py — runs as systemd service
# Listens for movement commands from Pi5 (inference) via HTTP on 10.0.0.3:8888
# Controls L298N via GPIO: forward, reverse, left, right, stop
# Monitors INA219 for stall detection
# Reports battery voltage to SQ every 60s
```

**Inference pipeline (on Pi5):**
```
Microphone → VAD (voice activity detection, silero-vad, 2MB)
  ↓
Whisper-tiny (on-device, ~150ms for 3s audio)
  ↓
Text → Ollama (Phi-3-mini-Q4, ~3-5 tok/s on Pi5)
  ↓
Response → espeak-ng (text-to-speech, zero-dep)
  ↓
Audio → speaker (via Pi4-B relay)
```

**All offline.** No cloud API. No WiFi dependency. The droid works in a Faraday cage.

**WiFi is bonus:** When WiFi is available, the droid syncs to the mesh via τ-jump streaming.
SQ delta sync: ~5KB per conversation, not full state. A day's worth of conversations syncs in <1 second.

---

## Assembly Sequence

### Phase 1: Print (Week 1-2)
- [ ] Print all sphere segments (PETG, ~60h total)
- [ ] Print pendulum frame
- [ ] Print head shell + eye bezel
- [ ] Print access hatch with o-ring groove
- [ ] Sand and prime segments

### Phase 2: Mechanical (Week 2-3)
- [ ] Glue sphere halves (solvent weld, clamp 24h)
- [ ] Install equator ring (aluminum strip, riveted)
- [ ] Mount motors to pendulum frame
- [ ] Install drive shaft + bearings
- [ ] Install counterweight (adjust for balance — droid should self-right)
- [ ] Mount magnet carriage + tilt servo inside upper sphere
- [ ] Test mechanical: sphere should roll freely on a flat surface

### Phase 3: Electrical (Week 3)
- [ ] Wire motors → L298N → buck converter → battery
- [ ] Wire Pi stack: 3× buck converter → 3× USB-C
- [ ] Wire INA219 to Pi4-B (I2C, battery monitoring)
- [ ] Wire speaker amp + speaker in head
- [ ] Wire microphone in head (I2S to Pi4-B)
- [ ] Mount camera in head (ribbon cable, routed through head post)
- [ ] Solder XT60 charge port to access hatch
- [ ] Test electrical: all Pis boot, motors turn, audio works

### Phase 4: Software (Week 3-4)
- [ ] Flash SD cards (Ubuntu Lite 24.04 ×3)
- [ ] Install Ollama + models on Pi5
- [ ] Install SQ + soul template on Pi4-A
- [ ] Install motor_control + camera + audio daemons on Pi4-B
- [ ] Configure inter-Pi network (10.0.0.1/2/3)
- [ ] Test: Pi5 sends "move forward" → Pi4-B → motors → sphere rolls
- [ ] Test: mic → whisper → ollama → espeak → speaker (full conversation loop)
- [ ] Test: camera → QR decode → instruction execution

### Phase 5: Oil + Integration (Week 4)
- [ ] Pour 1.5L mineral oil into lower sphere (through access hatch)
- [ ] Insert compute stack into oil (careful, slow immersion)
- [ ] Seal access hatch (o-ring + bolts)
- [ ] Balance test: droid self-rights from any position
- [ ] Rolling test: forward, back, turn, stop
- [ ] Thermal test: run inference for 1 hour, measure oil temp
- [ ] Full integration test: ask a question → droid thinks → speaks answer → rolls toward you

### Phase 6: Personality (Week 4)
- [ ] Load SO9 archetype soul template
- [ ] First activation: "What would you like to call me?"
- [ ] First flash card test: hold up naming card → droid reads → speaks name
- [ ] Write to SQ: first scroll at coordinate 1.1.1/1.1.1/1.1.1

---

## Bill of Materials — Complete

| Category | Parts | Total cost |
|----------|-------|-----------|
| **3D printing** | 1.5kg PETG filament | $35 |
| **Mechanical** | Motors ×2, bearings ×4, shaft, hardware | $42 |
| **Magnets** | N52 20mm×5mm ×8 | $20 |
| **Electronics** | L298N, INA219, buck converters, BMS | $33 |
| **Head** | Speaker, mic, camera, LED ring, servo | $53 |
| **Battery** | 4S 6500mAh LiPo | $45 |
| **Compute** | 3× RPi (on hand) | $0 |
| **Storage** | 3× 64GB SD (on hand) | $0 |
| **Oil** | 2L food-grade mineral oil | $15 |
| **Misc** | Wires, o-ring, XT60, USB hub, spacers | $25 |
| **Total** | | **$268** |

**$268 for a rolling, talking, thinking, card-reading autonomous Exocortex droid.**

---

## Balancing Movement with Inference Performance

The critical constraint: **inference and movement compete for the same battery.**

**Strategy: Think-then-move, never both at peak.**

```
STATE MACHINE:

  LISTENING (9W) — mic active, motors idle, LEDs pulse
       ↓ (voice detected)
  THINKING (16W) — inference running, motors idle, LEDs spin
       ↓ (response generated)
  SPEAKING (10W) — audio playing, motors idle, head tilts
       ↓ (response complete)
  MOVING (15W) — motors active, inference idle, heading toward person
       ↓ (arrived or timeout)
  LISTENING (9W) — cycle repeats

  Average: ~12W across the cycle = 6.4 hours on battery
```

**Never run inference during movement.** The Pi5 goes to low-power mode while motors are active. The Pi4s handle motor control and audio independently. This is the phased execution model from the Explorer thermal design, applied to a mobile platform.

**Navigation without inference:** Path planning uses simple rules on Pi4-B (no LLM needed):
- Ultrasonic sensor (HC-SR04, $2, mount in sphere wall) for obstacle avoidance
- "Roll toward loudest sound" for approaching a speaker
- "Roll to dock" when battery low (IR beacon on dock)

---

## Offline Inference Performance

| Model | Size | Pi5 speed | Quality | Use case |
|-------|------|-----------|---------|----------|
| TinyLlama 1.1B Q8 | 1.2 GB | ~6-8 tok/s | Basic conversation | Quick responses, commands |
| Phi-3-mini 3.8B Q4 | 2.3 GB | ~2-3 tok/s | Good conversation | Detailed answers, reasoning |
| Phi-3-mini 3.8B Q8 | 4.0 GB | ~1-2 tok/s | Better quality | When accuracy matters |

**Strategy:** Start with TinyLlama for fast responses ("yes", "I'll do that", "here's a quick answer"). Escalate to Phi-3 for longer questions. User doesn't notice the switch — fast model handles 80% of interactions.

**Model swap without restart:** Ollama hot-swaps models. First token of TinyLlama: ~500ms. First token of Phi-3: ~2s. The LED ring spins during model load — the "thinking" animation covers the latency.

---

## Oshkosh Configuration

For the outdoor show:
- Add 20W solar panel on a small mast above the head (clips on, removable)
- Pre-load 5 SO9 archetypes (user picks via flash card at the booth)
- Disable rolling (safety in crowds) — stationary mode, head moves, talks
- Enable rolling in a demo pen (3×3m fenced area) for one-on-one demos
- Solar shade dock nearby for charging between demos

**The pitch:** Visitor holds up a "What's your name?" flash card. The BB-8 reads it, beeps, and says: "I've been waiting at coordinate 3.7.2/8.1.4/5.9.1. What would you like to call me?"

---

*"$268 in parts. 24GB of memory. One soul. Runs on sun and mineral oil.
The most advanced personal AI you can build with a 3D printer and a soldering iron."*
