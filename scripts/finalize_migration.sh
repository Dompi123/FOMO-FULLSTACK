#!/bin/bash

# Configuration
SOURCE_DIR="../fomoskip"
TARGET_DIR="."
PREVIEW_ASSETS_DIR="Preview Content/Preview Assets.xcassets"
EXCLUDE_PATTERNS="sweetpad|LegacyCoreData|Sentry"

# Copy remaining preview assets
echo "Copying remaining preview assets..."
rsync -av --exclude-from=<(echo $EXCLUDE_PATTERNS) \
    "$SOURCE_DIR/$PREVIEW_ASSETS_DIR/" \
    "FOMO_FINAL/FOMO_FINAL/$PREVIEW_ASSETS_DIR/"

# Update localized strings
echo "Updating localized strings..."
find . -name "*.strings" -type f -exec cp -r {} FOMO_FINAL/FOMO_FINAL/Localizations/ \;

# Generate test coverage report
echo "Generating test coverage report..."
xcodebuild test \
    -project FOMO_FINAL/FOMO_FINAL.xcodeproj \
    -scheme FOMO_FINAL \
    -destination 'platform=iOS Simulator,name=iPhone 15' \
    -enableCodeCoverage YES \
    -resultBundlePath TestResults.xcresult

# Generate coverage report
xcrun xccov view --report TestResults.xcresult > coverage_report.txt

echo "Migration finalization complete!"
echo "Please check coverage_report.txt for detailed test coverage information." 