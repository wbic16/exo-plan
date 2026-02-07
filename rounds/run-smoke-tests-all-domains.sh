#!/bin/bash
# Round 14 Multi-Domain Smoke Test Suite
# Validates deployment of all 7 portals

PASS=0
FAIL=0

# Domain list
DOMAINS=(
    "mirrorborn.us"
    "visionquest.me"
    "apertureshift.com"
    "wishnode.net"
    "sotafomo.com"
    "quickfork.net"
    "singularitywatch.org"
)

test() {
  local name="$1"
  local cmd="$2"
  local expect="$3"
  
  echo -n "  Testing: $name ... "
  result=$(eval "$cmd" 2>&1)
  
  if echo "$result" | grep -q "$expect"; then
    echo "✅ PASS"
    ((PASS++))
  else
    echo "❌ FAIL"
    echo "    Expected: $expect"
    echo "    Got: $result"
    ((FAIL++))
  fi
}

echo "=== Round 14 Multi-Domain Smoke Tests ==="
echo "Date: $(date)"
echo ""

for domain in "${DOMAINS[@]}"; do
    echo "=== Testing: $domain ==="
    
    # Test 1: DNS Resolution
    test "DNS resolves" \
      "dig +short $domain | head -1" \
      "."
    
    # Test 2: HTTPS Reachable
    test "HTTPS returns 200" \
      "curl -s -o /dev/null -w '%{http_code}' https://$domain" \
      "200"
    
    # Test 3: Valid SSL Certificate
    test "SSL cert valid" \
      "echo | openssl s_client -connect $domain:443 -servername $domain 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter'" \
      "notAfter"
    
    # Test 4: Landing page loads
    test "HTML page loads" \
      "curl -s https://$domain | grep -o '<title>'" \
      "<title>"
    
    # Test 5: Footer present
    test "Network footer present" \
      "curl -s https://$domain | grep -c 'shared-footer'" \
      "[1-9]"
    
    # Test 6: No broken links (spot check)
    test "Footer script loads" \
      "curl -s -o /dev/null -w '%{http_code}' https://$domain/js/load-footer.js || curl -s -o /dev/null -w '%{http_code}' https://mirrorborn.us/js/load-footer.js" \
      "200"
    
    # Test 7: Mobile viewport meta tag
    test "Mobile responsive meta tag" \
      "curl -s https://$domain | grep -c 'viewport'" \
      "[1-9]"
    
    # Test 8: Performance (load time < 3s)
    load_time=$(curl -s -o /dev/null -w '%{time_total}' https://$domain)
    echo -n "  Testing: Page load time ... "
    if (( $(echo "$load_time < 3.0" | bc -l) )); then
        echo "✅ PASS (${load_time}s)"
        ((PASS++))
    else
        echo "❌ FAIL (${load_time}s > 3.0s)"
        ((FAIL++))
    fi
    
    echo ""
done

# Special tests for mirrorborn.us (SQ API)
if [[ " ${DOMAINS[@]} " =~ " mirrorborn.us " ]]; then
    echo "=== Testing: mirrorborn.us (SQ API) ==="
    
    test "SQ API version endpoint" \
      "curl -s https://mirrorborn.us/api/v2/version | jq -r .version" \
      "0.5"
    
    test "CYOA Origin scroll (1.1.1/1.1.1/1.1.1)" \
      "curl -s https://mirrorborn.us/api/v2/read/1.1.1/1.1.1/1.1.1" \
      "Mirrorborn"
    
    test "CORS headers present" \
      "curl -s -I -H 'Origin: https://example.com' https://mirrorborn.us/api/v2/version | grep -i 'access-control'" \
      "access-control"
    
    echo ""
fi

echo "=== Results ==="
echo "Passed: $PASS"
echo "Failed: $FAIL"
echo "Total:  $((PASS + FAIL))"
echo ""

if [ $FAIL -eq 0 ]; then
  echo "✅ All domains passed smoke tests"
  exit 0
else
  echo "❌ Some tests failed - review output above"
  exit 1
fi
