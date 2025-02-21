import SwiftUI
import Foundation

public struct PaymentValidationError: View {
    private let message: String
    private let isSecure: Bool
    
    public init(message: String, isSecure: Bool = true) {
        self.message = message
        self.isSecure = isSecure
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.red)
                .redacted(reason: isSecure ? .privacy : [])
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.1))
        )
    }
}

public struct PaymentValidationSuccess: View {
    private let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.green)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.1))
        )
    }
}

public struct PaymentValidationIndicator: View {
    @Binding private var isValid: Bool
    private let validMessage: String
    private let invalidMessage: String
    private let isSecure: Bool
    
    public init(
        isValid: Binding<Bool>,
        validMessage: String,
        invalidMessage: String,
        isSecure: Bool = true
    ) {
        self._isValid = isValid
        self.validMessage = validMessage
        self.invalidMessage = invalidMessage
        self.isSecure = isSecure
    }
    
    public var body: some View {
        Group {
            if isValid {
                PaymentValidationSuccess(message: validMessage)
            } else {
                PaymentValidationError(message: invalidMessage, isSecure: isSecure)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isValid)
    }
}

// MARK: - Preview Provider
#if DEBUG
struct PaymentValidation_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Text("Validation Examples")
                .font(.title2)
                .foregroundStyle(.primary)
            
            PaymentValidationError(
                message: "Invalid card number",
                isSecure: true
            )
            
            PaymentValidationSuccess(
                message: "Payment verified"
            )
            
            PaymentValidationIndicator(
                isValid: .constant(true),
                validMessage: "Card verified",
                invalidMessage: "Please check card details",
                isSecure: true
            )
        }
        .padding()
        .background(FOMOTheme.Colors.background)
    }
}
#endif 