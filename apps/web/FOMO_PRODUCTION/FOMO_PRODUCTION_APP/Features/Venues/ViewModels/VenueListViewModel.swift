import Foundation
import SwiftUI
import OSLog

@MainActor
public final class VenueListViewModel: ObservableObject {
    @Published private(set) var venues: [Venue] = []
    @Published private(set) var isLoading = false
    @Published private(set) var filteredAndSortedVenues: [Venue] = []
    @Published var error: Error?
    @Published var searchText = ""
    @Published var selectedSortOption = VenueSortOption.name
    
    private let apiClient = APIClient.shared
    private let logger = Logger(subsystem: "com.fomo", category: "VenueList")
    
    public init() {
        super.init()
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            venues = Venue.previewList
            filteredAndSortedVenues = venues
        }
        #endif
        Task {
            await loadVenues()
        }
    }
    
    public func loadVenues() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response: APIResponse<[Venue]> = try await apiClient.request(.venues)
            venues = response.data
            filteredAndSortedVenues = venues
            logger.info("Loaded \(venues.count) venues")
            
        } catch let error as NetworkError {
            handleError(error)
            logger.error("Failed to load venues: \(error.localizedDescription)")
            
            #if DEBUG
            // Use preview data as fallback in debug builds
            venues = Venue.previewList
            filteredAndSortedVenues = venues
            logger.debug("Using preview data as fallback")
            #endif
            
        } catch {
            handleError(NetworkError.wrapped(error))
            logger.error("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    public func refreshVenues() async {
        await loadVenues()
    }
    
    public func venue(withId id: String) -> Venue? {
        venues.first { venue in venue.id == id }
    }
    
    func applyFilters() {
        // TODO: Implement venue filtering logic
        filteredAndSortedVenues = venues
    }
}

// MARK: - Filtering and Sorting
extension VenueListViewModel {
    var filteredAndSortedVenues: [Venue] {
        let filtered = venues.filter { venue in
            searchText.isEmpty || venue.name.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { (first: Venue, second: Venue) in
            switch selectedSortOption {
            case .name:
                return first.name < second.name
            case .rating:
                return first.rating > second.rating
            case .waitTime:
                return first.waitTime < second.waitTime
            }
        }
    }
}

public enum VenueSortOption: String, CaseIterable {
    case name = "Name"
    case rating = "Rating"
    case waitTime = "Wait Time"
}

#if DEBUG
extension VenueListViewModel {
    static var preview: VenueListViewModel {
        let vm = VenueListViewModel()
        vm.venues = Venue.previewList
        vm.filteredAndSortedVenues = vm.venues
        return vm
    }
    
    func simulateError() {
        handleError(NetworkError.rateLimitExceeded(retryAfter: 60))
    }
}
#endif 