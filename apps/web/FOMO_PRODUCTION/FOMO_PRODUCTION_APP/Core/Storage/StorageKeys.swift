import Foundation

/// Centralizes all storage keys used in the app
enum StorageKeys {
    // MARK: - User Defaults Keys
    
    enum UserDefaults {
        static let hasCompletedOnboarding = "has_completed_onboarding"
        static let selectedVenueId = "selected_venue_id"
        static let lastRefreshTimestamp = "last_refresh_timestamp"
        static let userPreferences = "user_preferences"
        static let cachedVenues = "cached_venues"
        static let notificationSettings = "notification_settings"
    }
    
    // MARK: - File System Keys
    
    enum FileSystem {
        static let venueImages = "venue_images"
        static let userProfile = "user_profile"
        static let passData = "pass_data"
        static let offlineContent = "offline_content"
    }
    
    // MARK: - Keychain Keys
    
    enum Keychain {
        static let authToken = KeychainKey.authToken.rawValue
        static let refreshToken = KeychainKey.refreshToken.rawValue
        static let userCredentials = KeychainKey.userCredentials.rawValue
    }
} 