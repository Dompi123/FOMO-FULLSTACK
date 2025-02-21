import SwiftUI

extension PreviewDevice {
    static let fomoSimulator = PreviewDevice(rawValue: "FOMO_Simulator")
}

extension View {
    func fomoPreview() -> some View {
        self
            .previewDevice(.fomoSimulator)
            .previewDisplayName("FOMO Simulator")
            .modifier(ThemePreview())
    }
} 