#!/bin/zsh
set -e

echo "🔍 Running final preview validation..."

# 1. Verify preview paths
./scripts/validate_preview_paths.sh

# 2. Check Xcode project generation
echo "Generating Xcode project..."
xcodegen generate

# 3. Verify preview providers
echo "Checking preview providers..."
find . -name "*.swift" -type f -exec grep -l "PreviewProvider" {} \; | while read -r file; do
    if ! grep -q "@testable import FOMO_FINAL" "$file" && ! grep -q "import FOMO_FINAL" "$file"; then
        echo "⚠️  Warning: Missing FOMO_FINAL import in $file"
    fi
done

# 4. Verify preview assets
echo "Verifying preview assets..."
PREVIEW_ROOT="FOMO_FINAL/FOMO_FINAL/Preview Content"

if [ ! -d "$PREVIEW_ROOT/PreviewData" ] || [ ! -d "$PREVIEW_ROOT/Assets" ]; then
    echo "❌ Error: Missing preview directories"
    exit 1
fi

# 5. Check preview environment
echo "Checking preview environment..."
if ! grep -q "ENABLE_PREVIEWS: YES" "project.yml"; then
    echo "❌ Error: Previews not enabled in project.yml"
    exit 1
fi

if ! grep -q "PREVIEW" "project.yml"; then
    echo "❌ Error: Missing PREVIEW compilation condition"
    exit 1
fi

echo "✅ Final preview validation complete!" 