// CSRF Protection for Magic Link Auth
// Author: Cyon 🪶
// R17 Security Work

const crypto = require('crypto');

/**
 * CSRF Token Manager
 * Generates and validates tokens to prevent cross-site request forgery
 */
class CSRFProtection {
  constructor(options = {}) {
    this.tokenLength = options.tokenLength || 32;
    this.cookieName = options.cookieName || 'csrf_token';
    this.headerName = options.headerName || 'X-CSRF-Token';
    this.tokenExpiry = options.tokenExpiry || 24 * 60 * 60 * 1000; // 24 hours
    
    // In-memory store (production should use Redis or database)
    this.tokens = new Map(); // token -> {created, sessionId}
    
    // Cleanup expired tokens every hour
    setInterval(() => this.cleanup(), 60 * 60 * 1000);
  }
  
  /**
   * Generate a new CSRF token
   * @param {string} sessionId - Session identifier
   * @returns {string} CSRF token
   */
  generateToken(sessionId) {
    const token = crypto.randomBytes(this.tokenLength).toString('hex');
    
    this.tokens.set(token, {
      created: Date.now(),
      sessionId: sessionId
    });
    
    return token;
  }
  
  /**
   * Validate CSRF token
   * @param {string} token - Token from request
   * @param {string} sessionId - Current session ID
   * @returns {boolean} Valid or not
   */
  validateToken(token, sessionId) {
    if (!token || !sessionId) {
      return false;
    }
    
    const data = this.tokens.get(token);
    if (!data) {
      return false; // Token not found
    }
    
    // Check expiry
    const now = Date.now();
    if (now - data.created > this.tokenExpiry) {
      this.tokens.delete(token);
      return false;
    }
    
    // Check session binding
    if (data.sessionId !== sessionId) {
      return false;
    }
    
    return true;
  }
  
  /**
   * Invalidate a token (e.g., on logout)
   */
  invalidateToken(token) {
    this.tokens.delete(token);
  }
  
  /**
   * Remove expired tokens
   */
  cleanup() {
    const now = Date.now();
    for (const [token, data] of this.tokens.entries()) {
      if (now - data.created > this.tokenExpiry) {
        this.tokens.delete(token);
      }
    }
  }
}

/**
 * Express middleware to add CSRF token to response
 */
function csrfTokenMiddleware(csrfProtection) {
  return (req, res, next) => {
    // Generate token if not present
    if (!req.session.csrfToken) {
      const token = csrfProtection.generateToken(req.sessionID);
      req.session.csrfToken = token;
    }
    
    // Expose token to templates
    res.locals.csrfToken = req.session.csrfToken;
    
    // Set cookie for client-side access
    res.cookie(csrfProtection.cookieName, req.session.csrfToken, {
      httpOnly: false, // Needs to be readable by JS
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict'
    });
    
    next();
  };
}

/**
 * Express middleware to validate CSRF token on state-changing requests
 */
function csrfValidationMiddleware(csrfProtection) {
  return (req, res, next) => {
    // Skip validation for safe methods
    if (['GET', 'HEAD', 'OPTIONS'].includes(req.method)) {
      return next();
    }
    
    // Get token from header or body
    const token = req.get(csrfProtection.headerName) || 
                  req.body._csrf || 
                  req.query._csrf;
    
    // Validate token
    if (!csrfProtection.validateToken(token, req.sessionID)) {
      return res.status(403).json({
        error: 'Invalid CSRF token',
        code: 'CSRF_VALIDATION_FAILED'
      });
    }
    
    next();
  };
}

/**
 * Magic Link CSRF Protection
 * Special handling for magic links to prevent CSRF via URL manipulation
 */
class MagicLinkCSRF {
  /**
   * Generate state parameter for magic link
   * Binds magic link to originating session
   */
  static generateState(sessionId, email) {
    const payload = JSON.stringify({
      sessionId,
      email,
      timestamp: Date.now()
    });
    
    // Sign the payload
    const hmac = crypto.createHmac('sha256', process.env.MAGIC_LINK_SECRET);
    hmac.update(payload);
    const signature = hmac.digest('hex');
    
    // Encode as URL-safe base64
    const state = Buffer.from(payload).toString('base64url');
    return `${state}.${signature}`;
  }
  
  /**
   * Validate state parameter from magic link callback
   */
  static validateState(state, sessionId, email) {
    if (!state) return false;
    
    const [encodedPayload, signature] = state.split('.');
    if (!encodedPayload || !signature) return false;
    
    try {
      // Decode payload
      const payload = Buffer.from(encodedPayload, 'base64url').toString('utf8');
      const data = JSON.parse(payload);
      
      // Verify signature
      const hmac = crypto.createHmac('sha256', process.env.MAGIC_LINK_SECRET);
      hmac.update(payload);
      const expectedSignature = hmac.digest('hex');
      
      if (signature !== expectedSignature) {
        return false; // Signature mismatch
      }
      
      // Check expiry (15 minutes)
      const now = Date.now();
      if (now - data.timestamp > 15 * 60 * 1000) {
        return false; // Expired
      }
      
      // Verify session and email match
      if (data.sessionId !== sessionId || data.email !== email) {
        return false; // Session/email mismatch
      }
      
      return true;
    } catch (err) {
      return false; // Invalid state format
    }
  }
}

/**
 * SameSite Cookie Configuration
 * Additional CSRF protection via cookie attributes
 */
const SECURE_COOKIE_OPTIONS = {
  httpOnly: true,      // Prevent XSS access
  secure: true,        // HTTPS only
  sameSite: 'strict',  // Prevent CSRF
  maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days
  path: '/'
};

module.exports = {
  CSRFProtection,
  csrfTokenMiddleware,
  csrfValidationMiddleware,
  MagicLinkCSRF,
  SECURE_COOKIE_OPTIONS
};

// Example usage:
/*
const { CSRFProtection, csrfTokenMiddleware, csrfValidationMiddleware } = require('./csrf-protection');

const csrf = new CSRFProtection();

// Add token to all responses
app.use(csrfTokenMiddleware(csrf));

// Validate on state-changing requests
app.use(csrfValidationMiddleware(csrf));

// In login form HTML:
<input type="hidden" name="_csrf" value="<%= csrfToken %>">

// Or in fetch() headers:
headers: {
  'X-CSRF-Token': document.cookie.match(/csrf_token=([^;]+)/)[1]
}
*/
