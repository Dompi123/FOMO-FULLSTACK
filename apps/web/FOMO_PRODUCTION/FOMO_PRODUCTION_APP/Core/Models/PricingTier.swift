import Foundation

public struct PricingTier: Identifiable, Equatable, Codable {
    public let id: String
    public let name: String
    public let description: String
    public let price: Decimal
    public let features: [String]
    public let maxCapacity: Int?
    public let isBestValue: Bool
    
    public init(id: String, name: String, description: String, price: Decimal, features: [String], maxCapacity: Int? = nil, isBestValue: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.features = features
        self.maxCapacity = maxCapacity
        self.isBestValue = isBestValue
    }
    
    public var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        return formatter.string(from: price as NSDecimalNumber) ?? "$\(price)"
    }
}

#if DEBUG
public extension PricingTier {
    static func mockTiers() -> [PricingTier] {
        [
            PricingTier(
                id: "tier_standard",
                name: "Standard",
                description: "Basic entry pass",
                price: 29.99,
                features: ["Entry to venue", "Access to main bar"]
            ),
            PricingTier(
                id: "tier_vip",
                name: "VIP",
                description: "Premium experience with exclusive perks",
                price: 49.99,
                features: [
                    "Priority entry",
                    "VIP lounge access",
                    "Complimentary coat check",
                    "Dedicated bartender"
                ],
                maxCapacity: 50,
                isBestValue: true
            ),
            PricingTier(
                id: "tier_premium",
                name: "Premium",
                description: "Ultimate luxury experience",
                price: 99.99,
                features: [
                    "Instant entry",
                    "Private booth",
                    "Personal concierge",
                    "Bottle service",
                    "VIP parking"
                ],
                maxCapacity: 20
            )
        ]
    }
    
    static var mock: PricingTier { mockTiers()[0] }
} 
#endif 