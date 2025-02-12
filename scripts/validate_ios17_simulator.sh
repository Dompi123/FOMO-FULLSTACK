#!/bin/zsh
set -e

echo "🔍 Starting iOS simulator validation..."

# 1. Environment verification
echo "Checking Xcode version..."
XCODE_VERSION=$(xcodebuild -version | awk 'NR==1 {print $2}')
if [[ "$XCODE_VERSION" < "15.4" ]]; then
    echo "❌ Xcode 15.4+ required (found $XCODE_VERSION)"
    exit 1
fi

# 2. Simulator existence check
echo "Verifying simulator configuration..."
SIMULATOR_STATUS=$(xcrun simctl list | grep "FOMO_Simulator" || true)
if [[ -z "$SIMULATOR_STATUS" ]]; then
    echo "🔄 Creating iOS 18.1 simulator..."
    xcrun simctl create "FOMO_Simulator" "iPhone 15" "iOS18.1"
fi

# 3. Project generation
echo "Generating Xcode project..."
xcodegen generate

# 4. Build validation
echo "Building project..."
xcodebuild clean build \
  -scheme FOMO_FINAL \
  -destination 'platform=iOS Simulator,name=FOMO_Simulator,OS=18.1' \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  DEVELOPMENT_TEAM="" \
  VALID_ARCHS="x86_64 arm64" \
  ONLY_ACTIVE_ARCH=YES \
  | xcpretty || {
    echo "❌ Build failed"
    exit 1
  }

echo "✅ iOS simulator validation successful!" 