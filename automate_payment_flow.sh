#!/bin/zsh

# Configuration
PROJECT_DIR="FOMO_FINAL"
PAYMENT_DIR="${PROJECT_DIR}/FOMO_FINAL/Payment"
PREVIEWS_DIR="previews"

echo "🚀 Starting Payment Flow Automation..."

# 1. Create necessary directories
echo "\n📁 Creating directory structure..."
mkdir -p "${PAYMENT_DIR}/Tokenization"
mkdir -p "${PREVIEWS_DIR}"
mkdir -p "${PROJECT_DIR}/FOMO_FINAL/Resources"

# 2. Generate mock data for previews
echo "\n🔄 Generating mock data..."
cat > "${PREVIEWS_DIR}/payment_mocks.json" << EOF
{
  "tokenization": {
    "card_token": "tok_test_123456789",
    "expiry": "12/25",
    "last4": "4242"
  },
  "payment_methods": [
    {
      "id": "pm_1",
      "type": "card",
      "brand": "visa",
      "last4": "4242"
    }
  ]
}
EOF

cat > "${PREVIEWS_DIR}/mock_auth.json" << EOF
{
  "user": {
    "id": "usr_test_123",
    "email": "test@example.com",
    "verified": true
  },
  "session": {
    "token": "sess_test_456",
    "expires_at": "2025-12-31T23:59:59Z"
  }
}
EOF

# 3. Create PaymentStrings.strings
echo "\n📝 Creating localization strings..."
cat > "${PROJECT_DIR}/FOMO_FINAL/Resources/PaymentStrings.strings" << EOF
"payment.title" = "Payment";
"payment.card.title" = "Card Details";
"payment.card.number" = "Card Number";
"payment.card.expiry" = "Expiry Date";
"payment.card.cvc" = "CVC";
"payment.button.pay" = "Pay Now";
"payment.button.cancel" = "Cancel";
"payment.error.invalid" = "Invalid card details";
"payment.success" = "Payment successful";
EOF

# 4. Create PaymentGatewayView
echo "\n🛠 Creating PaymentGatewayView..."
cat > "${PAYMENT_DIR}/PaymentGatewayView.swift" << EOF
import SwiftUI

struct PaymentGatewayView: View {
    @StateObject private var viewModel = PaymentViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("payment.card.title".localized)) {
                    TextField("payment.card.number".localized, text: $viewModel.cardNumber)
                        .keyboardType(.numberPad)
                    
                    HStack {
                        TextField("payment.card.expiry".localized, text: $viewModel.expiry)
                            .keyboardType(.numberPad)
                        
                        TextField("payment.card.cvc".localized, text: $viewModel.cvc)
                            .keyboardType(.numberPad)
                    }
                }
                
                Button(action: viewModel.processPayment) {
                    Text("payment.button.pay".localized)
                }
                .disabled(!viewModel.isValid)
            }
            .navigationTitle("payment.title".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("payment.button.cancel".localized) {
                        dismiss()
                    }
                }
            }
            .alert("Payment", isPresented: $viewModel.showAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

#Preview {
    PaymentGatewayView()
        .environment(\.tokenizationService, MockTokenizationService())
}
EOF

# 5. Create PaymentViewModel
echo "\n📱 Creating PaymentViewModel..."
cat > "${PAYMENT_DIR}/PaymentViewModel.swift" << EOF
import SwiftUI

@MainActor
class PaymentViewModel: ObservableObject {
    @Published var cardNumber = ""
    @Published var expiry = ""
    @Published var cvc = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    @Environment(\.tokenizationService) private var tokenizationService
    
    var isValid: Bool {
        cardNumber.count >= 16 && expiry.count == 5 && cvc.count == 3
    }
    
    func processPayment() {
        Task {
            do {
                let token = try await tokenizationService.tokenize(
                    cardNumber: cardNumber,
                    expiry: expiry,
                    cvc: cvc
                )
                alertMessage = "payment.success".localized
                showAlert = true
            } catch {
                alertMessage = "payment.error.invalid".localized
                showAlert = true
            }
        }
    }
}
EOF

# 6. Create TokenizationService
echo "\n🔐 Creating TokenizationService..."
cat > "${PAYMENT_DIR}/Tokenization/TokenizationService.swift" << EOF
import Foundation

protocol TokenizationService {
    func tokenize(cardNumber: String, expiry: String, cvc: String) async throws -> String
}

struct MockTokenizationService: TokenizationService {
    func tokenize(cardNumber: String, expiry: String, cvc: String) async throws -> String {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return "tok_test_\(UUID().uuidString)"
    }
}

struct TokenizationEnvironmentKey: EnvironmentKey {
    static var defaultValue: TokenizationService = MockTokenizationService()
}

extension EnvironmentValues {
    var tokenizationService: TokenizationService {
        get { self[TokenizationEnvironmentKey.self] }
        set { self[TokenizationEnvironmentKey.self] = newValue }
    }
}
EOF

# 7. Create Preview Tests
echo "\n🧪 Creating Preview Tests..."
mkdir -p "${PROJECT_DIR}/FOMO_FINALTests/Previews"
cat > "${PROJECT_DIR}/FOMO_FINALTests/Previews/ContentViewPreviewTests.swift" << EOF
import Testing
import SwiftUI
@testable import FOMO_FINAL

struct ContentViewPreviewTests {
    @Test func previewLoads() async throws {
        let preview = ContentView()
            .environment(\.tokenizationService, MockTokenizationService())
        
        #expect(preview.body is some View)
    }
    
    @Test func paymentGatewayPreviewLoads() async throws {
        let preview = PaymentGatewayView()
            .environment(\.tokenizationService, MockTokenizationService())
        
        #expect(preview.body is some View)
    }
}
EOF

echo "\n✅ Payment Flow Automation Complete!"
echo "Next steps:"
echo "1. Run preview validation"
echo "2. Check generated files"
echo "3. Run the app in simulator" 