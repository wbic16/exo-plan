# Opus Daily Workflow: Getting Details Right

**For:** John Tooker  
**Date:** 2026-02-24  
**Version:** 2.0

---

## The Real Problem

You're not failing at planning. You're failing at **detail fidelity**. The AI generates plausible-sounding output that's wrong in ways that matter — wrong method signatures, wrong assumptions about your codebase, wrong understanding of business rules.

Opus 4.6 can sustain 4-12 hour work sessions. The issue isn't session length. It's **drift detection**.

---

## Daily Workflow

### Morning: Set the Anchor

Before your first AI interaction of the day:

```markdown
## Today's Context
- Working in: [specific file/module]
- Goal: [one concrete deliverable]
- Known constraints: [things AI tends to get wrong]
```

Example:
```markdown
## Today's Context
- Working in: OrderService.cs
- Goal: Add bulk discount calculation to ProcessOrder()
- Known constraints: 
  - Discounts are percentage-based, not flat
  - Tax calculated AFTER discount
  - Orders over $1000 get 10%, over $5000 get 15%
```

The constraints list is your **guardrail**. These are the details that matter. Write them down BEFORE the AI starts generating.

---

### During Work: The Checkpoint Pattern

Opus can work for hours, but you should checkpoint every significant output.

**Checkpoint trigger:** Any time AI generates code you're about to use.

**Checkpoint questions:**
1. Are the method signatures correct? (Names, parameters, return types)
2. Are the business rules encoded correctly? (Your constraints list)
3. Does it match existing patterns in the codebase?

This takes 60 seconds. Do it every time. The cost of a missed detail compounds fast.

---

### When Details Go Wrong

You notice the AI got something wrong. Don't just say "that's wrong." 

**Correction template:**
```
Wrong: [what it did]
Right: [what it should be]
Why: [the rule or context it missed]
```

Example:
```
Wrong: You calculated discount on the subtotal
Right: Discount applies to item prices before tax
Why: Our system calculates: (ItemPrice * Qty * DiscountRate) + Tax
```

The "Why" teaches the model your codebase's logic. Without it, you'll correct the same mistake repeatedly.

---

## Preventing Detail Drift

### 1. Reference Existing Code

Instead of describing what you want, show what you have:

**Weak:**
> "Create a method to calculate shipping costs"

**Strong:**
> "Here's our existing CalculateTax method. Create a similar CalculateShipping method that follows the same patterns:"
> ```csharp
> [paste actual code]
> ```

The AI will mirror your conventions, naming, error handling.

### 2. State Assumptions Explicitly

The AI fills gaps with guesses. Don't let it guess.

**Weak:**
> "Add validation to the order form"

**Strong:**
> "Add validation to the order form:
> - Email: required, must be valid format
> - Phone: optional, US format (XXX-XXX-XXXX)
> - Quantity: required, integer 1-100
> - Existing validation uses FluentValidation, see CustomerValidator.cs"

### 3. Enumerate Edge Cases

Details go wrong at boundaries. Name them:

```
Handle these cases:
- Empty cart → return error "Cart is empty"
- Single item → no bulk discount
- Exactly $1000 → gets 10% discount (threshold is inclusive)
- Item out of stock mid-order → partial fulfillment allowed
```

---

## AGENTS.md for Daily Use

Keep this lean. Update it when patterns change.

```markdown
# AGENTS.md

## Codebase Patterns
- Services return `Result<T>` not raw values
- Repositories use `async/await` throughout
- Validation happens in dedicated Validator classes
- Logging uses structured format: _logger.LogInformation("{Action} for {Entity}", ...)

## Current Module: Orders
- OrderService.cs handles business logic
- OrderRepository.cs handles data access  
- OrderValidator.cs handles input validation
- Tests in Orders.Tests/

## Common AI Mistakes to Avoid
- Don't use null returns — use Result.Failure()
- Don't add new NuGet packages without asking
- Don't change existing method signatures
```

The "Common AI Mistakes" section is gold. Populate it as you discover patterns.

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│  BEFORE GENERATING                                          │
│  □ Constraints written down                                 │
│  □ Edge cases listed                                        │
│  □ Reference code provided (not just described)             │
├─────────────────────────────────────────────────────────────┤
│  AFTER GENERATING                                           │
│  □ Method signatures correct?                               │
│  □ Business rules encoded correctly?                        │
│  □ Matches existing codebase patterns?                      │
├─────────────────────────────────────────────────────────────┤
│  WHEN CORRECTING                                            │
│  □ Wrong: [specific thing]                                  │
│  □ Right: [specific correction]                             │
│  □ Why: [rule it violated]                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

1. **Anchor daily** — Write down today's constraints before AI touches anything
2. **Checkpoint outputs** — 60-second verification before using generated code
3. **Show, don't describe** — Paste existing code as the pattern to follow
4. **Name your edges** — Enumerate boundary cases explicitly
5. **Correct with context** — Wrong/Right/Why teaches the model your rules
6. **Track AI mistakes** — AGENTS.md "Common Mistakes" prevents repeats

The AI is competent at structure. Your job is **detail fidelity**. Every constraint you state explicitly is a detail that won't drift.

---

*"Precision is not pedantry. It's the difference between code that works and code that almost works."*
