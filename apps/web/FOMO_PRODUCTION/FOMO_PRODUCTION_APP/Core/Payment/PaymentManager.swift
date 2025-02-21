import Foundation
import SwiftUI

@MainActor
public final class PaymentManager: ObservableObject {
    public static let shared: PaymentManager = {
        let manager = PaymentManager(tokenizationService: LiveTokenizationService())
        return manager
    }()
    
    @Published public private(set) var isProcessing = false
    @Published public private(set) var lastPaymentResult: PaymentResult?
    @Published public private(set) var showError = false
    @Published public private(set) var errorMessage = ""
    
    private let tokenizationService: TokenizationService
    
    public init(tokenizationService: TokenizationService) {
        self.tokenizationService = tokenizationService
    }
    
    public func processPayment(amount: Decimal, tier: PricingTier) async throws -> PaymentResult {
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let result = try await tokenizationService.processPayment(amount: amount, tier: tier)
            lastPaymentResult = result
            return result
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    public func validatePaymentMethod() async throws -> Bool {
        do {
            return try await tokenizationService.validatePaymentMethod()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    public func fetchPricingTiers(for venueId: String) async throws -> [PricingTier] {
        do {
            return try await tokenizationService.fetchPricingTiers(for: venueId)
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            throw error
        }
    }
}

#if DEBUG
public extension PaymentManager {
    static func preview() -> PaymentManager {
        PaymentManager(tokenizationService: MockTokenizationService())
    }
}
#endif 