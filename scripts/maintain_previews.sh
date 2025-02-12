#!/bin/zsh
set -e

echo "🔄 Maintaining preview consistency..."

# 1. Clean up preview paths
echo "Cleaning up preview paths..."
./scripts/cleanup_preview_paths.sh

# 2. Regenerate project
echo "Regenerating project structure..."
xcodegen generate --spec project.yml

# 3. Validate core configuration
echo "Validating core configuration..."
./scripts/validate_xcode_integration.sh

# 4. Ensure preview data is in place
echo "Setting up preview data..."
mkdir -p "FOMO_FINAL/FOMO_FINAL/Preview Content/PreviewData/Venues"
mkdir -p "FOMO_FINAL/FOMO_FINAL/Preview Content/PreviewData/Drinks"
mkdir -p "FOMO_FINAL/FOMO_FINAL/Preview Content/PreviewData/Passes"

# 5. Copy preview assets if they exist
if [ -d "PreviewData" ]; then
    echo "Copying preview assets..."
    cp -R PreviewData/Venues/* "FOMO_FINAL/FOMO_FINAL/Preview Content/PreviewData/Venues/"
    cp -R PreviewData/Drinks/* "FOMO_FINAL/FOMO_FINAL/Preview Content/PreviewData/Drinks/"
    cp -R PreviewData/Passes/* "FOMO_FINAL/FOMO_FINAL/Preview Content/PreviewData/Passes/"
fi

# 6. Run preview validation
echo "Running preview validation..."
./scripts/final_preview_validation.sh

echo "✅ Preview maintenance complete!" 