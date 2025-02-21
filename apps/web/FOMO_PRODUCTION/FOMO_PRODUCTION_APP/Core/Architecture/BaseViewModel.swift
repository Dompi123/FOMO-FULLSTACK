import SwiftUI
import OSLog

@MainActor
class BaseViewModel: ObservableObject {
    @Published var error: Error?
    private let logger = Logger(subsystem: "com.fomo", category: "ViewModel")
    
    func handleError(_ error: Error) {
        self.error = error
        logger.error("\(error.localizedDescription)")
    }
    
    func clearError() {
        error = nil
    }
}
