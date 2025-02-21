import SwiftUI

@main
struct FOMOApp: App {
    @StateObject private var collaborationManager = CollaborationManager.shared
    @StateObject private var sharedEnvironment = SharedEnvironment.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(collaborationManager)
                .environmentObject(sharedEnvironment)
                .task {
                    do {
                        // Enable collaboration
                        try await collaborationManager.enableCollaboration(
                            sessionName: "FOMO_Main"
                        )
                        
                        // Display share link
                        if let url = collaborationManager.shareURL {
                            print("""
                            
                            📤 Share this secure link:
                            \(url)
                            
                            🔒 Security requirements:
                            - Cursor 2.4+ required
                            - GitHub 2FA enabled
                            - Device authorization needed
                            
                            """)
                        }
                        
                        // Validate collaboration tools
                        try collaborationManager.validateCollaboration(
                            requiredTools: [.realtimeEditing, .aiAssist],
                            minVersion: "2.3.0"
                        )
                        
                        // Sync team environment
                        try await sharedEnvironment.synchronize()
                        
                    } catch {
                        // Handle initialization errors
                        print("Failed to initialize collaboration: \(error)")
                    }
                }
        }
    }
} 