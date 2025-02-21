import Foundation

enum KeychainKey: String {
    case apiKey = "api_key"
    case authToken = "auth_token"
    case refreshToken = "refresh_token"
    case userCredentials = "user_credentials"
    
    var key: String { rawValue }
} 