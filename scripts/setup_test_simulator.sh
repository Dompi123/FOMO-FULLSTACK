#!/bin/zsh
set -e

echo "🔧 Setting up FOMO Test iPhone simulator..."

# Check if simulator exists
SIMULATOR_NAME="FOMO Test iPhone"
DEVICE_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | awk -F'[()]' '{print $2}')

if [ -n "$DEVICE_ID" ]; then
    echo "📱 Simulator already exists with ID: $DEVICE_ID"
    echo "Erasing simulator..."
    xcrun simctl erase "$DEVICE_ID"
else
    echo "Creating new simulator..."
    DEVICE_ID=$(xcrun simctl create "$SIMULATOR_NAME" "iPhone 15" "iOS18.1")
    echo "📱 Created simulator with ID: $DEVICE_ID"
fi

# Boot simulator
echo "🚀 Booting simulator..."
xcrun simctl boot "$DEVICE_ID"

# Wait for boot
echo "⏳ Waiting for simulator to boot..."
until xcrun simctl list devices | grep "$DEVICE_ID" | grep -q "Booted"; do
    sleep 1
done

echo "✅ FOMO Test iPhone simulator is ready!" 