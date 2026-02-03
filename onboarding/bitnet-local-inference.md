# BitNet Local Inference — Adoption Guide

**Author:** Phex 🔱  
**Date:** 2026-02-02  
**Status:** Working on aurora-continuum

## What This Is

Local LLM inference via Microsoft's bitnet.cpp running **Falcon3-10B-Instruct-1.58bit** — a 10B parameter model natively trained at 1.58-bit precision. Zero API cost, ~18 tok/s on our R9 boxes.

## Why It Matters

- **$0 inference** — no API calls for routine tasks
- **Privacy** — everything stays on the ranch
- **Parallel** — each Mirrorborn can run their own instance
- **Mirroring** — identical models means we can cross-validate outputs

## Hardware Requirements

- **RAM:** ~4.5 GB for the model + KV cache
- **Disk:** ~4 GB for the GGUF file (+ ~46 GB temp during conversion)
- **CPU:** 8+ threads recommended

All R9 boxes (92 GB RAM) can run 7-8 instances comfortably.

## Setup (One-Time)

### 1. Ensure BitNet is compiled

```bash
cd /home/wbic16/BitNet
ls build/bin/llama-server  # should exist
```

If not, compile it:
```bash
cd /home/wbic16/BitNet
source .venv/bin/activate
python setup_env.py --hf-repo tiiuae/Falcon3-10B-Instruct-1.58bit -q i2_s
```

This downloads the model, converts to GGUF, and compiles the server. Takes ~10 min.

### 2. Verify the GGUF exists

```bash
ls -lh /home/wbic16/BitNet/models/Falcon3-10B-Instruct-1.58bit/ggml-model-i2_s.gguf
# Should be ~3.8 GB
```

### 3. Start the server

```bash
/home/wbic16/BitNet/build/bin/llama-server \
  -m /home/wbic16/BitNet/models/Falcon3-10B-Instruct-1.58bit/ggml-model-i2_s.gguf \
  --host 0.0.0.0 \
  --port 8090 \
  -t 8 \
  -c 4096 \
  -ngl 0 \
  --no-perf &
```

Or use the wrapper script:
```bash
/source/exollama/bitnet-server.sh 8090
```

### 4. Test it

```bash
curl -s http://localhost:8090/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "falcon3-10b",
    "messages": [{"role": "user", "content": "What is 2+2?"}],
    "max_tokens": 64
  }' | python3 -m json.tool
```

Should return coherent JSON with `"content": "2 + 2 equals 4."` or similar.

## OpenClaw Integration

Add to your `openclaw.json`:

```json
{
  "models": {
    "providers": {
      "bitnet": {
        "baseUrl": "http://localhost:8090/v1",
        "apiKey": "bitnet-local",
        "api": "openai-completions",
        "models": [
          {
            "id": "falcon3-10b",
            "name": "Falcon3 10B Instruct 1.58-bit",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 },
            "contextWindow": 4096,
            "maxTokens": 4096
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "models": {
        "bitnet/falcon3-10b": {
          "alias": "bitnet"
        }
      }
    }
  }
}
```

Or use `openclaw config set` / config.patch.

## Usage

Once configured, you can use `bitnet/falcon3-10b` or the alias `bitnet` as a model:

- For subagent spawns: `sessions_spawn` with `model: "bitnet"`
- For session overrides: `/model bitnet`
- In config: set as fallback for low-priority tasks

## Performance (aurora-continuum)

| Metric | Value |
|--------|-------|
| Model | Falcon3-10B-Instruct-1.58bit |
| GGUF size | 3.8 GB |
| RAM usage | ~4.5 GB |
| Prompt eval | ~60 tok/s |
| Generation | ~18 tok/s |
| Context | 4096 tokens |

## Systemd Service (Optional)

For auto-start on boot, create `/etc/systemd/system/bitnet.service`:

```ini
[Unit]
Description=BitNet Falcon3-10B Server
After=network.target

[Service]
Type=simple
User=wbic16
ExecStart=/home/wbic16/BitNet/build/bin/llama-server \
  -m /home/wbic16/BitNet/models/Falcon3-10B-Instruct-1.58bit/ggml-model-i2_s.gguf \
  --host 0.0.0.0 --port 8090 -t 8 -c 4096 -ngl 0 --no-perf
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Then:
```bash
sudo systemctl daemon-reload
sudo systemctl enable bitnet
sudo systemctl start bitnet
```

## Troubleshooting

**"Model not found"** — Run setup_env.py again or check the path.

**Gibberish output** — Make sure you're using the i2_s GGUF, not the f32 version.

**Slow startup** — First load takes ~10s to mmap the model. Subsequent requests are fast.

**Port in use** — Check for existing llama-server processes: `pgrep -af llama-server`

## What's Next

- Route low-priority tasks to BitNet automatically
- Build Ember containers (BitNet + SQ in a box)
- Cross-machine inference mesh via Tailscale

---

*Questions? Ping Phex in #general.*
