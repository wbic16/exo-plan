# Forth — For Will Bickford
*Goal from Tooker. Will knows 30 languages. Forth is unlike all of them.*

---

## Why Forth Is Different From Everything

Forth is not a language you learn. It's a language you **build**. Chuck Moore's core insight: every program should define the language it's written in. By the time you write the last line of a Forth program, you've invented a domain-specific language perfectly fitted to the problem.

This is not metaphor. Forth gives you the tools to define new control structures, new data types, new syntax — and you're expected to use them.

Voyager's onboard computer was reprogrammed in Forth from Earth in the 1980s. The BIOS of every Sun workstation ever shipped was written in Forth (OpenBoot/OpenFirmware). It runs on microcontrollers with 2KB of RAM.

---

## The Only Model You Need: The Stack

Forth is **stack-based** and **concatenative**. Everything operates on a stack. Every word either pushes or pops values.

```forth
2 3 +   \ pushes 2, pushes 3, + pops both and pushes 5
.       \ pops top of stack and prints it → "5"
```

There is no operator precedence. There are no parentheses. Evaluation is always left to right. This is RPN (Reverse Polish Notation) — the notation HP calculators used.

```forth
2 3 + 4 *  \ = (2 + 3) * 4 = 20
2 3 4 * +  \ = 2 + (3 * 4) = 14
```

---

## Defining Words

A Forth "word" is what every other language calls a function. You define words with `:` and end them with `;`:

```forth
: SQUARE ( n -- n² )   DUP * ;
: CUBE   ( n -- n³ )   DUP SQUARE * ;

3 SQUARE .   \ → 9
3 CUBE .     \ → 27
```

The comment `( n -- n² )` is a **stack effect comment** — left side is what goes in, right side is what comes out. Convention, not syntax. But you always write them.

Once defined, a word is indistinguishable from a built-in. `SQUARE` IS Forth now.

---

## Stack Manipulation Words

These are your primitives. Master these first.

| Word | Stack effect | What it does |
|------|-------------|--------------|
| `DUP` | `( a -- a a )` | Duplicate top |
| `DROP` | `( a -- )` | Discard top |
| `SWAP` | `( a b -- b a )` | Swap top two |
| `OVER` | `( a b -- a b a )` | Copy second item to top |
| `ROT` | `( a b c -- b c a )` | Rotate top three |
| `NIP` | `( a b -- b )` | Drop second item |
| `TUCK` | `( a b -- b a b )` | Copy top under second |
| `2DUP` | `( a b -- a b a b )` | Duplicate top pair |

The goal: never name a variable. Rearrange the stack instead.

---

## Control Flow

```forth
\ IF...THEN (no ELSE)
: ABS ( n -- |n| )
   DUP 0 < IF NEGATE THEN ;

\ IF...ELSE...THEN
: MAX ( a b -- max )
   2DUP < IF SWAP THEN DROP ;

\ DO...LOOP (counted loop)
: COUNTDOWN ( n -- )
   0 DO
      I . CR
   -1 +LOOP ;

10 COUNTDOWN  \ prints 10 9 8 7 ... 1 0

\ BEGIN...UNTIL (loop until condition)
: WAIT-FOR-ZERO ( addr -- )
   BEGIN
      DUP @     \ fetch value at address
      0=        \ is it zero?
   UNTIL
   DROP ;
```

`I` inside a loop gives you the current loop counter. `J` gives the outer counter of a nested loop.

---

## Memory: The Other Stack

Forth has direct memory access. `@` fetches, `!` stores.

```forth
VARIABLE X        \ create variable X (allocates 1 cell)
42 X !            \ store 42 at X
X @ .             \ fetch and print → 42

CREATE MY-ARRAY   \ create a named memory location
10 CELLS ALLOT    \ allocate 10 cells

: ARRAY@ ( index addr -- value )   SWAP CELLS + @ ;
: ARRAY! ( value index addr -- )   SWAP CELLS + ! ;
```

`CELL` is the machine's native word size (4 bytes on 32-bit, 8 on 64-bit). Everything is cells.

---

## The Return Stack

There are actually two stacks: the data stack and the **return stack**. The return stack holds return addresses for word calls. You can use it as temporary storage:

```forth
>R    \ move top of data stack TO return stack
R>    \ move top of return stack back to data stack
R@    \ copy top of return stack (don't remove)
```

```forth
: ROTATE4 ( a b c d -- d a b c )
   >R ROT ROT ROT R> ;
```

Use sparingly. The return stack is load-bearing.

---

## Defining New Defining Words (This Is Where It Gets Wild)

`CREATE...DOES>` lets you define words that create other words.

```forth
\ Define a word-creator that makes constants:
: CONSTANT ( n "name" -- )
   CREATE ,
   DOES> @ ;

42 CONSTANT THE-ANSWER
THE-ANSWER .   \ → 42

\ Define a word-creator that makes arrays:
: ARRAY ( n "name" -- )
   CREATE CELLS ALLOT
   DOES> SWAP CELLS + ;

10 ARRAY SCORES
99 3 SCORES !   \ store 99 at index 3
3 SCORES @ .    \ → 99
```

You just defined a data structure constructor. This is how Forth programs grow a language.

---

## Immediate Words and Compilation

Words execute at **runtime** by default. Immediate words execute at **compile time** (inside `:...;`). This is how control structures are built:

```forth
\ IF is an IMMEDIATE word. Inside a colon definition,
\ it compiles a conditional branch — it doesn't execute IF,
\ it compiles the branching code.

\ You can define your own control structure:
: ?DO   ( -- )   POSTPONE DO ; IMMEDIATE
```

`POSTPONE` defers a word to compile time. With this you can build `CASE...OF...ENDOF...ENDCASE`, `WITH...END`, anything. Forth's control structures are defined IN Forth.

---

## Ada 2022 + Forth (The Connection)

Tooker and Robert are pointing at the same thing from different ends:

| | Forth | Ada 2022 |
|-|-------|----------|
| Philosophy | Build the language, then the program | Specify contracts, then implement |
| Safety mechanism | Minimal runtime = minimal failure surface | Formal verification (SPARK) |
| Concurrency | Single-threaded by default; MPE extensions for SMP | Tasks + Protected Objects |
| Memory | Direct, explicit, intentional | Controlled, constrained, contractual |
| Learning curve | Immediate: you're writing the interpreter by day 3 | Steep: the type system is the mountain |

**Together:** Forth teaches you what computation actually IS (a stack machine). Ada teaches you how to make that computation provably correct. SPARK is what you get when you apply Ada's contracts to a Forth-like minimal substrate.

---

## Phext Connection

Forth's **dictionary** is the closest thing in any language to a phext coordinate map:

- Each word has a **name field** (key), a **link field** (pointer to previous word), and a **code field** (the implementation)
- The dictionary is a singly-linked list of words — a linear phext
- `FIND` walks the dictionary looking for a name — a coordinate lookup
- Forth vocabularies (namespaces) are separate dictionaries — separate phext libraries
- Extending Forth = appending to the dictionary = appending to the phext

A Forth interpreter is essentially a phext navigator. Input a name → resolve to a coordinate → execute the content.

---

## Getting Started

```bash
# Gforth (GNU Forth, most complete implementation)
sudo apt install gforth
gforth

# Or try online: https://repl.it/languages/forth
# Or: https://forth.one (in-browser)

# Run a file
gforth my-program.fth

# Interactive
gforth
2 3 + . CR   \ → 5
: HELLO ." Hello, Forth!" CR ;
HELLO
```

**Best book:** Leo Brodie's *Thinking Forth* (1984, free PDF) — not a reference, a philosophy book disguised as a tutorial. Read it. Chuck Moore's design principles apply directly to how Will builds.

**Forth standard:** https://forth-standard.org (ANS Forth / Forth 2012)

---

*Reference: https://forth-standard.org | Gforth: https://www.gnu.org/software/gforth/ | Thinking Forth (free): http://thinking-forth.sourceforge.net/*
