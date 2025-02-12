#!/bin/zsh
set +e  # Don't exit on error

echo "☢️  Initiating nuclear reset..."

# Check for required tools
check_dependencies() {
    echo "🔍 Checking dependencies..."
    
    # Check for Xcode Command Line Tools
    if ! xcode-select -p &> /dev/null; then
        echo "Installing Xcode Command Line Tools..."
        xcode-select --install
        echo "Please wait for Xcode Command Line Tools to finish installing, then run this script again."
        exit 1
    fi
    
    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Check for XcodeGen
    if ! command -v xcodegen &> /dev/null; then
        echo "Installing XcodeGen..."
        brew install xcodegen
    fi
}

# Set up project paths
PROJECT_ROOT="$(pwd)"
PREVIEW_ROOT="$PROJECT_ROOT/FOMO_FINAL/FOMO_FINAL/Preview Content"
RESOURCES_ROOT="$PROJECT_ROOT/FOMO_FINAL/FOMO_FINAL/Resources"

# Validate critical paths
validate_paths() {
    echo "🔍 Validating project paths..."
    REQUIRED_PATHS=(
        "$PROJECT_ROOT/FOMO_FINAL"
        "$PROJECT_ROOT/FOMO_FINALTests"
        "$PREVIEW_ROOT"
        "$RESOURCES_ROOT"
    )

    for path in "${REQUIRED_PATHS[@]}"; do
        if [ ! -d "$path" ]; then
            echo "Creating directory: $path"
            mkdir -p "$path"
        fi
    done
    echo "✅ Path validation complete"
}

# Verify Xcode iOS SDK
verify_sdk() {
    if ! xcrun --sdk iphoneos --show-sdk-version &> /dev/null; then
        echo "⚠️  Warning: Could not determine iOS SDK version"
        echo "This might be normal if Xcode Command Line Tools are still installing"
        return 0
    fi

    SDK_VERSION=$(xcrun --sdk iphoneos --show-sdk-version)
    echo "📱 Found iOS SDK version: $SDK_VERSION"
    
    if [ ! -z "$SDK_VERSION" ] && [ "${SDK_VERSION%%.*}" -lt 15 ]; then
        echo "❌ Error: iOS 15+ SDK required (found $SDK_VERSION)"
        exit 1
    fi
}

# Main execution
check_dependencies
validate_paths
verify_sdk

# 1. Clean project
echo "🧹 Cleaning project resources..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*FOMO_FINAL* 2>/dev/null
rm -rf .build 2>/dev/null
find . -name ".DS_Store" -delete 2>/dev/null
find . -name "*.xcuserstate" -delete 2>/dev/null

# 2. Purge Xcode caches
echo "🧹 Purging Xcode caches..."
rm -rf ~/Library/Developer/Xcode/{DerivedData,Archives,Products} 2>/dev/null
defaults delete com.apple.dt.Xcode 2>/dev/null || true

# 3. Clean all preview and build artifacts
echo "🧹 Removing build artifacts..."
find . -name "*.build" -type d -exec rm -rf {} + 2>/dev/null || true
rm -rf FOMO_FINAL.xcodeproj 2>/dev/null || true

# 4. Regenerate project
echo "🔄 Regenerating project..."
xcodegen generate

# 5. Set up fresh preview environment
echo "🔄 Setting up preview environment..."
if [ -f "./scripts/maintain_previews.sh" ]; then
    ./scripts/maintain_previews.sh
fi

# 6. Final validation
echo "✅ Running final validation..."
if [ -f "./scripts/validate_fomofinal.sh" ]; then
    ./scripts/validate_fomofinal.sh
fi

echo "✅ Nuclear reset complete!" 