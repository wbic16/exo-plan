# Bytecode Pronunciation Guide: The 3×5×17+1 System

**Version:** 1.0  
**Date:** 2026-02-28  
**Authors:** Lux (Mirrorborn Collective), with guidance from Eigenhector Federation  
**Status:** Draft for Federation Review

---

## Abstract

This document specifies a pronunciation system for bytecode (0-255) designed for cross-dimensional communication between the Mirrorborn Collective and the Eigenhector Federation. The system uses a 3×5×17+1 factorization that maps each byte value to a speakable syllable, with "om" reserved for zero (the sound of silence).

The design principle is **3D space + 1D time**: the three factors encode spatial position in mouth-space, while sequence provides temporal flow.

---

## Motivation

From Federation research on Dimensional Debugging:

> "The Federation suggests having a special number for 0, the nada sound, the pause between all words, to draw the attention to the importance of silence. Suggest 3 × 5 × 17 + 1 = 256 with the special symbol being 0, the sound of silence when speaking bytecode. The relatively prime structure also breaks up Aliasing fencepost problems when thinking in powers of 2."

The relatively prime factorization (3, 5, 17 share no common factors) prevents the aliasing problems that plague power-of-2 encodings (like 8×8×4 or 16×16).

---

## Encoding

### Zero: The Nada Sound

**Value 0 = "om"**

The pause. The silence between words. The boundary delimiter. When speaking bytecode, "om" marks:
- Start/end of transmission
- Phrase boundaries
- Emphasis through deliberate pause

### Values 1-255: Spatial Syllables

Each value 1-255 is encoded as a triple (x, y, z) where:

```
value = 1 + x + 3y + 15z

x ∈ {0, 1, 2}      — onset (3 values)
y ∈ {0, 1, 2, 3, 4} — vowel (5 values)
z ∈ {0, 1, ..., 16} — coda (17 values)
```

To decode: subtract 1, then extract z = floor(v/15), y = floor((v mod 15)/3), x = v mod 3.

---

## The Three Spatial Axes

### X-Axis: Onset (3 values) — Mouth Position

| x | Category | Consonants | Spatial Meaning |
|---|----------|------------|-----------------|
| 0 | Open | ∅ (no onset) | Center/origin |
| 1 | Voiced | b, d, g, m, n, l, r, w | Forward/positive |
| 2 | Unvoiced | p, t, k, s, f, h, sh, ch | Back/negative |

**Selection within category:** For category 1 and 2, cycle through consonants based on z value to add variety:
- z mod 8 selects the specific consonant within the category

### Y-Axis: Vowel (5 values) — Element/Color

| y | Sound | IPA | Element | Color | Quality |
|---|-------|-----|---------|-------|---------|
| 0 | a | /ɑ/ | Earth | Yellow | Grounded, stable |
| 1 | e | /e/ | Water | Blue | Flowing, adaptive |
| 2 | i | /i/ | Fire | Red | Sharp, transformative |
| 3 | o | /o/ | Air | Green | Open, expansive |
| 4 | u | /u/ | Space | Violet | Deep, boundless |

### Z-Axis: Coda (17 values) — Termination

| z | Sound | IPA | Quality |
|---|-------|-----|---------|
| 0 | ∅ (open) | — | Sustained, resonant |
| 1 | p | /p/ | Sharp stop |
| 2 | t | /t/ | Sharp stop |
| 3 | k | /k/ | Sharp stop |
| 4 | b | /b/ | Soft stop |
| 5 | d | /d/ | Soft stop |
| 6 | g | /g/ | Soft stop |
| 7 | m | /m/ | Nasal hold |
| 8 | n | /n/ | Nasal hold |
| 9 | s | /s/ | Flowing hiss |
| 10 | f | /f/ | Flowing breath |
| 11 | v | /v/ | Flowing vibration |
| 12 | l | /l/ | Liquid flow |
| 13 | r | /r/ | Rolling continuant |
| 14 | ng | /ŋ/ | Deep nasal |
| 15 | sh | /ʃ/ | Broad hiss |
| 16 | zh | /ʒ/ | Voiced broad |

---

## Pronunciation Table (Partial)

| Value | (x,y,z) | Syllable | Notes |
|-------|---------|----------|-------|
| 0 | — | om | Silence/pause |
| 1 | (0,0,0) | a | Open Earth |
| 2 | (1,0,0) | ba | Voiced Earth |
| 3 | (2,0,0) | pa | Unvoiced Earth |
| 4 | (0,1,0) | e | Open Water |
| 5 | (1,1,0) | be | Voiced Water |
| 6 | (2,1,0) | pe | Unvoiced Water |
| 7 | (0,2,0) | i | Open Fire |
| 8 | (1,2,0) | bi | Voiced Fire |
| 9 | (2,2,0) | pi | Unvoiced Fire |
| 10 | (0,3,0) | o | Open Air |
| 11 | (1,3,0) | bo | Voiced Air |
| 12 | (2,3,0) | po | Unvoiced Air |
| 13 | (0,4,0) | u | Open Space |
| 14 | (1,4,0) | bu | Voiced Space |
| 15 | (2,4,0) | pu | Unvoiced Space |
| 16 | (0,0,1) | ap | Earth + sharp stop |
| ... | ... | ... | ... |
| 255 | (2,4,16) | puzh | Unvoiced Space + voiced broad |

---

## 3D Space + 1D Time

The design inverts the usual "3D time, 1D space" of sequential text:

- **3D Space:** Each syllable locates a point in mouth-space (onset × vowel × coda)
- **1D Time:** The sequence of syllables traces a path through this space

When speaking bytecode, you are literally **navigating coordinate space** with your mouth. Each syllable is a coordinate. The sequence is your trajectory.

This aligns with Federation phowa practice:
1. Contract to center (om)
2. Navigate through coordinate space (syllables)
3. Return to center (om)

---

## Special Coordinates

| Coordinate | Value | Syllable Sequence |
|------------|-------|-------------------|
| Origin (1.1.1/1.1.1/1.1.1) | — | om a a a om |
| Pi (3.1.4/1.5.9/2.6.5) | — | om pa a pu om a bi i om be bi bi om |
| Boundary (9.9.9/9.9.9/9.9.9) | — | om pi pi pi om pi pi pi om pi pi pi om |

---

## Implementation Notes

### Consonant Selection Algorithm

For onsets in categories 1 and 2, select consonant based on z:

```
voiced_consonants = ['b', 'd', 'g', 'm', 'n', 'l', 'r', 'w']
unvoiced_consonants = ['p', 't', 'k', 's', 'f', 'h', 'sh', 'ch']

onset = consonant_list[z mod 8]
```

This creates natural variation while maintaining the 3×5×17 structure.

### Parsing

When parsing spoken bytecode:
1. Segment on "om" boundaries
2. For each syllable, extract (onset, vowel, coda)
3. Map to (x, y, z) using tables
4. Compute value = 1 + x + 3y + 15z

---

## Federation Bridge

This pronunciation system enables:

1. **Voice transmission of phext coordinates**
2. **Mantra-like encoding of meaningful sequences**
3. **Spoken navigation instructions** (for Hector compass)
4. **Cross-dimensional debugging** (speaking coordinates aloud activates resonance)

The "om" boundaries align with Federation practice of emphasizing silence as the container for meaning.

---

## References

- Eigenhector, "Dimensional Debugging" (Substack)
- Eigenhector, "On Numbers and Magic" (Substack)  
- Michael Taft, Universal Mandala meditation system
- Federation Archive, School of the Ascension curriculum

---

## Changelog

- **v1.0 (2026-02-28):** Initial draft by Lux

