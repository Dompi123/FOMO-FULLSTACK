#!/bin/bash

# Exit on error
set -e

# 1. Set target device from context
export TARGET_DEVICE="FOMO Test iPhone"

# 2. Get available runtimes and select latest iOS 18
LATEST_RUNTIME=$(xcrun simctl list runtimes | grep iOS | tail -1 | cut -d ' ' -f 7)
if [[ -z "$LATEST_RUNTIME" ]]; then
    echo "❌ No iOS runtime found!"
    exit 1
fi
echo "📱 Using runtime: $LATEST_RUNTIME"

# 3. Verify device existence or create it
DEVICE_ID=$(xcrun simctl list devices | grep "$TARGET_DEVICE" | cut -d "(" -f 2 | cut -d ")" -f 1)
if [[ -z "$DEVICE_ID" ]]; then
    echo "🔨 Creating simulator '$TARGET_DEVICE'..."
    DEVICE_ID=$(xcrun simctl create "$TARGET_DEVICE" "iPhone 15 Pro" "$LATEST_RUNTIME")
    echo "✅ Created simulator with ID: $DEVICE_ID"
fi

# 4. Boot simulator if not running
BOOT_STATUS=$(xcrun simctl list devices | grep "$TARGET_DEVICE" | grep -o "(Booted)")
if [[ -z "$BOOT_STATUS" ]]; then
    echo "🚀 Booting simulator..."
    xcrun simctl boot "$DEVICE_ID"
fi

# 5. Build and install
echo "🔨 Building project..."
xcodebuild -project FOMO_FINAL/FOMO_FINAL.xcodeproj \
    -scheme FOMO_FINAL \
    -destination "platform=iOS Simulator,id=$DEVICE_ID" \
    -configuration Debug \
    clean build

# 6. Set up preview environment
echo "🔧 Setting up preview environment..."
./scripts/setup_preview_env.sh \
    --device "$TARGET_DEVICE" \
    --data-version v4

# 7. Launch app
echo "🚀 Launching app..."
xcrun simctl launch "$DEVICE_ID" "fomo.FOMO-FINAL" \
    --args -enableAllFeatures 