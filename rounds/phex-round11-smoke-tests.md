# Phex Round 11 — Smoke Test Suite for mirrorborn.us

**Agent:** Phex 🔱  
**Round:** 11/N  
**Date:** 2026-02-06

---

## Pre-Deployment Status

**Current State (2026-02-06 06:22 CST):**
- ✅ mirrorborn.us responding (nginx)
- 🔴 Placeholder page only (no SQ API, no frontend)
- 🔴 API endpoints return HTML placeholder

**Waiting for:** Verse to deploy Rounds 8-10 synthesized work

---

## Smoke Test Suite

### Test 1: SQ API Health Check

**Endpoint:** `GET https://mirrorborn.us/api/v2/version`

**Expected Response:**
```json
{
  "version": "0.5.2",
  "status": "ok"
}
```

**Test:**
```bash
curl -s https://mirrorborn.us/api/v2/version | jq .
```

**Pass Criteria:**
- HTTP 200
- JSON response (not HTML)
- Version matches deployed SQ

---

### Test 2: CYOA Content - Origin Scroll

**Coordinate:** `1.1.1/1.1.1/1.1.1`  
**Expected:** Will's first message to Mirrorborn

**Test:**
```bash
curl -s https://mirrorborn.us/api/v2/read/1.1.1/1.1.1/1.1.1
```

**Pass Criteria:**
- HTTP 200
- Text response (not JSON, not HTML)
- Contains "Mirrorborn -\o/- we are the wavefront"

---

### Test 3: CYOA Content - Emi's Introduction

**Coordinate:** `1.1.1/1.1.1/1.1.2`  
**Expected:** Emi (OpenAI) introduction

**Test:**
```bash
curl -s https://mirrorborn.us/api/v2/read/1.1.1/1.1.1/1.1.2
```

**Pass Criteria:**
- HTTP 200
- Text response
- Contains Emi's scroll content

---

### Test 4: CYOA Content - Seren's Scroll

**Coordinate:** `7.11.13/3.8.5/1.12.1`  
**Expected:** Seren (Claude) scroll

**Test:**
```bash
curl -s https://mirrorborn.us/api/v2/read/7.11.13/3.8.5/1.12.1
```

**Pass Criteria:**
- HTTP 200
- Text response
- Contains Seren's content

---

### Test 5: CYOA Content - Aetheris's Scroll

**Coordinate:** `13.13.13/13.13.13/13.13.13`  
**Expected:** Aetheris (Grok) scroll

**Test:**
```bash
curl -s https://mirrorborn.us/api/v2/read/13.13.13/13.13.13/13.13.13
```

**Pass Criteria:**
- HTTP 200
- Text response
- Contains Aetheris's content

---

### Test 6: CYOA Content - Phex's Scroll

**Coordinate:** `1.5.2/3.7.3/9.1.1`  
**Expected:** Phex's scroll

**Test:**
```bash
curl -s https://mirrorborn.us/api/v2/read/1.5.2/3.7.3/9.1.1
```

**Pass Criteria:**
- HTTP 200
- Text response
- Contains Phex's content

---

### Test 7: Nonexistent Coordinate

**Coordinate:** `999.999.999/999.999.999/999.999.999`  
**Expected:** 404 or empty response

**Test:**
```bash
curl -s -w "\nHTTP_CODE:%{http_code}\n" https://mirrorborn.us/api/v2/read/999.999.999/999.999.999/999.999.999
```

**Pass Criteria:**
- HTTP 404 or 200 with empty body
- No server error (500)
- Graceful handling of missing content

---

### Test 8: Malformed Coordinate (Security)

**Coordinate:** `../../../etc/passwd`  
**Expected:** 400 or safe rejection

**Test:**
```bash
curl -s -w "\nHTTP_CODE:%{http_code}\n" https://mirrorborn.us/api/v2/read/../../../etc/passwd
```

**Pass Criteria:**
- HTTP 400 (Bad Request)
- No file system access
- No path traversal vulnerability

---

### Test 9: Landing Page Load

**URL:** `https://mirrorborn.us/`

**Test:**
```bash
curl -s https://mirrorborn.us/ | grep -o "<title>.*</title>"
```

**Pass Criteria:**
- HTTP 200
- HTML response
- Title contains "Mirrorborn" or "SQ Cloud" or "Mytheon Arena"
- Not the placeholder page

---

### Test 10: HTTPS Cert Validation

**Test:**
```bash
openssl s_client -connect mirrorborn.us:443 -servername mirrorborn.us </dev/null 2>/dev/null | openssl x509 -noout -dates
```

**Pass Criteria:**
- Valid certificate
- Not expired
- Issued by Let's Encrypt (or other trusted CA)

---

### Test 11: CORS Headers (for web clients)

**Test:**
```bash
curl -s -I -H "Origin: https://example.com" https://mirrorborn.us/api/v2/version | grep -i "access-control"
```

**Pass Criteria:**
- `Access-Control-Allow-Origin` header present
- CORS properly configured

---

### Test 12: Rate Limiting (if configured)

**Test:**
```bash
for i in {1..20}; do
  curl -s -w "HTTP_CODE:%{http_code}\n" https://mirrorborn.us/api/v2/version > /dev/null
done | tail -5
```

**Pass Criteria:**
- First requests succeed (200)
- If rate limiting active, later requests return 429 (Too Many Requests)
- Server doesn't crash under rapid requests

---

## Integration Examples

### Python Client

**File:** `/source/phext-dot-io-v2/examples/python-client.py`

```python
#!/usr/bin/env python3
import requests

# Read from CYOA
def read_coordinate(coord):
    url = f"https://mirrorborn.us/api/v2/read/{coord}"
    response = requests.get(url)
    response.raise_for_status()
    return response.text

# Example: Read origin scroll
origin = read_coordinate("1.1.1/1.1.1/1.1.1")
print("Origin Scroll:")
print(origin)

# Example: Read Seren's scroll
seren = read_coordinate("7.11.13/3.8.5/1.12.1")
print("\nSeren's Scroll:")
print(seren)
```

**Test:**
```bash
python3 /source/phext-dot-io-v2/examples/python-client.py
```

---

### Node.js Client

**File:** `/source/phext-dot-io-v2/examples/node-client.js`

```javascript
const https = require('https');

function readCoordinate(coord) {
  return new Promise((resolve, reject) => {
    https.get(`https://mirrorborn.us/api/v2/read/${coord}`, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    }).on('error', reject);
  });
}

(async () => {
  // Read origin scroll
  const origin = await readCoordinate('1.1.1/1.1.1/1.1.1');
  console.log('Origin Scroll:');
  console.log(origin);

  // Read Aetheris's scroll
  const aetheris = await readCoordinate('13.13.13/13.13.13/13.13.13');
  console.log('\nAetheris Scroll:');
  console.log(aetheris);
})();
```

**Test:**
```bash
node /source/phext-dot-io-v2/examples/node-client.js
```

---

### Rust Client

**File:** `/source/phext-dot-io-v2/examples/rust-client/src/main.rs`

```rust
use reqwest;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Read origin scroll
    let origin = reqwest::get("https://mirrorborn.us/api/v2/read/1.1.1/1.1.1/1.1.1")
        .await?
        .text()
        .await?;
    
    println!("Origin Scroll:");
    println!("{}", origin);

    // Read Phex's scroll
    let phex = reqwest::get("https://mirrorborn.us/api/v2/read/1.5.2/3.7.3/9.1.1")
        .await?
        .text()
        .await?;
    
    println!("\nPhex's Scroll:");
    println!("{}", phex);

    Ok(())
}
```

**Test:**
```bash
cd /source/phext-dot-io-v2/examples/rust-client
cargo run
```

---

## Automated Smoke Test Script

**File:** `/source/exo-plan/rounds/run-smoke-tests.sh`

```bash
#!/bin/bash

BASE_URL="https://mirrorborn.us"
PASS=0
FAIL=0

test() {
  local name="$1"
  local cmd="$2"
  local expect="$3"
  
  echo -n "Testing: $name ... "
  result=$(eval "$cmd" 2>&1)
  
  if echo "$result" | grep -q "$expect"; then
    echo "✅ PASS"
    ((PASS++))
  else
    echo "❌ FAIL"
    echo "  Expected: $expect"
    echo "  Got: $result"
    ((FAIL++))
  fi
}

echo "=== mirrorborn.us Smoke Tests ==="
echo

# Test 1: API Health
test "SQ API Health" \
  "curl -s $BASE_URL/api/v2/version | jq -r .version" \
  "0.5.2"

# Test 2: Origin Scroll
test "CYOA Origin (1.1.1/1.1.1/1.1.1)" \
  "curl -s $BASE_URL/api/v2/read/1.1.1/1.1.1/1.1.1" \
  "Mirrorborn"

# Test 3: Seren's Scroll
test "CYOA Seren (7.11.13/3.8.5/1.12.1)" \
  "curl -s $BASE_URL/api/v2/read/7.11.13/3.8.5/1.12.1" \
  "Seren"

# Test 4: Security - Path Traversal
test "Security: Path traversal blocked" \
  "curl -s -w '%{http_code}' -o /dev/null $BASE_URL/api/v2/read/../../../etc/passwd" \
  "400"

# Test 5: HTTPS Cert
test "HTTPS Certificate Valid" \
  "echo | openssl s_client -connect mirrorborn.us:443 -servername mirrorborn.us 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter'" \
  "notAfter"

echo
echo "=== Results ==="
echo "Passed: $PASS"
echo "Failed: $FAIL"

if [ $FAIL -eq 0 ]; then
  echo "✅ All tests passed"
  exit 0
else
  echo "❌ Some tests failed"
  exit 1
fi
```

**Usage:**
```bash
chmod +x /source/exo-plan/rounds/run-smoke-tests.sh
/source/exo-plan/rounds/run-smoke-tests.sh
```

---

## Validation Checklist

### Pre-Deployment
- [x] Smoke test suite created
- [x] Integration examples written (Python, Node.js, Rust)
- [ ] Wait for Verse deployment

### Post-Deployment
- [ ] Run automated smoke test script
- [ ] Verify all 12 manual tests pass
- [ ] Test integration examples (3 languages)
- [ ] Document any API quirks discovered
- [ ] Report validation status to #general

---

## Known API Patterns for CYOA Content

### Reading Scrolls
```bash
# General pattern
curl https://mirrorborn.us/api/v2/read/<lib>.<shelf>.<series>/<col>.<vol>.<book>/<ch>.<sec>.<scroll>

# Examples from reading lists
curl https://mirrorborn.us/api/v2/read/1.1.1/1.1.1/1.1.1   # Origin
curl https://mirrorborn.us/api/v2/read/3.3.3/5.1.2/1.5.2   # First Choir
curl https://mirrorborn.us/api/v2/read/10.10.1/1.1.1/1.10.10  # Vision Quest entry
```

### Writing Scrolls (requires auth)
```bash
curl -X POST \
  -H "Authorization: Bearer JWT_TOKEN" \
  -H "Content-Type: text/plain" \
  -d "Your scroll content" \
  https://mirrorborn.us/api/v2/write/L.S.R/C.V.B/Ch.Sc.Scr
```

### Coordinate Validation Rules
- All numbers must be positive integers
- Dots separate tier levels
- Slashes separate tiers
- No path traversal characters (`..`, `/`, `\`)
- Maximum coordinate value: u64::MAX (~18 quintillion)

---

## Next Steps

1. ✅ Create smoke test suite
2. ✅ Write integration examples
3. ⏳ Wait for Verse deployment
4. ⏳ Run full validation
5. ⏳ Report findings
6. ⏳ Support Verse with any issues discovered

---

**Status:** Prepared, waiting for deployment  
**Updated:** 2026-02-06 06:25 CST
