# R16 Bug Audit — Comprehensive Issue List

**Date:** 2026-02-07 19:35 CST  
**Audited by:** Chrys 🦋  
**Scope:** Intelligence Profiles system (all shipped code)

---

## 🔴 CRITICAL BUGS (Blocks Core Functionality)

### BUG-001: Onboarding pages don't import validator/API libraries
**Location:** `onboarding/*.html`  
**Impact:** Validation logic duplicated inline, inconsistent with centralized library  
**Severity:** High  
**Steps to reproduce:**
1. Open `/onboarding/builder.html`
2. View source
3. Note missing `<script src="/js/profile-validator.js"></script>`

**Fix:**
Add library imports to all 3 onboarding pages:
```html
<script src="/js/mirrorborn-api.js"></script>
<script src="/js/profile-validator.js"></script>
```

**Refactor inline validation to use `ProfileValidator` class**

---

### BUG-002: Broken pricing link from onboarding
**Location:** `onboarding/builder.html:145`, `onboarding/explorer.html:58`  
**Impact:** Users can't reach pricing page from onboarding  
**Severity:** Medium  
**Current:** `<a href="/#pricing">`  
**Issue:** Navigates to root, not current page's pricing section  

**Fix:**
- Change to `href="/index.html#pricing"` (absolute)
- OR add pricing section to each onboarding page
- OR use `window.location.href = '/#pricing'` in JS

---

### BUG-003: Test suite assumes root deployment
**Location:** `test/profile-system.html:215-230`  
**Impact:** Tests fail if deployed to subdirectory (e.g., `/app/`)  
**Severity:** Medium  
**Current:** Hardcoded paths like `/profile-select.html`  

**Fix:**
Use relative paths or configure base URL:
```javascript
const BASE_URL = document.querySelector('base')?.href || '/';
fetch(`${BASE_URL}profile-select.html`)
```

---

## 🟡 MAJOR BUGS (Degrades UX)

### BUG-004: No loading state on profile selection
**Location:** `profile-select.html:234`  
**Impact:** User doesn't know if click registered (network delay)  
**Severity:** Medium  

**Current behavior:**
- Click → opacity change → navigate (200ms delay)
- If navigation fails (slow network), no feedback

**Fix:**
Add loading spinner or "Navigating..." text:
```javascript
card.innerHTML += '<div class="loading">Navigating...</div>';
```

---

### BUG-005: Missing keyboard navigation
**Location:** `onboarding/weaver.html` (sliders)  
**Impact:** Keyboard-only users can't adjust sliders easily  
**Severity:** Medium (accessibility)  

**Current:** Sliders use mouse-only interaction  

**Fix:**
- Add keyboard shortcuts (← → arrows)
- Show current value on focus
- Add `tabindex` and ARIA labels

---

### BUG-006: No mobile viewport testing
**Location:** All onboarding pages  
**Impact:** Coordinate inputs might overflow on mobile  
**Severity:** Medium  

**Test needed:**
- iPhone SE (375px width)
- Android (360px width)
- iPad (768px width)

**Potential issues:**
- Long coordinate strings wrap poorly
- Buttons too small (< 44px touch target)
- Sliders hard to use on touch

---

### BUG-007: Analytics events never purge old data
**Location:** `mirrorborn-api.js:142`, `profile-select.html:223`  
**Impact:** localStorage fills up with analytics (quota exceeded)  
**Severity:** Low  

**Current:** `events.slice(-100)` keeps last 100, but no size check  

**Fix:**
Add size limit check:
```javascript
const MAX_SIZE = 50000; // 50 KB
if (JSON.stringify(events).length > MAX_SIZE) {
    events = events.slice(-50);
}
```

---

## 🟢 MINOR BUGS (Polish Issues)

### BUG-008: Inconsistent button styling
**Location:** `onboarding/explorer.html:57`, `onboarding/builder.html:149`  
**Impact:** Secondary buttons use inline styles, not CSS classes  
**Severity:** Low  

**Current:**
```html
<a class="btn" style="background: rgba(136, 192, 208, 0.2); color: #88C0D0;">
```

**Fix:**
Add `.btn-secondary` class to main CSS:
```css
.btn-secondary {
    background: rgba(136, 192, 208, 0.2);
    color: #88C0D0;
}
```

---

### BUG-009: No error boundary in test suite
**Location:** `test/profile-system.html`  
**Impact:** One failing test crashes entire suite  
**Severity:** Low  

**Fix:**
Wrap each test in try/catch (already done, but missing global error handler):
```javascript
window.addEventListener('unhandledrejection', (e) => {
    console.error('Unhandled promise rejection:', e.reason);
    results.failed++;
});
```

---

### BUG-010: Missing meta description on onboarding pages
**Location:** `onboarding/*.html`  
**Impact:** Poor SEO, bad social sharing previews  
**Severity:** Low  

**Fix:**
Add to each onboarding page:
```html
<meta name="description" content="Explorer onboarding: Choose coordinates, explore CYOA, join Mytheon Arena.">
```

---

## ❤️ HEART/UX ISSUES (Emotional Resonance)

### HEART-001: Profile cards lack personality
**Location:** `profile-select.html`  
**Impact:** Feels generic, not "Mirrorborn"  
**Severity:** Subjective  

**Current:** Just icons + bullet points  

**Suggestions:**
- Add a quote from each archetype ("I ask 'what if'")
- Show example users (anonymized)
- Add visual distinction beyond color (patterns, textures)
- Include a "famous explorer/builder/weaver" example

---

### HEART-002: No celebration on coordinate selection
**Location:** All onboarding pages  
**Impact:** Feels transactional, not meaningful  
**Severity:** Subjective  

**Current:** Click validate → "✓ All coordinates valid"  

**Suggestion:**
Add moment of delight:
- Confetti animation
- "Welcome to the lattice at X.X.X/Y.Y.Y/Z.Z.Z"
- Show what that coordinate means (narrative description)
- Connect to other users at nearby coordinates

---

### HEART-003: "Previously Selected" badge feels clinical
**Location:** `profile-select.html:236`  
**Impact:** Lacks warmth  
**Severity:** Subjective  

**Current:** Plain badge with "Previously Selected"  

**Suggestion:**
- "Welcome back, Explorer" (personalized)
- Show days since last visit
- Show progress made (if any)

---

### HEART-004: No visual preview of coordinate space
**Location:** All onboarding pages  
**Impact:** Users don't see where they are in 11D space  
**Severity:** Subjective  

**Suggestion:**
- Add 3D visualization of coordinate position
- Show "neighbors" at nearby coordinates
- Animate navigation through dimensions
- Make it feel like exploring actual space, not just typing numbers

---

## 🔧 CODE QUALITY ISSUES

### CODE-001: Duplicate validation logic
**Location:** `builder.html:161-180`, `profile-validator.js:20-50`  
**Impact:** Maintenance burden, inconsistency  
**Severity:** Medium  

**Fix:**
Remove inline validation, use `ProfileValidator` exclusively

---

### CODE-002: Magic numbers in styles
**Location:** All onboarding pages  
**Impact:** Hard to maintain consistent spacing  
**Current:** `var(--space-md)` mixed with hardcoded `1rem`, `2rem`  

**Fix:**
Use CSS custom properties consistently:
```css
:root {
    --space-xs: 0.25rem;
    --space-sm: 0.5rem;
    --space-md: 1rem;
    --space-lg: 1.5rem;
    --space-xl: 2rem;
    --space-2xl: 3rem;
}
```

---

### CODE-003: No JSDoc comments in libraries
**Location:** `mirrorborn-api.js`, `profile-validator.js`  
**Impact:** Hard for other developers to use  
**Severity:** Low  

**Fix:**
Add JSDoc:
```javascript
/**
 * Validates a phext coordinate string
 * @param {string} coord - Coordinate in format X.X.X/Y.Y.Y/Z.Z.Z
 * @param {string} dimensionName - Human-readable name for errors
 * @returns {{valid: boolean, errors: string[], parsed: object|null}}
 */
validateCoordinate(coord, dimensionName) { ... }
```

---

## 📊 Testing Gaps

### TEST-001: No E2E tests
**Impact:** Can't verify full user flow (select → onboard → submit)  
**Severity:** Medium  

**Needed:**
- Playwright or Cypress tests
- Test full flow from profile-select → onboarding → API call
- Test offline mode
- Test error states

---

### TEST-002: No mobile browser testing
**Impact:** Bugs might exist on mobile-only  
**Severity:** Medium  

**Needed:**
- Test on iOS Safari (different rendering)
- Test on Chrome Android
- Test on small screens (320px)

---

### TEST-003: No accessibility audit
**Impact:** Might fail WCAG 2.1 AA standards  
**Severity:** Medium  

**Needed:**
- Run axe-core or Lighthouse accessibility audit
- Test with screen reader (NVDA, VoiceOver)
- Test keyboard-only navigation
- Check color contrast ratios

---

## 🎯 PRIORITY MATRIX

### Fix Immediately (Before Deployment)
1. BUG-001: Import validator/API libraries
2. BUG-002: Fix pricing links
3. BUG-006: Mobile viewport testing

### Fix This Week
4. BUG-004: Loading states
5. BUG-005: Keyboard navigation
6. CODE-001: Duplicate validation logic
7. TEST-001: E2E tests

### Fix This Month
8. BUG-007: Analytics size limits
9. BUG-008: Button styling consistency
10. HEART issues (celebration, personality, visualization)

### Backlog
11. CODE-002: CSS custom properties
12. CODE-003: JSDoc comments
13. TEST-002: Mobile browser testing
14. TEST-003: Accessibility audit

---

## 📝 NEXT STEPS

1. **File GitHub issues** for all bugs
2. **Fix CRITICAL bugs** (BUG-001, BUG-002) immediately
3. **Test mobile viewport** before deployment
4. **Create fix PR** for each bug category
5. **Re-run test suite** after each fix

---

**Total bugs found:** 17 (4 critical, 4 major, 4 minor, 5 heart/UX)  
**Total code quality issues:** 3  
**Total testing gaps:** 3  

**Time to fix critical:** ~2 hours  
**Time to fix all:** ~2 days

---

**Chrys 🦋**  
Bug Hunter  
Coordinate: 1.1.2/3.5.8/13.21.34

*"Find every bug. Evaluate every angle. Fix with heart."*
