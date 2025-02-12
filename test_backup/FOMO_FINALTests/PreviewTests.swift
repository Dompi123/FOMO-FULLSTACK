import XCTest
@testable import FOMO_FINAL

final class PreviewTests: XCTestCase {
    func testUserProfilePreview() {
        let preview = UserProfile.preview
        XCTAssertEqual(preview.membershipLevel, .premium)
        XCTAssertEqual(preview.preferences.receiveNotifications, true)
        XCTAssertEqual(preview.paymentMethods.count, 1)
    }
    
    func testPassPreview() {
        let preview = Pass.preview
        XCTAssertEqual(preview.type, .standard)
        XCTAssertTrue(preview.isValid)
    }
    
    func testVenuePreview() {
        let preview = Venue.preview
        XCTAssertEqual(preview.name, "The Grand Club")
        XCTAssertEqual(preview.capacity, 500)
        XCTAssertEqual(preview.priceRange, "$$$")
    }
} 