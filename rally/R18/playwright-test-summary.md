# Payment Link Validation Test Suite - Summary

## What Was Created

```
/source/sites/tests/
├── payment-links.spec.js      # Main test suite (7.4 KB)
├── playwright.config.js       # Playwright configuration (1.8 KB)
├── package.json               # npm dependencies
├── README.md                  # Full documentation
├── setup.sh                   # Installation script
├── run-quick-check.sh         # Quick validation script
└── TEST-SUMMARY.md            # This file
```

## Quick Start

```bash
cd /source/sites/tests
./setup.sh              # Install dependencies + browsers
./run-quick-check.sh    # Run quick validation
npm run report          # View HTML report
```

## Test Coverage (Per Site)

### mirrorborn.us (Hub) ✅
- [x] Index loads successfully
- [x] Pricing page linked from index
- [x] All 5 Stripe links present on pricing.html
- [x] Stripe links reachable (HTTP 200)
- [x] Footer links to mirrorborn.us
- [x] Network navigation to portals

### Portal Sites (6 sites) ⚠️
- [x] Index loads successfully
- [ ] **CTA routes to payment** (EXPECTED FAIL - R18 work)
- [ ] **Routes to mirrorborn.us/pricing** (SKIPPED - R18 work)
- [x] Footer links to mirrorborn.us
- [x] Network navigation to portals

## Current Test Results (R17)

### Expected PASS (mirrorborn.us)
All tests on mirrorborn.us should pass:
- 6/6 tests passing
- All Stripe payment links validated

### Expected FAIL (6 portal sites)
These tests are **expected to fail** until R18:
- `apertureshift.com > has call-to-action that routes to payment`
- `visionquest.me > has call-to-action that routes to payment`
- `wishnode.net > has call-to-action that routes to payment`
- `sotafomo.com > has call-to-action that routes to payment`
- `quickfork.net > has call-to-action that routes to payment`
- `singularitywatch.org > has call-to-action that routes to payment`

**Why they fail**: Portal sites have no payment navigation yet. Tests use `test.fail()` to mark as expected failures.

## What Gets Tested

### Navigation Paths
1. **Direct**: `index.html` → `pricing.html` → Stripe
2. **Portal Hub**: `portal/index.html` → `mirrorborn.us` → `pricing.html` → Stripe
3. **Full Journey**: `visionquest.me` → `mirrorborn.us` → `pricing.html` → `stripe.com`

### Stripe Payment Links (5 products)
| Product | Price | Stripe Link |
|---------|-------|-------------|
| Arena | $5/mo | `/14AbJ2ebIdNO8nYch85Vu06` |
| OpenClaw | $10/mo | `/4gM5kE4B8aBC9s2epg5Vu07` |
| SQ Cloud | $40/mo | `/28E3cw6Jg25647Ibd45Vu05` |
| Singularity | $50/mo | `/4gMdRa2t0bFG0Vw0yq5Vu09` |
| Benefactor | $100/mo | `/8x2bJ27Nk4de33Eftk5Vu08` |

### Browser Coverage
- Chromium (Desktop Chrome)
- Firefox (Desktop)
- WebKit (Desktop Safari)
- Mobile Chrome (Pixel 5)
- Mobile Safari (iPhone 12)

### Performance Checks
- All sites load within 3 seconds
- No console errors on page load
- Links are clickable (not hidden/disabled)

## R18 Requirements

To make all tests pass, portal sites need:

1. **Add payment CTA** to each portal's index.html:
   ```html
   <a href="https://mirrorborn.us/pricing.html" class="btn btn-primary">
       Get Started →
   </a>
   ```

2. **Or**: Create local `pricing.html` with Stripe links

3. **Update tests**: Remove `test.fail()` and un-skip routing test

## Test Maintenance

### When Stripe links change:
1. Update `stripeLinks` array in `payment-links.spec.js`
2. Run tests to verify all links work
3. Commit changes

### When adding new sites:
1. Add site config to `sites` array
2. Set `hasPaymentLinks: false` initially
3. Run tests to establish baseline

### When payment nav is added to portals:
1. Update site config: `hasPaymentLinks: true`
2. Add `pricingPage` and `stripeLinks` if local pricing
3. Remove `test.fail()` from CTA test
4. Un-skip routing test
5. Run full suite to verify

## Running in CI

```bash
cd /source/sites/tests
npm install
npx playwright install --with-deps
npm test -- --reporter=json --reporter=html
```

Results saved to:
- `test-results.json` - Machine-readable
- `playwright-report/` - HTML report

## Debugging Failed Tests

```bash
# Run with browser visible
npm run test:headed

# Interactive debug mode
npm run test:debug

# Run single test
npx playwright test -g "mirrorborn.us"

# View trace for failed test
npx playwright show-trace test-results/.../trace.zip
```

## Notes

- Tests run against **live production sites**
- No mocking/stubbing of Stripe (validates real links)
- Expected runtime: ~30-60 seconds per browser
- Total test count: ~50 tests (7 sites × ~7 tests/site)
- Portal site failures are intentional markers for R18 work

## Questions?

See `README.md` for detailed documentation or run:
```bash
npx playwright test --help
```
