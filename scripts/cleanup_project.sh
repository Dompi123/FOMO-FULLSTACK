#!/bin/zsh
# Don't exit on error since we expect some files might not exist
set +e

echo "🧹 Cleaning up project resources..."

# Remove duplicate .keep files except in Preview Content
find . -name ".keep" -type f -not -path "*/Preview Content/*" -delete 2>/dev/null || true

# Ensure PreviewData is the single source of truth for JSON files
rm -f FOMO_FINAL/FOMO_FINAL/Resources/Drinks.json 2>/dev/null || true
rm -f FOMO_FINAL/FOMO_FINAL/Resources/Passes.json 2>/dev/null || true
rm -f FOMO_FINAL/FOMO_FINAL/Resources/Profile.json 2>/dev/null || true
rm -f FOMO_FINAL/FOMO_FINAL/Resources/Venues.json 2>/dev/null || true

# Remove duplicate copy_resources.sh
rm -f FOMO_FINAL/FOMO_FINAL/Resources/copy_resources.sh 2>/dev/null || true

# Clean Xcode derived data if it exists
if [ -d ~/Library/Developer/Xcode/DerivedData ]; then
    rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null || true
fi

# Remove duplicate Preview Content
echo "Removing duplicate preview content..."
rm -rf "FOMO_FINAL/Preview Content.backup" 2>/dev/null || true
rm -rf "FOMO_FINAL/Content" 2>/dev/null || true
rm -rf "FOMO_FINAL/Preview" 2>/dev/null || true

# Clean build artifacts
echo "Cleaning build artifacts..."
find . -name "*.build" -type d -exec rm -rf {} + 2>/dev/null || true
if [ -d "FOMO_FINAL.xcodeproj" ]; then
    xcodebuild clean -project FOMO_FINAL.xcodeproj -scheme FOMO_FINAL 2>/dev/null || true
fi

# Remove .DS_Store files
echo "Removing .DS_Store files..."
find . -name ".DS_Store" -delete 2>/dev/null || true

# Organize project structure
echo "Organizing project structure..."
mkdir -p "FOMO_FINAL/FOMO_FINAL/Core" 2>/dev/null || true
mkdir -p "FOMO_FINAL/FOMO_FINAL/Features" 2>/dev/null || true
mkdir -p "FOMO_FINAL/FOMO_FINAL/Resources" 2>/dev/null || true

# Move directories to correct location if they're in the wrong place
if [ -d "FOMO_FINAL/Core" ]; then
    mv "FOMO_FINAL/Core"/* "FOMO_FINAL/FOMO_FINAL/Core/" 2>/dev/null || true
    rm -rf "FOMO_FINAL/Core" 2>/dev/null || true
fi

if [ -d "FOMO_FINAL/Payment" ]; then
    mv "FOMO_FINAL/Payment" "FOMO_FINAL/FOMO_FINAL/Core/" 2>/dev/null || true
fi

echo "✅ Project cleanup complete!" 