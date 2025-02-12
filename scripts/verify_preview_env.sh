#!/bin/zsh
set -e

echo "🔍 Verifying preview environment..."

# Get simulator UUID
SIM_UUID=$(xcrun simctl list devices | grep "Preview iPhone" | grep -E -o -i "([0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})")

if [ -z "$SIM_UUID" ]; then
    echo "❌ Preview iPhone simulator not found!"
    exit 1
fi

# Check if simulator is booted
SIM_STATUS=$(xcrun simctl list devices | grep "$SIM_UUID" | grep -o "Booted")
if [ "$SIM_STATUS" != "Booted" ]; then
    echo "❌ Preview iPhone simulator is not booted!"
    exit 1
fi

# Check if app is installed
APP_INSTALLED=$(xcrun simctl get_app_container "$SIM_UUID" "com.fomo.FOMO-FINAL" app 2>/dev/null || echo "")
if [ -z "$APP_INSTALLED" ]; then
    echo "❌ App is not installed on the simulator!"
    exit 1
fi

# Check if app is running
APP_RUNNING=$(xcrun simctl spawn "$SIM_UUID" launchctl list | grep "com.fomo.FOMO-FINAL" || echo "")
if [ -z "$APP_RUNNING" ]; then
    echo "❌ App is not running!"
    exit 1
fi

# Check build flags
BUILD_FLAGS_FILE="$PWD/FOMO_FINAL/preview_build_flags.txt"
if [ ! -f "$BUILD_FLAGS_FILE" ]; then
    echo "❌ Build flags file not found!"
    exit 1
fi

# Check for preview mode flag
if ! grep -q "PREVIEW_MODE=1" "$BUILD_FLAGS_FILE"; then
    echo "❌ PREVIEW_MODE flag not found in build configuration!"
    exit 1
fi

# Check for mock data flag
if ! grep -q "MOCK_DATA_ENABLED=1" "$BUILD_FLAGS_FILE"; then
    echo "❌ MOCK_DATA_ENABLED flag not found in build configuration!"
    exit 1
fi

echo "✅ Preview environment verification complete!"
exit 0 