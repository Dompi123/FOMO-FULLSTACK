import Foundation

public protocol PaymentServiceProtocol {
    func processPayment(amount: Decimal, tier: PricingTier) async throws -> PaymentResult
    func validatePaymentMethod() async throws -> Bool
    func fetchPricingTiers(for venueId: String) async throws -> [PricingTier]
} 