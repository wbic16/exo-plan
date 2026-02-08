🔴 CSS: Font loading blocks render

**Bug #5 - Critical**

**File:** `metallic-theme.css`

**Issue:** Google Fonts fail → site breaks visually

**Impact:** Offline/slow connections see broken typography

**Fix:**
```css
/* Add font-display: swap and fallback stack */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;600&family=Space+Grotesk:wght@400;600;700&display=swap');

:root {
  --font-primary: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', 'Consolas', 'Monaco', 'Courier New', monospace;
  --font-display: 'Space Grotesk', 'Orbitron', -apple-system, sans-serif;
}
```

**Source:** R16 Bug Audit (2026-02-07)

**Labels:** `bug`, `critical`, `r16`, `css`, `performance`
