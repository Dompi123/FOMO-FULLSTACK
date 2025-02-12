#!/bin/zsh
set -e

echo "🔧 Adding drink feature files to Xcode project..."

# Create a temporary file list
TEMP_FILE=$(mktemp)
cat << EOF > "$TEMP_FILE"
FOMO_FINAL/FOMO_FINAL/Features/Drinks/Models/DrinkItem.swift
FOMO_FINAL/FOMO_FINAL/Features/Drinks/ViewModels/DrinkMenuViewModel.swift
FOMO_FINAL/FOMO_FINAL/Features/Drinks/ViewModels/CheckoutViewModel.swift
FOMO_FINAL/FOMO_FINAL/Features/Drinks/Views/DrinkMenuView.swift
FOMO_FINAL/FOMO_FINAL/Features/Drinks/Views/CheckoutView.swift
EOF

# Add files to the project
xcodebuild -project FOMO_FINAL.xcodeproj \
          -target FOMO_FINAL \
          -configuration Debug \
          build \
          SOURCES_TO_ADD="$(cat $TEMP_FILE)"

# Clean up
rm "$TEMP_FILE"

echo "✅ All drink feature files added to project" 