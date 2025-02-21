import Foundation
import SwiftUI
import OSLog

// MARK: - API Response Structures
struct APIResponse<T: Codable>: Codable {
    let data: T
    let meta: APIMeta
    let errors: [APIError]?
}

struct APIMeta: Codable {
    let requestId: String
    let timestamp: String
}

struct APIError: Codable {
    let code: String
    let type: String
    let param: String?
}

// MARK: - Network Error Types
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case rateLimitExceeded(retryAfter: TimeInterval)
    case tokenExpired
    case paymentError(code: String)
    case unhandledError(code: String)
    case wrapped(Error)
    case insecureConnection
    case unknown
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .rateLimitExceeded(let retryAfter):
            return "Rate limit exceeded. Please try again in \(Int(retryAfter)) seconds"
        case .tokenExpired:
            return "Session expired. Please log in again"
        case .paymentError(let code):
            return "Payment failed: \(code)"
        case .unhandledError(let code):
            return "An error occurred: \(code)"
        case .wrapped(let error):
            return error.localizedDescription
        case .insecureConnection:
            return "Insecure connection detected"
        case .unknown:
            return "An unknown error occurred"
        case .serverError(let statusCode):
            return "Server error: \(statusCode)"
        }
    }
}

// MARK: - Error Mapping
extension NetworkError {
    init(apiError: APIError) {
        switch apiError.code {
        case "rate_limit_exceeded":
            self = .rateLimitExceeded(retryAfter: 60)
        case "invalid_token":
            self = .tokenExpired
        case "payment_failed":
            DebugLogger.log("Payment error: \(apiError.type)")
            self = .paymentError(code: apiError.type)
        default:
            self = .unhandledError(code: apiError.code)
        }
    }
}

/// Handles all network communication with the FOMO API
/// 
/// The APIClient provides a type-safe interface for making network requests with:
/// - Automatic retry with exponential backoff
/// - Secure key management
/// - Error mapping
/// - Response validation
/// 
/// Example usage:
/// ```swift
/// let response: APIResponse<[Venue]> = try await apiClient.request(.venues)
/// ```
@MainActor
class APIClient: ObservableObject {
    /// Shared singleton instance
    static let shared = APIClient()
    
    private let logger = Logger(subsystem: "com.fomo", category: "Network")
    private let baseURL: URL
    
    private init() {
        // Enforce HTTPS
        guard let urlString = try? KeychainManager.get(.baseURL),
              let url = URL(string: urlString),
              url.scheme?.lowercased() == "https" else {
            fatalError("Invalid or insecure base URL")
        }
        self.baseURL = url
    }
    
    /// Makes a network request with automatic retry
    /// - Parameters:
    ///   - endpoint: The API endpoint to request
    ///   - maxRetries: Maximum number of retry attempts
    ///   - retryDelay: Base delay for exponential backoff
    /// - Returns: Decoded response of type T
    func request<T: Codable>(
        _ endpoint: APIEndpoint,
        maxRetries: Int = 3,
        retryDelay: TimeInterval = 1.5
    ) async throws -> T {
        let startTime = Date()
        var success = false
        
        defer {
            let duration = Date().timeIntervalSince(startTime)
            Metrics.logRequest(
                endpoint: endpoint.path,
                duration: duration,
                success: success
            )
            
            if duration > 2.0 {
                logger.warning("Request exceeded performance baseline: \(duration)s")
            }
        }
        
        for attempt in 1...maxRetries {
            do {
                let result = try await performRequest(endpoint)
                success = true
                return result
            } catch let error as NetworkError {
                guard attempt < maxRetries,
                      shouldRetry(error) else {
                    throw error
                }
                
                let delay = pow(retryDelay, Double(attempt))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                logger.info("Retrying request (attempt \(attempt)/\(maxRetries))")
            }
        }
        throw NetworkError.unknown
    }
    
    /// Validates an API key
    /// - Parameter apiKey: The key to validate
    /// - Returns: True if the key is valid
    func validateAPIKey(_ apiKey: String) async throws -> Bool {
        var request = URLRequest(url: baseURL.appendingPathComponent("/validate-key"))
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    /// Generates API documentation in Markdown format
    /// - Returns: Markdown string containing API documentation
    func generateAPISpec() -> String {
        let endpoints = APIEndpoint.allCases
        
        let endpointDocs = endpoints.map { endpoint -> String in
            """
            ### \(endpoint.method.rawValue) \(endpoint.path)
            
            **Description**: \(endpoint.description)
            
            **Authentication**: \(endpoint.requiresAuth ? "Required" : "Not Required")
            
            **Rate Limit**: \(endpoint.rateLimit) requests per minute
            
            **Response Format**:
            ```json
            {
                "data": \(endpoint.sampleResponse),
                "meta": {
                    "requestId": "string",
                    "timestamp": "string"
                }
            }
            ```
            
            **Error Codes**:
            - 401: Authentication failed
            - 429: Rate limit exceeded
            - 500: Internal server error
            
            ---
            """
        }.joined(separator: "\n\n")
        
        return """
        # FOMO API Documentation
        
        ## Overview
        
        The FOMO API provides secure access to venue and payment functionality. All requests must be made over HTTPS.
        
        ## Authentication
        
        API requests require an API key to be included in the `X-API-Key` header. Some endpoints also require a Bearer token.
        
        ## Rate Limiting
        
        Rate limits are enforced per API key. Exceeding the rate limit will result in a 429 response.
        
        ## Endpoints
        
        \(endpointDocs)
        
        ## Security
        
        - All requests must use HTTPS
        - API keys should be rotated regularly
        - Responses include request IDs for tracking
        - Rate limiting is enforced
        """
    }
    
    // MARK: - Private Methods
    
    private func performRequest<T: Codable>(_ endpoint: APIEndpoint) async throws -> T {
        guard var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint.path),
                                              resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL
        }
        
        // Enforce HTTPS
        if urlComponents.scheme?.lowercased() != "https" {
            throw NetworkError.insecureConnection
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add API key from keychain
        if let apiKey = try? KeychainManager.get(.apiKey) {
            request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        }
        
        // Add auth token from keychain if available
        if let token = try? KeychainManager.shared.get(.authToken) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add security headers
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("nosniff", forHTTPHeaderField: "X-Content-Type-Options")
        request.setValue("DENY", forHTTPHeaderField: "X-Frame-Options")
        
        // Add required headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", 
                        forHTTPHeaderField: "X-Device-ID")
        request.setValue(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0.0",
                        forHTTPHeaderField: "X-Client-Version")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // Track response metrics
            Metrics.trackResponseCode(httpResponse.statusCode)
            
            switch httpResponse.statusCode {
            case 200...299:
                let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                if let firstError = apiResponse.errors?.first {
                    Metrics.trackError(code: firstError.code)
                    throw NetworkError(apiError: firstError)
                }
                return apiResponse.data
                
            case 429:
                Metrics.trackRateLimit()
                throw NetworkError.rateLimitExceeded(retryAfter: 60)
                
            case 401:
                Metrics.trackAuthFailure()
                throw NetworkError.tokenExpired
                
            default:
                logger.error("Unhandled status code: \(httpResponse.statusCode)")
                Metrics.trackError(code: "http_\(httpResponse.statusCode)")
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            Metrics.trackError(code: "unknown")
            throw NetworkError.wrapped(error)
        }
    }
    
    private func shouldRetry(_ error: NetworkError) -> Bool {
        switch error {
        case .rateLimitExceeded, .invalidResponse:
            return true
        case .tokenExpired, .invalidURL, .insecureConnection, .paymentError, .unhandledError, .wrapped, .unknown, .serverError:
            return false
        }
    }
} 