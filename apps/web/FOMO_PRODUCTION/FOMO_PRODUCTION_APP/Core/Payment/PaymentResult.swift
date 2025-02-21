import Foundation

public struct PaymentResult: Equatable, Codable {
    public let id: String
    public let transactionId: String
    public let amount: Decimal
    public let timestamp: Date
    public let status: PaymentStatus
    
    public init(id: String = UUID().uuidString,
                transactionId: String,
                amount: Decimal,
                timestamp: Date = Date(),
                status: PaymentStatus) {
        self.id = id
        self.transactionId = transactionId
        self.amount = amount
        self.timestamp = timestamp
        self.status = status
    }
    
    public static func == (lhs: PaymentResult, rhs: PaymentResult) -> Bool {
        lhs.id == rhs.id
    }
}

public enum PaymentStatus: Equatable, Codable {
    case success
    case failure(String)
    case pending
    
    public static func == (lhs: PaymentStatus, rhs: PaymentStatus) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success),
             (.pending, .pending):
            return true
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
} 