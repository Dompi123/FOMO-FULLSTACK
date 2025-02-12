#!/bin/zsh
set -e

echo "🔍 Checking preview assets..."

PREVIEW_ROOT="FOMO_FINAL/FOMO_FINAL/Preview Content"

# 1. Check PreviewData
echo "Checking PreviewData..."
if [ ! -f "$PREVIEW_ROOT/PreviewData/sample_drinks.json" ]; then
    echo "❌ Error: Missing sample_drinks.json"
    exit 1
fi

# Validate JSON format
if ! jq . "$PREVIEW_ROOT/PreviewData/sample_drinks.json" > /dev/null 2>&1; then
    echo "❌ Error: Invalid JSON in sample_drinks.json"
    exit 1
fi

# 2. Check Assets
echo "Checking Assets..."
ASSET_ROOT="$PREVIEW_ROOT/Assets/test_assets.xcassets"
REQUIRED_ASSETS=(
    "drink_mojito.imageset/Contents.json"
    "drink_martini.imageset/Contents.json"
    "drink_wine.imageset/Contents.json"
)

for asset in "${REQUIRED_ASSETS[@]}"; do
    if [ ! -f "$ASSET_ROOT/$asset" ]; then
        echo "❌ Error: Missing asset $asset"
        exit 1
    fi
done

# 3. Verify asset catalog structure
if [ ! -f "$ASSET_ROOT/Contents.json" ]; then
    echo "❌ Error: Missing asset catalog Contents.json"
    exit 1
fi

# 4. Check .keep file
if [ ! -f "$PREVIEW_ROOT/.keep" ]; then
    echo "❌ Error: Missing .keep file"
    exit 1
fi

echo "✅ Preview assets validation complete!" 