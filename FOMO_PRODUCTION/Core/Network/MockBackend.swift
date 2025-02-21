import Foundation

enum MockBackendStatus {
    case operational
    case degraded
    case down
}

struct MockBackend {
    static let shared = MockBackend()
    private let status: MockBackendStatus = .operational
    
    func healthCheck() -> Bool {
        // Simulate backend health check
        switch status {
        case .operational:
            print("✅ Backend Healthy")
            return true
        case .degraded, .down:
            print("❌ Backend Degraded")
            return false
        }
    }
    
    func verifyEndpoints() -> Int {
        // Return mock endpoint count for verification
        return 42 // Expected number of endpoints
    }
} 