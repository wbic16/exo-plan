sudo mkdir -p /etc/systemd/system/ollama.service.d/
cat > /tmp/keep-alive.conf << 'EOF'
[Service]
Environment="OLLAMA_KEEP_ALIVE=-1"
Environment="OLLAMA_NUM_PARALLEL=1"
Environment="OLLAMA_MAX_LOADED_MODELS=2"
EOF
sudo cp /tmp/keep-alive.conf /etc/systemd/system/ollama.service.d/
sudo systemctl daemon-reload
sudo systemctl restart ollama
ollama run qwen3-coder-next --keep_alive -1 & # Warm/pin
