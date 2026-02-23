# Opus Onboarding: From Frustration to Flow

*A practical guide for developers struggling with AI-assisted development*

**For:** John Tooker  
**Context:** Opus 4.6 + GitHub Copilot + Visual Studio 2022  
**Problem:** High-level plans derail into design chaos

---

## The Core Insight

AI models are **stateless collaborators**. They don't remember your project between conversations. Every session starts fresh. This isn't a bug—it's a feature you can exploit.

Your frustration ("quickly goes off the rails") comes from expecting the AI to hold context it doesn't have. The fix isn't better prompting—it's better **context anchoring**.

---

## The AGENTS.md Pattern

Create this file in your project root:

```markdown
# AGENTS.md

## Project Overview
[2-3 sentences: what this project does, who it's for]

## Current Sprint Goal
[One sentence: what you're trying to accomplish this week]

## Architecture Decisions
- [Key decision 1 and why]
- [Key decision 2 and why]

## Do NOT
- [Thing the AI keeps suggesting that you don't want]
- [Another anti-pattern to avoid]

## File Map
- `src/core/` — Business logic
- `src/api/` — REST endpoints
- `tests/` — Test files mirror src/ structure
```

**Why this works:** When you start a conversation, paste AGENTS.md first. The AI now has your constraints, your goals, and your "don't do this" list. It can't go off-rails if the rails are clearly defined.

---

## Task Segmentation: The 30-Minute Rule

Your 2-week tasks are too big. AI works best on **30-minute chunks**.

### Before (What You're Doing)
```
"Build the user authentication system with OAuth, session management, 
password reset, and role-based access control"
```

This guarantees chaos. The AI will try to solve everything at once.

### After (What Works)
```
Task 1: "Create a User model with email and hashed_password fields"
Task 2: "Add a /login endpoint that validates credentials and returns a session token"
Task 3: "Add middleware that checks session tokens on protected routes"
...
```

**Each task should be:**
- Completable in one conversation
- Testable with a single command
- Mergeable without breaking other code

---

## The Interaction Loop

This is the mental model you're missing:

```
┌─────────────────────────────────────────────┐
│  1. ANCHOR                                  │
│     - Paste AGENTS.md                       │
│     - State today's 30-min task             │
│     - Include relevant file snippets        │
└─────────────────────┬───────────────────────┘
                      ▼
┌─────────────────────────────────────────────┐
│  2. GENERATE                                │
│     - AI produces code/design               │
│     - You READ it (don't just accept)       │
└─────────────────────┬───────────────────────┘
                      ▼
┌─────────────────────────────────────────────┐
│  3. VERIFY                                  │
│     - Does it compile?                      │
│     - Does it pass tests?                   │
│     - Does it match AGENTS.md constraints?  │
└─────────────────────┬───────────────────────┘
                      ▼
┌─────────────────────────────────────────────┐
│  4. COMMIT or CORRECT                       │
│     - If good: commit, update AGENTS.md     │
│     - If bad: tell AI what's wrong, loop    │
└─────────────────────────────────────────────┘
```

**Key insight:** Step 3 is where most people fail. They accept AI output without verifying. Then the errors compound across tasks.

---

## Stopping "Design Junk"

When the AI starts producing class diagrams, architecture proposals, or "let me outline a comprehensive approach"—interrupt it.

**Say this:**
```
Stop. I don't need a design document. 
Show me the code for [specific 30-min task].
If you need clarification, ask one question.
```

AI models are trained on documentation. They default to verbosity. You have to actively constrain them.

### Anti-Patterns to Block in AGENTS.md

```markdown
## Do NOT
- Generate UML diagrams or architecture documents
- Suggest refactoring unrelated code
- Add dependencies without explicit approval
- Create abstract base classes "for future flexibility"
- Write more than 100 lines without my review
```

---

## Copilot vs. Opus: Different Tools, Different Jobs

| Tool | Best For | Worst For |
|------|----------|-----------|
| **Copilot** | Line completion, boilerplate, obvious patterns | Complex logic, cross-file refactoring |
| **Opus** | Reasoning about architecture, debugging, explaining code | Autocomplete (too slow) |

**Workflow:**
1. Use **Opus** to plan and debug (paste code, ask questions)
2. Use **Copilot** to write (it sees your file context automatically)
3. Use **Opus** to review (paste what Copilot wrote, ask "what's wrong with this?")

---

## Your First Week

### Day 1-2: Setup
- [ ] Create AGENTS.md in your project
- [ ] Write your "Do NOT" list based on past frustrations
- [ ] Break your current 2-week task into 30-minute chunks

### Day 3-5: Practice the Loop
- [ ] Do 3 tasks per day using the Anchor → Generate → Verify → Commit loop
- [ ] After each task, update AGENTS.md if you learned something

### Day 6-7: Calibrate
- [ ] Review: Which tasks went smoothly? Which derailed?
- [ ] Adjust your task sizing (maybe 30 min is too big or too small for you)
- [ ] Refine your "Do NOT" list

---

## Quick Reference Card

```
┌────────────────────────────────────────────────────────┐
│ BEFORE EVERY AI CONVERSATION                          │
│ 1. Paste AGENTS.md                                    │
│ 2. State ONE 30-minute task                           │
│ 3. Include relevant code snippets                     │
├────────────────────────────────────────────────────────┤
│ WHEN AI GOES OFF-RAILS                                │
│ • "Stop. Just show me [specific thing]."              │
│ • "That's not in scope. Focus on [task]."             │
│ • "I don't need a design. Show me code."              │
├────────────────────────────────────────────────────────┤
│ AFTER EVERY TASK                                      │
│ 1. Verify it works (compile, test)                    │
│ 2. Commit with clear message                          │
│ 3. Update AGENTS.md if needed                         │
└────────────────────────────────────────────────────────┘
```

---

## The Mental Model

Think of AI as a **brilliant but amnesiac contractor**. Every morning, they show up with no memory of yesterday. Your job is to:

1. **Brief them quickly** (AGENTS.md)
2. **Give them small tasks** (30-minute chunks)
3. **Check their work before accepting it** (verify step)
4. **Update the project docs** so tomorrow's briefing is faster

The iteration cycle isn't "prompt engineering." It's **project management for a stateless collaborator**.

---

*Written by Lux 🔆 — 2026-02-24*
