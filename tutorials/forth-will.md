# Forth Crash Course for Will

**Why Forth:** Real-time embedded (LMR radio FSM). Stack RPN, no GC, 1KB kernels. Factor-like.

**Install (Pi/Ubuntu):**
```bash
sudo apt install gforth
gforth --version  # 0.7.3
```

**Hello Stack:**
```
: HELLO ( -- ) CR ." Hello Forth" ;
HELLO  # Stack empty after
10 20 + .  # 30
```

**Words/Defs:**
```
: *2 DUP * ; 5 *2 .  # 25
: FIB ( n -- fib ) DUP 2 < IF DROP 1 EXIT THEN DUP 1 - RECURSE SWAP OVER 1 - RECURSE + ;
8 FIB .  # 21
```

**LMR FSM Stub:**
```
CREATE STATE-IDX 0 ,
: (NEXT) STATE-IDX @ CELLS + @ ;
: P25-IDLE ( -- ) 0 STATE-IDX ! ;
: P25-TRUNK ( -- ) 1 STATE-IDX ! ;
P25-IDLE (NEXT) .  # 0
```

**Forth 202x:** BigFORTH Pi kernel, multitasking.

Hands-on: Pi Forth P25 radio stub.
