#!/bin/zsh

set -e  # Exit on any error

# Parse arguments
DEVICE_NAME="FOMO Test iPhone"
FEATURES="all"
DATA_VERSION="v3"

while [[ $# -gt 0 ]]; do
    case $1 in
        --device)
            DEVICE_NAME="$2"
            shift 2
            ;;
        --features)
            FEATURES="$2"
            shift 2
            ;;
        --data-version)
            DATA_VERSION="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🔧 Setting up preview environment..."
echo "Device: $DEVICE_NAME"
echo "Features: $FEATURES"
echo "Data Version: $DATA_VERSION"

# Get app container
APP_CONTAINER=$(xcrun simctl get_app_container "$DEVICE_NAME" fomo.FOMO-FINAL)
if [ -z "$APP_CONTAINER" ]; then
    echo "❌ Could not find app container in simulator"
    exit 1
fi

# Create required directories
mkdir -p "$APP_CONTAINER/Drinks"
mkdir -p "$APP_CONTAINER/Resources/JourneyData/Passes"
mkdir -p "$APP_CONTAINER/Resources/JourneyData/Profile"
mkdir -p "$APP_CONTAINER/PreviewData"
mkdir -p "$APP_CONTAINER/NewFeatures"

# Copy preview data based on version
PREVIEW_BASE="PreviewData"
# Version is handled in config.json only

echo "📦 Copying preview data..."

# Copy Drinks data
if [ "$FEATURES" = "all" ] || [[ "$FEATURES" =~ "drinks" ]]; then
    cp -R "$PREVIEW_BASE/Drinks/"* "$APP_CONTAINER/Drinks/"
    echo "✅ Drinks data copied"
fi

# Copy Profile and Passes data
cp -R "$PREVIEW_BASE/Profile/"* "$APP_CONTAINER/Resources/JourneyData/Profile/" || true
cp -R "$PREVIEW_BASE/Passes/"* "$APP_CONTAINER/Resources/JourneyData/Passes/" || true
echo "✅ Journey data copied"

# Copy new features data if available
if [ -d "$PREVIEW_BASE/NewFeatures" ]; then
    cp -R "$PREVIEW_BASE/NewFeatures/"* "$APP_CONTAINER/NewFeatures/"
    echo "✅ New features data copied"
fi

# Configure feature flags
cat > "$APP_CONTAINER/PreviewData/config.json" << EOF
{
    "enableAllFeatures": true,
    "dataVersion": "$DATA_VERSION",
    "features": {
        "drinks": true,
        "payment": true,
        "newFeatures": true
    },
    "debug": {
        "paymentDebug": true,
        "previewMode": true
    }
}
EOF
echo "✅ Feature flags configured"

# Verify setup
echo "🔍 Verifying setup..."
for dir in "Drinks" "Resources/JourneyData" "PreviewData"; do
    if [ ! -d "$APP_CONTAINER/$dir" ]; then
        echo "❌ Missing directory: $dir"
        exit 1
    fi
done

if [ ! -f "$APP_CONTAINER/PreviewData/config.json" ]; then
    echo "❌ Missing config file"
    exit 1
fi

echo "✅ Preview environment setup complete!"
exit 0 