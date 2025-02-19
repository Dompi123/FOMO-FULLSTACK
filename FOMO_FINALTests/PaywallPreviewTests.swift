import XCTest
@testable import FOMO_FINAL
import SwiftUI
import Security

final class PaywallPreviewTests: FOMOBaseTestCase {
    private var mockPaymentManager: PaymentManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockPaymentManager = PaymentManager(keychain: keychain)
    }
    
    override func tearDownWithError() throws {
        mockPaymentManager = nil
        try super.tearDownWithError()
    }
    
    func testPaywallPreviewLoading() async throws {
        try verifySecureContext()
        
        let venue = Venue.preview
        let paywall = PaywallView(venue: venue)
            .environmentObject(mockPaymentManager)
            .environmentObject(PreviewNavigationCoordinator.shared)
        
        XCTAssertNotNil(paywall.previewViewModel)
        XCTAssertEqual(paywall.previewViewModel.venue.id, venue.id)
        
        try await waitForAsync()
    }
    
    func testSecureContextVerification() throws {
        try verifySecureContext()
        
        let venue = Venue.preview
        let paywall = PaywallView(venue: venue)
        
        // Initially, secure context should not be verified
        XCTAssertFalse(Mirror(reflecting: paywall).children.contains { $0.label == "isSecureContextVerified" })
    }
    
    func testPricingCardSecurity() throws {
        try verifySecureContext()
        
        let tier = PricingTier.mockTiers()[0]
        let card = PricingCard(tier: tier, isSelected: true) {}
        
        // Verify price security
        XCTAssertTrue(Mirror(reflecting: card).children.contains { $0.label == "isSecurePrice" })
    }
}

// MARK: - Parallel Test Support
extension PaywallPreviewTests {
    override class var defaultTestSuite: XCTestSuite {
        let suite = XCTestSuite(forTestCaseClass: PaywallPreviewTests.self)
        
        // Configure for parallel execution
        suite.parallelizable = true
        suite.testCaseCount = ProcessInfo.processInfo.processorCount
        
        return suite
    }
}

// MARK: - Network Tests
final class PaywallNetworkTests: FOMOBaseTestCase {
    func testPricingTierFetch() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network required")
        
        let venue = Venue.preview
        let viewModel = PaywallViewModel(venue: venue)
        
        await viewModel.loadPricingTiers(for: venue.id)
        XCTAssertFalse(viewModel.pricingTiers.isEmpty)
    }
}

// MARK: - Validation Tests
final class PaywallValidationTests: FOMOBaseTestCase {
    func testPricingTierValidation() throws {
        let tier = PricingTier.mockTiers()[0]
        
        XCTAssertNotNil(tier.price as? NSDecimalNumber, "Price should be decimal")
        XCTAssertFalse(tier.features.isEmpty, "Features should not be empty")
        XCTAssertNotNil(tier.formattedPrice, "Price should be formattable")
    }
}

// MARK: - Test Helpers
extension PaywallPreviewTests {
    private func setupMockKeychain() throws {
        try keychain.set("test_api_key", for: .apiKey)
        try keychain.set("https://api.test.fomo.com/v1", for: .baseURL)
    }
} 