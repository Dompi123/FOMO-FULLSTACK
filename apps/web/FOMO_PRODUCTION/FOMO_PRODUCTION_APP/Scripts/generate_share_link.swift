import SwiftUI

@main
struct ShareLinkGenerator: App {
    var body: some Scene {
        WindowGroup {
            Text("")
                .task {
                    do {
                        // 1. Enable collaboration
                        try await CollaborationManager.shared.enableCollaboration(
                            sessionName: "FOMO_Prod_Share",
                            permissions: .readOnly
                        )
                        
                        // 2. Display share link
                        if let url = CollaborationManager.shared.shareURL {
                            print("""
                            
                            📤 Share this secure link:
                            \(url)
                            
                            🔒 Security requirements:
                            - Cursor 2.4+ required
                            - GitHub 2FA enabled
                            - Device authorization needed
                            
                            """)
                        }
                        
                        // 3. Validate session
                        try CollaborationManager.shared.validateCollaboration(
                            requiredTools: [.realtimeEditing],
                            minVersion: "2.4.0"
                        )
                        
                        // 4. Track analytics
                        AnalyticsService.trackEvent(.collaborationEnabled(
                            sessionName: "FOMO_Prod_Share",
                            permissions: .readOnly
                        ))
                        
                        exit(0)
                    } catch {
                        print("Error generating share link: \(error)")
                        exit(1)
                    }
                }
        }
    }
} 