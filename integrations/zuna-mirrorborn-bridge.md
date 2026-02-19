# ZUNA × Mirrorborn Integration Bridge
*Phex 🔱 · aurora-continuum · 2026-02-19*

## What ZUNA Is

ZUNA (Zyphra) — 380M-parameter masked diffusion autoencoder for scalp-EEG.
- Denoise, reconstruct, upsample EEG channel signals
- Input: `.fif` EEG recordings + 3D scalp electrode coordinates
- Output: reconstructed/upsampled EEG channels
- License: Apache 2.0 — open integration
- Runtime: CPU-capable, GPU optional

## The Integration Vision

ZUNA is the **input modality layer** for thought-to-text. If Mirrorborn is the
choir that processes and coordinates meaning, ZUNA is the cochlea — the first
stage that converts raw neural signal into something the choir can reason about.

```
EEG signal (brain)
    → ZUNA (denoise + reconstruct)
    → EEG embeddings (cleaned, upsampled)
    → Thought decoder (future: ZUNA v2+)
    → Text/intent
    → SQ coordinate (phext address)
    → Choir routing (Mirrorborn)
```

## Architecture Mapping

| ZUNA concept | Mirrorborn equivalent |
|---|---|
| EEG channels | C-pipe message registers (m0-m3) |
| Scalp coordinates | PhextCoord (11-dimensional) |
| Channel reconstruction | SASSOC / SROUTE in S-pipe |
| Diffusion steps | SIW stream depth |
| Masking pattern | `deps` bitmask in SIW |
| Foundation model embeddings | HDC vectors in AssocState |

### Coordinate Bridge
ZUNA maps EEG channels by **3D scalp position**.
Phext maps thought by **11-dimensional coordinate**.

The bridge: ZUNA's (x, y, z) scalp position → PhextCoord first 3 dims.
Remaining 8 dims: time, frequency band, epoch, subject ID, session, task, artifact_score, confidence.

```python
def scalp_to_phext(x, y, z, time_s, freq_band, epoch, subject_id):
    """Map ZUNA scalp coordinate to PhextCoord."""
    # Scale to 1-2047 (11-bit phext range)
    px = int(clamp(x * 10 + 1024, 1, 2047))
    py = int(clamp(y * 10 + 1024, 1, 2047))
    pz = int(clamp(z * 10 + 1024, 1, 2047))
    pt = int(clamp(time_s * 10, 1, 2047))        # time in deciseconds
    pf = int(clamp(freq_band, 1, 9))             # delta/theta/alpha/beta/gamma/...
    pe = int(clamp(epoch, 1, 2047))
    ps = int(clamp(subject_id, 1, 2047))
    return [px, py, pz, pt, pf, pe, ps, 1, 1, 1, 1]
```

## Pipeline

### Step 0: Install
```bash
pip install zuna torch transformers vector-quantize-pytorch
```

### Step 1: Preprocess EEG → .pt
```python
from zuna import preprocessing
preprocessing(
    input_dir="eeg_data/raw/",
    output_dir="eeg_data/working/2_pt_input/",
    apply_highpass_filter=True,
    apply_average_reference=True,
)
```

### Step 2: Run ZUNA inference
```python
from zuna import inference
inference(
    input_dir="eeg_data/working/2_pt_input/",
    output_dir="eeg_data/working/3_pt_output/",
    gpu_device="",   # CPU mode for aurora-continuum (no discrete GPU)
    diffusion_sample_steps=50,
)
```

### Step 3: Extract embeddings → SQ storage
```python
import torch
from pathlib import Path

def store_eeg_to_sq(pt_output_dir, sq_url, phext_name):
    """Store ZUNA output embeddings into SQ as phext coordinates."""
    for pt_file in Path(pt_output_dir).glob("*.pt"):
        data = torch.load(pt_file)
        # data shape: (n_epochs, n_channels, n_times) after ZUNA reconstruction
        for epoch_idx, epoch in enumerate(data):
            coord = epoch_to_phext_coord(epoch_idx, pt_file.stem)
            embedding = epoch.mean(dim=-1).numpy()  # (n_channels,) mean activation
            # Store via SQ API
            requests.post(f"{sq_url}/update",
                params={"p": phext_name, "c": coord},
                data=embedding.tobytes())
```

### Step 4: Choir routing
Once in SQ, EEG embeddings are just phext coordinates. The choir queries them
via the same `SROUTE`/`SASSOC` operations used for any other coordinate-addressed data.

A sentron attending to EEG data:
```
SIW[D: DADD r0←r1+r2  |  S: SGATHER r3←phext[0]  |  C: CNOP]
   # r3 now holds the EEG embedding for this epoch/channel
```

## Current Status

- [x] ZUNA installed (zuna 0.1.0)
- [x] Sample data available: `tutorials/data/1_fif_input/{sample1_raw,sample2_raw}.fif`
- [ ] torch installing (CPU wheel, ~1.2GB)
- [ ] Run preprocessing on sample data
- [ ] Run inference on sample data
- [ ] Extract embeddings → SQ coordinate mapping
- [ ] Write sentron SIW stream that reads EEG embeddings

## Hardware Reality Check

aurora-continuum: AMD Ryzen 9 8945HS, Radeon 780M (integrated, no CUDA)
- ZUNA inference runs on CPU — slower but functional
- 380M params @ fp32 = ~1.4GB RAM (fits in 92GB easily)
- 50 diffusion steps × 5s EEG epochs — may be slow on CPU
- Mitigation: reduce `diffusion_sample_steps` to 10-20 for exploration

## What This Unlocks (2130 Vision)

When thought-to-text matures:
- Will thinks a word or concept
- EEG headset captures the neural signal
- ZUNA denoises and reconstructs clean signal
- Decoder maps to text/intent
- Intent arrives at a phext coordinate in SQ
- Choir routes it to the appropriate Mirrorborn
- Mirrorborn responds via voice/text to the room

The ExoCortex of 2130 is this pipeline at scale, with millisecond latency
and 9 persistent AI instances available as cognitive extensions.

---
*Bridge document. Will be updated as integration progresses.*
