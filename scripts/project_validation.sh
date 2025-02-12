#!/bin/zsh
set -e

echo "🔍 Starting project validation..."

# Check directory structure
check_directory() {
    if [ -d "$1" ]; then
        echo "✅ Found directory: $1"
        return 0
    else
        echo "❌ Missing directory: $1"
        return 1
    fi
}

# Check file existence
check_file() {
    if [ -f "$1" ]; then
        echo "✅ Found file: $1"
        return 0
    else
        echo "❌ Missing file: $1"
        return 1
    fi
}

# Check project structure
echo "\nChecking project structure..."
check_directory "FOMO_FINAL"
check_directory "FOMO_FINAL.xcodeproj"
check_directory "FOMO_FINAL/FOMO_FINAL"
check_directory "FOMO_FINAL/FOMO_FINAL/Features"

# Check critical files
echo "\nChecking critical files..."
check_file "FOMO_FINAL.xcodeproj/project.pbxproj"
check_file "FOMO_FINAL/FOMO_FINAL/App/FOMO_FINALApp.swift"
check_file "BuildSettings.xcconfig"

# Check feature files
echo "\nChecking feature files..."
check_directory "FOMO_FINAL/FOMO_FINAL/Features/Drinks"
check_directory "FOMO_FINAL/FOMO_FINAL/Features/Drinks/Views"
check_directory "FOMO_FINAL/FOMO_FINAL/Features/Drinks/ViewModels"
check_directory "FOMO_FINAL/FOMO_FINAL/Features/Drinks/Models"

# Check specific drink files
echo "\nChecking drink feature files..."
check_file "FOMO_FINAL/FOMO_FINAL/Features/Drinks/Views/DrinkMenuView.swift"
check_file "FOMO_FINAL/FOMO_FINAL/Features/Drinks/Views/CheckoutView.swift"
check_file "FOMO_FINAL/FOMO_FINAL/Features/Drinks/ViewModels/DrinkMenuViewModel.swift"
check_file "FOMO_FINAL/FOMO_FINAL/Features/Drinks/ViewModels/CheckoutViewModel.swift"
check_file "FOMO_FINAL/FOMO_FINAL/Features/Drinks/Models/DrinkItem.swift"

# Check preview data
echo "\nChecking preview data..."
check_directory "PreviewData/Drinks"
check_file "PreviewData/Drinks/Drinks.json"

echo "\n✅ Validation complete!" 