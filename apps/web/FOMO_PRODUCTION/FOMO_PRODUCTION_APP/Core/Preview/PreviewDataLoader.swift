import Foundation

#if DEBUG
public final class PreviewDataLoader {
    public static let shared = PreviewDataLoader()
    
    private init() {}
    
    public func loadVenues() async throws -> [Venue] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return [
            Venue(
                id: "1",
                name: "The Rooftop Bar",
                description: "A luxurious rooftop bar with stunning city views",
                address: "123 Main St, New York, NY 10001",
                imageUrl: "https://example.com/rooftop.jpg",
                capacity: 200,
                currentCapacity: 150,
                rating: 4.5,
                isOpen: true,
                waitTime: 15
            ),
            Venue(
                id: "2",
                name: "Underground Lounge",
                description: "An exclusive underground speakeasy",
                address: "456 Park Ave, New York, NY 10002",
                imageUrl: "https://example.com/lounge.jpg",
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
                imageUrl: "https://example.com/beach.jpg",
                capacity: 300,
                currentCapacity: 200,
                rating: 4.2,
                isOpen: false,
                waitTime: 0
            )
        ]
    }
    
    public func loadPasses() async throws -> [Pass] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [.previewActive, .previewExpired]
    }
    
    public func loadProfile() async throws -> UserProfile {
        try await Task.sleep(nanoseconds: 500_000_000)
        return .preview
    }
    
    public static func loadPreviewData() -> [String: Any]? {
        guard let url = Bundle.main.url(forResource: "sample_drinks", withExtension: "json", subdirectory: "Preview Content/PreviewData"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return json
    }
}
#endif 