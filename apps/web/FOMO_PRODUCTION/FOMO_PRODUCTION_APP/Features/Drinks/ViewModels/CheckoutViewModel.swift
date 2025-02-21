import SwiftUI
import OSLog

@MainActor
final class CheckoutViewModel: BaseViewModel {
    @Published private(set) var order: DrinkOrder
    @Published private(set) var isLoading = false
    @Published private(set) var paymentStatus: PaymentStatus = .pending
    
    private let apiClient = APIClient.shared
    private let logger = Logger(subsystem: "com.fomo", category: "Checkout")
    
    init(order: DrinkOrder) {
        self.order = order
        super.init()
    }
    
    func processPayment() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response: APIResponse<PaymentResult> = try await apiClient.request(.processPayment(order: order))
            paymentStatus = .completed(response.data)
            logger.info("Payment processed successfully: \(response.data.transactionId)")
            
        } catch let error as NetworkError {
            paymentStatus = .failed
            handleError(error)
            logger.error("Payment failed: \(error.localizedDescription)")
            
        } catch {
            paymentStatus = .failed
            handleError(NetworkError.wrapped(error))
            logger.error("Unexpected payment error: \(error.localizedDescription)")
        }
    }
}

enum PaymentStatus {
    case pending
    case processing
    case completed(PaymentResult)
    case failed
}

#if DEBUG
extension CheckoutViewModel {
    static func preview(withOrder order: DrinkOrder = DrinkOrder(items: [])) -> CheckoutViewModel {
        CheckoutViewModel(order: order)
    }
    
    func simulateError() {
        handleError(NetworkError.rateLimitExceeded(retryAfter: 60))
    }
    
    func simulatePaymentError() {
        handleError(NetworkError.paymentError(code: "card_declined"))
        paymentStatus = .failed
    }
}
#endif 