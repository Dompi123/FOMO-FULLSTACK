import Foundation

public protocol TokenizationService {
    func tokenize(cardNumber: String, expiry: String, cvc: String) async throws -> String
    func processPayment(amount: Decimal, tier: PricingTier) async throws -> PaymentResult
    func validatePaymentMethod() async throws -> Bool
    func fetchPricingTiers(for venueId: String) async throws -> [PricingTier]
}

public enum TokenizationError: LocalizedError {
    case invalidAmount
    case invalidCard
    case expiredCard
    case rateLimitExceeded
    case networkError(Error)
    case serverError(String)
    case backendError(code: String)
    case invalidRequest
    case invalidResponse
    case invalidURL
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Invalid payment amount"
        case .invalidCard:
            return "Invalid card information"
        case .expiredCard:
            return "The card has expired"
        case .rateLimitExceeded:
            return "Too many payment attempts. Please try again later"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .backendError(let code):
            return "Backend error: \(code)"
        case .invalidRequest:
            return "Invalid request configuration"
        case .invalidResponse:
            return "Invalid response from payment service"
        case .invalidURL:
            return "Invalid payment service URL"
        case .unknown:
            return "An unknown error occurred"
        }
    }
} 