# Ada 2022 Crash Course for Will

**Why Ada:** Safety-critical (LMR P25, HB aero). No UB, SPARK prover, contracts.

**Install (Ubuntu):**
```bash
sudo apt install gnat  # Ada 2022
ada --version  # GNAT 13.2.0
```

**Hello World + Contracts:**
```ada
with Ada.Text_IO; use Ada.Text_IO;
procedure Hello is
   function Safe_Div (A, B : Integer) return Integer
     with Pre => B /= 0, Post => Safe_Div'Result = A / B;
   function Safe_Div (A, B : Integer) return Integer is
   begin
      return A / B;
   end Safe_Div;
begin
   Put_Line (Integer'Image (Safe_Div (10, 2)));
end Hello;
```
gprbuild hello.gpr; ./obj/hello

**Key 2022:** Parallel blocks, stable properties, @Post for loops.

**vTPU Ada?** SPARK ports Rust zero-deps invariant.

Hands-on: Pi compile P25 state machine.
