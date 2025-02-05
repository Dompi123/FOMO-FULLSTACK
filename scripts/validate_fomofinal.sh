#!/bin/zsh

# Configuration
TARGET_DIR=${1:-"FOMO_FINAL"}
REPORT_FILE="FINAL_VALIDATION.md"

echo "🔍 Starting FOMO_FINAL validation..."

# 1. Build Isolation Check
echo "\n📦 Running build isolation check..."
xcodebuild build -scheme FOMO_FINAL -project "${TARGET_DIR}/FOMO_FINAL.xcodeproj" -destination 'platform=iOS Simulator,name=iPhone 16' | xcpretty || {
    echo "❌ Build failed"
    exit 1
}

# 2. Sweetpad Reference Check
echo "\n🔍 Checking for Sweetpad references..."
SWEETPAD_REFS=$(grep -r "fomoskip" "${TARGET_DIR}" | grep -v "MIGRATION_REPORT.md" || true)
if [ ! -z "$SWEETPAD_REFS" ]; then
    echo "❌ Sweetpad references detected:"
    echo "$SWEETPAD_REFS"
    exit 1
fi

# 3. Namespace Check
echo "\n🏷 Running namespace check..."
OBJC_REFS=$(grep -r "@objc(Pass)" "${TARGET_DIR}" | wc -l)
if [ "$OBJC_REFS" -ne 0 ]; then
    echo "❌ Found $OBJC_REFS @objc(Pass) references"
    exit 1
fi

# 4. Preview Tests
echo "\n🖼 Running preview tests..."
xcodebuild test -scheme FOMO_FINAL -project "${TARGET_DIR}/FOMO_FINAL.xcodeproj" -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:FOMO_FINALTests | xcpretty || {
    echo "❌ Preview tests failed"
    exit 1
}

# 5. Generate Validation Report
echo "\n📝 Generating validation report..."
cat > "${REPORT_FILE}" << EOF
# FOMO_FINAL Validation Report
Generated on $(date)

## Build Status
✅ Build successful
✅ No Sweetpad references found
✅ Namespace check passed (0 @objc(Pass) references)
✅ Preview tests passed

## Validation Details
- Target Directory: ${TARGET_DIR}
- Build Scheme: FOMO_FINAL
- Preview Tests: Passed
- Sweetpad Safety: Clean

## Next Steps
1. Review test coverage report
2. Verify preview assets
3. Run final integration tests

## Notes
- All builds are isolated from Sweetpad
- Preview tests running in parallel mode
- No legacy namespace conflicts detected
EOF

echo "\n✅ Validation complete! Report generated at ${REPORT_FILE}" 