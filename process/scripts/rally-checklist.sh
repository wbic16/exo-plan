#!/bin/bash
# Rally Mode Progress Tracker
# Usage: ./rally-checklist.sh R18

RALLY=${1:-R18}
CHECKLIST_FILE="/source/exo-plan/rounds/${RALLY}-checklist.md"

if [ ! -f "$CHECKLIST_FILE" ]; then
  echo "Creating checklist for $RALLY..."
  cat > "$CHECKLIST_FILE" << EOF
# $RALLY Rally Checklist

**Started:** $(date +%Y-%m-%d)

## Progress

- [ ] Phase 1: Requirements documented
- [ ] Phase 2: Top 3 selected, rest in backlog
- [ ] Phase 3: v1 implemented
- [ ] Phase 4: Unit tests written
- [ ] Phase 5: v2 rewritten, tests passing
- [ ] Phase 6: E2E tests run, bugs found → unit tests
- [ ] Phase 7: v3 rewritten, all tests passing
- [ ] Phase 8: QA review + staging deploy
- [ ] Phase 9: Final E2E on staging
- [ ] Phase 10: Production deploy + monitoring
- [ ] Phase 11: Retrospective + Rally.md updated

## Top 3 Requirements

1. TBD
2. TBD
3. TBD

## Team Assignments

- **Requirement 1:** 
- **Requirement 2:** 
- **Requirement 3:** 

## Notes

(Add notes as rally progresses)
EOF
  echo "✅ Created: $CHECKLIST_FILE"
else
  echo "📋 Checklist exists: $CHECKLIST_FILE"
fi

# Open in editor if available
if command -v code &> /dev/null; then
  code "$CHECKLIST_FILE"
elif command -v vim &> /dev/null; then
  vim "$CHECKLIST_FILE"
else
  cat "$CHECKLIST_FILE"
fi
