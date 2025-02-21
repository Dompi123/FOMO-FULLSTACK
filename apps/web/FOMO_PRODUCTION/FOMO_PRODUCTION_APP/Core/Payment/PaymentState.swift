import Foundation

public enum PaymentState: Equatable {
    case ready
    case processing
    case completed
    case failed(Error)
    
    public var buttonTitle: String {
        switch self {
        case .ready:
            return "payment.button.ready".localized
        case .processing:
            return "payment.button.processing".localized
        case .completed:
            return "payment.button.completed".localized
        case .failed:
            return "payment.button.retry".localized
        }
    }
    
    public var isEnabled: Bool {
        switch self {
        case .ready, .failed:
            return true
        case .processing, .completed:
            return false
        }
    }
    
    public static func == (lhs: PaymentState, rhs: PaymentState) -> Bool {
        switch (lhs, rhs) {
        case (.ready, .ready),
             (.processing, .processing),
             (.completed, .completed):
            return true
        case let (.failed(error1), .failed(error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
} 