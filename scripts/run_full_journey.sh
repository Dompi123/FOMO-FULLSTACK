#!/bin/zsh
set -e

echo "🚀 Starting full user journey setup..."

# 1. Nuclear cleanup
echo "🧹 Cleaning up existing environment..."
xcrun simctl delete all 2>/dev/null || true
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 2. Create dedicated simulator
echo "📱 Creating journey simulator..."
JOURNEY_UUID=$(xcrun simctl create "Journey iPhone" \
    "iPhone 16 Pro" \
    "com.apple.CoreSimulator.SimRuntime.iOS-18-2")

echo "⏳ Booting simulator..."
xcrun simctl boot "$JOURNEY_UUID"
open -a Simulator

# 3. Copy mock data
echo "📦 Installing mock data..."
CONTAINER_PATH=$(xcrun simctl get_app_container "$JOURNEY_UUID" "com.fomo.FOMO-FINAL" data 2>/dev/null || echo "")
if [ ! -z "$CONTAINER_PATH" ]; then
    mkdir -p "$CONTAINER_PATH/JourneyData"
    cp JourneyData/*.json "$CONTAINER_PATH/JourneyData/"
fi

# 4. Build with journey config
echo "🏗 Building with journey configuration..."
xcodebuild -project FOMO_FINAL/FOMO_FINAL.xcodeproj \
    -scheme FOMO_FINAL \
    -destination "platform=iOS Simulator,id=$JOURNEY_UUID" \
    PREVIEW_MODE=1 \
    MOCK_DATA_SCOPE=full \
    AUTO_NAVIGATE=1 \
    clean build

# 5. Install and launch
echo "📲 Installing app..."
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "FOMO_FINAL.app" -print -quit)
if [ -z "$APP_PATH" ]; then
    echo "❌ Build failed: No .app found"
    exit 1
fi

xcrun simctl install "$JOURNEY_UUID" "$APP_PATH"

echo "🚀 Launching app..."
xcrun simctl launch "$JOURNEY_UUID" "com.fomo.FOMO-FINAL"

# 6. Run automated journey
echo "🤖 Starting automated journey..."
./JourneyScripts/automated_flow.zsh "$JOURNEY_UUID"

echo "✅ Journey setup complete!" 