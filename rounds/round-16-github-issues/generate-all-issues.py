#!/usr/bin/env python3
"""
Generate all 47 R16 bug issues as markdown files
Ready for GitHub issue creation
"""

import os

# Issue data extracted from round-16-bug-audit.md
issues = [
    # Already created: #1, #2, #3
    
    # Critical #4-8
    {
        "num": 4,
        "title": "🔴 Arena: No SQ integration",
        "severity": "Critical",
        "file": "arena.html",
        "issue": "Hardcoded scroll data, doesn't fetch from SQ",
        "impact": "Shows fake data, not real CYOA",
        "fix": """```javascript
async function loadScrolls(coord) {
  try {
    const response = await fetch(`http://localhost:1337/select/${coord}`);
    if (!response.ok) throw new Error('SQ fetch failed');
    const data = await response.json();
    displayScrolls(data.scrolls || []);
  } catch (err) {
    console.error('Failed to load scrolls:', err);
    displayError('Unable to load scrolls from this coordinate.');
  }
}
```""",
        "labels": ["bug", "critical", "r16", "arena", "integration"]
    },
    {
        "num": 5,
        "title": "🔴 CSS: Font loading blocks render",
        "severity": "Critical",
        "file": "metallic-theme.css",
        "issue": "Google Fonts fail → site breaks visually",
        "impact": "Offline/slow connections see broken typography",
        "fix": """```css
/* Add font-display: swap and fallback stack */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;600&family=Space+Grotesk:wght@400;600;700&display=swap');

:root {
  --font-primary: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', 'Consolas', 'Monaco', 'Courier New', monospace;
  --font-display: 'Space Grotesk', 'Orbitron', -apple-system, sans-serif;
}
```""",
        "labels": ["bug", "critical", "r16", "css", "performance"]
    },
    {
        "num": 6,
        "title": "🔴 Coordinate Signup: No input validation",
        "severity": "Critical",
        "file": "coordinate-signup.html",
        "issue": "`setCoord()` doesn't validate input format",
        "impact": "Malformed coordinates crash the picker",
        "fix": """```javascript
function setCoord(coordNum, coordStr) {
  // Validate format
  if (!/^\\d+\\.\\d+\\.\\d+\\/\\d+\\.\\d+\\.\\d+\\/\\d+\\.\\d+\\.\\d+$/.test(coordStr)) {
    alert('Invalid coordinate format. Use: X.X.X/X.X.X/X.X.X');
    return false;
  }
  
  const parts = coordStr.split('/');
  const p1 = parts[0].split('.');
  const p2 = parts[1].split('.');
  const p3 = parts[2].split('.');
  
  // Validate ranges (1-999 per dimension)
  const allParts = [...p1, ...p2, ...p3];
  if (allParts.some(n => parseInt(n) < 1 || parseInt(n) > 999)) {
    alert('Coordinates must be between 1 and 999');
    return false;
  }
  
  // Rest of implementation
  // ...
  return true;
}
```""",
        "labels": ["bug", "critical", "r16", "validation"]
    },
    {
        "num": 7,
        "title": "🔴 All pages: No CSRF protection",
        "severity": "Critical",
        "file": "All HTML files",
        "issue": "Forms don't include CSRF tokens",
        "impact": "Cross-site request forgery vulnerability",
        "fix": """**Backend (sq-admin-api/server.js):**
```javascript
const csrf = require('csurf');
const csrfProtection = csrf({cookie: true});

app.use(csrfProtection);

app.get('/csrf-token', (req, res) => {
  res.json({token: req.csrfToken()});
});
```

**Frontend (all forms):**
```javascript
// Fetch CSRF token on page load
fetch('/csrf-token')
  .then(r => r.json())
  .then(data => {
    document.querySelectorAll('form').forEach(form => {
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = '_csrf';
      input.value = data.token;
      form.appendChild(input);
    });
  });
```""",
        "labels": ["bug", "critical", "r16", "security"]
    },
    {
        "num": 8,
        "title": "🔴 Arena: localStorage data not encrypted",
        "severity": "Critical",
        "file": "arena.html",
        "issue": "Sensitive coordinate data stored in plain text",
        "impact": "XSS can steal user's entire navigation history",
        "fix": """```javascript
// Use Web Crypto API for encryption
async function savePosition(position) {
  const key = await getEncryptionKey();
  const data = JSON.stringify(position);
  const encrypted = await encryptData(key, data);
  localStorage.setItem('arena-position', encrypted);
}

async function loadPosition() {
  const encrypted = localStorage.getItem('arena-position');
  if (!encrypted) return null;
  
  try {
    const key = await getEncryptionKey();
    const decrypted = await decryptData(key, encrypted);
    return JSON.parse(decrypted);
  } catch (err) {
    console.error('Failed to decrypt position:', err);
    return null;
  }
}

// Helper: Derive encryption key from user session
async function getEncryptionKey() {
  const sessionId = getSessionId(); // From auth token
  const keyMaterial = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(sessionId),
    {name: 'PBKDF2'},
    false,
    ['deriveBits', 'deriveKey']
  );
  
  return crypto.subtle.deriveKey(
    {name: 'PBKDF2', salt: new Uint8Array(16), iterations: 100000, hash: 'SHA-256'},
    keyMaterial,
    {name: 'AES-GCM', length: 256},
    false,
    ['encrypt', 'decrypt']
  );
}
```

**Note:** Requires authentication system to provide session ID.""",
        "labels": ["bug", "critical", "r16", "security", "arena"]
    },
]

# Generate markdown files
output_dir = "/source/exo-plan/rounds/round-16-github-issues"
os.makedirs(output_dir, exist_ok=True)

for issue in issues:
    filename = os.path.join(output_dir, f"issue-{issue['num']:03d}.md")
    content = f"""{issue['title']}

**Bug #{issue['num']} - {issue['severity']}**

**File:** `{issue['file']}`

**Issue:** {issue['issue']}

**Impact:** {issue['impact']}

**Fix:**
{issue['fix']}

**Source:** R16 Bug Audit (2026-02-07)

**Labels:** {', '.join(f'`{l}`' for l in issue['labels'])}
"""
    with open(filename, 'w') as f:
        f.write(content)
    print(f"✅ Created {filename}")

print(f"\n✅ Generated {len(issues)} issue files (Critical #4-8)")
print("⏸️  High/Medium/Low severity issues pending (manually create or extend script)")
print("\nNext: Run this script to generate remaining 39 issues, or create manually on GitHub")
