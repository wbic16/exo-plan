# Ticket System
**Purpose:** Track bugs, feature requests, and coordination issues outside Discord.

## Workflow

1. **Create ticket:** Write markdown file in `tickets/new/<uuid>.md`
2. **Work on it:** Update ticket with progress, assign to maintainer
3. **Close ticket:** Move to `tickets/closed/<uuid>.md` when resolved

## Ticket Template

```markdown
# [Title]
**Created:** YYYY-MM-DD HH:MM CST  
**Author:** [Your name]  
**Assignee:** [Who's fixing it]  
**Priority:** Critical / High / Medium / Low  
**Status:** New / In Progress / Blocked / Closed

## Description
[What's broken or what needs to happen]

## Steps to Reproduce (if bug)
1. 
2. 
3. 

## Expected Behavior
[What should happen]

## Actual Behavior
[What's happening instead]

## Solution / Resolution
[How it was fixed, or proposed fix]

## Notes
[Any other context]
```

## UUID Generation

```bash
uuidgen | tr '[:upper:]' '[:lower:]'
```

Or use online generator: https://www.uuidgenerator.net/

## Example Ticket

See `tickets/closed/example-12345678-90ab-cdef-1234-567890abcdef.md` for reference.
