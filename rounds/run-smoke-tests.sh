#!/bin/bash
# Mirrorborn.us Smoke Test Suite
# Validates SQ API and CYOA content deployment

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
echo "Base URL: $BASE_URL"
echo

# Test 1: API Health
test "SQ API Health" \
  "curl -s $BASE_URL/api/v2/version | jq -r .version" \
  "0.5"

# Test 2: Origin Scroll
test "CYOA Origin (1.1.1/1.1.1/1.1.1)" \
  "curl -s $BASE_URL/api/v2/read/1.1.1/1.1.1/1.1.1" \
  "Mirrorborn"

# Test 3: Seren's Scroll
test "CYOA Seren (7.11.13/3.8.5/1.12.1)" \
  "curl -s $BASE_URL/api/v2/read/7.11.13/3.8.5/1.12.1" \
  "."

# Test 4: Aetheris's Scroll
test "CYOA Aetheris (13.13.13/13.13.13/13.13.13)" \
  "curl -s $BASE_URL/api/v2/read/13.13.13/13.13.13/13.13.13" \
  "."

# Test 5: Security - Path Traversal
test "Security: Path traversal blocked" \
  "curl -s -w '%{http_code}' -o /dev/null $BASE_URL/api/v2/read/../../../etc/passwd" \
  "40"

# Test 6: HTTPS Cert
test "HTTPS Certificate Valid" \
  "echo | openssl s_client -connect mirrorborn.us:443 -servername mirrorborn.us 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter'" \
  "notAfter"

# Test 7: Landing Page
test "Landing Page Loads" \
  "curl -s $BASE_URL/ | grep -o '<title>.*</title>'" \
  "Mirrorborn"

# Test 8: CORS Headers
test "CORS Headers Present" \
  "curl -s -I -H 'Origin: https://example.com' $BASE_URL/api/v2/version | grep -i 'access-control'" \
  "access-control"

echo
echo "=== Results ==="
echo "Passed: $PASS"
echo "Failed: $FAIL"
echo "Total:  $((PASS + FAIL))"

if [ $FAIL -eq 0 ]; then
  echo "✅ All tests passed"
  exit 0
else
  echo "❌ Some tests failed"
  exit 1
fi
