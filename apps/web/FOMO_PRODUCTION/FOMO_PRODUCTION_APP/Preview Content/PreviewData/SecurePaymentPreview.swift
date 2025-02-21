import SwiftUI
import Foundation

#if DEBUG
struct SecurePaymentPreviewData: Codable {
    struct TestCard: Codable {
        let type: String
        let number: String
        let expiry: String
        let cvc: String
    }
    
    struct TestAmount: Codable {
        let amount: Int
        let currency: String
        let description: String
    }
    
    struct ValidationMessages: Codable {
        let success: [String]
        let error: [String]
    }
    
    let test_cards: [TestCard]
    let test_amounts: [TestAmount]
    let validation_messages: ValidationMessages
}

class SecurePaymentPreviewProvider {
    static let shared = SecurePaymentPreviewProvider()
    private var previewData: SecurePaymentPreviewData?
    
    private init() {
        loadPreviewData()
    }
    
    private func loadPreviewData() {
        guard let url = Bundle.main.url(forResource: "payment_preview", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(SecurePaymentPreviewData.self, from: data) else {
            print("Failed to load payment preview data")
            return
        }
        previewData = decoded
    }
    
    func getTestCard(type: String = "visa") -> SecurePaymentPreviewData.TestCard? {
        return previewData?.test_cards.first { $0.type == type }
    }
    
    func getTestAmount(description: String = "VIP Pass") -> SecurePaymentPreviewData.TestAmount? {
        return previewData?.test_amounts.first { $0.description == description }
    }
    
    func getRandomSuccessMessage() -> String {
        return previewData?.validation_messages.success.randomElement() ?? "Payment successful"
    }
    
    func getRandomErrorMessage() -> String {
        return previewData?.validation_messages.error.randomElement() ?? "Payment failed"
    }
}

struct SecurePaymentPreview: ViewModifier {
    @State private var testCard: SecurePaymentPreviewData.TestCard?
    @State private var testAmount: SecurePaymentPreviewData.TestAmount?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                testCard = SecurePaymentPreviewProvider.shared.getTestCard()
                testAmount = SecurePaymentPreviewProvider.shared.getTestAmount()
            }
            .environment(\.testCard, testCard)
            .environment(\.testAmount, testAmount)
    }
}

private struct TestCardKey: EnvironmentKey {
    static let defaultValue: SecurePaymentPreviewData.TestCard? = nil
}

private struct TestAmountKey: EnvironmentKey {
    static let defaultValue: SecurePaymentPreviewData.TestAmount? = nil
}

extension EnvironmentValues {
    var testCard: SecurePaymentPreviewData.TestCard? {
        get { self[TestCardKey.self] }
        set { self[TestCardKey.self] = newValue }
    }
    
    var testAmount: SecurePaymentPreviewData.TestAmount? {
        get { self[TestAmountKey.self] }
        set { self[TestAmountKey.self] = newValue }
    }
}

extension View {
    func previewWithSecurePayment() -> some View {
        modifier(SecurePaymentPreview())
    }
}
#endif 