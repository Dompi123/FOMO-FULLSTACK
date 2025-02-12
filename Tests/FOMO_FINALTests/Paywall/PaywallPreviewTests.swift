import XCTest
import SwiftUI
@testable import FOMO_FINAL

@MainActor
final class PaywallPreviewTests: XCTestCase {
    func testStandardPreviewLoads() async {
        let preview = PaywallView(venue: .mock)
            .environmentObject(PaymentManager.preview)
        XCTAssertNotNil(preview)
    }
    
    func testProcessingStatePreviewLoads() async {
        let vm = PaywallViewModel(venue: .mock)
        vm.paymentState = .processing
        
        let preview = PaywallView(venue: .mock)
            .environmentObject(PaymentManager.preview)
        XCTAssertNotNil(preview)
    }
    
    func testCompletedStatePreviewLoads() async {
        let vm = PaywallViewModel(venue: .mock)
        vm.paymentState = .completed
        
        let preview = PaywallView(venue: .mock)
            .environmentObject(PaymentManager.preview)
        XCTAssertNotNil(preview)
    }
    
    func testFailedStatePreviewLoads() async {
        let vm = PaywallViewModel(venue: .mock)
        vm.paymentState = .failed(NSError(domain: "test", code: -1))
        
        let preview = PaywallView(venue: .mock)
            .environmentObject(PaymentManager.preview)
        XCTAssertNotNil(preview)
    }
    
    func testPricingTierMocks() async {
        let tiers = PricingTier.mockTiers()
        XCTAssertEqual(tiers.count, 3, "Should have 3 pricing tiers")
        XCTAssertEqual(tiers[0].price, 29.99, "Standard tier price should be 29.99")
        XCTAssertEqual(tiers[1].price, 49.99, "VIP tier price should be 49.99")
        XCTAssertEqual(tiers[2].price, 99.99, "Premium tier price should be 99.99")
    }
    
    func testVenueMock() async {
        let venue = Venue.mock
        XCTAssertEqual(venue.name, "Neon Lounge")
        XCTAssertFalse(venue.description.isEmpty)
        XCTAssertNotNil(venue.imageURL)
    }
} 