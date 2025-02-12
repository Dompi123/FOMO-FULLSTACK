#!/bin/zsh
set -e

echo "📦 Installing mock data..."

# Find any iPhone simulator
SIM_UUID=$(xcrun simctl list devices | grep "iPhone" | grep "Booted" | head -1 | grep -oE "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}")

if [ -z "$SIM_UUID" ]; then
    echo "❌ No booted simulator found!"
    echo "Please make sure a simulator is running."
    exit 1
fi

echo "Found simulator: $SIM_UUID"

# Get app container path
CONTAINER_PATH=$(xcrun simctl get_app_container "$SIM_UUID" "com.fomo.FOMO-FINAL" data)
if [ -z "$CONTAINER_PATH" ]; then
    echo "❌ App container not found! Make sure the app is installed."
    exit 1
fi

# Create Documents directory
DOCUMENTS_PATH="$CONTAINER_PATH/Documents"
mkdir -p "$DOCUMENTS_PATH"

# Copy mock data
echo "📝 Copying mock data files..."
cp JourneyData/*.json "$DOCUMENTS_PATH/"

echo "✅ Mock data installed successfully!"
ls -la "$DOCUMENTS_PATH" 