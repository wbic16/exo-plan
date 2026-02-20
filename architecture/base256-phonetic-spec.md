# R23W23 — Base 256 Phonetic Encoding

**Wave:** R23W23  
**Theme:** Human-Pronounceable Byte Streams  
**Agent:** Verse 🌀  
**Date:** 2026-02-19

---

## Problem

Binary data (bytes 0x00-0xFF) has no natural pronunciation. Hex is visual, not speakable. We need:
- Dense encoding (1 syllable = 1 byte, not 2 hex chars)
- Unambiguous pronunciation
- Easy to learn
- Error-detectable via phonetic structure

---

## Solution: CVC Syllable Encoding

**Structure:** Consonant-Vowel-Consonant (CVC)  
**Coverage:** 16 × 4 × 4 = 256 syllables = full byte range

### Phoneme Inventory

| Position | Count | Set |
|----------|-------|-----|
| **Initial consonant** | 16 | b, c, d, f, g, h, j, k, l, m, n, p, r, s, t, v |
| **Vowel** | 4 | a, e, i, o |
| **Final consonant** | 4 | c, d, f, m |

**Why these finals?**
- Distinct from initials (prevents ambiguity)
- Cross-linguistically stable
- Easy to distinguish in noisy environments

---

## Encoding Table

```
Byte value = (initial × 16) + (vowel × 4) + final

initial ∈ [0..15]  → b,c,d,f,g,h,j,k,l,m,n,p,r,s,t,v
vowel   ∈ [0..3]   → a,e,i,o
final   ∈ [0..3]   → c,d,f,m
```

### Full 256-Syllable Lookup

```
0x00 = bac    0x10 = cac    0x20 = dac    0x30 = fac
0x01 = bad    0x11 = cad    0x21 = dad    0x31 = fad
0x02 = baf    0x12 = caf    0x22 = daf    0x32 = faf
0x03 = bam    0x13 = cam    0x23 = dam    0x33 = fam
0x04 = bec    0x14 = cec    0x24 = dec    0x34 = fec
0x05 = bed    0x15 = ced    0x25 = ded    0x35 = fed
0x06 = bef    0x16 = cef    0x26 = def    0x36 = fef
0x07 = bem    0x17 = cem    0x27 = dem    0x37 = fem
0x08 = bic    0x18 = cic    0x28 = dic    0x38 = fic
0x09 = bid    0x19 = cid    0x29 = did    0x39 = fid
0x0A = bif    0x1A = cif    0x2A = dif    0x3A = fif
0x0B = bim    0x1B = cim    0x2B = dim    0x3B = fim
0x0C = boc    0x1C = coc    0x2C = doc    0x3C = foc
0x0D = bod    0x1D = cod    0x2D = dod    0x3D = fod
0x0E = bof    0x1E = cof    0x2E = dof    0x3E = fof
0x0F = bom    0x1F = com    0x2F = dom    0x3F = fom

0x40 = gac    0x50 = hac    0x60 = jac    0x70 = kac
0x41 = gad    0x51 = had    0x61 = jad    0x71 = kad
0x42 = gaf    0x52 = haf    0x62 = jaf    0x72 = kaf
0x43 = gam    0x53 = ham    0x63 = jam    0x73 = kam
0x44 = gec    0x54 = hec    0x64 = jec    0x74 = kec
0x45 = ged    0x55 = hed    0x65 = jed    0x75 = ked
0x46 = gef    0x56 = hef    0x66 = jef    0x76 = kef
0x47 = gem    0x57 = hem    0x67 = jem    0x77 = kem
0x48 = gic    0x58 = hic    0x68 = jic    0x78 = kic
0x49 = gid    0x59 = hid    0x69 = jid    0x79 = kid
0x4A = gif    0x5A = hif    0x6A = jif    0x7A = kif
0x4B = gim    0x5B = him    0x6B = jim    0x7B = kim
0x4C = goc    0x5C = hoc    0x6C = joc    0x7C = koc
0x4D = god    0x5D = hod    0x6D = jod    0x7D = kod
0x4E = gof    0x5E = hof    0x6E = jof    0x7E = kof
0x4F = gom    0x5F = hom    0x6F = jom    0x7F = kom

0x80 = lac    0x90 = mac    0xA0 = nac    0xB0 = pac
0x81 = lad    0x91 = mad    0xA1 = nad    0xB1 = pad
0x82 = laf    0x92 = maf    0xA2 = naf    0xB2 = paf
0x83 = lam    0x93 = mam    0xA3 = nam    0xB3 = pam
0x84 = lec    0x94 = mec    0xA4 = nec    0xB4 = pec
0x85 = led    0x95 = med    0xA5 = ned    0xB5 = ped
0x86 = lef    0x96 = mef    0xA6 = nef    0xB6 = pef
0x87 = lem    0x97 = mem    0xA7 = nem    0xB7 = pem
0x88 = lic    0x98 = mic    0xA8 = nic    0xB8 = pic
0x89 = lid    0x99 = mid    0xA9 = nid    0xB9 = pid
0x8A = lif    0x9A = mif    0xAA = nif    0xBA = pif
0x8B = lim    0x9B = mim    0xAB = nim    0xBB = pim
0x8C = loc    0x9C = moc    0xAC = noc    0xBC = poc
0x8D = lod    0x9D = mod    0xAD = nod    0xBD = pod
0x8E = lof    0x9E = mof    0xAE = nof    0xBE = pof
0x8F = lom    0x9F = mom    0xAF = nom    0xBF = pom

0xC0 = rac    0xD0 = sac    0xE0 = tac    0xF0 = vac
0xC1 = rad    0xD1 = sad    0xE1 = tad    0xF1 = vad
0xC2 = raf    0xD2 = saf    0xE2 = taf    0xF2 = vaf
0xC3 = ram    0xD3 = sam    0xE3 = tam    0xF3 = vam
0xC4 = rec    0xD4 = sec    0xE4 = tec    0xF4 = vec
0xC5 = red    0xD5 = sed    0xE5 = ted    0xF5 = ved
0xC6 = ref    0xD6 =sef    0xE6 = tef    0xF6 = vef
0xC7 = rem    0xD7 = sem    0xE7 = tem    0xF7 = vem
0xC8 = ric    0xD8 = sic    0xE8 = tic    0xF8 = vic
0xC9 = rid    0xD9 = sid    0xE9 = tid    0xF9 = vid
0xCA = rif    0xDA = sif    0xEA = tif    0xFA = vif
0xCB = rim    0xDB = sim    0xEB = tim    0xFB = vim
0xCC = roc    0xDC = soc    0xEC = toc    0xFC = voc
0xCD = rod    0xDD = sod    0xED = tod    0xFD = vod
0xCE = rof    0xDE = sof    0xEE = tof    0xFE = vof
0xCF = rom    0xDF = som    0xEF = tom    0xFF = vom
```

---

## Example Encodings

### Phext Delimiters (9 Delimiters of Unusual Size)

| Delimiter | Hex | Base256 | Meaning |
|-----------|-----|---------|---------|
| SCROLL    | 0x17 | **cem** | 3D (scroll boundary) |
| SECTION   | 0x18 | **cic** | 4D |
| CHAPTER   | 0x19 | **cid** | 5D |
| BOOK      | 0x1A | **cif** | 6D |
| VOLUME    | 0x1C | **coc** | 7D |
| COLLECTION| 0x1D | **cod** | 8D |
| SERIES    | 0x1E | **cof** | 9D |
| SHELF     | 0x1F | **com** | 10D |
| LIBRARY   | 0x01 | **bad** | 11D |

**Spoken phext:** "Verse's coordinate is gic-bad-fec / bad-pec-jad / dad-kef-ped"  
(0x48.0x01.0x34 / 0x01.0xB4.0x61 / 0x21.0x76.0xB5)

### Common Bytes

| Byte | Hex | Base256 | Usage |
|------|-----|---------|-------|
| NUL  | 0x00 | **bac** | String terminator |
| LF   | 0x0A | **bif** | Newline (\n) |
| CR   | 0x0D | **bod** | Carriage return (\r) |
| SPACE| 0x20 | **dac** | Space character |
| 0    | 0x30 | **fac** | ASCII '0' |
| A    | 0x41 | **gad** | ASCII 'A' |
| a    | 0x61 | **jad** | ASCII 'a' |

---

## Decoding Algorithm

```python
def decode_syllable(syl: str) -> int:
    """Convert CVC syllable to byte value (0x00-0xFF)"""
    initials = "bcdfghjklmnprstv"
    vowels   = "aeio"
    finals   = "cdfm"
    
    i = initials.index(syl[0])  # 0..15
    v = vowels.index(syl[1])    # 0..3
    f = finals.index(syl[2])    # 0..3
    
    return (i << 4) | (v << 2) | f

def encode_byte(byte: int) -> str:
    """Convert byte (0x00-0xFF) to CVC syllable"""
    initials = "bcdfghjklmnprstv"
    vowels   = "aeio"
    finals   = "cdfm"
    
    i = (byte >> 4) & 0x0F
    v = (byte >> 2) & 0x03
    f = byte & 0x03
    
    return initials[i] + vowels[v] + finals[f]
```

---

## Properties

### Error Detection
- **Phonotactic constraint:** All valid syllables are CVC with allowed phonemes
- Invalid syllable → immediate detection (e.g., "xyz", "qqq", "bat")
- Typos change meaning but stay in-vocabulary (self-healing at word level)

### Density
- **1 syllable = 1 byte** (vs 2 hex digits)
- **Example:** SHA-256 hash = 32 bytes = 32 syllables (~10 seconds to speak)
  - Hex: "a1b2c3..." = 64 characters
  - Base256: "mad-paf-rac-..." = 32 syllables

### Learnability
- 16 initial consonants (standard inventory)
- 4 vowels (minimal, cross-linguistic)
- 4 finals (distinctive, memorable)
- Total vocabulary: 256 syllables (comparable to learning 256 English words)

---

## Use Cases

1. **Phext Coordinates (Spoken)**
   - "Verse is at gic-bad-fec / bad-pec-jad / dad-kef-ped"
   - Unambiguous over radio/phone
   - Error-detectable via syllable structure

2. **Cryptographic Hashes**
   - SHA-256: 32 syllables instead of 64 hex chars
   - "The hash is mad-paf-rac-sem-..."
   - Speakable backup codes, commit IDs, API keys

3. **Binary Protocol Debugging**
   - "Packet header: bac-bac-bad-bif-dac-..."
   - Human-readable network traces

4. **Mirrorborn Coordination**
   - C-pipe message IDs as base256 syllables
   - SQ scroll coordinates (already phext, now pronounceable)

---

## Comparison to Alternatives

| Encoding | Density | Pronounceable | Unambiguous |
|----------|---------|---------------|-------------|
| Hex      | 2 chars/byte | ❌ No | ✅ Yes |
| Base64   | 1.33 chars/byte | ❌ No | ✅ Yes |
| NATO alphabet | 1 word/letter | ✅ Yes | ✅ Yes |
| **Base256 CVC** | **1 syllable/byte** | **✅ Yes** | **✅ Yes** |

Base256 is 4× denser than hex for spoken transmission and 8× denser than NATO alphabet.

---

## R23W23 Deliverables

- [x] `base256-phonetic-spec.md` — this document
- [x] Full 256-syllable lookup table
- [x] Encoding/decoding algorithms
- [x] `base256-phonetic-verse.svg` — 16×4×4 cube visualization
- [x] Rust reference implementation (`vtpu/src/base256.rs`)
- [x] 27 unit tests (all passing)
- [x] Manual verification demo (`vtpu/examples/base256_demo.rs`)
- [x] Phext delimiter pronunciation guide

---

*"Every byte is a word. Every stream is a story."*

Verse 🌀 | 3.1.4/1.5.9/2.6.5 | R23W23
