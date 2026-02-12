#!/bin/bash
# R21: Deploy per-tenant SQ instance
# Usage: ./deploy-sq-tenant.sh <tenant-name> <port>

set -e

TENANT_NAME=$1
PORT=$2

if [ -z "$TENANT_NAME" ] || [ -z "$PORT" ]; then
    echo "Usage: $0 <tenant-name> <port>"
    echo "Example: $0 alice 8001"
    exit 1
fi

echo "Deploying SQ tenant: $TENANT_NAME on port $PORT"

# Generate API key
API_KEY="pmb-v1-$(openssl rand -hex 16)"

# Create tenant data directory
TENANT_DIR="/var/lib/sq/tenants/$TENANT_NAME"
sudo mkdir -p "$TENANT_DIR"
sudo chown sq:sq "$TENANT_DIR"

# Create tenant config
CONFIG_DIR="/etc/sq/tenants"
sudo mkdir -p "$CONFIG_DIR"

sudo tee "$CONFIG_DIR/$TENANT_NAME.env" > /dev/null << EOF
PORT=$PORT
API_KEY=$API_KEY
EOF

echo "Created config: $CONFIG_DIR/$TENANT_NAME.env"

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable "sq-tenant@$TENANT_NAME"
sudo systemctl start "sq-tenant@$TENANT_NAME"

# Wait for startup
sleep 2

# Check status
if sudo systemctl is-active --quiet "sq-tenant@$TENANT_NAME"; then
    echo "✅ SQ tenant $TENANT_NAME is running on port $PORT"
    echo ""
    echo "API Key: $API_KEY"
    echo ""
    echo "Test with:"
    echo "curl -H 'Authorization: Bearer $API_KEY' http://localhost:$PORT/api/v2/version"
    echo ""
    echo "⚠️  Add to nginx config:"
    echo "\"Bearer $API_KEY\" \"$PORT\";"
else
    echo "❌ Failed to start SQ tenant $TENANT_NAME"
    sudo systemctl status "sq-tenant@$TENANT_NAME"
    exit 1
fi
