#!/bin/zsh

set -e  # Exit on any error

echo "🔍 Verifying preview environment..."

# 1. Check simulator exists and is booted
echo "📱 Checking simulator status..."
SIM_UUID=$(xcrun simctl list | grep "Preview iPhone" | grep -oE "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}" | head -1)

if [ -z "$SIM_UUID" ]; then
    echo "❌ Preview simulator not found!"
    exit 1
fi

if ! xcrun simctl list | grep "$SIM_UUID" | grep -q "Booted"; then
    echo "❌ Preview simulator not booted!"
    exit 1
fi

echo "  Simulator check passed ✅"

# 2. Verify app installation
echo "📦 Verifying app installation..."
if ! xcrun simctl listapps "$SIM_UUID" | grep -q "com.fomo.FOMO-FINAL"; then
    echo "❌ App not installed!"
    exit 1
fi

echo "  App installation check passed ✅"

# 3. Check app is running
echo "⚙️ Checking app process..."
if ! xcrun simctl spawn "$SIM_UUID" launchctl list | grep -q "com.fomo.FOMO-FINAL"; then
    echo "❌ App not running!"
    exit 1
fi

echo "  Process check passed ✅"

# 4. Verify preview mode flags
echo "🔧 Checking build configuration..."
BUILD_LOG=$(find ~/Library/Developer/Xcode/DerivedData -name "build.log" -print -quit)
if [ ! -f "$BUILD_LOG" ]; then
    echo "❌ Build log not found!"
    exit 1
fi

if ! grep -q "PREVIEW_MODE=1" "$BUILD_LOG"; then
    echo "❌ Preview mode not enabled!"
    exit 1
fi

if ! grep -q "MOCK_DATA_ENABLED=1" "$BUILD_LOG"; then
    echo "❌ Mock data not enabled!"
    exit 1
fi

echo "  Build configuration check passed ✅"

echo "✅ Preview environment verification complete!"
exit 0 