import SwiftUI

public struct SecurePaymentField: View {
    @Binding private var text: String
    private let placeholder: String
    private let contentType: UITextContentType
    private let keyboardType: UIKeyboardType
    @State private var isFocused: Bool = false
    
    public init(
        text: Binding<String>,
        placeholder: String,
        contentType: UITextContentType,
        keyboardType: UIKeyboardType = .default
    ) {
        self._text = text
        self.placeholder = placeholder
        self.contentType = contentType
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        SecureField(placeholder, text: $text)
            .textContentType(contentType)
            .keyboardType(keyboardType)
            .font(.body)
            .foregroundStyle(.primary)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(FOMOTheme.Colors.background)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color.pink : Color.black.opacity(0.2),
                        lineWidth: 1
                    )
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFocused = true
                }
            }
            .onChange(of: text) { oldValue, newValue in
                if !isFocused {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFocused = true
                    }
                }
            }
    }
}

public struct PaymentButton: View {
    private let title: String
    private let action: () -> Void
    @State private var isLoading = false
    @State private var isPressed = false
    
    public init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
                isLoading = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = false
                    isLoading = false
                }
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.trailing, 8)
                }
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .pink]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
        }
        .disabled(isLoading)
    }
}

// MARK: - Preview Provider
#if DEBUG
struct SecurePaymentComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Text("Payment Details")
                .font(.title2)
                .foregroundStyle(.primary)
            
            SecurePaymentField(
                text: .constant(""),
                placeholder: "Card Number",
                contentType: .creditCardNumber,
                keyboardType: .numberPad
            )
            
            PaymentButton(title: "Pay Now") {
                print("Payment initiated")
            }
        }
        .padding()
        .background(FOMOTheme.Colors.background)
        .previewWithTheme()
    }
}
#endif 