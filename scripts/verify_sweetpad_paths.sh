#!/bin/zsh

# Configuration
PREVIEW_DIR="FOMO_FINAL/Preview Content"
XCODEPROJ_PATH="FOMO_FINAL/FOMO_FINAL.xcodeproj/project.pbxproj"

echo "🔍 Validating Sweetpad preview paths..."

# Check directory exists
if [ ! -d "$PREVIEW_DIR" ]; then
    echo "❌ Preview directory missing!"
    exit 1
fi

# Check .keep file exists
if [ ! -f "$PREVIEW_DIR/.keep" ]; then
    echo "❌ .keep file missing!"
    exit 1
fi

# Verify Xcode setting
if [ ! -f "$XCODEPROJ_PATH" ]; then
    echo "❌ Xcode project file not found!"
    exit 1
fi

if ! grep -q "DEVELOPMENT_ASSET_PATHS.*Preview Content" "$XCODEPROJ_PATH"; then
    echo "❌ Xcode path configuration incorrect!"
    exit 1
fi

echo "✅ Sweetpad path validation passed!"
exit 0 