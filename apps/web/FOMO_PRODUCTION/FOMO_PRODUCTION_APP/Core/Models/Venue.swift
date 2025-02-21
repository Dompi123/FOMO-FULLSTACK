import Foundation

public struct Venue: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let description: String
    public let address: String
    public let imageUrl: String
    public let capacity: Int
    public let currentCapacity: Int
    public let rating: Double
    public let isOpen: Bool
    public let waitTime: Int
    
    public init(
        id: String,
        name: String,
        description: String,
        address: String,
        imageUrl: String,
        capacity: Int,
        currentCapacity: Int,
        rating: Double,
        isOpen: Bool,
        waitTime: Int
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.address = address
        self.imageUrl = imageUrl
        self.capacity = capacity
        self.currentCapacity = currentCapacity
        self.rating = rating
        self.isOpen = isOpen
        self.waitTime = waitTime
    }
}

#if DEBUG
public extension Venue {
    static let preview = Venue(
        id: "1",
        name: "The Rooftop Bar",
        description: "A luxurious rooftop bar with stunning city views",
        address: "123 Main St, New York, NY 10001",
        imageUrl: "venue_rooftop",
        capacity: 200,
        currentCapacity: 150,
        rating: 4.5,
        isOpen: true,
        waitTime: 15
    )
    
    static let previewList = [
        preview,
        Venue(
            id: "2",
            name: "Underground Lounge",
            description: "An exclusive underground speakeasy",
            address: "456 Park Ave, New York, NY 10002",
            imageUrl: "venue_lounge",
            capacity: 100,
            currentCapacity: 80,
            rating: 4.8,
            isOpen: true,
            waitTime: 30
        ),
        Venue(
            id: "3",
            name: "Beach Club",
            description: "Beachfront venue with live music",
            address: "789 Ocean Dr, Miami, FL 33139",
            imageUrl: "venue_beach",
            capacity: 300,
            currentCapacity: 200,
            rating: 4.2,
            isOpen: false,
            waitTime: 0
        )
    ]
}
#endif 