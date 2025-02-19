#!/bin/zsh
set -e

echo "🔍 Validating preview implementations..."

# Project directory
PROJECT_DIR="FOMO_FINAL/FOMO_FINAL"

# Required preview files
PREVIEW_FILES=(
    "Features/Drinks/Views/DrinkMenuView.swift"
    "Features/Drinks/Views/DrinkRowView.swift"
    "Features/Drinks/Views/CheckoutView.swift"
    "Features/Venues/Views/VenueDetailView.swift"
    "Features/Venues/Views/Paywall/PaywallView.swift"
    "Features/Profile/Views/ProfileView.swift"
)

# Check each file for preview implementation
for file in "${PREVIEW_FILES[@]}"; do
    FULL_PATH="${PROJECT_DIR}/${file}"
    echo "\nChecking ${file}..."
    
    if [ ! -f "$FULL_PATH" ]; then
        echo "❌ File not found: ${file}"
        exit 1
    fi
    
    # Check for preview provider
    if ! grep -q "#Preview" "$FULL_PATH" && ! grep -q "PreviewProvider" "$FULL_PATH"; then
        echo "❌ Missing preview implementation in ${file}"
        exit 1
    fi
    
    # Check for preview environment setup
    if ! grep -q "\.environmentObject" "$FULL_PATH" && ! grep -q "\.environment(" "$FULL_PATH"; then
        echo "⚠️ Warning: No environment modifiers found in ${file}"
    fi
    
    echo "✅ Preview implementation verified in ${file}"
done

# Verify PreviewDataLoader
PREVIEW_LOADER="${PROJECT_DIR}/Core/Preview/PreviewDataLoader.swift"
if [ ! -f "$PREVIEW_LOADER" ]; then
    echo "❌ Missing PreviewDataLoader.swift"
    exit 1
fi

# Check for preview data files
if [ ! -d "${PROJECT_DIR}/PreviewData" ]; then
    echo "❌ Missing PreviewData directory"
    exit 1
fi

echo "\n✅ All preview implementations validated successfully!"
exit 0 