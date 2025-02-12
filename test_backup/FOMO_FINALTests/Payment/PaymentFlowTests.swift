import XCTest
@testable import FOMO_FINAL

final class PaymentFlowTests: XCTestCase {
    // Critical Path Test
    func testLiveTokenizationSuccess() async {
        let service = LiveTokenizationService()
        do {
            let token = try await service.tokenize(
                cardNumber: "4111111111111111",
                expiry: "12/28",
                cvc: "123"
            )
            XCTAssertFalse(token.isEmpty, "Token should not be empty")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // Security Rule Validation
    func testKeychainIntegration() {
        XCTAssertNoThrow(try KeychainManager.shared.retrieve(for: .apiKey),
                        "KeychainManager must provide API key")
    }
    
    // Error Mapping Test
    func testErrorLocalization() {
        let error = TokenizationError.rateLimitExceeded
        XCTAssertEqual(error.errorDescription, 
                      "payment.error.rate_limit".localized,
                      "Error messages must be localized")
    }
    
    // HTTPS Enforcement Test
    func testSecureURLEnforcement() async {
        // Override API constants to use non-HTTPS URL
        APIConstants.paymentBaseURL = "http://api.example.com"
        let service = LiveTokenizationService()
        
        do {
            _ = try await service.tokenize(
                cardNumber: "4111111111111111",
                expiry: "12/28",
                cvc: "123"
            )
            XCTFail("Should fail with non-HTTPS URL")
        } catch TokenizationError.invalidURL {
            // Expected error
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
} 