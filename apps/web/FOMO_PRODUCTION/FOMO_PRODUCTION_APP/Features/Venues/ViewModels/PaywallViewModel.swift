import Foundation
import SwiftUI

@MainActor
@MainActor
public final class PaywallViewModel: ObservableObject {
: BaseViewModel
    @Published private(set) var pricingTiers: [PricingTier] = []
    @Published var selectedTier: PricingTier?
    @Published private(set) var isLoading = false
    @Published var error: Error?
    @Published public var paymentState: PaymentState = .ready
    @Published public var showAlert = false
    @Published public var alertMessage = ""
    @Published public private(set) var venue: Venue
    
    private let tokenizationService: TokenizationService
    
    public init(venue: Venue) {
        self.venue = venue
        self.tokenizationService = LiveTokenizationService()
        Task {
            await loadPricingTiers(for: venue.id)
        }
    }
    
    public init(venue: Venue, tokenizationService: TokenizationService) {
        self.venue = venue
        self.tokenizationService = tokenizationService
        Task {
            await loadPricingTiers(for: venue.id)
        }
    }
    
    public func loadPricingTiers(for venueId: String) async {
        isLoading = true
        error = nil
        
        do {
            pricingTiers = try await tokenizationService.fetchPricingTiers(for: venueId)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    public func selectTier(_ tier: PricingTier) {
        withAnimation(.spring(response: 0.3)) {
            selectedTier = tier
        }
    }
    
    public func processPurchase() async {
        guard let tier = selectedTier else { return }
        
        isLoading = true
        error = nil
        
        do {
            let result = try await tokenizationService.processPayment(amount: tier.price, tier: tier)
            // Handle successful payment result
            print("Payment processed successfully: \(result)")
            paymentState = .completed
            showAlert = true
            alertMessage = "payment.success".localized
        } catch {
            self.error = error
            paymentState = .failed(error)
            showAlert = true
            alertMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

#if DEBUG
public extension PaywallViewModel {
    static func preview(venue: Venue) -> PaywallViewModel {
        PaywallViewModel(venue: venue)
    }
    
    static var defaultPreview: PaywallViewModel {
        preview(venue: .preview)
    }
}
#endif 