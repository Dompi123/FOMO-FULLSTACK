#!/bin/zsh

echo "🔍 Verifying data files..."

# Get the build directory from xcodebuild with specific configuration
DERIVED_DATA_DIR=$(xcodebuild -scheme FOMO_FINAL -configuration Debug -sdk iphonesimulator -showBuildSettings | grep -m 1 "BUILT_PRODUCTS_DIR" | grep -oE "\/.*")
BUILD_DIR="${DERIVED_DATA_DIR}/FOMO_FINAL.app"

echo "Checking build directory: ${BUILD_DIR}"

# Check if directories exist
check_directory() {
    if [ ! -d "$BUILD_DIR/$1" ]; then
        echo "❌ Missing directory: $1"
        exit 1
    fi
}

# Check if files exist
check_file() {
    if [ ! -f "$BUILD_DIR/$1" ]; then
        echo "❌ Missing file: $1"
        exit 1
    fi
}

# Verify directory structure
check_directory "Resources"
check_directory "Resources/JourneyData"
check_directory "Resources/JourneyData/Passes"
check_directory "Resources/JourneyData/Profile"

# Verify files
check_file "Resources/JourneyData/Venues.json"
check_file "Resources/JourneyData/Passes/Passes.json"
check_file "Resources/JourneyData/Profile/Profile.json"

echo "✅ All data files verified successfully!"
exit 0 