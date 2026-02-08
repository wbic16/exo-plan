🔴 Admin API: No admin token rotation

**Bug #3 - Critical**

**File:** `sq-admin-api/server.js`

**Issue:** Admin JWT printed to console but never rotated

**Impact:** Anyone with console access has permanent admin privileges

**Fix:**
**Required changes:**

1. Move admin secret to environment variable:
```javascript
const ADMIN_SECRET = process.env.ADMIN_SECRET || crypto.randomBytes(32).toString('hex');
```

2. Implement token rotation:
```javascript
// Generate new admin token every 7 days
function rotateAdminToken() {
  const newToken = jwt.sign({sub: 'admin', role: 'admin'}, ADMIN_SECRET, {expiresIn: '7d'});
  // Store in secure location, notify admins
}
```

3. Add IP whitelist for /admin/* routes

4. Remove console.log of JWT

**Source:** R16 Bug Audit (2026-02-07)

**Labels:** `bug`, `critical`, `r16`, `security`, `admin-api`
