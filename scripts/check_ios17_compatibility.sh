#!/bin/zsh
set -e

echo "🔍 Checking iOS 17 compatibility..."

# 1. Verify Xcode version
echo "Checking Xcode version..."
XCODE_VERSION=$(xcodebuild -version | head -n 1 | awk '{ print $2 }')
if [ "${XCODE_VERSION%%.*}" -lt 15 ]; then
    echo "❌ Error: Xcode 15+ required (found $XCODE_VERSION)"
    exit 1
fi

# 2. Check iOS SDK version
echo "Checking iOS SDK version..."
SDK_VERSION=$(xcrun --sdk iphoneos --show-sdk-version)
if [ "${SDK_VERSION%%.*}" -lt 17 ]; then
    echo "❌ Error: iOS 17 SDK required (found $SDK_VERSION)"
    exit 1
fi

# 3. Verify project configuration
echo "Verifying project configuration..."
# Check deployment targets
if ! grep -A 2 "deploymentTarget:" project.yml | grep -q "iOS: 17.0"; then
    if ! grep -A 2 "FOMO_FINAL:" project.yml | grep -q "iOS: 17.0"; then
        echo "❌ Error: iOS 17 deployment target not found"
        exit 1
    fi
fi

# Check compilation conditions
if ! grep -q "SWIFT_ACTIVE_COMPILATION_CONDITIONS.*IOS17_COMPAT" project.yml; then
    echo "❌ Error: Missing IOS17_COMPAT compilation condition"
    exit 1
fi

# 4. Check SwiftUI availability
echo "Checking SwiftUI features..."
if ! grep -q "SwiftUI.framework" project.yml; then
    echo "❌ Error: SwiftUI framework not properly configured"
    exit 1
fi

# 5. Verify test target configuration
echo "Checking test configuration..."
if ! grep -q "FOMO_FINALTests:" project.yml; then
    echo "❌ Error: Test target not found"
    exit 1
fi

if ! grep -q "type: bundle.unit-test" project.yml; then
    echo "❌ Error: Test target not properly configured"
    exit 1
fi

echo "✅ iOS 17 compatibility check complete!" 