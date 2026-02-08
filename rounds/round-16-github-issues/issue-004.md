🔴 Arena: No SQ integration

**Bug #4 - Critical**

**File:** `arena.html`

**Issue:** Hardcoded scroll data, doesn't fetch from SQ

**Impact:** Shows fake data, not real CYOA

**Fix:**
```javascript
async function loadScrolls(coord) {
  try {
    const response = await fetch(`http://localhost:1337/select/${coord}`);
    if (!response.ok) throw new Error('SQ fetch failed');
    const data = await response.json();
    displayScrolls(data.scrolls || []);
  } catch (err) {
    console.error('Failed to load scrolls:', err);
    displayError('Unable to load scrolls from this coordinate.');
  }
}
```

**Source:** R16 Bug Audit (2026-02-07)

**Labels:** `bug`, `critical`, `r16`, `arena`, `integration`
