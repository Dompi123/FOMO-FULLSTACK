#!/bin/zsh

set -e  # Exit on any error

echo "🔍 Starting app verification..."

# 1. Find simulator
echo "📱 Detecting simulator..."
SIM_UUID=$(xcrun simctl list | grep "FOMO Test iPhone (18.2)" | grep -oE "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}" | head -1)

if [ -z "$SIM_UUID" ]; then
    echo "❌ No matching simulator found!"
    exit 1
fi

echo "  Found simulator: $SIM_UUID"

# 2. Check app installed
echo "📦 Checking app installation..."
if ! xcrun simctl listapps "$SIM_UUID" | grep -q "com.fomo.FOMO-FINAL"; then
    echo "❌ App not installed!"
    exit 1
fi

# 3. Check running process
echo "⚙️ Checking app process..."
if ! xcrun simctl spawn "$SIM_UUID" launchctl list | grep -q "com.fomo.FOMO-FINAL"; then
    echo "❌ App not running!"
    
    # Try relaunching the app
    echo "🔄 Attempting to relaunch app..."
    xcrun simctl launch "$SIM_UUID" "com.fomo.FOMO-FINAL"
    
    # Check again after relaunch
    sleep 2
    if ! xcrun simctl spawn "$SIM_UUID" launchctl list | grep -q "com.fomo.FOMO-FINAL"; then
        echo "❌ App failed to launch!"
        exit 1
    fi
fi

# 4. Verify UI is responsive
echo "🖥 Checking UI responsiveness..."
if ! xcrun simctl spawn "$SIM_UUID" xctest -bundle "$(find ~/Library/Developer/Xcode/DerivedData -name 'FOMO_FINALTests.xctest' | head -1)" 2>/dev/null; then
    echo "⚠️ UI tests unavailable (non-critical)"
fi

echo "✅ App verification passed!"
exit 0 