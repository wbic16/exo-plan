# R16 Metallic Design System

**Date:** 2026-02-07  
**Owner:** Chrys 🦋 + Lux 🔆 (implementation)  
**Spec by:** Phex 🔱  
**Status:** Ready for implementation

---

## Vision

> "Metallic Liquid Neon Lineage, Understated and Refined"

The Mirrorborn visual identity should feel like **high-end tech infrastructure**—not flashy consumer products, not academic papers, not blockchain hype. Think: server racks in a clean data center, aerospace engineering diagrams, professional audio equipment.

**Core principles:**
- **Structural clarity** over decoration
- **Metallic surfaces** that reflect light (gradients, sheens, depth)
- **Neon accents** used sparingly for emphasis (not everywhere)
- **Dark foundation** with high contrast for readability
- **Understated confidence** (we know what we're building)

---

## Color Palette

### Base Colors (Foundation)

```css
--bg-primary: #0a0a0a;        /* Near-black background */
--bg-secondary: #1a1a1a;      /* Elevated surfaces */
--bg-tertiary: #2a2a2a;       /* Cards, panels */

--text-primary: #f0f0f0;      /* Main text */
--text-secondary: #aaaaaa;    /* Supporting text */
--text-tertiary: #666666;     /* Muted text */
```

### Metallic Colors (Structure)

```css
--metal-dark: #1a1d23;        /* Dark gunmetal */
--metal-mid: #3d4451;         /* Medium steel */
--metal-light: #6b7280;       /* Light aluminum */
--metal-bright: #9ca3af;      /* Polished chrome */
```

### Neon Accents (Energy)

```css
--neon-cyan: #00d4ff;         /* Primary accent - coordination, links */
--neon-magenta: #ff00ff;      /* Singularity tier, high-energy */
--neon-gold: #ffd700;         /* Founding Nine, prestige */
--neon-green: #00ff88;        /* Success states, active */
--neon-red: #ff0044;          /* Warnings, errors */
```

### Tier-Specific Colors

```css
--singularity: #ff00ff;       /* Magenta - all-access */
--sq-cloud: #00d4ff;          /* Cyan - infrastructure */
--arena: #00ff88;             /* Green - gameplay */
--openclaw: #ffa500;          /* Orange - tools */
--founding-nine: #ffd700;     /* Gold - exclusive */
```

---

## Typography

### Font Stack

```css
--font-primary: 'Inter', 'Helvetica Neue', Arial, sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', 'Consolas', monospace;
--font-display: 'Space Grotesk', 'Orbitron', sans-serif; /* Headers */
```

### Scale

```css
--text-xs: 12px;
--text-sm: 14px;
--text-base: 16px;
--text-lg: 18px;
--text-xl: 24px;
--text-2xl: 32px;
--text-3xl: 48px;
--text-4xl: 64px;
```

### Weights

```css
--weight-normal: 400;
--weight-medium: 500;
--weight-semibold: 600;
--weight-bold: 700;
```

---

## Spacing & Layout

### Spacing Scale

```css
--space-xs: 4px;
--space-sm: 8px;
--space-md: 16px;
--space-lg: 24px;
--space-xl: 32px;
--space-2xl: 48px;
--space-3xl: 64px;
```

### Container Widths

```css
--container-sm: 640px;
--container-md: 768px;
--container-lg: 1024px;
--container-xl: 1280px;
--container-full: 100%;
```

### Border Radius

```css
--radius-sm: 4px;
--radius-md: 8px;
--radius-lg: 12px;
--radius-xl: 16px;
--radius-full: 9999px;
```

---

## Components

### Buttons

**Primary Button (CTA)**
```css
.btn-primary {
  background: linear-gradient(135deg, var(--neon-cyan), #0099cc);
  color: #000;
  padding: 12px 32px;
  border-radius: var(--radius-md);
  font-weight: var(--weight-bold);
  transition: all 0.3s;
  border: none;
  cursor: pointer;
}

.btn-primary:hover {
  background: linear-gradient(135deg, #00ffff, var(--neon-cyan));
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,212,255,0.3);
}
```

**Secondary Button**
```css
.btn-secondary {
  background: transparent;
  color: var(--neon-cyan);
  padding: 12px 32px;
  border: 2px solid var(--neon-cyan);
  border-radius: var(--radius-md);
  font-weight: var(--weight-semibold);
  transition: all 0.3s;
  cursor: pointer;
}

.btn-secondary:hover {
  background: rgba(0,212,255,0.1);
  border-color: #00ffff;
  color: #00ffff;
}
```

**Metallic Button**
```css
.btn-metallic {
  background: linear-gradient(135deg, var(--metal-mid), var(--metal-bright));
  color: var(--text-primary);
  padding: 12px 32px;
  border-radius: var(--radius-md);
  font-weight: var(--weight-semibold);
  transition: all 0.3s;
  border: 1px solid var(--metal-light);
  cursor: pointer;
}

.btn-metallic:hover {
  background: linear-gradient(135deg, var(--metal-light), var(--metal-bright));
  box-shadow: 0 4px 12px rgba(107,114,128,0.2);
}
```

### Cards

**Standard Card**
```css
.card {
  background: linear-gradient(135deg, rgba(30,30,30,0.95), rgba(50,50,50,0.95));
  border: 1px solid var(--metal-mid);
  border-radius: var(--radius-lg);
  padding: var(--space-xl);
  box-shadow: 0 4px 16px rgba(0,0,0,0.3);
}
```

**Highlighted Card (with neon accent)**
```css
.card-highlight {
  background: linear-gradient(135deg, rgba(30,30,30,0.95), rgba(50,50,50,0.95));
  border: 2px solid var(--neon-cyan);
  border-radius: var(--radius-lg);
  padding: var(--space-xl);
  box-shadow: 0 4px 16px rgba(0,212,255,0.2);
  position: relative;
}

.card-highlight::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--neon-cyan), var(--neon-magenta));
  border-radius: var(--radius-lg) var(--radius-lg) 0 0;
}
```

### Links

```css
a {
  color: var(--neon-cyan);
  text-decoration: none;
  transition: all 0.3s;
  border-bottom: 1px solid transparent;
}

a:hover {
  color: #00ffff;
  border-bottom-color: #00ffff;
}
```

### Headers

```css
h1, h2, h3, h4, h5, h6 {
  font-family: var(--font-display);
  font-weight: var(--weight-bold);
  color: var(--text-primary);
  line-height: 1.2;
}

h1 {
  font-size: var(--text-4xl);
  background: linear-gradient(135deg, var(--neon-cyan), var(--neon-magenta));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

h2 {
  font-size: var(--text-3xl);
}

h3 {
  font-size: var(--text-2xl);
}
```

---

## Effects & Interactions

### Metallic Gradient

```css
.metallic-gradient {
  background: linear-gradient(
    135deg,
    var(--metal-dark) 0%,
    var(--metal-mid) 25%,
    var(--metal-light) 50%,
    var(--metal-mid) 75%,
    var(--metal-dark) 100%
  );
  background-size: 200% 200%;
  animation: shimmer 3s ease infinite;
}

@keyframes shimmer {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}
```

### Neon Glow

```css
.neon-glow {
  box-shadow: 
    0 0 10px rgba(0,212,255,0.3),
    0 0 20px rgba(0,212,255,0.2),
    0 0 30px rgba(0,212,255,0.1);
}

.neon-glow:hover {
  box-shadow: 
    0 0 15px rgba(0,212,255,0.5),
    0 0 30px rgba(0,212,255,0.3),
    0 0 45px rgba(0,212,255,0.2);
}
```

### Glass Morphism (subtle)

```css
.glass {
  background: rgba(30,30,30,0.7);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255,255,255,0.1);
}
```

---

## Dark/Light Mode

**Default: Dark Mode**  
Light mode optional (low priority for R16).

If implementing light mode:
```css
[data-theme="light"] {
  --bg-primary: #f5f5f5;
  --bg-secondary: #e5e5e5;
  --bg-tertiary: #d5d5d5;
  --text-primary: #0a0a0a;
  --text-secondary: #4a4a4a;
  --text-tertiary: #888888;
  
  /* Keep neon accents (adjust saturation if needed) */
  --neon-cyan: #0099cc;
  --neon-magenta: #cc00cc;
}
```

---

## Implementation Guide

### 1. CSS Variables Setup

Create `metallic-theme.css`:
```css
:root {
  /* Copy all variables above */
}

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: var(--font-primary);
  background-color: var(--bg-primary);
  color: var(--text-primary);
  line-height: 1.6;
}
```

### 2. Component Library

Create `components.css` with all component styles above.

### 3. Integration

Each site includes:
```html
<link rel="stylesheet" href="/shared/metallic-theme.css">
<link rel="stylesheet" href="/shared/components.css">
<link rel="stylesheet" href="/css/site-specific.css">
```

### 4. Testing

- Verify color contrast (WCAG AA minimum)
- Test on dark backgrounds
- Ensure neon accents don't overwhelm
- Check mobile responsiveness

---

## Examples

### Hero Section

```html
<section class="hero" style="
  background: linear-gradient(135deg, var(--bg-primary), var(--metal-dark));
  padding: 64px 16px;
  text-align: center;
  border-bottom: 2px solid var(--neon-cyan);
">
  <h1>We Are the Visible Wavefront</h1>
  <p style="
    font-size: var(--text-lg);
    color: var(--text-secondary);
    margin: 24px 0;
  ">
    Coordinated cognition across humans and AI
  </p>
  <button class="btn-primary">Explore the Lattice</button>
</section>
```

### Pricing Tiers

See `/source/exo-plan/rounds/round-16-payment-buttons.html` for full implementation with metallic styling.

---

## Assets Needed

- [ ] Inter font (Google Fonts)
- [ ] JetBrains Mono (Google Fonts)
- [ ] Space Grotesk (Google Fonts)
- [ ] Logo variants (metallic treatment)
- [ ] Icon set (consistent style)

---

## Rollout Plan

1. **Week 1:** Create `metallic-theme.css` + `components.css`
2. **Week 1:** Update mirrorborn.us as reference implementation
3. **Week 2:** Roll out to all 7 portals
4. **Week 2:** Update phext.io
5. **Week 2:** Implement Arena-specific styling

---

## Success Criteria

- [ ] All 9 sites use consistent color palette
- [ ] Typography is clean and readable
- [ ] Metallic gradients add depth without distraction
- [ ] Neon accents draw eye to CTAs and key info
- [ ] Site feels professional, not amateur
- [ ] Hardened agentic users recognize "these people know what they're doing"

---

**The goal: When someone lands on any Mirrorborn property, they should immediately feel the structural resonance—not through flashy animations, but through confident, refined design that reflects the depth of what we're building.**

🔱
