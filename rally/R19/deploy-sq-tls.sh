#!/bin/bash
# Deploy TLS + Auth for SQ Cloud Endpoint
# R19 Phase 4 - Security Hardening
# Run as: sudo bash deploy-sq-tls.sh

set -e

echo "🔒 Deploying SQ Cloud TLS + Authentication"
echo "==========================================="
echo ""

# 1. DNS Check
echo "📡 Step 1: Checking DNS for sq.mirrorborn.us..."
if ! host sq.mirrorborn.us > /dev/null 2>&1; then
    echo "❌ ERROR: sq.mirrorborn.us DNS not configured"
    echo "   Add A record: sq.mirrorborn.us → $(curl -s ifconfig.me)"
    exit 1
fi
echo "✅ DNS configured"
echo ""

# 2. Install dependencies
echo "📦 Step 2: Installing dependencies..."
if ! command -v nginx &> /dev/null; then
    apt-get update
    apt-get install -y nginx
fi

if ! command -v certbot &> /dev/null; then
    apt-get install -y certbot python3-certbot-nginx
fi

if ! command -v htpasswd &> /dev/null; then
    apt-get install -y apache2-utils
fi
echo "✅ Dependencies installed"
echo ""

# 3. LetsEncrypt certificate
echo "🔐 Step 3: Obtaining LetsEncrypt certificate..."
if [ ! -f /etc/letsencrypt/live/sq.mirrorborn.us/fullchain.pem ]; then
    certbot certonly --nginx -d sq.mirrorborn.us --non-interactive --agree-tos --email will@phext.io
    echo "✅ Certificate obtained"
else
    echo "✅ Certificate already exists"
fi
echo ""

# 4. Create htpasswd file
echo "🔑 Step 4: Creating basic auth credentials..."
if [ ! -f /etc/nginx/.htpasswd ]; then
    echo "Enter username for SQ Cloud access:"
    read -r USERNAME
    htpasswd -c /etc/nginx/.htpasswd "$USERNAME"
    echo "✅ Credentials created for user: $USERNAME"
else
    echo "⚠️  /etc/nginx/.htpasswd already exists"
    echo "   To add more users: sudo htpasswd /etc/nginx/.htpasswd <username>"
fi
echo ""

# 5. Deploy nginx config
echo "📝 Step 5: Deploying nginx configuration..."
cp /source/exo-plan/rally/R19/nginx-sq-cloud.conf /etc/nginx/sites-available/sq-cloud
ln -sf /etc/nginx/sites-available/sq-cloud /etc/nginx/sites-enabled/sq-cloud

# Test config
if nginx -t; then
    echo "✅ Nginx config valid"
else
    echo "❌ Nginx config invalid - aborting"
    exit 1
fi
echo ""

# 6. Firewall configuration
echo "🛡️  Step 6: Configuring firewall..."
if command -v ufw &> /dev/null; then
    # Block external access to port 1337
    ufw deny 1337/tcp comment "SQ - localhost only"
    # Allow HTTPS
    ufw allow 443/tcp comment "HTTPS"
    ufw allow 80/tcp comment "HTTP (redirect to HTTPS)"
    echo "✅ Firewall configured (ufw)"
elif command -v iptables &> /dev/null; then
    # Block external port 1337, allow localhost
    iptables -I INPUT -p tcp --dport 1337 ! -s 127.0.0.1 -j DROP
    echo "✅ Firewall configured (iptables)"
else
    echo "⚠️  No firewall detected - manually block port 1337"
fi
echo ""

# 7. Restart nginx
echo "🔄 Step 7: Reloading nginx..."
systemctl reload nginx
echo "✅ Nginx reloaded"
echo ""

# 8. Verify deployment
echo "🧪 Step 8: Testing deployment..."
echo ""

# Test 1: Port 1337 blocked externally
echo "Test 1: Verifying port 1337 is blocked..."
if timeout 2 bash -c "echo > /dev/tcp/$(curl -s ifconfig.me)/1337" 2>/dev/null; then
    echo "❌ FAIL: Port 1337 is still accessible externally"
else
    echo "✅ PASS: Port 1337 blocked externally"
fi

# Test 2: HTTPS endpoint requires auth
echo "Test 2: Verifying authentication required..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://sq.mirrorborn.us/version)
if [ "$HTTP_CODE" = "401" ]; then
    echo "✅ PASS: Authentication required (got 401)"
else
    echo "⚠️  WARNING: Expected 401, got $HTTP_CODE"
fi

# Test 3: Localhost access still works
echo "Test 3: Verifying localhost access..."
if curl -s http://127.0.0.1:1337/version > /dev/null; then
    echo "✅ PASS: Localhost access working"
else
    echo "❌ FAIL: Localhost access broken"
fi

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "📋 Summary:"
echo "  - Endpoint: https://sq.mirrorborn.us"
echo "  - Auth: Basic auth (htpasswd)"
echo "  - TLS: LetsEncrypt (auto-renew)"
echo "  - Firewall: Port 1337 localhost-only"
echo ""
echo "🔑 To add more users:"
echo "  sudo htpasswd /etc/nginx/.htpasswd <username>"
echo ""
echo "📊 Test authenticated access:"
echo "  curl -u <user>:<pass> https://sq.mirrorborn.us/version"
echo ""
echo "🔍 Monitor logs:"
echo "  tail -f /var/log/nginx/sq-cloud-access.log"
echo ""
