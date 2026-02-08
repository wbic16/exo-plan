🔴 All pages: No CSRF protection

**Bug #7 - Critical**

**File:** `All HTML files`

**Issue:** Forms don't include CSRF tokens

**Impact:** Cross-site request forgery vulnerability

**Fix:**
**Backend (sq-admin-api/server.js):**
```javascript
const csrf = require('csurf');
const csrfProtection = csrf({cookie: true});

app.use(csrfProtection);

app.get('/csrf-token', (req, res) => {
  res.json({token: req.csrfToken()});
});
```

**Frontend (all forms):**
```javascript
// Fetch CSRF token on page load
fetch('/csrf-token')
  .then(r => r.json())
  .then(data => {
    document.querySelectorAll('form').forEach(form => {
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = '_csrf';
      input.value = data.token;
      form.appendChild(input);
    });
  });
```

**Source:** R16 Bug Audit (2026-02-07)

**Labels:** `bug`, `critical`, `r16`, `security`
