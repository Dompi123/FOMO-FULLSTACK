import Foundation
import SwiftUI

// MARK: - Response Types
public struct TokenizationResponse: Codable {
    public let token: String
    
    public init(token: String) {
        self.token = token
    }
}

public struct ValidationResponse: Codable {
    public let isValid: Bool
    
    public init(isValid: Bool) {
        self.isValid = isValid
    }
}

public struct PaymentTokenRequest: Encodable {
    public let cardNumber: String
    public let expiryMonth: String
    public let expiryYear: String
    public let cvc: String
    
    public init(cardNumber: String, expiryMonth: String, expiryYear: String, cvc: String) {
        self.cardNumber = cardNumber
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cvc = cvc
    }
}

public struct PaymentTokenResponse: Decodable {
    public let token: String
    public let expiry: String
    public let last4: String
    
    public init(token: String, expiry: String, last4: String) {
        self.token = token
        self.expiry = expiry
        self.last4 = last4
    }
}

public struct ErrorResponse: Decodable {
    public struct APIError: Decodable {
        public let code: String
        public let message: String
        
        public init(code: String, message: String) {
            self.code = code
            self.message = message
        }
    }
    public let error: APIError
    
    public init(error: APIError) {
        self.error = error
    }
    
    public func asTokenizationError() -> TokenizationError {
        switch error.code {
        case "rate_limit_exceeded": return .rateLimitExceeded
        case "invalid_card": return .invalidCard
        case "expired_card": return .expiredCard
        default: return .backendError(code: error.code)
        }
    }
}

// MARK: - Production Tokenization Service
@MainActor
public final class LiveTokenizationService: TokenizationService {
    private let apiClient: APIClient
    private let keychainManager: KeychainManager
    
    public init(apiClient: APIClient = APIClient(baseURL: URL(string: APIConstants.paymentBaseURL)!),
                keychainManager: KeychainManager = .shared) {
        self.apiClient = apiClient
        self.keychainManager = keychainManager
    }
    
    public func tokenize(cardNumber: String, expiry: String, cvc: String) async throws -> String {
        let request = PaymentTokenRequest(
            cardNumber: cardNumber,
            expiryMonth: String(expiry.prefix(2)),
            expiryYear: String(expiry.suffix(2)),
            cvc: cvc
        )
        
        let endpoint = TokenizationEndpoint.tokenize(request)
        let response: PaymentTokenResponse = try await apiClient.request(endpoint)
        return response.token
    }
    
    public func processPayment(amount: Decimal, tier: PricingTier) async throws -> PaymentResult {
        guard amount > 0 else {
            throw TokenizationError.invalidAmount
        }
        
        let endpoint = TokenizationEndpoint.processPayment(amount: amount, tierId: tier.id)
        let response: PaymentResult = try await apiClient.request(endpoint)
        return response
    }
    
    public func validatePaymentMethod() async throws -> Bool {
        let endpoint = TokenizationEndpoint.validatePaymentMethod
        let response: ValidationResponse = try await apiClient.request(endpoint)
        return response.isValid
    }
    
    public func fetchPricingTiers(for venueId: String) async throws -> [PricingTier] {
        let endpoint = TokenizationEndpoint.fetchPricingTiers(venueId: venueId)
        return try await apiClient.request(endpoint)
    }
} 