#!/bin/bash
# Round 14 Deployment Diagnostic Script
# Run this on the deployment server to identify blockers
# Usage: bash deployment-diagnostic.sh

echo "=== Round 14 Deployment Diagnostic ==="
echo "Generated: $(date)"
echo ""

# List of domains to check
DOMAINS=(
    "mirrorborn.us"
    "visionquest.me"
    "apertureshift.com"
    "wishnode.net"
    "sotafomo.com"
    "quickfork.net"
    "singularitywatch.org"
)

echo "=== 1. DNS Resolution Check ==="
for domain in "${DOMAINS[@]}"; do
    echo -n "$domain: "
    dig +short "$domain" | head -1 || echo "FAIL"
done
echo ""

echo "=== 2. HTTP Status Check ==="
for domain in "${DOMAINS[@]}"; do
    echo -n "$domain: "
    curl -s -o /dev/null -w "%{http_code}" "https://$domain" || echo "FAIL"
    echo ""
done
echo ""

echo "=== 3. Webroot Directory Check ==="
for domain in "${DOMAINS[@]}"; do
    webroot="/var/www/$domain"
    echo -n "$domain webroot: "
    if [ -d "$webroot" ]; then
        echo "EXISTS"
        ls -lh "$webroot/index.html" 2>/dev/null || echo "  (index.html missing)"
    else
        echo "MISSING"
    fi
done
echo ""

echo "=== 4. Nginx Vhost Check ==="
for domain in "${DOMAINS[@]}"; do
    vhost="/etc/nginx/sites-enabled/$domain"
    echo -n "$domain vhost: "
    if [ -f "$vhost" ]; then
        echo "EXISTS"
    else
        echo "MISSING"
    fi
done
echo ""

echo "=== 5. Nginx Config Test ==="
nginx -t 2>&1 || echo "SYNTAX ERROR"
echo ""

echo "=== 6. SSL Certificate Check ==="
if command -v certbot &> /dev/null; then
    certbot certificates 2>&1 | grep -A 3 "Certificate Name:" | grep -E "(Certificate Name|Domains|Expiry Date)"
else
    echo "certbot not found"
fi
echo ""

echo "=== 7. Git Repo Status ==="
if [ -d "/var/www/phext-dot-io-v2" ]; then
    cd /var/www/phext-dot-io-v2
    echo "Branch: $(git branch --show-current)"
    echo "Latest commit: $(git log --oneline -1)"
    echo "Status: $(git status --porcelain | wc -l) modified files"
else
    echo "Repo not found at /var/www/phext-dot-io-v2"
fi
echo ""

echo "=== 8. Permissions Check ==="
for domain in "${DOMAINS[@]}"; do
    webroot="/var/www/$domain"
    if [ -d "$webroot" ]; then
        echo "$domain: $(stat -c '%U:%G %a' "$webroot")"
    fi
done
echo ""

echo "=== Diagnostic Complete ==="
echo "Share this output in #general for troubleshooting"
