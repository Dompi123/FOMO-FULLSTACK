#!/bin/zsh

# Exit on any error
set -e

echo "🔍 Starting fixed preview verification..."

# Get app container path
APP_CONTAINER=$(xcrun simctl get_app_container booted com.fomo.FOMO-FINAL)
if [ -z "$APP_CONTAINER" ]; then
    echo "❌ Could not find app container"
    exit 1
fi

# 1. Check mock data exists
echo "📦 Checking mock data..."
if [ ! -f "$APP_CONTAINER/PreviewData/FixedData.json" ]; then
    echo "❌ Mock data not found"
    exit 1
fi

# 2. Verify data content
echo "📋 Verifying data content..."
VENUE_NAME=$(cat "$APP_CONTAINER/PreviewData/FixedData.json" | grep -o '"name":"Fixed Venue"' || echo "")
if [ -z "$VENUE_NAME" ]; then
    echo "❌ Fixed venue data not found"
    exit 1
fi

# 3. Verify app is running
echo "🚀 Verifying app status..."
if ! xcrun simctl spawn booted launchctl list | grep -q "com.fomo.FOMO-FINAL"; then
    echo "❌ App is not running"
    exit 1
fi

# 4. Verify UI elements (basic check)
echo "🖼️ Verifying UI elements..."
UI_DUMP=$(xcrun simctl ui booted dump 2>/dev/null || echo "")
if ! echo "$UI_DUMP" | grep -q "Fixed Venue\|Gold"; then
    echo "❌ Required UI elements not found"
    exit 1
fi

echo "✅ Fixed preview validated successfully!"
exit 0 