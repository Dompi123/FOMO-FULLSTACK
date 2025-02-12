#!/bin/zsh
set -e

echo "🔍 Validating Preview Content paths..."

# Check Preview Content directory
if [ ! -d "FOMO_FINAL/FOMO_FINAL/Preview Content" ]; then
    echo "❌ Preview Content directory missing!"
    exit 1
fi

# Check .keep file
if [ ! -f "FOMO_FINAL/FOMO_FINAL/Preview Content/.keep" ]; then
    echo "❌ .keep file missing in Preview Content"
    exit 1
fi

# Check if directory is referenced in project.yml
if ! grep -q "DEVELOPMENT_ASSET_PATHS.*Preview Content" project.yml; then
    echo "❌ Preview Content path not properly configured in project.yml"
    exit 1
fi

echo "✅ Preview Content paths validation successful!" 