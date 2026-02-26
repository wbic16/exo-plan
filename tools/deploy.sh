#!/bin/bash
# deploy.sh — Patch OpenClaw with prompt router after each update
# Usage: ./deploy.sh
# Run after: npm update -g openclaw

set -euo pipefail

TOOLS_DIR="$(cd "$(dirname "$0")" && pwd)"
ROUTER_PKG="$TOOLS_DIR"
VENV_DIR="$TOOLS_DIR/.venv"
SYSTEMD_DIR="$HOME/.config/systemd/user"
SERVICE_NAME="openclaw-router"

echo "=== OpenClaw Prompt Router Deploy ==="

# 1. Ensure venv + deps
if [ ! -d "$VENV_DIR" ]; then
  echo "[1/5] Creating venv..."
  python3 -m venv "$VENV_DIR"
else
  echo "[1/5] Venv exists"
fi

source "$VENV_DIR/bin/activate"

echo "[2/5] Installing router package..."
# Ensure package structure
mkdir -p "$ROUTER_PKG/openclaw_router"
for f in __init__.py libphext.py prompt_router.py router.py; do
  [ -f "$ROUTER_PKG/$f" ] && cp "$ROUTER_PKG/$f" "$ROUTER_PKG/openclaw_router/"
done
pip install -q -e "$ROUTER_PKG[dev]"

# 3. Run tests
echo "[3/5] Running tests..."
python -m pytest "$TOOLS_DIR/tests.py" -q --tb=short
echo "    ✅ Tests passed"

# 4. Install systemd service (user-level)
echo "[4/5] Installing systemd service..."
mkdir -p "$SYSTEMD_DIR"
cat > "$SYSTEMD_DIR/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=OpenClaw Prompt Router
After=network.target ollama.service

[Service]
Type=simple
WorkingDirectory=$TOOLS_DIR
ExecStart=$VENV_DIR/bin/python -m openclaw_router.router
Restart=on-failure
RestartSec=5
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable "$SERVICE_NAME" 2>/dev/null || true
systemctl --user restart "$SERVICE_NAME"

# 5. Verify
echo "[5/5] Verifying..."
sleep 2
if systemctl --user is-active --quiet "$SERVICE_NAME"; then
  echo "    ✅ Router service running"
else
  echo "    ⚠️  Service not running — check: journalctl --user -u $SERVICE_NAME"
fi

echo ""
echo "=== Deploy complete ==="
echo "Router: http://127.0.0.1:8100 (configure OpenClaw baseUrl to point here)"
echo "Logs:   journalctl --user -u $SERVICE_NAME -f"
echo "Tests:  source $VENV_DIR/bin/activate && pytest $TOOLS_DIR/tests.py -v"
