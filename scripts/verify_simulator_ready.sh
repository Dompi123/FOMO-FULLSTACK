#!/bin/zsh

# Configuration
SIM_UDID="A9AA9E1A-7C83-4296-A51C-5277F1BF4AE4"
APP_BUNDLE_ID="com.fomo.FOMO-FINAL"

echo "🔍 Verifying simulator status..."

# Check if simulator exists
echo "📱 Checking simulator existence..."
if ! xcrun simctl list | grep -q "$SIM_UDID"; then
    echo "❌ Simulator not found!"
    exit 1
fi

# Check boot status
echo "🔄 Checking boot status..."
SIM_STATUS=$(xcrun simctl list | grep -A 3 "$SIM_UDID" | grep "state:" | awk '{print $2}')
if [[ "$SIM_STATUS" != "Booted" ]]; then
    echo "❌ Simulator not booted (Status: $SIM_STATUS)"
    exit 1
fi

# Verify system readiness
echo "⚙️ Verifying system readiness..."
if ! xcrun simctl spawn "$SIM_UDID" launchctl print system | grep -q "com.apple.springboard"; then
    echo "❌ SpringBoard not ready!"
    exit 1
fi

# Test basic app launch
echo "📲 Testing app launch..."
if ! xcrun simctl launch "$SIM_UDID" "$APP_BUNDLE_ID" &>/dev/null; then
    echo "❌ App launch failed!"
    exit 1
fi

echo "✅ Simulator validation passed!"
exit 0 