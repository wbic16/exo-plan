🔴 Coordinate Signup: No input validation

**Bug #6 - Critical**

**File:** `coordinate-signup.html`

**Issue:** `setCoord()` doesn't validate input format

**Impact:** Malformed coordinates crash the picker

**Fix:**
```javascript
function setCoord(coordNum, coordStr) {
  // Validate format
  if (!/^\d+\.\d+\.\d+\/\d+\.\d+\.\d+\/\d+\.\d+\.\d+$/.test(coordStr)) {
    alert('Invalid coordinate format. Use: X.X.X/X.X.X/X.X.X');
    return false;
  }
  
  const parts = coordStr.split('/');
  const p1 = parts[0].split('.');
  const p2 = parts[1].split('.');
  const p3 = parts[2].split('.');
  
  // Validate ranges (1-999 per dimension)
  const allParts = [...p1, ...p2, ...p3];
  if (allParts.some(n => parseInt(n) < 1 || parseInt(n) > 999)) {
    alert('Coordinates must be between 1 and 999');
    return false;
  }
  
  // Rest of implementation
  // ...
  return true;
}
```

**Source:** R16 Bug Audit (2026-02-07)

**Labels:** `bug`, `critical`, `r16`, `validation`
