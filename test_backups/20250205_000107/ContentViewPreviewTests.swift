import Testing
import SwiftUI
@testable import FOMO_FINAL

struct ContentViewPreviewTests {
    @Test func previewLoads() async throws {
        let preview = ContentView()
            .environment(\.tokenizationService, MockTokenizationService())
        
        #expect(preview.body is some View)
    }
    
    @Test func paymentGatewayPreviewLoads() async throws {
        let preview = PaymentGatewayView()
            .environment(\.tokenizationService, MockTokenizationService())
        
        #expect(preview.body is some View)
    }
    
    @Test func paymentValidationEdgeCases() async throws {
        let vm = PaymentViewModel()
        
        // Test expired card
        vm.expiry = "12/23"
        #expect(vm.isValid == false, "Expired card should be invalid")
        
        // Test short card number
        vm.cardNumber = "411111"
        #expect(vm.isValid == false, "Short card number should be invalid")
        
        // Test invalid CVC
        vm.cvc = "12"
        #expect(vm.isValid == false, "Short CVC should be invalid")
        
        // Test valid state
        vm.cardNumber = "4111111111111111"
        vm.expiry = "12/28"
        vm.cvc = "123"
        #expect(vm.isValid == true, "Valid card details should be accepted")
    }
    
    @Test func cardNumberValidation() async throws {
        let vm = PaymentViewModel()
        
        // Test spaces in card number
        vm.cardNumber = "4111 1111 1111 1111"
        #expect(vm.isCardNumberValid == true, "Card number with spaces should be valid")
        
        // Test too long card number
        vm.cardNumber = "41111111111111111111"
        #expect(vm.isCardNumberValid == false, "Too long card number should be invalid")
        
        // Test non-numeric characters
        vm.cardNumber = "4111abc1111111111"
        #expect(vm.isCardNumberValid == false, "Non-numeric card number should be invalid")
    }
    
    @Test func expiryValidation() async throws {
        let vm = PaymentViewModel()
        
        // Test invalid month
        vm.expiry = "13/25"
        #expect(vm.isExpiryValid == false, "Month > 12 should be invalid")
        
        // Test zero month
        vm.expiry = "00/25"
        #expect(vm.isExpiryValid == false, "Month 00 should be invalid")
        
        // Test invalid format
        vm.expiry = "1225"
        #expect(vm.isExpiryValid == false, "Wrong format should be invalid")
        
        // Test current month/year
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        let validExpiry = String(format: "%02d/%02d", currentMonth, currentYear % 100)
        vm.expiry = validExpiry
        #expect(vm.isExpiryValid == true, "Current month should be valid")
    }
    
    @Test func cvcValidation() async throws {
        let vm = PaymentViewModel()
        
        // Test non-numeric CVC
        vm.cvc = "12a"
        #expect(vm.isCVCValid == false, "Non-numeric CVC should be invalid")
        
        // Test too long CVC
        vm.cvc = "1234"
        #expect(vm.isCVCValid == false, "Too long CVC should be invalid")
        
        // Test too short CVC
        vm.cvc = "12"
        #expect(vm.isCVCValid == false, "Too short CVC should be invalid")
        
        // Test valid CVC
        vm.cvc = "123"
        #expect(vm.isCVCValid == true, "Valid CVC should be accepted")
    }
}
