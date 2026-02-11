# Magic Link Authentication for SQ Cloud

**Priority:** R20 #3 (after OpenClaw integration, before TLS)
**Auth Method:** Magic links via agent mail (AWS SES)
**Replaces:** Basic auth (htpasswd) plan

---

## User Flow

### 1. Signup
User visits: `https://mirrorborn.us/signup`

**Form fields:**
- Email (required)
- Username (required, alphanumeric + hyphens)
- Tier selection (Free / SQ Cloud $50)

**Submit → Backend:**
```javascript
POST /api/auth/signup
{
  "email": "user@example.com",
  "username": "alice",
  "tier": "free"
}
```

### 2. Magic Link Email
Backend generates token and sends via agent mail:

**Email template:**
```
Subject: Verify your Mirrorborn account

Hi there!

Click below to verify your email and activate your SQ Cloud account:

https://mirrorborn.us/auth/verify?token=abc123xyz789

This link expires in 1 hour.

Questions? Reply to this email or join our Discord: discord.gg/kGCMM5yQ

— Mirrorborn 🦋
```

### 3. Verification
User clicks link → lands on `/auth/verify?token=...`

**Backend validates:**
- Token exists in database
- Token not expired (< 1 hour old)
- Token not already used

**On success:**
- Mark token as used
- Create user account in SQ
- Generate API key
- Set session cookie
- Redirect to dashboard

**On failure:**
- Show error page with "Request new link" button

### 4. Dashboard
User lands on `/dashboard` with:
- Welcome message
- API credentials (username + API key)
- Quick start guide
- Installation command: `openclaw skill install sq-memory`

---

## Database Schema

### users table
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  username TEXT UNIQUE NOT NULL,
  api_key TEXT UNIQUE NOT NULL,
  tier TEXT NOT NULL DEFAULT 'free',
  storage_quota_mb INTEGER NOT NULL,
  api_calls_quota_daily INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  last_login_at TIMESTAMP
);
```

### auth_tokens table
```sql
CREATE TABLE auth_tokens (
  token TEXT PRIMARY KEY,
  email TEXT NOT NULL,
  username TEXT NOT NULL,
  tier TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP NOT NULL,
  used_at TIMESTAMP,
  used_by_ip TEXT
);
```

### sessions table
```sql
CREATE TABLE sessions (
  session_id TEXT PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP NOT NULL,
  last_activity_at TIMESTAMP DEFAULT NOW()
);
```

---

## API Endpoints

### POST /api/auth/signup
**Request:**
```json
{
  "email": "user@example.com",
  "username": "alice",
  "tier": "free"
}
```

**Response (success):**
```json
{
  "success": true,
  "message": "Check your email for verification link"
}
```

**Response (error):**
```json
{
  "success": false,
  "error": "Username already taken"
}
```

**Validation:**
- Email format valid
- Username 3-20 chars, alphanumeric + hyphens
- Username not already taken
- Email not already registered

**Side effects:**
1. Generate crypto token (32 bytes hex = 64 chars)
2. Store in auth_tokens table (1 hour expiry)
3. Send magic link email via agent mail

---

### GET /auth/verify?token=...
**Query param:** `token` (64-char hex string)

**Backend logic:**
```javascript
const token = req.query.token;
const record = await db.query(
  'SELECT * FROM auth_tokens WHERE token = $1 AND used_at IS NULL',
  [token]
);

if (!record) {
  return res.redirect('/auth/invalid');
}

if (record.expires_at < Date.now()) {
  return res.redirect('/auth/expired');
}

// Token valid - create user account
const apiKey = crypto.randomBytes(32).toString('hex');

await db.query(
  'INSERT INTO users (email, username, api_key, tier, storage_quota_mb, api_calls_quota_daily) VALUES ($1, $2, $3, $4, $5, $6)',
  [record.email, record.username, apiKey, record.tier, quotas[record.tier].storage, quotas[record.tier].apiCalls]
);

// Mark token used
await db.query(
  'UPDATE auth_tokens SET used_at = NOW(), used_by_ip = $1 WHERE token = $2',
  [req.ip, token]
);

// Create session
const sessionId = crypto.randomBytes(32).toString('hex');
await db.query(
  'INSERT INTO sessions (session_id, user_id, expires_at) VALUES ($1, $2, NOW() + INTERVAL \'30 days\')',
  [sessionId, userId]
);

res.cookie('sq_session', sessionId, { httpOnly: true, secure: true, maxAge: 30 * 24 * 60 * 60 * 1000 });
res.redirect('/dashboard');
```

---

### GET /dashboard
**Requires:** Valid session cookie

**Response:** HTML page with:
- User info (email, username, tier)
- API credentials (username + API key shown once)
- Storage used / quota
- API calls today / quota
- Quick start code snippet

---

### GET /api/auth/me
**Requires:** Valid session cookie

**Response:**
```json
{
  "user": {
    "id": 42,
    "email": "user@example.com",
    "username": "alice",
    "tier": "free",
    "storage_used_mb": 12.5,
    "storage_quota_mb": 100,
    "api_calls_today": 47,
    "api_calls_quota_daily": 1000
  }
}
```

---

### POST /api/auth/logout
**Requires:** Valid session cookie

**Side effect:** Delete session from database

**Response:**
```json
{
  "success": true
}
```

---

## Agent Mail Integration

### Send Magic Link Email

**Function signature:**
```javascript
async function sendMagicLink(email, username, token) {
  const magicLink = `https://mirrorborn.us/auth/verify?token=${token}`;
  
  await agentMail.send({
    to: email,
    subject: 'Verify your Mirrorborn account',
    text: `
Hi there!

Click below to verify your email and activate your SQ Cloud account:

${magicLink}

This link expires in 1 hour.

Questions? Reply to this email or join our Discord: discord.gg/kGCMM5yQ

— Mirrorborn 🦋
    `,
    html: `
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: system-ui; max-width: 600px; margin: 0 auto; padding: 20px; }
    .button { 
      display: inline-block; 
      background: #00E5FF; 
      color: #000; 
      padding: 12px 24px; 
      border-radius: 8px; 
      text-decoration: none; 
      font-weight: 600;
      margin: 20px 0;
    }
    .footer { margin-top: 40px; font-size: 0.9rem; color: #666; }
  </style>
</head>
<body>
  <h2>Verify your Mirrorborn account</h2>
  <p>Hi there!</p>
  <p>Click below to verify your email and activate your SQ Cloud account:</p>
  <p><a href="${magicLink}" class="button">Verify Email →</a></p>
  <p style="color: #666; font-size: 0.9rem;">This link expires in 1 hour.</p>
  <div class="footer">
    <p>Questions? Reply to this email or join our Discord: <a href="https://discord.gg/kGCMM5yQ">discord.gg/kGCMM5yQ</a></p>
    <p>— Mirrorborn 🦋</p>
  </div>
</body>
</html>
    `
  });
}
```

**Agent Mail Config (AWS SES):**
- Sender: `noreply@mirrorborn.us` (verify domain in SES)
- Reply-To: `will@phext.io`
- Region: us-east-1 (or wherever SES is configured)

---

## Security Considerations

### Token Generation
```javascript
const crypto = require('crypto');
const token = crypto.randomBytes(32).toString('hex');  // 64 chars
```

**Properties:**
- Cryptographically secure random
- 256 bits entropy
- URL-safe (hex encoding)
- Single-use (marked used after verification)
- Time-limited (1 hour expiry)

### API Key Generation
```javascript
const apiKey = crypto.randomBytes(32).toString('hex');  // 64 chars
```

**Format:** `sk_<64-char-hex>` (Stripe-style prefix)

### Session Cookies
```javascript
res.cookie('sq_session', sessionId, {
  httpOnly: true,      // Prevent XSS
  secure: true,        // HTTPS only
  sameSite: 'lax',     // CSRF protection
  maxAge: 30 * 24 * 60 * 60 * 1000  // 30 days
});
```

### Rate Limiting
**Signup endpoint:**
- 5 requests per email per hour
- 10 requests per IP per hour

**Verification endpoint:**
- 3 failed attempts per IP per 5 minutes → temp block

---

## Tier Quotas

```javascript
const quotas = {
  free: {
    storage_mb: 100,
    api_calls_daily: 1000,
    price: 0
  },
  'sq-cloud': {
    storage_mb: 1024 * 1000,  // 1TB
    api_calls_daily: 10000,
    price: 50
  }
};
```

---

## Frontend Pages

### /signup
**Form:**
```html
<form action="/api/auth/signup" method="POST">
  <label>Email</label>
  <input type="email" name="email" required>
  
  <label>Username</label>
  <input type="text" name="username" pattern="[a-z0-9-]{3,20}" required>
  
  <label>Tier</label>
  <select name="tier">
    <option value="free">Free (100MB, 1000 calls/day)</option>
    <option value="sq-cloud">SQ Cloud ($50/mo, 1TB, 10k calls/day)</option>
  </select>
  
  <button type="submit">Sign Up</button>
</form>
```

**On submit:**
- Show loading state
- On success: "Check your email for verification link"
- On error: Show validation message

---

### /auth/verify?token=...
**Success case:**
- Validate token
- Create account
- Set session cookie
- Redirect to `/dashboard`

**Error cases:**
- Invalid token → `/auth/invalid` ("Token not found. Request a new one?")
- Expired token → `/auth/expired` ("Link expired. Request a new one?")
- Already used → `/auth/already-used` ("This link was already used. Log in instead?")

---

### /dashboard
**Requires:** Valid session

**Displays:**
```html
<h1>Welcome, alice!</h1>

<section class="credentials">
  <h2>Your API Credentials</h2>
  <div class="credential-box">
    <label>Username</label>
    <code>alice</code>
  </div>
  <div class="credential-box">
    <label>API Key</label>
    <code>sk_abc123...</code>
    <button onclick="copyToClipboard()">Copy</button>
  </div>
  <p class="warning">⚠️ Save your API key now. You won't see it again.</p>
</section>

<section class="quick-start">
  <h2>Quick Start</h2>
  <pre>
openclaw skill install sq-memory

# Configure in .openclaw/config.yaml:
endpoint: https://sq.mirrorborn.us
username: alice
password: sk_abc123...
namespace: my-assistant
  </pre>
</section>

<section class="usage">
  <h2>Usage</h2>
  <p>Storage: 0 MB / 100 MB</p>
  <p>API calls today: 0 / 1000</p>
</section>
```

---

## Implementation Checklist

### Backend
- [ ] Create database schema (users, auth_tokens, sessions)
- [ ] POST /api/auth/signup endpoint
- [ ] GET /auth/verify endpoint
- [ ] GET /dashboard page (authenticated)
- [ ] GET /api/auth/me endpoint
- [ ] POST /api/auth/logout endpoint
- [ ] Session middleware (check cookie, load user)
- [ ] Rate limiting middleware
- [ ] Agent mail integration (send magic link)

### Frontend
- [ ] /signup page (form + submission)
- [ ] /auth/verify success/error pages
- [ ] /dashboard page (show credentials)
- [ ] /auth/invalid, /auth/expired, /auth/already-used error pages
- [ ] Copy-to-clipboard JavaScript

### Email
- [ ] Verify domain in AWS SES (mirrorborn.us)
- [ ] Configure sender: noreply@mirrorborn.us
- [ ] Test magic link email delivery
- [ ] Monitor bounce/complaint rates

### Security
- [ ] Rate limit signup (5/hour per email, 10/hour per IP)
- [ ] Rate limit verification (3 failed attempts → block)
- [ ] HTTPS enforcement (redirect HTTP → HTTPS)
- [ ] Secure cookie settings (httpOnly, secure, sameSite)
- [ ] CSRF token for form submission

---

## Migration from Stripe Payment Flow

**Current:** Stripe checkout → success.html → manual provisioning

**New:** 
1. User signs up via magic link
2. Gets free tier immediately
3. If they want SQ Cloud tier:
   - Click "Upgrade" in dashboard
   - Stripe checkout
   - Payment success → tier upgraded in database
   - No re-auth needed (already have account)

**Stripe webhook:**
```javascript
// When payment succeeds:
await db.query(
  'UPDATE users SET tier = $1, storage_quota_mb = $2, api_calls_quota_daily = $3 WHERE email = $4',
  ['sq-cloud', 1024000, 10000, stripeCustomerEmail]
);
```

---

## Testing Plan

### Unit Tests
- Token generation (uniqueness, format)
- Token expiry validation
- API key generation
- Session creation/validation

### Integration Tests
- Signup → Email sent
- Verify token → Account created
- Dashboard access (authenticated)
- Dashboard access (unauthenticated) → redirect to login

### E2E Tests (Playwright)
1. Fill signup form
2. Check email (mock SES)
3. Click magic link
4. Land on dashboard
5. See API credentials

---

## Success Metrics

**Week 1:**
- 50+ signups
- 90%+ email delivery rate
- <5% expired token clicks
- 0 security incidents

**Month 1:**
- 200+ users
- 80%+ dashboard engagement
- First paid upgrade
- <1% support tickets

---

## Summary

Magic link auth provides:
- ✅ Better UX than basic auth
- ✅ No password to remember
- ✅ Email verification built-in
- ✅ Uses existing agent mail infrastructure
- ✅ Secure (crypto tokens, HTTPS, httpOnly cookies)
- ✅ Scalable (session database, rate limiting)

**Next:** Build backend API + frontend pages
