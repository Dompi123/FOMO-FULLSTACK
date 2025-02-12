#!/bin/zsh
# Validate tokenization implementation

# Check for required files
if [ ! -f "FOMO_FINAL/Payment/Tokenization/LiveTokenizationService.swift" ]; then
    echo "❌ LiveTokenizationService.swift not found!"
    exit 1
fi

# Check and install dependencies
echo "Checking dependencies..."
if ! command -v swiftlint &> /dev/null; then
    echo "Installing SwiftLint..."
    brew install swiftlint
fi

# Run SwiftLint
echo "Running SwiftLint checks..."
if ! swiftlint --strict FOMO_FINAL/Payment/Tokenization/LiveTokenizationService.swift; then
    echo "❌ SwiftLint checks failed!"
    exit 1
fi

# Verify error mapping
echo "\nVerifying error mappings..."
if ! swift test --filter PaymentFlowTests/testErrorLocalization; then
    echo "❌ Error mapping validation failed!"
    exit 1
fi

# Check security headers
echo "\nChecking security implementation..."
if ! grep -q "Bearer \$(try KeychainManager.shared.retrieve(for: .apiKey))" \
    FOMO_FINAL/Payment/Tokenization/LiveTokenizationService.swift; then
    echo "❌ Missing secure API key handling!"
    exit 1
fi

# Check HTTPS enforcement
echo "\nVerifying HTTPS enforcement..."
if ! grep -q "url.scheme == \"https\"" \
    FOMO_FINAL/Payment/Tokenization/LiveTokenizationService.swift; then
    echo "❌ Missing HTTPS enforcement!"
    exit 1
fi

echo "\n✅ Tokenization implementation validated!" 