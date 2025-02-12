#!/bin/zsh

# Exit on error
set -e

echo "📦 Copying preview data to app bundle..."

# Get the build directory from xcodebuild
BUILD_DIR=$(xcodebuild -showBuildSettings | grep -m 1 "BUILD_DIR" | grep -oE "\/.*")
APP_BUNDLE="$BUILD_DIR/Debug-iphonesimulator/FOMO_FINAL.app"

# Create PreviewData directory in app bundle
mkdir -p "$APP_BUNDLE/PreviewData"

# Copy fixed data
cp PreviewData/FixedData.json "$APP_BUNDLE/PreviewData/"

# Verify copy
if [ -f "$APP_BUNDLE/PreviewData/FixedData.json" ]; then
    echo "✅ Preview data copied successfully"
    exit 0
else
    echo "❌ Failed to copy preview data"
    exit 1
fi

DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"
mkdir -p "$DEST/JourneyData" "$DEST/Passes" "$DEST/Profile"

copy_with_verify() {
    cp -v "$1" "$2" || { echo "❌ Failed to copy $1"; exit 1; }
    [ -f "$2" ] || { echo "❌ Missing output $2"; exit 1; }
}

copy_with_verify "PreviewData/Venues/Venues.json" "$DEST/JourneyData/Venues.json"
copy_with_verify "PreviewData/Passes/Passes.json" "$DEST/Passes/Passes.json"
copy_with_verify "PreviewData/Profile/Profile.json" "$DEST/Profile/Profile.json" 