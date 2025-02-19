import Foundation

public enum TokenizationEndpoint: EndpointProtocol {
    case tokenize(PaymentTokenRequest)
    case processPayment(amount: Decimal, tierId: String)
    case validatePaymentMethod
    case fetchPricingTiers(venueId: String)
    
    public var path: String {
        switch self {
        case .tokenize:
            return "/tokenize"
        case .processPayment:
            return "/process"
        case .validatePaymentMethod:
            return "/validate"
        case .fetchPricingTiers(let venueId):
            return "/venues/\(venueId)/tiers"
        }
    }
    
    public var method: String {
        switch self {
        case .tokenize, .processPayment:
            return "POST"
        case .validatePaymentMethod:
            return "POST"
        case .fetchPricingTiers:
            return "GET"
        }
    }
    
    public var body: Data? {
        switch self {
        case .tokenize(let request):
            return try? JSONEncoder().encode(request)
        case .processPayment(let amount, let tierId):
            let payload: [String: Any] = [
                "amount": amount as NSDecimalNumber,
                "tier_id": tierId,
                "timestamp": ISO8601DateFormatter().string(from: Date())
            ]
            return try? JSONSerialization.data(withJSONObject: payload)
        case .validatePaymentMethod:
            return nil
        case .fetchPricingTiers:
            return nil
        }
    }
    
    public func urlRequest(baseURL: URL) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // In development, use a mock API key
        #if DEBUG
        request.setValue("Bearer test_key_123", forHTTPHeaderField: "Authorization")
        #else
        // In production, we would fetch this from the keychain
        request.setValue("Bearer live_key_xyz", forHTTPHeaderField: "Authorization")
        #endif
        
        request.httpBody = body
        return request
    }
} 