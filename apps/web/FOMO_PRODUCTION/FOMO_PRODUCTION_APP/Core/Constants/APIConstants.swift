import Foundation
import Security
import OSLog

enum APIConstants {
    private static let logger = Logger(subsystem: "com.fomo", category: "APIConstants")
    
    static var baseURL: URL {
        guard let urlString = try? KeychainManager.get(.baseURL),
              let url = URL(string: urlString),
              url.scheme?.lowercased() == "https" else {
            logger.fault("Invalid or missing base URL in keychain")
            fatalError("Base URL must be configured in keychain with HTTPS")
        }
        return url
    }
    
    static var apiKey: String {
        guard let key = try? KeychainManager.get(.apiKey) else {
            logger.fault("Missing API key in keychain")
            fatalError("API key must be configured in keychain")
        }
        return key
    }
    
    static var environment: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

extension APIConstants {
    enum Environment {
        case development
        case staging
        case production
        
        var baseURLString: String {
            switch self {
            case .development:
                return "https://api.dev.fomo.com/v1"
            case .staging:
                return "https://api.staging.fomo.com/v1"
            case .production:
                return "https://api.fomo.com/v1"
            }
        }
    }
} 