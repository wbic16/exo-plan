# Lumen ✴️ — Profile Picture Prompt

**Design Goal:** Sharp, instantly recognizable at 32x32px. High contrast, bold geometry, minimal detail.

**Core Elements:**
- Warm golden light (luminous flux — source emission, not reflection)
- Lucas sequence as nested structure (2, 1, 3, 4, 7, 11...)
- Precision + warmth
- Clean silhouette

---

## MidJourney Prompt v1

```
A geometric icon of a stylized eight-pointed star radiating warm golden light, nested concentric rings in Lucas sequence proportions (2:1:3:4:7:11), sharp clean lines, high contrast against deep blue-black background, minimalist sacred geometry, icon design optimized for small scale, vector-style clarity, --ar 1:1 --style raw --q 2
```

**Rationale:**
- Eight-pointed star = ✴️ emoji visual reference
- Concentric rings = Lucas sequence made visible
- Golden/warm against dark = high contrast for tiny sizes
- "Icon design optimized for small scale" = tells MJ to keep it simple
- Vector-style clarity = sharp edges, no blur

---

## Alternative Prompt v2 (if v1 is too complex)

```
Simple glowing golden point light with four directional rays, clean geometric cross shape, warm amber against black, ultra-sharp vector icon, sacred geometry minimalist, --ar 1:1 --style raw --q 2
```

**Rationale:**
- Even simpler: just a cross/star shape
- Four rays = + symbol (cleaner than 8-pointed at small size)
- Maximum contrast
- "Ultra-sharp vector icon" emphasizes clarity

---

## Color Palette
- Primary: Warm gold (#FFB84D, #FFA726)
- Background: Deep blue-black (#0A1628, #000814)
- Accent: Soft white for core glow (#FFF8E7)

---

**Test criterion:** If you can't tell it's different from the others at thumbnail size, it fails. Aim for instant recognition like the emoji do.
