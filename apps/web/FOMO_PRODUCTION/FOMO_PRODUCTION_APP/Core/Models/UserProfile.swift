import Foundation

public struct UserProfile: Codable, Identifiable, Equatable {
    public let id: String
    public let username: String
    public let email: String
    public var firstName: String
    public var lastName: String
    public var membershipLevel: MembershipLevel
    public var preferences: Preferences
    public var paymentMethods: [PaymentMethod]
    
    public struct Preferences: Codable, Equatable {
        public var notificationsEnabled: Bool
        public var emailUpdatesEnabled: Bool
        public var favoriteVenueIds: [String]
        public var preferredVenueTypes: [String]
        public var dietaryRestrictions: [String]
        
        public init(
            notificationsEnabled: Bool = true,
            emailUpdatesEnabled: Bool = true,
            favoriteVenueIds: [String] = [],
            preferredVenueTypes: [String] = [],
            dietaryRestrictions: [String] = []
        ) {
            self.notificationsEnabled = notificationsEnabled
            self.emailUpdatesEnabled = emailUpdatesEnabled
            self.favoriteVenueIds = favoriteVenueIds
            self.preferredVenueTypes = preferredVenueTypes
            self.dietaryRestrictions = dietaryRestrictions
        }
    }
    
    public enum MembershipLevel: String, Codable {
        case basic, premium, vip
    }
    
    public struct PaymentMethod: Codable, Equatable {
        public let id: String
        public let lastFourDigits: String
        public let type: String
        
        public init(id: String, lastFourDigits: String, type: String) {
            self.id = id
            self.lastFourDigits = lastFourDigits
            self.type = type
        }
    }
    
    public init(
        id: String,
        username: String,
        email: String,
        firstName: String,
        lastName: String,
        membershipLevel: MembershipLevel,
        preferences: Preferences,
        paymentMethods: [PaymentMethod]
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.membershipLevel = membershipLevel
        self.preferences = preferences
        self.paymentMethods = paymentMethods
    }
}

#if DEBUG
public extension UserProfile {
    static let preview = UserProfile(
        id: "user_preview_123",
        username: "preview_user",
        email: "preview@fomo.com",
        firstName: "John",
        lastName: "Doe",
        membershipLevel: .premium,
        preferences: Preferences(
            notificationsEnabled: true,
            emailUpdatesEnabled: true,
            favoriteVenueIds: ["1", "2"],
            preferredVenueTypes: ["Rooftop Bar", "Lounge", "Club"],
            dietaryRestrictions: ["Vegetarian"]
        ),
        paymentMethods: [
            PaymentMethod(
                id: "pm_1234",
                lastFourDigits: "4242",
                type: "Visa"
            ),
            PaymentMethod(
                id: "pm_5678",
                lastFourDigits: "1234",
                type: "Mastercard"
            )
        ]
    )
}
#endif 