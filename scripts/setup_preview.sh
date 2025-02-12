#!/bin/zsh
set -e

echo "🚀 Setting up preview environment..."

# Create new simulator
echo "📱 Creating new simulator..."
SIM_NAME="FOMO Preview"
SIM_RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-18-2"
SIM_DEVICE="com.apple.CoreSimulator.SimDeviceType.iPhone-15"

# Delete existing simulator if it exists
xcrun simctl delete "$SIM_NAME" 2>/dev/null || true

# Create new simulator
SIM_UUID=$(xcrun simctl create "$SIM_NAME" "$SIM_DEVICE" "$SIM_RUNTIME")
echo "Created simulator: $SIM_UUID"

# Boot simulator
echo "📱 Starting simulator..."
xcrun simctl boot "$SIM_UUID"
open -a Simulator

# Wait for simulator to boot
echo "⏳ Waiting for simulator to boot..."
while true; do
    if xcrun simctl list devices | grep "$SIM_UUID" | grep -q "Booted"; then
        echo "Simulator booted successfully"
        break
    fi
    sleep 1
done

# Build and install app
echo "🏗 Building app..."
xcodebuild \
    -project FOMO_FINAL/FOMO_FINAL.xcodeproj \
    -scheme FOMO_FINAL \
    -destination "platform=iOS Simulator,id=$SIM_UUID" \
    -configuration Debug \
    build

# Get app container and install mock data
echo "📦 Installing mock data..."
CONTAINER_PATH=$(xcrun simctl get_app_container "$SIM_UUID" "com.fomo.FOMO-FINAL" data)
if [ -z "$CONTAINER_PATH" ]; then
    echo "❌ App container not found!"
    exit 1
fi

DOCUMENTS_PATH="$CONTAINER_PATH/Documents"
mkdir -p "$DOCUMENTS_PATH"

# Copy mock data
echo "📝 Copying mock data files..."
cp JourneyData/*.json "$DOCUMENTS_PATH/"

echo "✅ Setup complete! Mock data installed at:"
ls -la "$DOCUMENTS_PATH"

# Launch app
echo "🚀 Launching app..."
xcrun simctl launch "$SIM_UUID" "com.fomo.FOMO-FINAL" 