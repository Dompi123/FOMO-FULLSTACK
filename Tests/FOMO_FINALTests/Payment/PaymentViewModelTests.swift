import XCTest
import SwiftUI
@testable import FOMO_FINAL

@MainActor
final class PaymentViewModelTests: XCTestCase {
    func testPaymentValidationEdgeCases() async throws {
        let vm = PaymentViewModel()
        
        // Test empty fields
        XCTAssertFalse(vm.isValid, "Empty fields should be invalid")
        
        // Test valid card details
        vm.cardNumber = "4242424242424242"
        vm.expiry = "12/25"
        vm.cvc = "123"
        XCTAssertTrue(vm.isValid, "Valid card details should be accepted")
    }
    
    func testCardNumberValidation() async throws {
        let vm = PaymentViewModel()
        
        // Test invalid card numbers
        vm.cardNumber = "1234"
        XCTAssertFalse(vm.isValid, "Short card number should be invalid")
        
        vm.cardNumber = "4242424242424241"
        XCTAssertFalse(vm.isValid, "Invalid checksum should be rejected")
        
        // Test valid card number
        vm.cardNumber = "4242424242424242"
        vm.expiry = "12/25"
        vm.cvc = "123"
        XCTAssertTrue(vm.isValid, "Valid card number should be accepted")
    }
    
    func testExpiryValidation() async throws {
        let vm = PaymentViewModel()
        
        // Test invalid expiry dates
        vm.expiry = "13/23"
        XCTAssertFalse(vm.isValid, "Invalid month should be rejected")
        
        vm.expiry = "00/23"
        XCTAssertFalse(vm.isValid, "Zero month should be rejected")
        
        let pastDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let pastYear = Calendar.current.component(.year, from: pastDate) % 100
        vm.expiry = "12/\(pastYear)"
        XCTAssertFalse(vm.isValid, "Past date should be rejected")
        
        // Test valid expiry date
        let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let futureYear = Calendar.current.component(.year, from: futureDate) % 100
        vm.expiry = "12/\(futureYear)"
        vm.cardNumber = "4242424242424242"
        vm.cvc = "123"
        XCTAssertTrue(vm.isValid, "Valid future date should be accepted")
    }
    
    func testCVCValidation() async throws {
        let vm = PaymentViewModel()
        
        // Test invalid CVC
        vm.cvc = "12"
        XCTAssertFalse(vm.isValid, "Short CVC should be invalid")
        
        vm.cvc = "12345"
        XCTAssertFalse(vm.isValid, "Long CVC should be invalid")
        
        vm.cvc = "abc"
        XCTAssertFalse(vm.isValid, "Non-numeric CVC should be invalid")
        
        // Test valid CVC
        vm.cardNumber = "4242424242424242"
        vm.expiry = "12/25"
        
        vm.cvc = "123"
        XCTAssertTrue(vm.isValid, "Valid 3-digit CVC should be accepted")
        
        vm.cvc = "1234"
        XCTAssertTrue(vm.isValid, "Valid 4-digit CVC should be accepted")
    }
    
    func testTokenizationWithMissingAPIKey() async throws {
        // Delete the API key to simulate missing configuration
        try KeychainManager.delete(.apiKey)
        
        let vm = PaymentViewModel()
        
        // Set valid card details
        vm.cardNumber = "4242424242424242"
        vm.expiry = "12/25"
        vm.cvc = "123"
        
        // Attempt payment
        vm.processPayment()
        
        // Wait for async operation to complete
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertTrue(vm.showAlert, "Alert should be shown for missing API key")
        let expectedError = KeychainError.retrievalError as NSError
        XCTAssertEqual(vm.alertMessage, expectedError.localizedDescription, "Should show keychain retrieval error")
    }
}
