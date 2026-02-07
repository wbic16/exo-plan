#!/bin/bash
# Round 14 Deployment Script
# Deploys all 7 portals + shared assets to mirrorborn.us
# Usage: bash deploy-all-portals.sh

set -e  # Exit on any error

RPUSH="/source/exocortical/rpush.sh"
REPO="/source/phext-dot-io-v2"
SERVER="mirrorborn.us"

echo "=== Round 14 Deployment Script ==="
echo "Date: $(date)"
echo "Server: $SERVER"
echo ""

# Step 1: Pull latest code
echo "=== Step 1: Pulling latest code from exo branch ==="
cd "$REPO"
git fetch origin
git checkout exo
git pull origin exo
echo "✅ Latest code pulled"
echo ""

# Step 2: Deploy each portal
echo "=== Step 2: Deploying portals ==="

echo "Deploying visionquest.me..."
$RPUSH domains/visionquest.me/ $SERVER
echo "✅ visionquest.me deployed"
echo ""

echo "Deploying apertureshift.com..."
$RPUSH domains/apertureshift.com/ $SERVER
echo "✅ apertureshift.com deployed"
echo ""

echo "Deploying wishnode.net..."
$RPUSH domains/wishnode.net/ $SERVER
echo "✅ wishnode.net deployed"
echo ""

echo "Deploying sotafomo.com..."
$RPUSH domains/sotafomo.com/ $SERVER
echo "✅ sotafomo.com deployed"
echo ""

echo "Deploying quickfork.net..."
$RPUSH domains/quickfork.net/ $SERVER
echo "✅ quickfork.net deployed"
echo ""

echo "Deploying singularitywatch.org..."
$RPUSH domains/singularitywatch.org/ $SERVER
echo "✅ singularitywatch.org deployed"
echo ""

# Step 3: Deploy shared assets
echo "=== Step 3: Deploying shared assets ==="

echo "Deploying public/ (hub + shared footer)..."
$RPUSH public/ $SERVER
echo "✅ public/ deployed"
echo ""

# Step 4: Summary
echo "=== Deployment Complete ==="
echo "✅ 6 portals deployed"
echo "✅ 1 chronicle deployed (singularitywatch.org)"
echo "✅ Shared assets deployed"
echo ""
echo "Next steps:"
echo "1. Verify DNS resolution (dig <domain>)"
echo "2. Configure nginx vhosts for each domain"
echo "3. Run smoke tests: /source/exo-plan/rounds/run-smoke-tests-all-domains.sh"
echo ""
echo "Domains deployed:"
echo "  - visionquest.me"
echo "  - apertureshift.com"
echo "  - wishnode.net"
echo "  - sotafomo.com"
echo "  - quickfork.net"
echo "  - singularitywatch.org"
echo "  - mirrorborn.us (hub update)"
