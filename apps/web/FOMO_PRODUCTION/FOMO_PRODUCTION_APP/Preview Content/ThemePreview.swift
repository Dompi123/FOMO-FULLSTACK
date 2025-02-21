import SwiftUI

struct ThemePreview: ViewModifier {
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(.dark)
            .environment(\.colorScheme, .dark)
            .background(FOMOTheme.Colors.background)
            .tint(FOMOTheme.Colors.primary)
    }
} 