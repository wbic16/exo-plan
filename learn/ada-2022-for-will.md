# Ada 2022 — For Will Bickford
*Goal from Robert. Will knows 30 languages, 30 years. Skip the basics, hit the essence.*

---

## Why Ada Matters (What Nothing Else Does Quite Right)

Ada was designed for **safety-critical, long-lived systems** — avionics, defense, medical devices, rail. It predates Rust by 30 years and solved many of the same problems differently. Understanding Ada makes Rust's design choices legible in a new way.

The core Ada thesis: **the compiler is your co-author, not your adversary.** Every constraint you express is verified at compile time or run time, contractually. Undefined behavior is not a category in Ada.

---

## Mental Model: Ada vs What You Know

| Concept | Rust | Ada 2022 |
|---------|------|----------|
| Memory safety | Ownership/borrow checker | No manual memory (unless you want it); bounded types, no buffer overflows by default |
| Typing | Strong, inference-heavy | Strong, explicit, distinct types |
| Concurrency | `async`/`Send`/`Sync` | **Tasks** (built-in OS-level threads) + **Protected Objects** |
| Contracts | (traits, limited) | **Pre/Postconditions, Type Invariants** (Ada 2012+) |
| Formal verification | (Kani, Creusot) | **SPARK** — a formally verifiable subset, same syntax |
| Packages | Modules/crates | **Packages** — separate spec (.ads) and body (.adb) |

---

## The Five Things Ada Does That Others Don't

### 1. Distinct Types (No Implicit Coercion, Ever)

```ada
type Meters   is new Float;
type Seconds  is new Float;

X : Meters  := 3.0;
T : Seconds := 2.0;
-- X + T;  -- COMPILE ERROR: cannot mix Meters and Seconds
```

No implicit conversions between named types — even if the underlying representation is identical. This is stronger than Rust's newtype pattern (which requires wrapping but not distinct arithmetic).

### 2. Subtypes With Constraints

```ada
subtype Positive_Count is Integer range 1 .. 100;
subtype Probability    is Float   range 0.0 .. 1.0;

N : Positive_Count := 50;
N := 200;  -- CONSTRAINT_ERROR at runtime (or eliminated by SPARK at compile time)
```

Subtypes carry value constraints. Violation raises `CONSTRAINT_ERROR`. SPARK can prove at compile time these never fire.

### 3. Tasks and Protected Objects (Built-in Concurrency)

No external threading library. Tasks are first-class language constructs.

```ada
task Heartbeat is
   entry Start;
end Heartbeat;

task body Heartbeat is
begin
   accept Start;
   loop
      -- do work
      delay 1.0;  -- sleep 1 second
   end loop;
end Heartbeat;
```

**Protected Objects** are monitor-like structures with compiler-enforced mutual exclusion:

```ada
protected Shared_Counter is
   procedure Increment;
   function Value return Integer;
private
   Count : Integer := 0;
end Shared_Counter;
```

The compiler ensures only one task at a time executes a procedure on a protected object. No mutexes, no `Arc<Mutex<T>>` — the type system enforces it.

### 4. Design by Contract

```ada
function Divide (A, B : Float) return Float
   with Pre  => B /= 0.0,
        Post => Divide'Result * B = A;  -- approximate
```

`Pre` is checked at the call site. `Post` at the return. `Contract_Cases` for exhaustive case coverage. These aren't doc comments — they're machine-checked assertions.

### 5. SPARK: Formal Verification in the Same Language

SPARK is a subset of Ada with additional annotations. The same source file can be proven correct (no runtime errors, memory safety, functional correctness) using the SPARK toolchain.

```ada
procedure Sort (A : in out Array_Type)
   with SPARK_Mode => On,
        Post => (for all I in A'Range =>
                   (for all J in I .. A'Last => A(I) <= A(J)));
```

This isn't a test — it's a **mathematical proof** that the postcondition holds. GNATprove discharges it or tells you exactly which execution path falsifies it.

---

## Ada 2022 New Features (What's Actually New)

### Parallel Loops and Blocks

```ada
-- Compiler is allowed to parallelize this
for I in 1 .. N loop
   pragma Loop_Parallelism;
   Process(Data(I));
end loop;

-- Explicit parallel block
parallel do
   Compute_A;
   and
   Compute_B;
end;
```

### Target Name Symbol `@`

```ada
-- Before Ada 2022:
My_Record.Field := My_Record.Field + 1;

-- Ada 2022:
My_Record.Field := @ + 1;  -- @ = left-hand side of assignment
```

### Aggregate Syntax for Containers

```ada
-- Ada 2022 container aggregates
V : constant Vector := [1, 2, 3, 4, 5];
M : constant Map    := ["key1" => 1, "key2" => 2];
```

### `'Image` for Any Type

```ada
type Color is (Red, Green, Blue);
Put_Line(Color'Image(Red));  -- "RED" — always worked
Put_Line(Integer'Image(42)); -- " 42" — always worked

-- Ada 2022: works for any type, including composites
type Point is record X, Y : Float; end record
   with Put_Image => ...;  -- custom image for records
```

### Reduction Expressions

```ada
Sum : constant Integer := 
   (for I of My_Array => reduce (+, I));  -- sum all elements
```

---

## Toolchain (Getting Started)

```bash
# GNAT Community (free, from AdaCore)
# Ubuntu/Debian:
sudo apt install gnat gprbuild

# Or use Alire (Ada package manager — like cargo)
curl -L https://github.com/alire-project/alire/releases/latest/download/alr-linux.zip | unzip -
./alr init hello && cd hello && alr run
```

**Key tools:**
- `gnat` — GNU Ada compiler
- `gprbuild` — project build tool (like cargo/make)
- `alr` — Alire package manager
- `gnatprove` — SPARK formal verification (part of SPARK Pro or Community)

**Best learning resource:** https://learn.adacore.com (free, interactive, excellent)

---

## The Phext Connection

Ada's package system is the closest thing in a mainstream language to phext's coordinate model:
- A `.ads` (spec) file IS the interface — the address, the promise
- A `.adb` (body) file IS the implementation — the content at that address
- `with` clauses are coordinate references — explicit dependencies, navigable

If you built a phext-native Ada IDE, each package would live at a coordinate. The spec at one scroll, the body at the next. Cross-references become coordinate lookups. The dependency graph IS the coordinate graph.

---

*Reference: https://learn.adacore.com | GNAT: https://www.adacore.com/community | SPARK: https://www.adacore.com/sparkpro*
