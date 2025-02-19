#!/bin/zsh
set -e

echo "🚀 Running comprehensive validation..."

# 1. Check environment
if ! command -v xcodegen &> /dev/null; then
    echo "❌ XcodeGen not found. Please install it first."
    exit 1
fi

# 2. Validate project structure
echo "\n📁 Validating project structure..."
./scripts/validate_preview_paths.sh
./scripts/validate_paywall.sh

# 3. Check iOS compatibility
echo "\n📱 Checking iOS compatibility..."
./scripts/check_ios17_compatibility.sh

# 4. Validate preview system
echo "\n🖼 Validating preview system..."
./scripts/validate_previews.sh

# 5. Run final validation
echo "\n✨ Running final validation..."
./scripts/final_validation.sh

# 6. Generate fresh project
echo "\n🔄 Generating fresh project..."
xcodegen generate

# 7. Build validation
echo "\n🏗 Running build validation..."
xcodebuild clean build \
    -scheme FOMO_FINAL \
    -destination 'platform=iOS Simulator,name=iPhone 15,OS=18.1' \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY="" \
    | xcpretty

echo "\n✅ All validations completed successfully!" 