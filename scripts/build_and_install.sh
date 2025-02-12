#!/bin/zsh

# Exit on error
set -e

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --device)
            DEVICE_NAME="$2"
            shift 2
            ;;
        --flags)
            BUILD_FLAGS="$2"
            shift 2
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate device
if ! xcrun simctl list devices | grep -q "$DEVICE_NAME"; then
    echo "❌ Device $DEVICE_NAME not found"
    exit 1
fi

# Clean if requested
if [[ $CLEAN_BUILD == true ]]; then
    echo "🧹 Cleaning build..."
    rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null || true
fi

echo "🔨 Building FOMO_FINAL..."
xcodebuild \
    -project FOMO_FINAL.xcodeproj \
    -scheme FOMO_FINAL \
    -destination "platform=iOS Simulator,name=$DEVICE_NAME" \
    -configuration Debug \
    $BUILD_FLAGS \
    build

# Get latest build path
BUILD_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "FOMO_FINAL.app" -type d | head -n 1)

echo "📱 Installing on $DEVICE_NAME..."
xcrun simctl install "$DEVICE_NAME" "$BUILD_PATH"

echo "✅ Build and install complete!"