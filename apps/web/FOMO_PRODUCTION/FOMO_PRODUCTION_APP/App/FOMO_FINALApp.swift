import SwiftUI

@main
struct FOMOApp: App {
    @StateObject private var navigationCoordinator = PreviewNavigationCoordinator.shared
    
    init() {
        // Configure global appearance
        UITabBar.appearance().backgroundColor = UIColor(FOMOTheme.Colors.background)
        UINavigationBar.appearance().tintColor = UIColor(FOMOTheme.Colors.primary)
        
        // Register custom fonts
        ["SpaceGrotesk-Bold", "SpaceGrotesk-Medium"].forEach { font in
            if let url = Bundle.main.url(forResource: font, withExtension: "otf"),
               let data = try? Data(contentsOf: url),
               let provider = CGDataProvider(data: data as CFData),
               let cgFont = CGFont(provider) {
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
                    print("⚠️ Warning: Could not load font \(font)")
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationCoordinator)
                .preferredColorScheme(.dark)
                .background(FOMOTheme.Colors.background)
                .tint(FOMOTheme.Colors.primary)
        }
    }
}
