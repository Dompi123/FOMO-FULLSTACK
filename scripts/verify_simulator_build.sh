#!/bin/zsh

set -e  # Exit on any error

# Configuration
SIM_NAME="FOMO Test iPhone"
SIM_OS="18.2"

echo "🔍 Verifying simulator build configuration..."

# Find the most recently created simulator
echo "📱 Checking simulator status..."
SIM_UUID=$(xcrun simctl list | grep "$SIM_NAME" | grep -oE "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}" | head -1)

if [ -z "$SIM_UUID" ]; then
    echo "❌ Simulator not found!"
    exit 1
fi

echo "  Found simulator: $SIM_UUID"

# Check if simulator is booted
if ! xcrun simctl list devices | grep "$SIM_UUID" | grep -q "Booted"; then
    echo "❌ Simulator not booted!"
    exit 1
fi

# Verify build destination
echo "🔧 Verifying build configuration..."
if ! xcrun xcodebuild -scheme FOMO_FINAL -destination "platform=iOS Simulator,id=$SIM_UUID" -showBuildSettings 2>/dev/null | grep -q "$SIM_UUID"; then
    echo "❌ Invalid build destination!"
    exit 1
fi

echo "✅ Simulator build configuration verified!"
exit 0 