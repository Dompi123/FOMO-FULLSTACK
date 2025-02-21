import Foundation

public struct Pass: Identifiable, Codable {
    public let id: String
    public let venueId: String
    public let userId: String
    public let type: PassType
    public let purchaseDate: Date
    public let expirationDate: Date
    public let status: PassStatus
    
    public init(id: String, venueId: String, userId: String, type: PassType, purchaseDate: Date, expirationDate: Date) {
        self.id = id
        self.venueId = venueId
        self.userId = userId
        self.type = type
        self.purchaseDate = purchaseDate
        self.expirationDate = expirationDate
        self.status = Self.determineStatus(expirationDate: expirationDate)
    }
    
    private static func determineStatus(expirationDate: Date) -> PassStatus {
        if expirationDate > Date() {
            return .active
        } else {
            return .expired
        }
    }
}

public enum PassType: String, Codable {
    case standard
    case vip
    case premium
}

public enum PassStatus: String, Codable {
    case active
    case expired
    case used
}

#if DEBUG
public extension Pass {
    static var previewActive: Pass {
        Pass(
            id: "pass_active",
            venueId: "venue_1",
            userId: "user_1",
            type: .vip,
            purchaseDate: Date(),
            expirationDate: Date().addingTimeInterval(7 * 24 * 60 * 60)
        )
    }
    
    static var previewExpired: Pass {
        Pass(
            id: "pass_expired",
            venueId: "venue_1",
            userId: "user_1",
            type: .standard,
            purchaseDate: Date().addingTimeInterval(-14 * 24 * 60 * 60),
            expirationDate: Date().addingTimeInterval(-7 * 24 * 60 * 60)
        )
    }
}
#endif 