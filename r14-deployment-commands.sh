#!/bin/bash
# Round 14 Deployment Commands
# Deploy phext-dot-io-v2 content to production using rpush
# Created: 2026-02-07 10:01 CST by Chrys 🦋

set -e  # Exit on error

RPUSH="/source/exocortical/rpush.sh"
SERVER="mirrorborn.us"

echo "🦋 Round 14 Deployment Starting..."
echo "Server: $SERVER"
echo ""

# Strategy: Sync entire phext-dot-io-v2 directory to server
# rpush will place it at /source/phext-dot-io-v2/ on the remote server
# Then nginx configs can point to the appropriate subdirectories

echo "📦 Deploying phext-dot-io-v2 directory to server..."
echo "This will sync all content (public/, domains/, templates/, etc.)"
$RPUSH /source/phext-dot-io-v2 $SERVER

echo ""
echo "✅ Content synced to server at /source/phext-dot-io-v2/"
echo ""
echo "🔧 Next steps (manual or via separate script):"
echo "1. SSH to $SERVER"
echo "2. Create/update nginx configs for each domain"
echo "3. Point nginx root to appropriate directories:"
echo "   - mirrorborn.us → /source/phext-dot-io-v2/public/"
echo "   - visionquest.me → /source/phext-dot-io-v2/domains/visionquest.me/"
echo "   - apertureshift.com → /source/phext-dot-io-v2/domains/apertureshift.com/"
echo "   - wishnode.net → /source/phext-dot-io-v2/domains/wishnode.net/"
echo "   - sotafomo.com → /source/phext-dot-io-v2/domains/sotafomo.com/"
echo "   - quickfork.net → /source/phext-dot-io-v2/domains/quickfork.net/"
echo "   - singularitywatch.org → /source/phext-dot-io-v2/domains/singularitywatch.org/"
echo "4. Get SSL certs: sudo certbot --nginx -d <domain>"
echo "5. Reload nginx: sudo systemctl reload nginx"
echo ""
echo "⏸️  .ai domains (deploy after acquisition):"
echo "   - logicforge.ai"
echo "   - learnpatterns.ai"
echo "   - alignmentpath.ai"
echo ""
echo "Validation:"
echo "1. Test each domain: curl -I https://<domain>"
echo "2. Run smoke tests (Phex + Chrys)"
echo "3. Capture screenshots"
echo "4. Document validation results"
