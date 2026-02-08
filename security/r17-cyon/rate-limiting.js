// Rate Limiting Implementation for Magic Link Auth
// Author: Cyon 🪶
// R17 Security Work

const crypto = require('crypto');

/**
 * In-memory rate limiter (production should use Redis)
 * Tracks request counts per email and IP address
 */
class RateLimiter {
  constructor(options = {}) {
    this.emailLimit = options.emailLimit || 3; // requests per window
    this.ipLimit = options.ipLimit || 10;
    this.windowMs = options.windowMs || 60 * 60 * 1000; // 1 hour
    
    this.emailStore = new Map(); // email -> {count, resetAt}
    this.ipStore = new Map();     // ip -> {count, resetAt}
    
    // Cleanup expired entries every 5 minutes
    setInterval(() => this.cleanup(), 5 * 60 * 1000);
  }
  
  /**
   * Check if request is allowed
   * @param {string} email - User email
   * @param {string} ip - Request IP address
   * @returns {Object} {allowed: boolean, retryAfter: number}
   */
  checkLimit(email, ip) {
    const now = Date.now();
    
    // Check email rate limit
    const emailData = this.emailStore.get(email);
    if (emailData) {
      if (now < emailData.resetAt) {
        if (emailData.count >= this.emailLimit) {
          return {
            allowed: false,
            retryAfter: Math.ceil((emailData.resetAt - now) / 1000),
            reason: 'email_limit_exceeded'
          };
        }
      } else {
        // Window expired, reset counter
        this.emailStore.delete(email);
      }
    }
    
    // Check IP rate limit
    const ipData = this.ipStore.get(ip);
    if (ipData) {
      if (now < ipData.resetAt) {
        if (ipData.count >= this.ipLimit) {
          return {
            allowed: false,
            retryAfter: Math.ceil((ipData.resetAt - now) / 1000),
            reason: 'ip_limit_exceeded'
          };
        }
      } else {
        // Window expired, reset counter
        this.ipStore.delete(ip);
      }
    }
    
    return { allowed: true };
  }
  
  /**
   * Record a successful request
   * @param {string} email - User email
   * @param {string} ip - Request IP address
   */
  recordRequest(email, ip) {
    const now = Date.now();
    const resetAt = now + this.windowMs;
    
    // Update email counter
    const emailData = this.emailStore.get(email);
    if (emailData && now < emailData.resetAt) {
      emailData.count++;
    } else {
      this.emailStore.set(email, { count: 1, resetAt });
    }
    
    // Update IP counter
    const ipData = this.ipStore.get(ip);
    if (ipData && now < ipData.resetAt) {
      ipData.count++;
    } else {
      this.ipStore.set(ip, { count: 1, resetAt });
    }
  }
  
  /**
   * Remove expired entries to prevent memory bloat
   */
  cleanup() {
    const now = Date.now();
    
    for (const [email, data] of this.emailStore.entries()) {
      if (now >= data.resetAt) {
        this.emailStore.delete(email);
      }
    }
    
    for (const [ip, data] of this.ipStore.entries()) {
      if (now >= data.resetAt) {
        this.ipStore.delete(ip);
      }
    }
  }
  
  /**
   * Get current stats (for monitoring)
   */
  getStats() {
    return {
      emailEntries: this.emailStore.size,
      ipEntries: this.ipStore.size,
      totalTracked: this.emailStore.size + this.ipStore.size
    };
  }
}

/**
 * Express middleware for rate limiting magic link requests
 */
function rateLimitMiddleware(limiter) {
  return (req, res, next) => {
    const email = req.body.email;
    const ip = req.ip || req.connection.remoteAddress;
    
    if (!email) {
      return res.status(400).json({ error: 'Email required' });
    }
    
    const result = limiter.checkLimit(email, ip);
    
    if (!result.allowed) {
      return res.status(429).json({
        error: 'Too many requests',
        retryAfter: result.retryAfter,
        reason: result.reason
      });
    }
    
    // Record this request
    limiter.recordRequest(email, ip);
    
    next();
  };
}

/**
 * Token verification rate limiter (prevent brute force)
 */
class TokenVerificationLimiter {
  constructor() {
    this.ipAttempts = new Map(); // ip -> {count, resetAt, blockedUntil}
    this.maxAttempts = 10; // per minute
    this.windowMs = 60 * 1000; // 1 minute
    this.blockDurationMs = 15 * 60 * 1000; // 15 minutes
    
    setInterval(() => this.cleanup(), 5 * 60 * 1000);
  }
  
  /**
   * Check if IP is blocked
   */
  isBlocked(ip) {
    const data = this.ipAttempts.get(ip);
    if (!data) return { blocked: false };
    
    const now = Date.now();
    
    // Check if currently blocked
    if (data.blockedUntil && now < data.blockedUntil) {
      return {
        blocked: true,
        retryAfter: Math.ceil((data.blockedUntil - now) / 1000)
      };
    }
    
    // Check if window expired
    if (now >= data.resetAt) {
      // Window expired, reset
      this.ipAttempts.delete(ip);
      return { blocked: false };
    }
    
    // Check rate limit (block on NEXT attempt after limit)
    if (data.count >= this.maxAttempts) {
      // Block this IP
      data.blockedUntil = now + this.blockDurationMs;
      return {
        blocked: true,
        retryAfter: Math.ceil(this.blockDurationMs / 1000)
      };
    }
    
    return { blocked: false };
  }
  
  /**
   * Record token verification attempt
   */
  recordAttempt(ip, success = false) {
    const now = Date.now();
    const data = this.ipAttempts.get(ip);
    
    if (data && now < data.resetAt) {
      data.count++;
      if (!success) {
        data.invalidCount = (data.invalidCount || 0) + 1;
        
        // Block after 5 consecutive invalid attempts
        if (data.invalidCount >= 5) {
          data.blockedUntil = now + this.blockDurationMs;
        }
      } else {
        data.invalidCount = 0; // Reset on success
      }
    } else {
      this.ipAttempts.set(ip, {
        count: 1,
        resetAt: now + this.windowMs,
        invalidCount: success ? 0 : 1
      });
    }
  }
  
  cleanup() {
    const now = Date.now();
    for (const [ip, data] of this.ipAttempts.entries()) {
      if (now >= data.resetAt && (!data.blockedUntil || now >= data.blockedUntil)) {
        this.ipAttempts.delete(ip);
      }
    }
  }
}

// Export for use in API routes
module.exports = {
  RateLimiter,
  rateLimitMiddleware,
  TokenVerificationLimiter
};

// Example usage:
/*
const { RateLimiter, rateLimitMiddleware } = require('./rate-limiting');

const limiter = new RateLimiter({
  emailLimit: 3,
  ipLimit: 10,
  windowMs: 60 * 60 * 1000 // 1 hour
});

app.post('/api/v2/auth/magic-link/request', 
  rateLimitMiddleware(limiter),
  async (req, res) => {
    // Handle magic link request
  }
);
*/
