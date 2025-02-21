import Foundation
import SwiftUI

@MainActor
@MainActor
final class ProfileViewModel: ObservableObject {
: BaseViewModel
    @Published private(set) var profile: UserProfile?
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let logger = DebugLogger(category: "Profile")
    
    func loadProfile() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            #if DEBUG
            // Always load preview data in debug builds
            profile = .preview
            return
            #else
            // In production, this would load from the backend
            throw NSError(domain: "Profile", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
            #endif
        } catch {
            self.error = error
            logger.error("Failed to load profile: \(error)")
        }
    }
    
    func updateProfile(_ updatedProfile: UserProfile) async throws {
        isLoading = true
        defer { isLoading = false }
        
        #if DEBUG
        // In debug builds, just update the local profile
        profile = updatedProfile
        #else
        // In production, we would update via API
        throw NSError(domain: "Profile", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
        #endif
    }
    
    func toggleNotifications() async {
        guard var currentProfile = profile else { return }
        currentProfile.preferences.notificationsEnabled.toggle()
        do {
            try await updateProfile(currentProfile)
        } catch {
            logger.error("Failed to toggle notifications: \(error)")
            self.error = error
        }
    }
    
    func toggleEmailUpdates() async {
        guard var currentProfile = profile else { return }
        currentProfile.preferences.emailUpdatesEnabled.toggle()
        do {
            try await updateProfile(currentProfile)
        } catch {
            logger.error("Failed to toggle email updates: \(error)")
            self.error = error
        }
    }
    
    func toggleFavoriteVenue(id: String) async {
        guard var currentProfile = profile else { return }
        if currentProfile.preferences.favoriteVenueIds.contains(id) {
            currentProfile.preferences.favoriteVenueIds.removeAll { $0 == id }
        } else {
            currentProfile.preferences.favoriteVenueIds.append(id)
        }
        do {
            try await updateProfile(currentProfile)
        } catch {
            logger.error("Failed to toggle favorite venue: \(error)")
            self.error = error
        }
    }
}

#if DEBUG
extension ProfileViewModel {
    static var preview: ProfileViewModel {
        let vm = ProfileViewModel()
        Task { await vm.loadProfile() }
        return vm
    }
}
#endif 