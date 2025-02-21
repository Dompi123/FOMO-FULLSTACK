import Foundation

struct DrinkMenu: Codable, Equatable {
    let venueId: String
    let categories: [DrinkCategory]
    
    struct DrinkCategory: Codable, Equatable, Identifiable {
        let id: String
        let name: String
        let description: String?
        let drinks: [Drink]
    }
    
    struct Drink: Codable, Equatable, Identifiable {
        let id: String
        let name: String
        let description: String
        let price: Decimal
        let imageURL: URL?
        let ingredients: [String]
        let isAvailable: Bool
        let tags: [String]
    }
}

// MARK: - Preview Data
extension DrinkMenu {
    static let preview = DrinkMenu(
        venueId: "venue-1",
        categories: [
            DrinkCategory(
                id: "cat-1",
                name: "Signature Cocktails",
                description: "Our unique house creations",
                drinks: [
                    Drink(
                        id: "drink-1",
                        name: "Rooftop Sunset",
                        description: "A refreshing blend of premium vodka, fresh strawberries, and lime juice",
                        price: 15.00,
                        imageURL: URL(string: "https://example.com/drinks/sunset.jpg"),
                        ingredients: ["Vodka", "Strawberries", "Lime Juice", "Simple Syrup"],
                        isAvailable: true,
                        tags: ["Popular", "Sweet", "Fruity"]
                    ),
                    Drink(
                        id: "drink-2",
                        name: "City Lights",
                        description: "Our take on an Old Fashioned with a smoky twist",
                        price: 18.00,
                        imageURL: URL(string: "https://example.com/drinks/citylights.jpg"),
                        ingredients: ["Bourbon", "Bitters", "Orange", "Cherry"],
                        isAvailable: true,
                        tags: ["Classic", "Strong"]
                    )
                ]
            ),
            DrinkCategory(
                id: "cat-2",
                name: "Classic Cocktails",
                description: "Timeless favorites",
                drinks: [
                    Drink(
                        id: "drink-3",
                        name: "Manhattan",
                        description: "A perfect blend of whiskey, sweet vermouth, and bitters",
                        price: 16.00,
                        imageURL: URL(string: "https://example.com/drinks/manhattan.jpg"),
                        ingredients: ["Whiskey", "Sweet Vermouth", "Bitters", "Cherry"],
                        isAvailable: true,
                        tags: ["Classic", "Strong"]
                    )
                ]
            )
        ]
    )
}

#if DEBUG
extension DrinkMenu {
    static var mock: DrinkMenu {
        DrinkMenu(
            venueId: "mock-venue",
            categories: [
                DrinkCategory(
                    id: "mock-cat-1",
                    name: "Mock Drinks",
                    description: "Test drinks for preview",
                    drinks: [
                        Drink(
                            id: "d1",
                            name: "House Cocktail",
                            description: "Our signature cocktail",
                            price: 15.0,
                            imageURL: nil,
                            ingredients: ["Vodka", "Lime"],
                            isAvailable: true,
                            tags: ["Popular"]
                        ),
                        Drink(
                            id: "d2",
                            name: "Premium Wine",
                            description: "Selected red or white wine",
                            price: 12.0,
                            imageURL: nil,
                            ingredients: ["Wine"],
                            isAvailable: true,
                            tags: ["Wine"]
                        )
                    ]
                )
            ]
        )
    }
}
#endif 