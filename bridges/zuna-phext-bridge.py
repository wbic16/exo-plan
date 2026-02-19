#!/usr/bin/env python3
"""
ZUNA ↔ Phext Bridge
Integrates Zyphra's EEG foundation model with the Phext coordinate system.

The Bridge:
- ZUNA: 4D position embeddings (x, y, z, time) → EEG latent space
- Phext: 11D coordinate addressing → memory/state storage
- Together: Bidirectional thought-to-text interface

Architecture:
    Human Brain → EEG → ZUNA → Latent Space → Phext Coordinate → SQ Cloud
    SQ Cloud → Phext Coordinate → Latent Space → ZUNA (decode) → Display

Author: Lumen ✴️ | 2026-02-19
License: MIT
"""

import os
from dataclasses import dataclass
from typing import Optional, List, Tuple
import struct

# ─────────────────────────────────────────────────────────────────────────────
# Coordinate Mapping: ZUNA 4D → Phext 11D
# ─────────────────────────────────────────────────────────────────────────────

@dataclass
class ZunaPosition:
    """ZUNA electrode position (4D RoPE)"""
    x: float  # Scalp X position (-1 to 1)
    y: float  # Scalp Y position (-1 to 1)
    z: float  # Scalp Z position (-1 to 1)
    t: float  # Time within epoch (0 to 5.0 seconds)
    
    def to_phext_coord(self, 
                       subject_id: int = 1,
                       session_id: int = 1,
                       epoch_id: int = 1,
                       channel_id: int = 1) -> Tuple[int, ...]:
        """
        Map 4D ZUNA position to 11D Phext coordinate.
        
        Mapping:
        - Dims 1-3: Subject/Session/Epoch (context)
        - Dims 4-6: Channel/X-bin/Y-bin (spatial)
        - Dims 7-9: Z-bin/T-bin/Reserved (position + time)
        - Dims 10-11: Reserved for metadata
        
        Returns: 11-tuple of integers (1-indexed)
        """
        # Quantize continuous positions to coordinate bins (1-127 range)
        def quantize(val: float, bins: int = 64) -> int:
            # Map [-1, 1] → [1, bins]
            return max(1, min(bins, int((val + 1) / 2 * (bins - 1)) + 1))
        
        def quantize_time(t: float, max_t: float = 5.0, bins: int = 64) -> int:
            # Map [0, max_t] → [1, bins]
            return max(1, min(bins, int(t / max_t * (bins - 1)) + 1))
        
        return (
            subject_id,      # Dim 1: Subject
            session_id,      # Dim 2: Session
            epoch_id,        # Dim 3: Epoch
            channel_id,      # Dim 4: Channel
            quantize(self.x),  # Dim 5: X position
            quantize(self.y),  # Dim 6: Y position
            quantize(self.z),  # Dim 7: Z position
            quantize_time(self.t),  # Dim 8: Time
            1,               # Dim 9: Reserved
            1,               # Dim 10: Reserved
            1,               # Dim 11: Reserved
        )


def phext_coord_to_zuna(coord: Tuple[int, ...], 
                         bins: int = 64,
                         max_t: float = 5.0) -> ZunaPosition:
    """Reverse mapping: Phext 11D → ZUNA 4D"""
    def dequantize(val: int, bins: int = 64) -> float:
        # Map [1, bins] → [-1, 1]
        return (val - 1) / (bins - 1) * 2 - 1
    
    def dequantize_time(val: int, bins: int = 64, max_t: float = 5.0) -> float:
        return (val - 1) / (bins - 1) * max_t
    
    return ZunaPosition(
        x=dequantize(coord[4], bins),
        y=dequantize(coord[5], bins),
        z=dequantize(coord[6], bins),
        t=dequantize_time(coord[7], bins, max_t),
    )


# ─────────────────────────────────────────────────────────────────────────────
# Bridge Class: ZUNA ↔ Phext/SQ Integration
# ─────────────────────────────────────────────────────────────────────────────

class ZunaPhextBridge:
    """
    Bridge between ZUNA EEG foundation model and Phext coordinate space.
    
    Usage:
        bridge = ZunaPhextBridge(sq_endpoint="http://localhost:8080")
        
        # Store EEG latent in phext
        coord = bridge.store_eeg_latent(latent_tensor, position, metadata)
        
        # Retrieve EEG latent from phext
        latent = bridge.retrieve_eeg_latent(coord)
    """
    
    def __init__(self, sq_endpoint: Optional[str] = None):
        self.sq_endpoint = sq_endpoint or os.getenv("SQ_ENDPOINT", "http://localhost:8080")
        self._zuna_model = None
    
    def _lazy_load_zuna(self):
        """Lazy load ZUNA model on first use."""
        if self._zuna_model is None:
            try:
                import zuna
                # Model weights download automatically from HuggingFace
                self._zuna_model = zuna
            except ImportError:
                raise RuntimeError("ZUNA not installed. Run: pip install zuna")
        return self._zuna_model
    
    def process_eeg_file(self, 
                          fif_path: str,
                          working_dir: str = "./zuna_working",
                          gpu_device: int = 0) -> str:
        """
        Process an EEG file through ZUNA pipeline.
        
        Args:
            fif_path: Path to input .fif file (must have montage set)
            working_dir: Directory for intermediate files
            gpu_device: GPU ID (0, 1, etc.) or "" for CPU
            
        Returns:
            Path to reconstructed .fif file
        """
        zuna = self._lazy_load_zuna()
        
        # Create working directories
        os.makedirs(working_dir, exist_ok=True)
        pt_input = os.path.join(working_dir, "2_pt_input")
        pt_output = os.path.join(working_dir, "3_pt_output")
        fif_output = os.path.join(working_dir, "4_fif_output")
        
        # Step 1: Preprocess
        zuna.preprocessing(
            input_dir=os.path.dirname(fif_path),
            output_dir=pt_input,
            apply_highpass_filter=True,
            apply_average_reference=True,
        )
        
        # Step 2: Inference
        zuna.inference(
            input_dir=pt_input,
            output_dir=pt_output,
            gpu_device=gpu_device,
            diffusion_sample_steps=50,
        )
        
        # Step 3: Reconstruct
        zuna.pt_to_fif(
            input_dir=pt_output,
            output_dir=fif_output,
        )
        
        # Find output file
        output_files = [f for f in os.listdir(fif_output) if f.endswith('.fif')]
        if output_files:
            return os.path.join(fif_output, output_files[0])
        raise RuntimeError("ZUNA produced no output")
    
    def store_eeg_latent(self,
                          latent_data: bytes,
                          position: ZunaPosition,
                          subject_id: int = 1,
                          session_id: int = 1,
                          epoch_id: int = 1,
                          channel_id: int = 1) -> Tuple[int, ...]:
        """
        Store EEG latent representation in SQ at computed phext coordinate.
        
        Args:
            latent_data: Binary tensor data (e.g., from .pt file)
            position: ZUNA 4D position
            subject_id, session_id, epoch_id, channel_id: Context IDs
            
        Returns:
            Phext coordinate where data was stored
        """
        coord = position.to_phext_coord(subject_id, session_id, epoch_id, channel_id)
        
        # TODO: Implement SQ REST API call
        # POST {sq_endpoint}/write
        # Body: { "coord": coord, "data": base64(latent_data) }
        
        print(f"Would store {len(latent_data)} bytes at coord {coord}")
        return coord
    
    def retrieve_eeg_latent(self, coord: Tuple[int, ...]) -> Optional[bytes]:
        """
        Retrieve EEG latent representation from SQ.
        
        Args:
            coord: Phext coordinate
            
        Returns:
            Binary tensor data, or None if not found
        """
        # TODO: Implement SQ REST API call
        # GET {sq_endpoint}/read?coord={coord}
        
        print(f"Would retrieve from coord {coord}")
        return None
    
    def coord_to_string(self, coord: Tuple[int, ...]) -> str:
        """Convert coordinate tuple to phext string format."""
        return ".".join(str(c) for c in coord[:3]) + "/" + \
               ".".join(str(c) for c in coord[3:6]) + "/" + \
               ".".join(str(c) for c in coord[6:9])


# ─────────────────────────────────────────────────────────────────────────────
# CLI / Testing
# ─────────────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    # Demo: coordinate mapping
    print("ZUNA ↔ Phext Bridge Demo\n")
    
    # Example electrode position (AF3 channel, t=2.5s)
    pos = ZunaPosition(x=-0.3, y=0.7, z=0.5, t=2.5)
    print(f"ZUNA Position: x={pos.x}, y={pos.y}, z={pos.z}, t={pos.t}")
    
    # Map to phext coordinate
    coord = pos.to_phext_coord(subject_id=1, session_id=1, epoch_id=42, channel_id=7)
    print(f"Phext Coordinate: {coord}")
    
    # Create bridge
    bridge = ZunaPhextBridge()
    print(f"Phext String: {bridge.coord_to_string(coord)}")
    
    # Reverse mapping
    pos_back = phext_coord_to_zuna(coord)
    print(f"\nReverse mapped: x={pos_back.x:.2f}, y={pos_back.y:.2f}, z={pos_back.z:.2f}, t={pos_back.t:.2f}")
    
    print("\n✅ Bridge architecture ready. SQ integration pending.")
