import Foundation

class JWTInterceptor {
    static func addAuthHeader(to request: URLRequest) throws -> URLRequest {
        var modifiedRequest = request
        
        if let token = try? KeychainManager.load(.authToken) {
            modifiedRequest.setValue("Bearer \(token)", 
                                  forHTTPHeaderField: "Authorization")
        }
        
        return modifiedRequest
    }
    
    static func handleAuthError(_ error: Error) -> Bool {
        // Return true if error was handled (e.g., refreshed token)
        guard let networkError = error as? NetworkError,
              case .serverError(let statusCode) = networkError,
              statusCode == 401 else {
            return false
        }
        
        // Trigger auth refresh flow
        Task {
            await AuthManager.shared.refreshToken()
        }
        
        return true
    }
} 