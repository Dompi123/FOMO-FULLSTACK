import SwiftUI
import OSLog

@MainActor
final class DrinkMenuViewModel: BaseViewModel {
    @Published private(set) var menuItems: [DrinkItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var currentOrder: DrinkOrder?
    
    private let apiClient = APIClient.shared
    private let logger = Logger(subsystem: "com.fomo", category: "DrinkMenu")
    
    override init() {
        super.init()
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            loadPreviewData()
        } else {
            Task {
                await loadDrinkMenu()
            }
        }
        #else
        Task {
            await loadDrinkMenu()
        }
        #endif
    }
    
    func loadDrinkMenu() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response: APIResponse<[DrinkItem]> = try await apiClient.request(.drinks)
            menuItems = response.data
            logger.info("Loaded \(menuItems.count) drinks")
            
        } catch let error as NetworkError {
            handleError(error)
            logger.error("Failed to load drinks: \(error.localizedDescription)")
            
            #if DEBUG
            // Use preview data as fallback in debug builds
            loadPreviewData()
            logger.debug("Using preview data as fallback")
            #endif
            
        } catch {
            handleError(NetworkError.wrapped(error))
            logger.error("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func createOrder(items: [DrinkOrderItem]) {
        currentOrder = DrinkOrder(items: items)
        logger.debug("Created order with \(items.count) items")
    }
    
    private func loadPreviewData() {
        menuItems = [
            DrinkItem(
                id: "drink_1",
                name: "Signature Mojito",
                description: "Fresh mint, lime juice, rum, and soda water",
                price: 12.99
            ),
            DrinkItem(
                id: "drink_2",
                name: "Classic Martini",
                description: "Gin or vodka with dry vermouth and olive garnish",
                price: 14.99
            ),
            DrinkItem(
                id: "drink_3",
                name: "House Red Wine",
                description: "Premium California Cabernet Sauvignon",
                price: 9.99
            ),
            DrinkItem(
                id: "drink_4",
                name: "Craft Beer",
                description: "Local IPA with citrus notes",
                price: 8.99
            )
        ]
    }
}

#if DEBUG
extension DrinkMenuViewModel {
    static var preview: DrinkMenuViewModel {
        let vm = DrinkMenuViewModel()
        vm.loadPreviewData()
        return vm
    }
    
    func simulateError() {
        handleError(NetworkError.rateLimitExceeded(retryAfter: 60))
    }
    
    func simulatePaymentError() {
        handleError(NetworkError.paymentError(code: "insufficient_funds"))
    }
}
#endif 