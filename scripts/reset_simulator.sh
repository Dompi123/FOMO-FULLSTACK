#!/bin/zsh

set -e  # Exit on any error

# Configuration
SIM_NAME="FOMO Test iPhone"
SIM_OS="18.2"
SIM_DEVICE="iPhone 16 Pro"
SIM_RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-18-2"
BOOT_TIMEOUT=60

echo "🔄 Starting simulator reset process..."

# Clean up existing simulators
echo "🧹 Cleaning up existing simulators..."
for uuid in $(xcrun simctl list | grep "$SIM_NAME" | grep -oE "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}"); do
    echo "  Shutting down simulator: $uuid"
    xcrun simctl shutdown "$uuid" 2>/dev/null || true
    echo "  Deleting simulator: $uuid"
    xcrun simctl delete "$uuid" 2>/dev/null || true
done

# Create fresh simulator
echo "🆕 Creating fresh simulator..."
NEW_UDID=$(xcrun simctl create "$SIM_NAME" "$SIM_DEVICE" "$SIM_RUNTIME")
echo "  Created simulator with UDID: $NEW_UDID"

# Boot simulator
echo "🚀 Booting simulator..."
xcrun simctl boot "$NEW_UDID"
open -a Simulator

# Wait for simulator to be ready
echo "⏳ Waiting for simulator to be ready..."
for i in {1..$BOOT_TIMEOUT}; do
    if xcrun simctl list devices | grep "$NEW_UDID" | grep -q "Booted"; then
        sleep 5  # Give it a moment to fully initialize
        echo "  Simulator is ready!"
        break
    fi
    
    if [ $i -eq $BOOT_TIMEOUT ]; then
        echo "❌ Simulator boot timeout!"
        exit 1
    fi
    sleep 1
done

# Verify setup
echo "🔍 Running verification..."
if ./scripts/verify_simulator_build.sh; then
    echo "✅ Simulator reset complete!"
else
    echo "❌ Verification failed!"
    exit 1
fi 