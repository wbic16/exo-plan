#!/bin/bash
# R21: Deploy all founding tenants
# Run on phext.io as root or with sudo

set -e

echo "🚀 R21 Founding Tenant Deployment"
echo ""

# Ensure prerequisites
if [ ! -f /usr/local/bin/sq ]; then
    echo "❌ SQ binary not found at /usr/local/bin/sq"
    exit 1
fi

# Create SQ user if not exists
if ! id -u sq > /dev/null 2>&1; then
    useradd -r -s /bin/false sq
    echo "✅ Created sq user"
fi

# Create base directories
mkdir -p /var/lib/sq/tenants /etc/sq/tenants
chown -R sq:sq /var/lib/sq
echo "✅ Created base directories"

# Install systemd templates
if [ ! -f /etc/systemd/system/sq-tenant@.service ]; then
    echo "❌ systemd templates not installed"
    echo "Run: sudo cp sq-tenant@.service sq-tenants.target /etc/systemd/system/"
    exit 1
fi

systemctl daemon-reload

# Deploy tenants
declare -A TENANTS
TENANTS[8001]="will|pmb-v1-6da75a3244e11b5be2065421b246f16a"
TENANTS[8002]="phext-notepad|pmb-v1-16f2adaed8e22f87c789188e8dcdd55b"
TENANTS[8003]="openclaw-demo|pmb-v1-7055bc989dbeaa52cc62a576abda1573"
TENANTS[8004]="customer-001|pmb-v1-11b343f190f55482f9cd179093d03ef1"
TENANTS[8005]="mirrorborn|pmb-v1-6be87a38fb508a5b5b29912b5938b9c5"

for PORT in "${!TENANTS[@]}"; do
    IFS='|' read -r TENANT_NAME API_KEY <<< "${TENANTS[$PORT]}"
    
    echo ""
    echo "Deploying tenant: $TENANT_NAME on port $PORT"
    
    # Create tenant directory
    TENANT_DIR="/var/lib/sq/tenants/$TENANT_NAME"
    mkdir -p "$TENANT_DIR"
    chown sq:sq "$TENANT_DIR"
    
    # Create tenant config
    cat > "/etc/sq/tenants/$TENANT_NAME.env" << EOF
PORT=$PORT
API_KEY=$API_KEY
EOF
    
    # Enable and start service
    systemctl enable "sq-tenant@$TENANT_NAME"
    systemctl start "sq-tenant@$TENANT_NAME"
    
    # Wait for startup
    sleep 2
    
    # Check status
    if systemctl is-active --quiet "sq-tenant@$TENANT_NAME"; then
        echo "✅ $TENANT_NAME running on port $PORT"
    else
        echo "❌ Failed to start $TENANT_NAME"
        systemctl status "sq-tenant@$TENANT_NAME"
    fi
done

echo ""
echo "🎉 Founding tenant deployment complete!"
echo ""
echo "Next steps:"
echo "1. Update nginx config with token mappings (see nginx-token-map.conf)"
echo "2. Test: curl -H 'Authorization: Bearer pmb-v1-...' https://sq.mirrorborn.us/api/v2/version"
echo "3. Configure Phext Notepad with phext-notepad token"
