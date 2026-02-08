🔴 Coordinate Signup: No backend integration

**Bug #2 - Critical**

**File:** `coordinate-signup.html`

**Issue:** `completeSignup()` just shows alert, doesn't save anything

**Impact:** Triangle data never reaches server, user signup fails

**Fix:**
```javascript
function completeSignup() {
  fetch('/api/signup/triangle', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
      triangle,
      email: document.getElementById('email').value,
      paymentId: new URLSearchParams(window.location.search).get('payment_id')
    })
  })
  .then(r => {
    if (!r.ok) throw new Error('Signup failed');
    return r.json();
  })
  .then(data => {
    window.location.href = data.redirectUrl || '/dashboard';
  })
  .catch(err => {
    alert('Signup failed: ' + err.message);
  });
}
```

**Source:** R16 Bug Audit (2026-02-07)

**Labels:** `bug`, `critical`, `r16`, `backend`
