import Foundation

public struct DrinkOrder: Identifiable, Hashable, Codable {
    public let id: String
    public let items: [DrinkOrderItem]
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, items: [DrinkOrderItem], timestamp: Date = Date()) {
        self.id = id
        self.items = items
        self.timestamp = timestamp
    }
    
    public var total: Decimal {
        items.reduce(0) { $0 + ($1.drink.price * Decimal($1.quantity)) }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: DrinkOrder, rhs: DrinkOrder) -> Bool {
        lhs.id == rhs.id
    }
}

public struct DrinkOrderItem: Identifiable, Hashable, Codable {
    public let id: String
    public let drink: DrinkItem
    public var quantity: Int
    
    public init(id: String = UUID().uuidString, drink: DrinkItem, quantity: Int = 1) {
        self.id = id
        self.drink = drink
        self.quantity = quantity
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: DrinkOrderItem, rhs: DrinkOrderItem) -> Bool {
        lhs.id == rhs.id
    }
}

public struct DrinkItem: Identifiable, Hashable, Codable {
    public let id: String
    public let name: String
    public let description: String
    public let price: Decimal
    public var quantity: Int
    
    public var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        return formatter.string(from: price as NSDecimalNumber) ?? "$\(price)"
    }
    
    public init(id: String, name: String, description: String, price: Double, quantity: Int = 1) {
        self.id = id
        self.name = name
        self.description = description
        self.price = Decimal(price)
        self.quantity = quantity
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: DrinkItem, rhs: DrinkItem) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
public extension DrinkItem {
    static let mock = DrinkItem(
        id: "drink_1",
        name: "Signature Mojito",
        description: "Fresh mint, lime juice, rum, and soda water",
        price: 12.99
    )
    
    static let mock2 = DrinkItem(
        id: "drink_2",
        name: "Classic Martini",
        description: "Gin or vodka with dry vermouth and olive garnish",
        price: 14.99
    )
}
#endif 