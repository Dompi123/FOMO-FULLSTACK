import XCTest
@testable import FOMO_FINAL

class PaymentFlowTests: XCTestCase {
    var sut: PaymentManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let config = PaymentConfig(
            baseURL: "https://api.test.fomo.com",
            environment: .testing
        )
        sut = PaymentManager(config: config)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testPaymentFlow() async throws {
        // Given
        let amount = Decimal(29.99)
        let tier = PricingTier.mockTiers()[0]
        
        // When
        let result = try await sut.processPayment(amount: amount, tier: tier)
        
        // Then
        XCTAssertNotNil(result.transactionId)
        XCTAssertEqual(result.amount, amount)
    }
    
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