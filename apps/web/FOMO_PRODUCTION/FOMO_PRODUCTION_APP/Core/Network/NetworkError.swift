import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case wrapped(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .wrapped(let error):
            return error.localizedDescription
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
