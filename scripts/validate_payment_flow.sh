#!/bin/zsh
# Full Payment Flow Validation

echo "🔥 Running Comprehensive Validation..."

# 1. Check KeychainManager fixes
if ! grep -q "func delete(_ key: KeychainKey) throws" "Sources/FOMO_FINAL/Core/Storage/KeychainManager.swift"; then
    echo "❌ KeychainManager.delete implementation missing!"
    exit 1
fi

# 2. Check secure API key handling
echo "\n🔒 Checking secure API key handling..."
if ! grep -q "try KeychainManager.shared.retrieve(for: .apiKey)" "Sources/FOMO_FINAL/Payment/PaymentViewModel.swift"; then
    echo "❌ Missing secure API key handling!"
    exit 1
fi

# 3. Execute updated tests
echo "\n🔄 Running Fixed Tests..."
swift test --filter "FOMO_FINALTests.PaymentViewModelTests" || {
    echo "❌ Tests failed"
    exit 1
}

# 4. Verify test results
TEST_RESULT=$?
if [ $TEST_RESULT -ne 0 ]; then
    echo "❌ Tests failed with exit code $TEST_RESULT"
    exit 1
fi

# 5. Check error message alignment
echo "\n🔍 Validating Error Messages..."
if ! grep -q "payment.error.retrieval_error" "FOMO_FINAL/Resources/PaymentStrings.strings"; then
    echo "❌ Missing error message localization"
    exit 1
fi

echo "\n✅ All Systems Go! Payment Flow Validation Successful!" 