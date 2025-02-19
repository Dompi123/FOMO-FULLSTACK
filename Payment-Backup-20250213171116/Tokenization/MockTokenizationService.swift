import Foundation

public final class MockTokenizationService: TokenizationService {
    public init() {}
    
    public func tokenize(cardNumber: String, expiry: String, cvc: String) async throws -> String {
        try await Task.sleep(nanoseconds: 500_000_000)
        return "mock_token_\(UUID().uuidString)"
    }
    
    public func processPayment(amount: Decimal, tier: PricingTier) async throws -> PaymentResult {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return PaymentResult(
            transactionId: "mock_transaction_\(UUID().uuidString)",
            amount: amount,
            timestamp: Date(),
            status: .success
        )
    }
    
    public func validatePaymentMethod() async throws -> Bool {
        try await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    public func fetchPricingTiers(for venueId: String) async throws -> [PricingTier] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return PricingTier.mockTiers()
    }
} 