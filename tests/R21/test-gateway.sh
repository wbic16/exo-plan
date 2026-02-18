#!/usr/bin/env bash
# R21 Phase 4 — Gateway integration tests
set -uo pipefail

SQ_BIN="/source/SQ/target/release/sq"
GW_DIR="/source/SQ/gateway"
TEST_DIR="/tmp/r21-test"
PASS=0; FAIL=0

cleanup() {
    kill "$SQ_PID" "$GW_PID" 2>/dev/null || true
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

assert_eq() {
    local label="$1" expected="$2" actual="$3"
    if [ "$expected" = "$actual" ]; then
        echo "  PASS: $label"; ((PASS++))
    else
        echo "  FAIL: $label (expected='$expected', got='$actual')"; ((FAIL++))
    fi
}

assert_contains() {
    local label="$1" needle="$2" haystack="$3"
    if echo "$haystack" | grep -q "$needle"; then
        echo "  PASS: $label"; ((PASS++))
    else
        echo "  FAIL: $label (expected to contain '$needle')"; ((FAIL++))
    fi
}

assert_status() {
    local label="$1" expected="$2" url="$3"; shift 3
    local code
    code=$(curl -s -o /dev/null -w '%{http_code}' "$@" "$url")
    assert_eq "$label" "$expected" "$code"
}

# Setup
echo "=== R21 Gateway Tests ==="
mkdir -p "$TEST_DIR/data/testuser"

# Write test config
cat > "$TEST_DIR/sq-gateway.toml" <<EOF
[gateway]
listen_port = 9080
admin_key = "admin-secret"

[[tenants]]
token = "test-token-123"
name = "testuser"
port = 9337
phext = "testuser"
EOF

# Start SQ instance
$SQ_BIN host 9337 --key "test-token-123" --data-dir "$TEST_DIR/data/testuser" &
SQ_PID=$!
sleep 1

# Start gateway
SQ_GATEWAY_CONFIG="$TEST_DIR/sq-gateway.toml" python3 "$GW_DIR/sq-gateway.py" 9080 &
GW_PID=$!
sleep 1

echo ""
echo "--- Test 1: Health endpoint (no auth) ---"
HEALTH=$(curl -s http://127.0.0.1:9080/health)
assert_contains "health returns ok" '"ok"' "$HEALTH"
assert_contains "health shows tenant count" 'tenants' "$HEALTH"

echo ""
echo "--- Test 2: Unauthorized (no token) ---"
assert_status "no token = 401" "401" "http://127.0.0.1:9080/api/v2/version?p=test"

echo ""
echo "--- Test 3: Unauthorized (bad token) ---"
assert_status "bad token = 401" "401" "http://127.0.0.1:9080/api/v2/version?p=test" \
    -H "Authorization: Bearer wrong-token"

echo ""
echo "--- Test 4: Authorized version check ---"
VER=$(curl -s -H "Authorization: Bearer test-token-123" "http://127.0.0.1:9080/api/v2/version?p=test")
assert_eq "version returns 0.5.5" "0.5.5" "$VER"

echo ""
echo "--- Test 5: Write and read a scroll ---"
# Insert
INSERT=$(curl -s -H "Authorization: Bearer test-token-123" \
    "http://127.0.0.1:9080/api/v2/update?p=hello&c=1.1.1/1.1.1/1.1.1&s=Hello+from+R21")
assert_contains "insert succeeds" "Updated" "$INSERT"

# Select
SELECT=$(curl -s -H "Authorization: Bearer test-token-123" \
    "http://127.0.0.1:9080/api/v2/select?p=hello&c=1.1.1/1.1.1/1.1.1")
assert_eq "select returns scroll" "Hello from R21" "$SELECT"

echo ""
echo "--- Test 6: CORS headers ---"
CORS=$(curl -s -D- -o /dev/null -H "Authorization: Bearer test-token-123" \
    "http://127.0.0.1:9080/api/v2/version?p=test" | grep -i "access-control")
assert_contains "CORS origin header" "Access-Control-Allow-Origin" "$CORS"

echo ""
echo "--- Test 7: OPTIONS preflight ---"
assert_status "OPTIONS returns 204" "204" "http://127.0.0.1:9080/api/v2/select" -X OPTIONS

echo ""
echo "--- Test 8: Admin endpoint ---"
ADMIN=$(curl -s -H "Authorization: Bearer admin-secret" "http://127.0.0.1:9080/admin/tenants")
assert_contains "admin lists tenants" "testuser" "$ADMIN"

echo ""
echo "--- Test 9: Admin unauthorized ---"
assert_status "admin bad key = 401" "401" "http://127.0.0.1:9080/admin/tenants" \
    -H "Authorization: Bearer wrong"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && echo "ALL TESTS PASSED" || echo "SOME TESTS FAILED"
exit "$FAIL"
