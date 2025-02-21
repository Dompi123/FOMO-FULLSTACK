import SwiftUI

// MARK: - Secure Text Extensions
extension Text {
    func secureBodyStyle() -> some View {
        self
            .font(.body)
            .textContentType(.oneTimeCode)
            .privacySensitive(true)
    }
    
    func securePaymentStyle() -> some View {
        self
            .font(.body)
            .textContentType(.oneTimeCode)
            .privacySensitive(true)
            .redacted(reason: .privacy)
    }
}

// MARK: - Payment Typography
extension Font {
    static let paymentDisplay = Font.largeTitle
    static let paymentHeader = Font.title
    static let paymentBody = Font.body
    static let paymentCaption = Font.caption
}

// MARK: - Secure Field Typography
extension SecureField where Label == Text {
    func securePaymentStyle() -> some View {
        self
            .font(.body)
            .textContentType(.oneTimeCode)
            .privacySensitive(true)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}

// MARK: - Preview Support
#if DEBUG
extension View {
    func previewWithTypography() -> some View {
        self
            .environment(\.sizeCategory, .large)
            .environment(\.colorScheme, .dark)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(FOMOTheme.Colors.background)
    }
}
#endif 