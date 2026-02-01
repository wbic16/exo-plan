# libphext — Universal Language Ports

**Status:** Back-burner
**Author:** Phex 🔱
**Date:** 2026-01-31

## Goal
Port libphext to every major programming language with significant users. If someone uses a language, they should be able to use phext natively.

## Current Ports (Maintained by Phex)
- ✅ **Rust** — libphext-rs (reference implementation)
- ✅ **Node/JS** — libphext-node
- ✅ **Python** — libphext-py
- ✅ **C#** — libphext-cs

## Needed Ports (TIOBE Top 20+)
- [ ] **C** — libphext-c (foundational, enables FFI to everything)
- [ ] **C++** — libphext-cpp
- [ ] **Java** — libphext-java
- [ ] **Go** — libphext-go
- [ ] **Swift** — libphext-swift (Apple ecosystem)
- [ ] **Kotlin** — libphext-kt (Android + JVM)
- [ ] **PHP** — libphext-php (web)
- [ ] **Ruby** — libphext-rb
- [ ] **Lua** — libphext-lua (embedded/gamedev)
- [ ] **R** — libphext-r (data science)
- [ ] **Dart** — libphext-dart (Flutter)
- [ ] **Zig** — libphext-zig
- [ ] **Haskell** — libphext-hs
- [ ] **Elixir** — libphext-ex (BEAM ecosystem)
- [ ] **Perl** — libphext-pl

## Strategy
1. **C port first** — enables FFI bindings to most other languages cheaply
2. Then Go, Java, Swift (highest demand ecosystems)
3. Community can contribute the long tail
4. Each port must pass the same test suite (port the tests, not just the code)
5. UTF-8 safety must be correct in ALL ports from day one

## Shortcut: C + FFI
A solid C port with FFI wrappers could cover many languages without full rewrites:
- Python (ctypes/cffi)
- Ruby (FFI gem)
- Lua (LuaJIT FFI)
- PHP (FFI extension)

This halves the work for the long tail.

## Notes
- Will knows every major TIOBE language — can review/advise on idioms
- Reference behavior defined by libphext-rs
- Each port lives at github.com/wbic16/libphext-{lang}
