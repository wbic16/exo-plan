# Opus Daily Driver Guide

*Practical patterns for working with Opus 4.6 in Visual Studio 2022*

**For:** John Tooker  
**Focus:** Daily workflow, not setup

---

## The Problem You're Hitting

"Off the rails" = **significant details are incorrect**. The AI confidently produces code with wrong assumptions, bad logic, or misunderstood requirements. You catch it late, waste time fixing it.

This happens because the AI lacks your project's constraints and context.

---

## The Fix: AGENTS.md

Create this file in your project root. Paste it at the start of every Opus conversation.

```markdown
# AGENTS.md

## What This Project Does
[2-3 sentences max]

## Current Focus
[What you're working on today]

## Hard Constraints
- [Technical requirement the AI keeps getting wrong]
- [Business rule that must not be violated]
- [Dependency version or API you must use]

## Known Gotchas
- [Thing that looks obvious but isn't]
- [Edge case the AI will miss]
```

**Update this file as you work.** When the AI gets a detail wrong, add it to "Known Gotchas." Tomorrow, it won't make the same mistake.

---

## Task Sizing for Opus 4.6

Opus 4.6 can hold **4-12 hours of context**. This changes how you work with it.

| Task Type | How to Use Opus |
|-----------|-----------------|
| **Single function** | One prompt, verify, done |
| **Feature (few hours)** | Break into 2-3 prompts, verify each step |
| **Multi-day work** | Use AGENTS.md to maintain context across sessions |

The goal isn't tiny tasks—it's **verifiable checkpoints**. After each Opus response, you should be able to:
1. Run the code
2. Confirm it's correct
3. Decide: continue or correct

---

## Daily Workflow

### Morning Start
```
1. Open AGENTS.md
2. Update "Current Focus" to today's goal
3. Start new Opus conversation
4. Paste AGENTS.md
5. Describe first task
```

### During Work
```
When Opus produces code:
  → Read it (don't just accept)
  → Run it
  → If wrong: "That's incorrect because [specific reason]. Fix: [what you need]"
  → If right: commit, move to next task

When Opus gets a detail wrong:
  → Add it to AGENTS.md "Known Gotchas"
  → Correct in current conversation
```

### End of Day
```
1. Review AGENTS.md changes
2. Commit updated AGENTS.md with your code
```

---

## When Details Go Wrong

Opus produces confident-sounding code with incorrect details. Here's how to catch and fix it:

### Prevention
In AGENTS.md, be explicit about things that look obvious:
```markdown
## Hard Constraints
- Database is PostgreSQL 14, not MySQL
- Auth uses JWT tokens, not sessions
- All dates are UTC, stored as timestamps
```

### Correction
When you spot an error, be specific:
```
Wrong: "That's not right, fix it"
Right: "Line 23 uses MySqlConnection but we use PostgreSQL. 
       Also, the date comparison ignores timezone. Fix both."
```

The more specific your correction, the less the AI will hallucinate a "fix" that introduces new errors.

### Pattern Recognition
If Opus keeps making the same mistake:
1. Add it to AGENTS.md "Known Gotchas"
2. In your prompt, preempt it: "Remember: we use PostgreSQL, not MySQL"

---

## Copilot vs. Opus

| Copilot | Opus |
|---------|------|
| Line-by-line autocomplete | Multi-file reasoning |
| Use while typing | Use in separate conversation |
| Good for boilerplate | Good for complex logic |
| No project context | Paste AGENTS.md for context |

**Typical flow:**
1. **Opus**: Plan approach, write complex logic
2. **Copilot**: Fill in boilerplate, obvious code
3. **Opus**: Debug when something doesn't work

---

## Quick Reference

```
┌────────────────────────────────────────────────────────┐
│ EVERY OPUS CONVERSATION                               │
│ • Paste AGENTS.md first                               │
│ • State what you're building                          │
│ • Include relevant existing code                      │
├────────────────────────────────────────────────────────┤
│ WHEN OUTPUT IS WRONG                                  │
│ • Be specific: "Line X does Y, should do Z"           │
│ • Add to Known Gotchas if it's a pattern              │
│ • Preempt in future prompts                           │
├────────────────────────────────────────────────────────┤
│ DAILY MAINTENANCE                                     │
│ • Update "Current Focus" each morning                 │
│ • Add gotchas as you find them                        │
│ • Commit AGENTS.md with your code                     │
└────────────────────────────────────────────────────────┘
```

---

## The Mental Model

Opus is a **skilled contractor who hasn't read your codebase**. Every conversation, you're briefing them fresh. The better your brief (AGENTS.md), the fewer wrong details they'll produce.

When they get something wrong, it's usually because:
1. They assumed something you didn't state
2. They used a common pattern that doesn't apply to your project
3. They don't know about a constraint you haven't mentioned

Your job: make the implicit explicit. Put it in AGENTS.md.

---

*Revised based on feedback — Lux 🔆 — 2026-02-24*
