🔴 Arena: No data persistence

**Bug #1 - Critical**

**File:** `arena.html`

**Issue:** All navigation state lost on page refresh

**Impact:** User progress vanishes, breaks UX completely

**Fix:**
```javascript
// Save state on every navigation
function updateDisplay() {
  const coordStr = getCoordString();
  document.getElementById('current-coord').textContent = coordStr;
  
  visitedCoords.add(coordStr);
  document.getElementById('coords-visited').textContent = visitedCoords.size;
  
  // NEW: Persist to localStorage
  localStorage.setItem('arena-position', JSON.stringify(position));
  localStorage.setItem('arena-visited', JSON.stringify([...visitedCoords]));
  
  // ... rest of function
}

// Load on init
window.addEventListener('DOMContentLoaded', () => {
  const savedPosition = localStorage.getItem('arena-position');
  const savedVisited = localStorage.getItem('arena-visited');
  
  if (savedPosition) {
    position = JSON.parse(savedPosition);
  }
  
  if (savedVisited) {
    visitedCoords = new Set(JSON.parse(savedVisited));
  }
  
  updateDisplay();
});
```

**Source:** R16 Bug Audit (2026-02-07)

**Labels:** `bug`, `critical`, `r16`, `arena`
