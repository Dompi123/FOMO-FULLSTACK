#!/bin/zsh
set -e

echo "🚀 Running final preflight validation..."

# 1. Check iOS version compatibility
echo "Checking iOS compatibility..."
if ! grep -q "iOS: 17.0" project.yml; then
    echo "❌ Error: iOS version mismatch in project.yml"
    exit 1
fi

# 2. Verify compilation conditions
echo "Verifying compilation conditions..."
if ! grep -q "SWIFT_ACTIVE_COMPILATION_CONDITIONS.*IOS17_COMPAT" project.yml; then
    echo "❌ Error: Missing IOS17_COMPAT compilation condition"
    exit 1
fi

# 3. Validate preview system
echo "Validating preview system..."
./scripts/validate_preview_paths.sh
./scripts/check_preview_assets.sh

# 4. Check test configuration
echo "Checking test configuration..."
if ! grep -q "type: bundle.unit-test" project.yml; then
    echo "❌ Error: Test target not properly configured"
    exit 1
fi

# 5. Verify project structure
echo "Verifying project structure..."
REQUIRED_DIRS=(
    "FOMO_FINAL/FOMO_FINAL/Preview Content"
    "FOMO_FINAL/FOMO_FINAL/Preview Content/PreviewData"
    "FOMO_FINAL/FOMO_FINAL/Preview Content/Assets"
    "FOMO_FINALTests"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "❌ Error: Required directory missing: $dir"
        exit 1
    fi
done

# 6. Check for critical files
echo "Checking critical files..."
REQUIRED_FILES=(
    "project.yml"
    "FOMO_FINAL/FOMO_FINAL/Preview Content/PreviewData/sample_drinks.json"
    "FOMO_FINAL/FOMO_FINAL/Preview Content/Assets/test_assets.xcassets/Contents.json"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: Required file missing: $file"
        exit 1
    fi
done

# 7. Verify Xcode 15 compatibility
echo "Checking Xcode 15 compatibility..."
XCODE_VERSION=$(xcodebuild -version | head -n 1 | awk '{ print $2 }')
if [ "${XCODE_VERSION%%.*}" -lt 15 ]; then
    echo "⚠️  Warning: Project configured for Xcode 15+ but running on Xcode $XCODE_VERSION"
fi

# 8. Generate fresh project
echo "Generating fresh Xcode project..."
xcodegen generate

echo "✅ Final preflight validation complete!" 