#!/bin/zsh
set -e

# Create log directory
mkdir -p .cursor/validation_logs

# Regenerate project with full logging
echo "🔄 Regenerating project..."
xcodegen generate --spec project.yml 2>&1 | tee .cursor/validation_logs/xcodegen.log

# Validate Xcode integration
echo "🔍 Validating Xcode project..."
./scripts/validate_xcode_integration.sh 2>&1 | tee .cursor/validation_logs/xcode_validation.log

# Clean build environment
echo "🧹 Cleaning project..."
./scripts/cleanup_project.sh 2>&1 | tee .cursor/validation_logs/cleanup.log

# Run preview validation
echo "🖼 Running preview checks..."
./scripts/final_preview_validation.sh 2>&1 | tee .cursor/validation_logs/preview_validation.log

# Check results
echo "\n📋 Validation Results:"
if grep -q "Created project" .cursor/validation_logs/xcodegen.log; then
    echo "✅ Project Generated Successfully"
else
    echo "❌ Project Generation Failed"
fi

if grep -q "All required files" .cursor/validation_logs/xcode_validation.log; then
    echo "✅ Xcode Integration Valid"
else
    echo "❌ Xcode Integration Issues"
fi

if grep -q "preview validation complete" .cursor/validation_logs/preview_validation.log; then
    echo "✅ Preview Checks Passed"
else
    echo "❌ Preview Check Issues"
fi

echo "\n📝 Check detailed logs in .cursor/validation_logs/" 