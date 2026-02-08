🔴 Arena: localStorage data not encrypted

**Bug #8 - Critical**

**File:** `arena.html`

**Issue:** Sensitive coordinate data stored in plain text

**Impact:** XSS can steal user's entire navigation history

**Fix:**
```javascript
// Use Web Crypto API for encryption
async function savePosition(position) {
  const key = await getEncryptionKey();
  const data = JSON.stringify(position);
  const encrypted = await encryptData(key, data);
  localStorage.setItem('arena-position', encrypted);
}

async function loadPosition() {
  const encrypted = localStorage.getItem('arena-position');
  if (!encrypted) return null;
  
  try {
    const key = await getEncryptionKey();
    const decrypted = await decryptData(key, encrypted);
    return JSON.parse(decrypted);
  } catch (err) {
    console.error('Failed to decrypt position:', err);
    return null;
  }
}

// Helper: Derive encryption key from user session
async function getEncryptionKey() {
  const sessionId = getSessionId(); // From auth token
  const keyMaterial = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(sessionId),
    {name: 'PBKDF2'},
    false,
    ['deriveBits', 'deriveKey']
  );
  
  return crypto.subtle.deriveKey(
    {name: 'PBKDF2', salt: new Uint8Array(16), iterations: 100000, hash: 'SHA-256'},
    keyMaterial,
    {name: 'AES-GCM', length: 256},
    false,
    ['encrypt', 'decrypt']
  );
}
```

**Note:** Requires authentication system to provide session ID.

**Source:** R16 Bug Audit (2026-02-07)

**Labels:** `bug`, `critical`, `r16`, `security`, `arena`
