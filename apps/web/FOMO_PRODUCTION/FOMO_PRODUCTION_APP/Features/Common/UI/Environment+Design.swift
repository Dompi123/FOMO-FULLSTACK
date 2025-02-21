import SwiftUI

private struct FOMOThemeKey: EnvironmentKey {
    static let defaultValue: FOMOTheme.Type = FOMOTheme.self
}

extension EnvironmentValues {
    var fomoTheme: FOMOTheme.Type {
        get { self[FOMOThemeKey.self] }
        set { self[FOMOThemeKey.self] = newValue }
    }
}

// MARK: - View Extensions
extension View {
    func fomoTheme(_ theme: FOMOTheme.Type) -> some View {
        environment(\.fomoTheme, theme)
    }
}

// MARK: - Preview Support
#if DEBUG
extension View {
    func previewWithTheme() -> some View {
        self
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif 