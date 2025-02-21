import SwiftUI
import Foundation
import OSLog

struct PricingCard: View {
    let tier: PricingTier
    let isSelected: Bool
    let action: () -> Void
    
    // Add security validation
    private var isSecurePrice: Bool {
        guard let _ = tier.price as? NSDecimalNumber else {
            Logger.appSecurity.error("Invalid price format detected")
            return false
        }
        return true
    }
    
    var body: some View {
        Button(action: {
            guard isSecurePrice else {
                Logger.appSecurity.fault("Attempted to select tier with invalid price")
                return
            }
            action()
        }) {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text(tier.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if isSecurePrice {
                        Text(tier.formattedPrice)
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                            .privacySensitive()
                    }
                }
                
                if tier.isBestValue {
                    Text("Best Value")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(FOMOTheme.Colors.success)
                        .clipShape(Capsule())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(tier.features, id: \.self) { feature in
                        Label {
                            Text(feature)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(FOMOTheme.Colors.success)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? FOMOTheme.Colors.primary.opacity(0.1) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(isSelected ? FOMOTheme.Colors.primary : Color.gray.opacity(0.3))
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isSecurePrice)
    }
}

// MARK: - Secure Price Formatting
extension PricingTier {
    var secureFormattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        
        guard let price = price as? NSDecimalNumber,
              let formatted = formatter.string(from: price) else {
            Logger.appSecurity.error("Failed to format price securely")
            return "Invalid Price"
        }
        return formatted
    }
}

#if DEBUG
struct PricingCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            PricingCard(
                tier: PricingTier.mockTiers()[0],
                isSelected: true,
                action: {}
            )
            PricingCard(
                tier: PricingTier.mockTiers()[1],
                isSelected: false,
                action: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif 