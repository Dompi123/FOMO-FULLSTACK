import XCTest
@testable import FOMO_FINAL
import SwiftUI
import SnapshotTesting

final class PaywallSnapshotTests: FOMOBaseTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Configure snapshot testing
        isRecording = false
    }
    
    func testPaywallLightMode() throws {
        try verifySecureContext()
        
        let venue = Venue.preview
        let view = PaywallView(venue: venue)
            .environmentObject(mockPaymentManager)
            .environmentObject(PreviewNavigationCoordinator.shared)
            .preferredColorScheme(.light)
        
        assertSnapshot(
            matching: view,
            as: .image(
                on: .iPhone13Pro,
                traits: .init(userInterfaceStyle: .light)
            ),
            named: "paywall_light_mode"
        )
    }
    
    func testPaywallDarkMode() throws {
        try verifySecureContext()
        
        let venue = Venue.preview
        let view = PaywallView(venue: venue)
            .environmentObject(mockPaymentManager)
            .environmentObject(PreviewNavigationCoordinator.shared)
            .preferredColorScheme(.dark)
        
        assertSnapshot(
            matching: view,
            as: .image(
                on: .iPhone13Pro,
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "paywall_dark_mode"
        )
    }
    
    func testPricingCardSelected() throws {
        try verifySecureContext()
        
        let tier = PricingTier.mockTiers()[0]
        let view = PricingCard(tier: tier, isSelected: true) {}
            .frame(width: 300)
            .padding()
        
        assertSnapshot(
            matching: view,
            as: .image(on: .iPhone13Pro),
            named: "pricing_card_selected"
        )
    }
    
    func testPricingCardUnselected() throws {
        try verifySecureContext()
        
        let tier = PricingTier.mockTiers()[0]
        let view = PricingCard(tier: tier, isSelected: false) {}
            .frame(width: 300)
            .padding()
        
        assertSnapshot(
            matching: view,
            as: .image(on: .iPhone13Pro),
            named: "pricing_card_unselected"
        )
    }
}

// MARK: - Snapshot Configuration
extension PaywallSnapshotTests {
    override class var defaultTestSuite: XCTestSuite {
        let suite = XCTestSuite(forTestCaseClass: PaywallSnapshotTests.self)
        // Disable parallel execution for snapshot tests
        suite.parallelizable = false
        return suite
    }
} 