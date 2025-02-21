import XCTest
@testable import FOMO_FINAL

final class BackendIntegrationTests: XCTestCase {
    private var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = APIClient.shared
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    func testBackendIntegration() async throws {
        // Test 1: Verify venue capacity fields
        let venue = try await apiClient.request(APIEndpoint.getVenue(id: "test_venue")) as Venue
        XCTAssertGreaterThan(venue.maxCapacity, 0)
        XCTAssertGreaterThanOrEqual(venue.currentCapacity, 0)
        XCTAssertLessThanOrEqual(venue.currentCapacity, venue.maxCapacity)
        
        // Test 2: Check error code mapping
        let error = TokenizationError(code: "insufficient_funds")
        XCTAssertEqual(error, .insufficientFunds)
        
        let processingError = TokenizationError(code: "processing_error")
        XCTAssertEqual(processingError, .processingError)
        
        // Test 3: Validate request headers
        let request = try XCTUnwrap(APIEndpoint.getVenues.urlRequest(baseURL: APIConstants.baseURL))
        XCTAssertNotNil(request.value(forHTTPHeaderField: "X-Device-ID"))
        XCTAssertNotNil(request.value(forHTTPHeaderField: "X-Client-Version"))
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        
        // Test 4: Health check endpoint
        let isHealthy = await NetworkMonitor.shared.verifyBackendConnection()
        XCTAssertTrue(isHealthy, "Backend health check failed")
        
        // Test 5: Rate limit handling
        do {
            for _ in 1...5 {
                _ = try await apiClient.request(APIEndpoint.getVenues) as [Venue]
            }
            XCTFail("Expected rate limit error")
        } catch let error as NetworkError {
            if case .rateLimitExceeded = error {
                // Success - rate limit was hit as expected
            } else {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
    
    func testTokenizationErrorMapping() {
        let errors = [
            "rate_limit_exceeded": TokenizationError.rateLimitExceeded,
            "invalid_card": TokenizationError.invalidCard,
            "expired_card": TokenizationError.expiredCard,
            "insufficient_funds": TokenizationError.insufficientFunds,
            "card_declined": TokenizationError.cardDeclined,
            "processing_error": TokenizationError.processingError
        ]
        
        for (code, expectedError) in errors {
            let error = TokenizationError(code: code)
            XCTAssertEqual(error, expectedError, "Error mapping failed for code: \(code)")
        }
    }
} 