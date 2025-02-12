#!/bin/zsh
set -e

echo "🔍 Validating drink features integration..."

# File existence check
check_file() {
    if [ ! -f "$1" ]; then
        echo "❌ Missing file: $1"
        return 1
    fi
    echo "✅ Found file: $1"
    return 0
}

# Project directory
PROJECT_DIR="FOMO_FINAL"

# Check source files
echo "\nChecking source files..."
check_file "${PROJECT_DIR}/FOMO_FINAL/Features/Drinks/ViewModels/DrinkMenuViewModel.swift"
check_file "${PROJECT_DIR}/FOMO_FINAL/Features/Drinks/ViewModels/CheckoutViewModel.swift"
check_file "${PROJECT_DIR}/FOMO_FINAL/Features/Drinks/Views/DrinkMenuView.swift"
check_file "${PROJECT_DIR}/FOMO_FINAL/Features/Drinks/Views/CheckoutView.swift"

# Check preview data
echo "\nChecking preview data..."
check_file "${PROJECT_DIR}/PreviewData/Drinks/Drinks.json"

# Check simulator content
echo "\nChecking simulator content..."
APP_CONTAINER=$(xcrun simctl get_app_container booted fomo.FOMO-FINAL)
if [ -z "$APP_CONTAINER" ]; then
    echo "❌ Could not find app container in simulator"
    exit 1
fi

if [ ! -f "$APP_CONTAINER/Drinks/Drinks.json" ]; then
    echo "❌ Missing drinks data in simulator"
    exit 1
fi
echo "✅ Found drinks data in simulator"

# Project reference check
echo "\nChecking project references..."
if ! plutil -extract objects xml1 -o - FOMO_FINAL.xcodeproj/project.pbxproj | grep -q "DrinkMenuViewModel.swift"; then
    echo "❌ DrinkMenuViewModel.swift not referenced in project"
    exit 1
fi
echo "✅ Found drink feature references in project"

echo "\n✅ Drink features validation completed successfully!"
exit 0 