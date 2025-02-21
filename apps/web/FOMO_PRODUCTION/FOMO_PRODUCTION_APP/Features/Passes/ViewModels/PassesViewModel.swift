import Foundation
import SwiftUI

@MainActor
@MainActor
final class PassesViewModel: ObservableObject {
: BaseViewModel
    @Published private(set) var passes: [Pass] = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let logger = DebugLogger(category: "Passes")
    
    func loadPasses() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            #if DEBUG
            // Always load preview data in debug builds for now
            passes = [.previewActive, .previewExpired]
            return
            #else
            // In production, this would load from the backend
            throw NSError(domain: "Passes", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
            #endif
        } catch {
            self.error = error
            logger.error("Failed to load passes: \(error)")
        }
    }
    
    func refreshPasses() async {
        await loadPasses()
    }
    
    func pass(withId id: String) -> Pass? {
        passes.first { pass in pass.id == id }
    }
    
    func passes(forVenueId venueId: String) -> [Pass] {
        passes.filter { pass in pass.venueId == venueId }
    }
}

// MARK: - Filtering
extension PassesViewModel {
    var activePasses: [Pass] {
        passes.filter { pass in pass.status == .active }
    }
    
    var expiredPasses: [Pass] {
        passes.filter { $0.status == .expired }
    }
    
    var usedPasses: [Pass] {
        passes.filter { $0.status == .used }
    }
}

#if DEBUG
extension PassesViewModel {
    static var preview: PassesViewModel {
        let vm = PassesViewModel()
        Task { await vm.loadPasses() }
        return vm
    }
}
#endif 