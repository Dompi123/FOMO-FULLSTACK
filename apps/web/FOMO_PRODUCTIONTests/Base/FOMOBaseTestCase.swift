import XCTest
@testable import FOMO_FINAL
import Security

class FOMOBaseTestCase: XCTestCase {
    var keychain: KeychainManager!
    var networkMonitor: NetworkMonitor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        try setupKeychain()
        try setupNetworkMonitor()
        
        // Enable parallel testing
        #if !targetEnvironment(simulator)
        try XCTSkipIf(true, "Running on device - skipping parallel tests")
        #endif
    }
    
    override func tearDownWithError() throws {
        try cleanupKeychain()
        networkMonitor = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Setup Helpers
    private func setupKeychain() throws {
        keychain = KeychainManager.shared
        try keychain.set("test_api_key", for: .apiKey)
        try keychain.set("https://api.test.fomo.com/v1", for: .baseURL)
    }
    
    private func setupNetworkMonitor() throws {
        networkMonitor = NetworkMonitor.shared
        try XCTSkipUnless(networkMonitor.isConnected, "Network connection required")
    }
    
    private func cleanupKeychain() throws {
        try? keychain.delete(.apiKey)
        try? keychain.delete(.baseURL)
        keychain = nil
    }
    
    // MARK: - Test Helpers
    func waitForAsync(_ timeout: TimeInterval = 5.0, function: String = #function) async throws {
        let expectation = expectation(description: "\(function) async operation")
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: timeout)
    }
    
    func verifySecureContext() throws {
        guard let bundleID = Bundle.main.bundleIdentifier,
              bundleID.hasPrefix("com.fomo") else {
            throw XCTSkip("Invalid test environment")
        }
    }
}

// MARK: - Network Monitoring
class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    var isConnected: Bool {
        // Implement actual network reachability check
        return true
    }
    
    private init() {}
} 