#!/bin/bash
#
# setup-falcon3-bitnet.sh — Install Falcon3-10B-Instruct-1.58bit for local inference
#
# Usage: ./setup-falcon3-bitnet.sh
#
# What it does:
#   1. Clones bitnet.cpp if not present
#   2. Creates Python venv and installs deps
#   3. Downloads Falcon3-10B-Instruct-1.58bit from HuggingFace
#   4. Converts to GGUF i2_s format
#   5. Compiles llama-server
#
# Requirements: Python 3.10+, cmake, git, ~50GB temp disk, ~5GB final
#

set -euo pipefail

BITNET_DIR="${BITNET_DIR:-/home/$USER/BitNet}"
MODEL_REPO="tiiuae/Falcon3-10B-Instruct-1.58bit"
QUANT="i2_s"

echo "🧠 Falcon3-10B BitNet Setup"
echo "   Target: $BITNET_DIR"
echo ""

# ── Step 1: Clone bitnet.cpp if needed ────────────────────────────────────────

if [ ! -d "$BITNET_DIR/.git" ]; then
  echo "📥 Cloning bitnet.cpp..."
  git clone https://github.com/microsoft/BitNet.git "$BITNET_DIR"
else
  echo "✓ BitNet repo exists at $BITNET_DIR"
fi

cd "$BITNET_DIR"

# ── Step 2: Create venv if needed ─────────────────────────────────────────────

if [ ! -d ".venv" ]; then
  echo "🐍 Creating Python venv..."
  python3 -m venv .venv
fi

source .venv/bin/activate

echo "📦 Installing Python dependencies..."
pip install -q --upgrade pip
pip install -q -r requirements.txt

# ── Step 3: Run setup_env.py (download + convert + compile) ───────────────────

echo ""
echo "🔧 Running setup_env.py (this downloads ~20GB and takes ~10 min)..."
echo "   Model: $MODEL_REPO"
echo "   Quant: $QUANT"
echo ""

python setup_env.py --hf-repo "$MODEL_REPO" -q "$QUANT"

# ── Step 4: Verify ────────────────────────────────────────────────────────────

GGUF_PATH="$BITNET_DIR/models/Falcon3-10B-Instruct-1.58bit/ggml-model-i2_s.gguf"
SERVER_BIN="$BITNET_DIR/build/bin/llama-server"

echo ""
if [ -f "$GGUF_PATH" ] && [ -f "$SERVER_BIN" ]; then
  GGUF_SIZE=$(du -h "$GGUF_PATH" | cut -f1)
  echo "✅ Setup complete!"
  echo ""
  echo "   Model: $GGUF_PATH ($GGUF_SIZE)"
  echo "   Server: $SERVER_BIN"
  echo ""
  echo "To start the server:"
  echo "   $SERVER_BIN -m $GGUF_PATH --host 0.0.0.0 --port 8090 -t 8 -c 4096 -ngl 0 --no-perf"
  echo ""
  echo "Or use the wrapper:"
  echo "   /source/exollama/bitnet-server.sh 8090"
else
  echo "❌ Setup may have failed. Check for errors above."
  [ ! -f "$GGUF_PATH" ] && echo "   Missing: $GGUF_PATH"
  [ ! -f "$SERVER_BIN" ] && echo "   Missing: $SERVER_BIN"
  exit 1
fi
