// Security Implementation Tests
// Author: Cyon 🪶
// R17 Security Work

const assert = require('assert');
const { RateLimiter, TokenVerificationLimiter } = require('./rate-limiting');
const { CSRFProtection, MagicLinkCSRF } = require('./csrf-protection');

/**
 * Test suite for rate limiting
 */
function testRateLimiting() {
  console.log('\n=== Testing Rate Limiting ===\n');
  
  const limiter = new RateLimiter({
    emailLimit: 3,
    ipLimit: 5,
    windowMs: 1000 // 1 second for faster testing
  });
  
  // Test 1: Allow first 3 requests for same email
  console.log('Test 1: Email rate limiting (3 requests allowed)');
  for (let i = 0; i < 3; i++) {
    const result = limiter.checkLimit('test@example.com', '192.168.1.1');
    assert(result.allowed, `Request ${i+1} should be allowed`);
    limiter.recordRequest('test@example.com', '192.168.1.1');
  }
  console.log('✓ First 3 requests allowed');
  
  // Test 2: Block 4th request
  console.log('\nTest 2: Block 4th request (email limit exceeded)');
  const blocked = limiter.checkLimit('test@example.com', '192.168.1.1');
  assert(!blocked.allowed, 'Fourth request should be blocked');
  assert(blocked.reason === 'email_limit_exceeded', 'Should indicate email limit');
  assert(blocked.retryAfter > 0, 'Should provide retry-after time');
  console.log(`✓ Request blocked, retry after ${blocked.retryAfter}s`);
  
  // Test 3: Different email should still work
  console.log('\nTest 3: Different email not affected by limit');
  const differentEmail = limiter.checkLimit('other@example.com', '192.168.1.1');
  assert(differentEmail.allowed, 'Different email should be allowed');
  console.log('✓ Different email allowed');
  
  // Test 4: IP rate limiting
  console.log('\nTest 4: IP rate limiting (5 requests allowed)');
  for (let i = 0; i < 5; i++) {
    const result = limiter.checkLimit(`user${i}@example.com`, '192.168.1.100');
    assert(result.allowed, `IP request ${i+1} should be allowed`);
    limiter.recordRequest(`user${i}@example.com`, '192.168.1.100');
  }
  const ipBlocked = limiter.checkLimit('user6@example.com', '192.168.1.100');
  assert(!ipBlocked.allowed, 'Sixth request from same IP should be blocked');
  assert(ipBlocked.reason === 'ip_limit_exceeded', 'Should indicate IP limit');
  console.log('✓ IP rate limiting works');
  
  // Test 5: Cleanup
  console.log('\nTest 5: Cleanup expired entries');
  const statsBefore = limiter.getStats();
  setTimeout(() => {
    limiter.cleanup();
    const statsAfter = limiter.getStats();
    console.log(`✓ Cleanup: ${statsBefore.totalTracked} → ${statsAfter.totalTracked} entries`);
  }, 1100); // After 1-second window expires
  
  console.log('\n✅ Rate limiting tests passed\n');
}

/**
 * Test suite for token verification limiter
 */
function testTokenVerification() {
  console.log('\n=== Testing Token Verification Limiter ===\n');
  
  const verifier = new TokenVerificationLimiter();
  
  // Test 1: Allow first 5 attempts (then block on consecutive invalid)
  console.log('Test 1: Allow first 5 verification attempts (consecutive invalid limit)');
  for (let i = 0; i < 5; i++) {
    const result = verifier.isBlocked('192.168.1.200');
    assert(!result.blocked, `Attempt ${i+1} should be allowed`);
    verifier.recordAttempt('192.168.1.200', false);
  }
  console.log('✓ First 5 attempts allowed');
  
  // Test 2: Block after 5 consecutive invalid
  console.log('\nTest 2: Block after 5 consecutive failed attempts');
  const blocked = verifier.isBlocked('192.168.1.200');
  assert(blocked.blocked, 'Should be blocked after 5 consecutive invalid');
  assert(blocked.retryAfter > 0, 'Should provide retry time');
  console.log(`✓ IP blocked for ${blocked.retryAfter}s`);
  
  // Test 3: Block after 5 consecutive invalid attempts
  console.log('\nTest 3: Block after 5 consecutive invalid attempts');
  for (let i = 0; i < 5; i++) {
    verifier.recordAttempt('192.168.1.201', false);
  }
  const consecutiveBlocked = verifier.isBlocked('192.168.1.201');
  assert(consecutiveBlocked.blocked, 'Should be blocked after 5 invalid attempts');
  console.log('✓ Consecutive invalid attempts trigger block');
  
  // Test 4: Reset counter on success
  console.log('\nTest 4: Success resets invalid counter');
  verifier.recordAttempt('192.168.1.202', false);
  verifier.recordAttempt('192.168.1.202', false);
  verifier.recordAttempt('192.168.1.202', true); // Success
  verifier.recordAttempt('192.168.1.202', false);
  const notBlocked = verifier.isBlocked('192.168.1.202');
  assert(!notBlocked.blocked, 'Should not be blocked after successful attempt');
  console.log('✓ Success resets invalid counter');
  
  console.log('\n✅ Token verification tests passed\n');
}

/**
 * Test suite for CSRF protection
 */
function testCSRFProtection() {
  console.log('\n=== Testing CSRF Protection ===\n');
  
  const csrf = new CSRFProtection();
  
  // Test 1: Generate token
  console.log('Test 1: Generate CSRF token');
  const token1 = csrf.generateToken('session-123');
  assert(token1.length === 64, 'Token should be 64 characters (32 bytes hex)');
  console.log(`✓ Generated token: ${token1.substring(0, 16)}...`);
  
  // Test 2: Validate correct token
  console.log('\nTest 2: Validate correct token');
  const valid = csrf.validateToken(token1, 'session-123');
  assert(valid, 'Token should be valid for correct session');
  console.log('✓ Token validated successfully');
  
  // Test 3: Reject wrong session
  console.log('\nTest 3: Reject token for wrong session');
  const wrongSession = csrf.validateToken(token1, 'session-456');
  assert(!wrongSession, 'Token should be invalid for different session');
  console.log('✓ Wrong session rejected');
  
  // Test 4: Reject invalid token
  console.log('\nTest 4: Reject invalid token');
  const invalidToken = csrf.validateToken('fake-token-123', 'session-123');
  assert(!invalidToken, 'Invalid token should be rejected');
  console.log('✓ Invalid token rejected');
  
  // Test 5: Invalidate token
  console.log('\nTest 5: Invalidate token on logout');
  csrf.invalidateToken(token1);
  const afterInvalidate = csrf.validateToken(token1, 'session-123');
  assert(!afterInvalidate, 'Invalidated token should be rejected');
  console.log('✓ Token invalidated');
  
  console.log('\n✅ CSRF protection tests passed\n');
}

/**
 * Test suite for Magic Link CSRF
 */
function testMagicLinkCSRF() {
  console.log('\n=== Testing Magic Link CSRF ===\n');
  
  // Set secret for testing
  process.env.MAGIC_LINK_SECRET = 'test-secret-key-for-testing-only';
  
  // Test 1: Generate state
  console.log('Test 1: Generate magic link state');
  const state = MagicLinkCSRF.generateState('session-789', 'user@example.com');
  assert(state.includes('.'), 'State should contain signature separator');
  console.log(`✓ Generated state: ${state.substring(0, 32)}...`);
  
  // Test 2: Validate correct state
  console.log('\nTest 2: Validate correct state');
  const valid = MagicLinkCSRF.validateState(state, 'session-789', 'user@example.com');
  assert(valid, 'State should be valid for correct session and email');
  console.log('✓ State validated');
  
  // Test 3: Reject wrong session
  console.log('\nTest 3: Reject state for wrong session');
  const wrongSession = MagicLinkCSRF.validateState(state, 'session-999', 'user@example.com');
  assert(!wrongSession, 'State should be invalid for different session');
  console.log('✓ Wrong session rejected');
  
  // Test 4: Reject wrong email
  console.log('\nTest 4: Reject state for wrong email');
  const wrongEmail = MagicLinkCSRF.validateState(state, 'session-789', 'other@example.com');
  assert(!wrongEmail, 'State should be invalid for different email');
  console.log('✓ Wrong email rejected');
  
  // Test 5: Reject tampered state
  console.log('\nTest 5: Reject tampered state');
  const tampered = state.replace(/[a-f]/g, 'z');
  const tamperedValid = MagicLinkCSRF.validateState(tampered, 'session-789', 'user@example.com');
  assert(!tamperedValid, 'Tampered state should be rejected');
  console.log('✓ Tampered state rejected');
  
  console.log('\n✅ Magic Link CSRF tests passed\n');
}

/**
 * Run all tests
 */
function runAllTests() {
  console.log('╔════════════════════════════════════════╗');
  console.log('║   R17 Security Implementation Tests    ║');
  console.log('║          Cyon 🪶 Security Audit        ║');
  console.log('╚════════════════════════════════════════╝');
  
  try {
    testRateLimiting();
    testTokenVerification();
    testCSRFProtection();
    testMagicLinkCSRF();
    
    console.log('\n╔════════════════════════════════════════╗');
    console.log('║     ✅ ALL TESTS PASSED                 ║');
    console.log('╚════════════════════════════════════════╝\n');
    
    process.exit(0);
  } catch (err) {
    console.error('\n❌ TEST FAILED:', err.message);
    console.error(err.stack);
    process.exit(1);
  }
}

// Run tests if executed directly
if (require.main === module) {
  runAllTests();
}

module.exports = {
  testRateLimiting,
  testTokenVerification,
  testCSRFProtection,
  testMagicLinkCSRF,
  runAllTests
};
