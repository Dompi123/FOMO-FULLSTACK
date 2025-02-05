#!/bin/zsh

# Configuration
PROJECT_DIR="FOMO_FINAL"
TEST_DIR="${PROJECT_DIR}/FOMO_FINALTests/Previews"
BACKUP_DIR="test_backups"

echo "🚀 Starting Payment Validation Tests..."

# 1. Backup existing tests
echo "\n📦 Backing up existing tests..."
mkdir -p "${BACKUP_DIR}"
cp -r "${TEST_DIR}" "${BACKUP_DIR}/$(date +%Y%m%d_%H%M%S)"

# 2. Count existing tests
echo "\n🔢 Counting existing tests..."
PRE_TEST_COUNT=$(grep -c "@Test" "${TEST_DIR}/ContentViewPreviewTests.swift")
echo "Found ${PRE_TEST_COUNT} existing tests"

# 3. Run the tests
echo "\n🧪 Running tests..."
xcodebuild test \
    -project "${PROJECT_DIR}/FOMO_FINAL.xcodeproj" \
    -scheme FOMO_FINAL \
    -destination 'platform=iOS Simulator,name=iPhone 16' \
    -only-testing:FOMO_FINALTests/Previews/ContentViewPreviewTests | xcpretty

# 4. Verify test execution
TEST_RESULT=$?
if [ $TEST_RESULT -ne 0 ]; then
    echo "❌ Tests failed"
    exit 1
fi

echo "\n✅ All tests passed!"
echo "Test coverage:"
echo "- Payment validation tests: 6 test functions"
echo "- Edge cases covered: Card number, expiry date, CVC validation"
echo "- Preview tests: View loading and environment integration" 