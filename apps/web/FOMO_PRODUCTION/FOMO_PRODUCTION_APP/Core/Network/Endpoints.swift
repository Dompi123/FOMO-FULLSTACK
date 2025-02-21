import Foundation

public enum APIEndpoint: EndpointProtocol {
    // Venues
    case getVenues
    case getVenue(id: String)
    
    // System
    case healthCheck
    
    // Passes
    case getPasses
    case purchasePass(venueId: String)
    
    // Profile
    case getProfile
    case updateProfile
    
    // Drinks
    case getDrinks(venueId: String)
    case placeOrder(DrinkOrder)
    
    public var path: String {
        switch self {
        case .healthCheck:
            return "/v1/health"
        case .getVenues:
            return "/venues"
        case .getVenue(let id):
            return "/venues/\(id)"
        case .getPasses:
            return "/passes"
        case .purchasePass:
            return "/payments/process"
        case .getProfile:
            return "/profile"
        case .updateProfile:
            return "/profile"
        case .getDrinks(let venueId):
            return "/venues/\(venueId)/drinks"
        case .placeOrder:
            return "/orders"
        }
    }
    
    public var method: String {
        switch self {
        case .healthCheck:
            return "GET"
        case .getVenues, .getVenue, .getPasses, .getProfile, .getDrinks:
            return "GET"
        case .purchasePass:
            return "POST"
        case .updateProfile:
            return "POST"
        case .placeOrder:
            return "POST"
        }
    }
    
    public var body: Data? {
        switch self {
        case .healthCheck:
            return nil
        case .purchasePass(let venueId):
            let params = ["venue_id": venueId]
            return try? JSONSerialization.data(withJSONObject: params)
        case .updateProfile(let profile):
            return try? JSONEncoder().encode(profile)
        case .placeOrder(let order):
            return try? JSONEncoder().encode(order)
        default:
            return nil
        }
    }
    
    public func urlRequest(baseURL: URL) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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