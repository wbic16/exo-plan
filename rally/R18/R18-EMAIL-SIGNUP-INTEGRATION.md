# R18 Email Signup Integration Guide

## Overview

R18 adds dual-email signup notifications:
1. **User email**: "Welcome - pending confirmation"
2. **Admin email** (will@phext.io): "New signup - action required"

Each user gets isolated phext space after manual confirmation.

## Files Created

### 1. Email Service (`lib/email-service.js` - 7.6 KB)
- **Purpose**: Send dual emails on signup
- **Providers**: AWS SES, SMTP, console (dev mode)
- **Templates**: User welcome + admin notification
- **Features**: 
  - Dual-email on signup
  - Confirmation email after approval
  - Rejection email (optional)

### 2. Admin Approval Routes (`routes/admin-approvals.js` - 5.7 KB)
- **GET /api/admin/pending** - List all pending users
- **POST /api/admin/approve/:userId** - Approve and send confirmation
- **POST /api/admin/reject/:userId** - Reject and send notification
- **GET /api/admin/users/:userId** - Get user details + audit history

### 3. Updated Signup Route (`routes/signup-sq.js`)
- Now sends dual emails after user creation
- Sets user status to 'pending' (not 'active')
- Returns message: "Awaiting manual confirmation"

### 4. Enhanced SQ Backend (`lib/sq-backend.js`)
**New Methods**:
- `getUsersByStatus(status)` - Get all users with given status
- `updateUserStatus(userId, newStatus, note)` - Change user status
- `getUserById(userId)` - Get user by ID
- `getAuditHistory(userId, limit)` - Get user's audit trail
- `logAction(...)` - Log admin actions

**Status Index**: Creates `user-status-{status}` phext for efficient lookup

## Dependencies Added

Updated `package.json`:
```json
{
  "dependencies": {
    "nodemailer": "^6.9.9",
    "aws-sdk": "^2.1691.0"
  }
}
```

Install:
```bash
cd /source/sq-admin-api
npm install
```

## Configuration

### Environment Variables

```bash
# Email provider ('ses', 'smtp', 'console')
EMAIL_PROVIDER=console

# Admin email (receives signup notifications)
ADMIN_EMAIL=will@phext.io

# From email (sender address)
FROM_EMAIL=noreply@mirrorborn.us

# AWS SES (if provider=ses)
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret

# SMTP (if provider=smtp)
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=username
SMTP_PASS=password

# Admin API key (for approval endpoints)
ADMIN_API_KEY=CHANGE_THIS_IN_PRODUCTION
```

### Development Mode

Default provider is `console` - emails print to terminal instead of sending.

```bash
# Start server in dev mode
cd /source/sq-admin-api
node server.js

# Emails will log to console
```

### AWS SES Setup

1. Verify sender email in AWS SES console
2. Verify recipient emails (sandbox mode)
3. Move to production (remove sandbox restrictions)
4. Set environment variables:

```bash
export EMAIL_PROVIDER=ses
export AWS_REGION=us-east-1
export FROM_EMAIL=noreply@mirrorborn.us
```

## Integration into server.js

Add these lines to `server.js`:

```javascript
// At top with other requires
const signupRoutes = require('./routes/signup-sq');
const adminRoutes = require('./routes/admin-approvals');

// After other middleware, before route definitions
app.use('/api/signup', signupRoutes);
app.use('/api/admin', adminRoutes);
```

## User Signup Flow

### 1. User Submits Signup
```bash
POST /api/signup/triangle
Content-Type: application/json

{
  "email": "user@example.com",
  "triangle": {
    "home": "1.5.2/3.7.3/9.1.1",
    "aspiration": "2.3.5/7.11.13/17.19.23",
    "lineage": "3.1.4/1.5.9/2.6.5"
  },
  "paymentId": "stripe_payment_123"
}
```

**Response**:
```json
{
  "success": true,
  "userId": "user@example.com",
  "coordinate": "1.5.2/3.7.3/9.1.1",
  "status": "pending",
  "message": "Signup received. Awaiting manual confirmation from admin.",
  "emailsSent": {
    "userEmailSent": true,
    "adminEmailSent": true
  },
  "redirectUrl": "/signup-pending"
}
```

### 2. Dual Emails Sent

**Email 1 - User**:
```
To: user@example.com
Subject: 🔱 Welcome to Mirrorborn - Your Coordinate Awaits Confirmation

Hello!

Your Mirrorborn signup has been received. Your account is pending manual confirmation.

Your Coordinate Triangle:
  🏠 Home: 1.5.2/3.7.3/9.1.1
  ✨ Aspiration: 2.3.5/7.11.13/17.19.23
  🌳 Lineage: 3.1.4/1.5.9/2.6.5

Tier: free

What Happens Next:
1. Will Bickford will review your signup (usually within 24 hours)
2. You'll receive a confirmation email when your account is activated
3. You'll be granted access to your isolated phext space
4. Your coordinate will be reserved in the lattice

— The Shell of Nine 🔱
```

**Email 2 - Admin (will@phext.io)**:
```
To: will@phext.io
Subject: 🔔 New Signup: user@example.com - Action Required

New Mirrorborn Signup Pending Confirmation

User Details:
  Email: user@example.com
  Coordinate: 1.5.2/3.7.3/9.1.1
  Tier: free
  Payment ID: stripe_payment_123

Coordinate Triangle:
  🏠 Home: 1.5.2/3.7.3/9.1.1
  ✨ Aspiration: 2.3.5/7.11.13/17.19.23
  🌳 Lineage: 3.1.4/1.5.9/2.6.5

Action Required:
1. Review user profile
2. Verify payment (if applicable)
3. Provision isolated phext space
4. Confirm account activation
```

### 3. Will Reviews Signup

List pending users:
```bash
GET /api/admin/pending
Headers:
  X-Admin-API-Key: your_admin_key

Response:
{
  "count": 1,
  "users": [
    {
      "id": "user@example.com",
      "email": "user@example.com",
      "coordinate": "1.5.2/3.7.3/9.1.1",
      "tier": "free",
      "paymentId": "stripe_payment_123",
      "triangle": {...},
      "createdAt": 1707523200000,
      "age": 15  // minutes since signup
    }
  ]
}
```

### 4. Will Approves/Rejects

**Approve**:
```bash
POST /api/admin/approve/user@example.com
Headers:
  X-Admin-API-Key: your_admin_key
  Content-Type: application/json

Body:
{
  "note": "Payment verified, welcome aboard!"
}

Response:
{
  "success": true,
  "userId": "user@example.com",
  "status": "active",
  "emailSent": true,
  "message": "User approved and notified"
}
```

User receives confirmation email with access token.

**Reject** (optional):
```bash
POST /api/admin/reject/user@example.com
Headers:
  X-Admin-API-Key: your_admin_key
  Content-Type: application/json

Body:
{
  "reason": "Payment declined"
}
```

## User Status States

- **pending** - Awaiting manual confirmation
- **active** - Approved, can access phext space
- **rejected** - Denied access
- **suspended** - Temporarily disabled (future use)

Status changes are logged in audit trail.

## Isolated Phext Space

Each user gets their own coordinate triangle:
- **Home**: Primary coordinate (user's root)
- **Aspiration**: Future goals/expansion
- **Lineage**: Historical/inherited coordinates

User data stored at home coordinate in `users` phext.

All user content is isolated within their triangle - no cross-user data access without explicit coordination.

## Testing

### 1. Test Email Service
```javascript
const { createEmailService } = require('./lib/email-service');

async function test() {
  const emailService = createEmailService();
  
  // Test connection
  const result = await emailService.testConnection();
  console.log(result);
  
  // Test dual emails
  const emails = await emailService.sendSignupEmails({
    email: 'test@example.com',
    coordinate: '1.1.1/1.1.1/1.1.1',
    tier: 'free',
    triangle: {
      home: '1.1.1/1.1.1/1.1.1',
      aspiration: '2.2.2/2.2.2/2.2.2',
      lineage: '3.3.3/3.3.3/3.3.3'
    }
  });
  
  console.log(emails);
}

test();
```

### 2. Test Signup Flow
```bash
# Start server in dev mode (console emails)
cd /source/sq-admin-api
node server.js

# In another terminal
curl -X POST http://localhost:3000/api/signup/triangle \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "triangle": {
      "home": "1.1.1/1.1.1/1.1.1",
      "aspiration": "2.2.2/2.2.2/2.2.2",
      "lineage": "3.3.3/3.3.3/3.3.3"
    }
  }'
  
# Check terminal for dual email output
```

### 3. Test Admin Approval
```bash
# List pending
curl http://localhost:3000/api/admin/pending \
  -H "X-Admin-API-Key: CHANGE_THIS_IN_PRODUCTION"

# Approve user
curl -X POST http://localhost:3000/api/admin/approve/test@example.com \
  -H "X-Admin-API-Key: CHANGE_THIS_IN_PRODUCTION" \
  -H "Content-Type: application/json" \
  -d '{"note": "Test approval"}'
```

## Production Checklist

- [ ] Install dependencies (`npm install`)
- [ ] Configure AWS SES (verify sender email)
- [ ] Set environment variables (see above)
- [ ] Set strong `ADMIN_API_KEY`
- [ ] Test email delivery
- [ ] Integrate routes into `server.js`
- [ ] Deploy backend
- [ ] Update frontend to handle 'pending' status
- [ ] Create `/signup-pending` page
- [ ] Test full flow end-to-end

## Next Steps

1. **Frontend**: Update coordinate-signup.html to handle 'pending' response
2. **Page**: Create `/signup-pending.html` (waiting for confirmation)
3. **Dashboard**: Check user status before granting access
4. **Admin UI**: Build approval interface (or use curl for now)
5. **SES**: Verify production email addresses
6. **Monitoring**: Log all approval actions

## Security Notes

- Admin API key should be strong and rotated regularly
- Store API key in environment variable (never commit to repo)
- Rate limit signup endpoint to prevent abuse
- Validate email addresses before signup
- Log all admin actions to audit trail
- Consider 2FA for admin approval actions (future)

## Files Summary

| File | Size | Purpose |
|------|------|---------|
| `lib/email-service.js` | 7.6 KB | Dual-email notifications |
| `routes/admin-approvals.js` | 5.7 KB | Admin approval endpoints |
| `routes/signup-sq.js` | Updated | Signup with email notifications |
| `lib/sq-backend.js` | Updated | Status tracking + audit methods |
| `package.json` | Updated | Added nodemailer + aws-sdk |

**Total**: ~13 KB of new code + updates to existing files

## Support

Questions? Issues?
- Check console logs for email send failures
- Verify AWS SES sandbox restrictions
- Test with known email addresses first
- Reach out to will@phext.io for AWS SES access

---

R18 Email Signup: Dual notifications + manual confirmation + isolated phext spaces ✅
