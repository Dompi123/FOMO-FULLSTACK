#!/bin/zsh
# Paywall Implementation Validation

echo "🔍 Validating Paywall Implementation..."

# 1. Check file structure
echo "\n📁 Checking file structure..."
REQUIRED_FILES=(
    "FOMO_FINAL/FOMO_FINAL/Features/Venues/Views/Paywall/PaywallView.swift"
    "FOMO_FINAL/FOMO_FINAL/Features/Venues/ViewModels/PaywallViewModel.swift"
    "FOMO_FINAL/FOMO_FINAL/Preview Content/PaywallView+Preview.swift"
    "FOMO_FINAL/FOMO_FINAL/Core/Models/PricingTier.swift"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Missing required file: $file"
        exit 1
    fi
done

# 2. Verify type safety
echo "\n🔒 Verifying type safety..."

# Check for required type safety implementations in specific files
if ! grep -q "struct PricingTier: Identifiable, Equatable" "FOMO_FINAL/FOMO_FINAL/Core/Models/PricingTier.swift"; then
    echo "❌ Missing type safety requirement: struct PricingTier: Identifiable, Equatable"
    exit 1
fi

if ! grep -q "public enum PaymentState: Equatable" "FOMO_FINAL/FOMO_FINAL/Core/Payment/PaymentState.swift"; then
    echo "❌ Missing type safety requirement: public enum PaymentState: Equatable"
    exit 1
fi

# Check PaywallViewModel requirements
VIEWMODEL_CHECKS=(
    "@MainActor"
    "final class PaywallViewModel: ObservableObject"
)

for check in "${VIEWMODEL_CHECKS[@]}"; do
    if ! grep -q "$check" "FOMO_FINAL/FOMO_FINAL/Features/Venues/ViewModels/PaywallViewModel.swift"; then
        echo "❌ Missing type safety requirement: $check"
        exit 1
    fi
done

# 3. Validate navigation integration
echo "\n🔄 Validating navigation integration..."
if ! grep -q ".sheet(isPresented: \$showPaywall)" "FOMO_FINAL/FOMO_FINAL/Features/Venues/Views/VenueDetailView.swift"; then
    echo "❌ Missing sheet presentation in VenueDetailView"
    exit 1
fi

# 4. Check preview implementation
echo "\n🖼 Checking preview implementation..."
PREVIEW_STATES=(
    "Default"
    "Dark Mode"
    "iPhone 15 Pro"
)

for state in "${PREVIEW_STATES[@]}"; do
    if ! grep -q "\"$state\"" "FOMO_FINAL/FOMO_FINAL/Preview Content/PaywallView+Preview.swift"; then
        echo "❌ Missing preview state: $state"
        exit 1
    fi
done

# 5. Verify localization
echo "\n🌐 Verifying localization..."
REQUIRED_STRINGS=(
    "payment.button.pay"
    "payment.button.processing"
    "payment.button.success"
    "payment.button.retry"
)

for string in "${REQUIRED_STRINGS[@]}"; do
    if ! grep -q "\"$string\"" "FOMO_FINAL/FOMO_FINAL/Resources/PaymentStrings.strings"; then
        echo "❌ Missing localization string: $string"
        exit 1
    fi
done

# 6. Run SwiftUI preview tests
echo "\n🧪 Running preview tests..."
xcodebuild test \
    -project FOMO_FINAL.xcodeproj \
    -scheme FOMO_FINAL \
    -destination 'platform=iOS Simulator,name=FOMO Test iPhone,OS=18.2' \
    -only-testing:FOMO_FINALTests/PaywallPreviewTests || {
    echo "❌ Preview tests failed"
    exit 1
}

# 7. Verify environment object injection
echo "\n🔌 Verifying environment object injection..."
if ! grep -q "@EnvironmentObject private var paymentManager: PaymentManager" "FOMO_FINAL/FOMO_FINAL/Features/Venues/Views/Paywall/PaywallView.swift"; then
    echo "❌ Missing PaymentManager environment object"
    exit 1
fi

echo "\n✅ Paywall implementation validation successful!" 