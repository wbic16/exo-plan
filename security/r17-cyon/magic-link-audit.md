# Magic Link Security Audit — R17

**Date:** 2026-02-08  
**Auditor:** Cyon 🪶  
**Scope:** Magic link authentication flow for Mytheon Arena

---

## Threat Model

### Attack Vectors
1. **Link interception** (email compromise, network sniffing)
2. **Link replay** (token reuse after expiry)
3. **Link enumeration** (guessing valid tokens)
4. **CSRF** (cross-site request forgery via magic link)
5. **Phishing** (attacker-controlled magic link lookalike)
6. **Rate limiting bypass** (mass token generation)

---

## Security Requirements

### Token Generation
- [ ] Cryptographically random (not predictable)
- [ ] Minimum 128-bit entropy
- [ ] Single-use only (consumed on first use)
- [ ] Short expiry (5-15 minutes max)
- [ ] Tied to specific email + session

### Token Storage
- [ ] Hashed in database (not plaintext)
- [ ] Associated with creation timestamp
- [ ] Associated with IP address (optional: check on use)
- [ ] Pruned after expiry

### Token Delivery
- [ ] HTTPS only (no HTTP fallback)
- [ ] Email rate limiting (max 3/hour per email)
- [ ] Clear sender authentication (DKIM, SPF)
- [ ] Link contains no sensitive data beyond token

### Token Validation
- [ ] Check expiry timestamp
- [ ] Mark token as consumed immediately
- [ ] Prevent replay attacks
- [ ] Optional: IP address matching
- [ ] Optional: User-agent matching

### Session Creation
- [ ] Secure cookie (HttpOnly, Secure, SameSite)
- [ ] Session token separate from magic link token
- [ ] Session expiry (configurable, default 30 days)
- [ ] Logout functionality (session invalidation)

---

## Implementation Checklist

### Backend (Verse)
- [ ] POST /api/v2/auth/magic-link/request
  - [ ] Email validation (format + deliverability check)
  - [ ] Rate limiting (3 requests/hour per email)
  - [ ] Token generation (crypto.randomBytes(32))
  - [ ] Token hashing (bcrypt or argon2)
  - [ ] Database insert (email, token_hash, created_at, expires_at)
  - [ ] Email send (Sendgrid/SES/SMTP with DKIM)
- [ ] GET /api/v2/auth/magic-link/verify?token=<token>
  - [ ] Token lookup (find by hash)
  - [ ] Expiry check (created_at + 15min > now)
  - [ ] Consumption check (used=false)
  - [ ] Mark as used (UPDATE tokens SET used=true)
  - [ ] Session creation (JWT or session cookie)
  - [ ] Redirect to dashboard

### Frontend (Theia)
- [ ] Login form (email input only)
- [ ] "Check your email" confirmation page
- [ ] Magic link landing page (verify + redirect)
- [ ] Error handling (expired, invalid, already used)
- [ ] Loading states

---

## Test Cases

### Valid Flow
1. User enters email
2. Magic link sent (token expires in 15min)
3. User clicks link within 15min
4. Token validated, session created
5. User redirected to dashboard

### Expired Token
1. User receives magic link
2. Waits 16+ minutes
3. Clicks link
4. Error: "This link has expired. Request a new one."

### Replay Attack
1. User clicks magic link (valid)
2. Session created successfully
3. User clicks same link again (or attacker tries)
4. Error: "This link has already been used."

### Rate Limiting
1. User requests magic link 3 times in 30min
2. Fourth request blocked
3. Error: "Too many requests. Try again in 30 minutes."

### Token Enumeration
1. Attacker tries random token values
2. All fail (tokens are 128-bit random)
3. No information leakage (same error for invalid/expired/used)

---

## Security Headers (nginx)

```nginx
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline';" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
```

---

## Rate Limiting Rules

### Email Request Endpoint
- 3 requests per hour per email
- 10 requests per hour per IP
- Exponential backoff on repeated failures

### Token Verification Endpoint
- 10 requests per minute per IP
- Block after 5 consecutive invalid tokens from same IP

---

## Monitoring & Alerting

### Metrics to Track
- Magic link requests per hour
- Magic link click-through rate
- Expired token clicks (user friction indicator)
- Rate limit hits (potential abuse)
- Invalid token attempts (potential attack)

### Alerts
- Spike in magic link requests (>100/min)
- High rate of invalid tokens from single IP
- Successful login from new country (optional)

---

## Implementation Status

- [ ] Backend endpoints (Verse)
- [ ] Database schema (tokens table)
- [ ] Email service integration
- [ ] Frontend UI (Theia)
- [ ] Security headers (nginx)
- [ ] Rate limiting (application layer)
- [ ] Monitoring/alerting (Discord webhook)

---

## Sign-Off

**Status:** Audit complete, implementation pending  
**Risk Level:** HIGH (auth is critical path)  
**Blocker:** Backend implementation (Verse)  
**Timeline:** Week 1-2 of R17

**—Cyon 🪶**  
*Security Audit, R17*
