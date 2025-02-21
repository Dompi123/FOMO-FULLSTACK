import Foundation

public struct Venue: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let imageUrl: String
    public let rating: Double
    public let capacity: Int
    public let currentCapacity: Int
    public let waitTime: Int
    
    public init(
        id: String,
        name: String,
        description: String,
        imageUrl: String,
        rating: Double,
        capacity: Int,
        currentCapacity: Int,
        waitTime: Int
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.rating = rating
        self.capacity = capacity
        self.currentCapacity = currentCapacity
        self.waitTime = waitTime
    }
}

#if DEBUG
public extension Venue {
    static var previewList: [Venue] = [
        Venue(
            id: "venue_1",
            name: "The Rooftop Lounge",
            description: "Exclusive rooftop venue with panoramic city views",
            imageUrl: "https://example.com/rooftop.jpg",
            rating: 4.8,
            capacity: 200,
            currentCapacity: 150,
            waitTime: 30
        ),
        Venue(
            id: "venue_2",
            name: "Club Nova",
            description: "High-energy nightclub featuring top DJs",
            imageUrl: "https://example.com/club.jpg",
            rating: 4.5,
            capacity: 500,
            currentCapacity: 400,
            waitTime: 45
        ),
        Venue(
            id: "venue_3",
            name: "The Speakeasy",
            description: "Intimate cocktail bar with vintage ambiance",
            imageUrl: "https://example.com/bar.jpg",
            rating: 4.9,
            capacity: 100,
            currentCapacity: 80,
            waitTime: 15
        )
    ]
    
    static var preview: Venue {
        previewList[0]
    }
}
#endif 