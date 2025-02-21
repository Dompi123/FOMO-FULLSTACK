import SwiftUI

extension Color {
    static var background: Color { FOMOTheme.Colors.background }
    static var primaryAccent: Color { FOMOTheme.Colors.primary }
    static var secondaryAccent: Color { FOMOTheme.Colors.secondary }
}

extension View {
    func themeStyle() -> some View {
        self
            .background(FOMOTheme.Colors.background)
            .tint(Color.primaryAccent)
    }
}
