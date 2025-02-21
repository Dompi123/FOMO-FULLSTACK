import Foundation

#if DEBUG
// MARK: - Venue
public struct Venue: Identifiable {
    public let id: String
    public let name: String
    public let description: String
    public let address: String
    public let imageUrl: String
    public let rating: Double
    public let isOpen: Bool
}

extension Venue {
    public static let mock = Venue(
        id: "venue-1",
        name: "The Nightclub",
        description: "Experience the best nightlife in town",
        address: "123 Party Street",
        imageUrl: "venue-preview",
        rating: 4.5,
        isOpen: true
    )
}

// MARK: - Pass
public struct Pass: Identifiable {
    public let id: String
    public let name: String
    public let description: String
    public let price: Double
    public let validUntil: Date
    public let isActive: Bool
}

extension Pass {
    public static let previewActive = Pass(
        id: "pass-1",
        name: "VIP Pass",
        description: "Access to all premium venues",
        price: 99.99,
        validUntil: Date().addingTimeInterval(30 * 24 * 60 * 60), // 30 days from now
        isActive: true
    )
    
    public static let previewExpired = Pass(
        id: "pass-2",
        name: "Standard Pass",
        description: "Basic venue access",
        price: 49.99,
        validUntil: Date().addingTimeInterval(-1 * 24 * 60 * 60), // 1 day ago
        isActive: false
    )
}

// MARK: - UserProfile
public struct UserProfile {
    public let id: String
    public let name: String
    public let email: String
    public let phoneNumber: String
    public let memberSince: Date
    public let profileImageUrl: String?
}

extension UserProfile {
    public static let preview = UserProfile(
        id: "user-1",
        name: "John Doe",
        email: "john.doe@example.com",
        phoneNumber: "+1 (555) 123-4567",
        memberSince: Date().addingTimeInterval(-90 * 24 * 60 * 60), // 90 days ago
        profileImageUrl: "profile-preview"
    )
}
#endif 