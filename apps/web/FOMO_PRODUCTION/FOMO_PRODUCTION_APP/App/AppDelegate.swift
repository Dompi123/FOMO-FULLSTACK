import SwiftUI
import OSLog

@main
struct FOMOApp: App {
    @StateObject private var crashTracker = CrashTracker()
    
    init() {
        Logger.appLifecycle.info("App initializing...")
        setupCrashReporting()
        
        // Support all orientations
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(crashTracker)
                .task {
                    Logger.appLifecycle.info("Root view appeared")
                }
        }
    }
    
    private func setupCrashReporting() {
        NSSetUncaughtExceptionHandler { exception in
            Logger.appCrash.fault("CRASH: \(exception)")
        }
    }
}

@MainActor
final class CrashTracker: ObservableObject {
    @Published var lastError: Error?
    
    func log(_ error: Error) {
        lastError = error
        Logger.appError.error("\(error.localizedDescription)")
    }
}

extension Logger {
    static let appLifecycle = Logger(subsystem: "com.fomo", category: "Lifecycle")
    static let appCrash = Logger(subsystem: "com.fomo", category: "Crash")
    static let appError = Logger(subsystem: "com.fomo", category: "Error")
}
