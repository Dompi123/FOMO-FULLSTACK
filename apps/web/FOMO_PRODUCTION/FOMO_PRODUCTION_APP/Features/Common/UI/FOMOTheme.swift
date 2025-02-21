import SwiftUI

enum FOMOTheme {
    enum Colors {
        static let vividPink = Color(hex: 0xE91E63)
        static let oledBlack = Color(hex: 0x000000)
        static let cyanAccent = Color(hex: 0x00BCD4)
        
        static let background = oledBlack
        static let primary = vividPink
        static let secondary = cyanAccent
        static let surface = Color(hex: 0xF5F5F5)
        static let text = Color.white
        static let textSecondary = Color.gray
        
        static let buttonEnabled = primary
        static let buttonDisabled = Color.gray.opacity(0.5)
        
        static let success = Color(hex: 0x4CAF50)
        static let warning = Color(hex: 0xFFC107)
        static let error = Color(hex: 0xF44336)
        static let inactive = Color.gray
    }
    
    enum Typography {
        private static let spaceGroteskBold = "SpaceGrotesk-Bold"
        private static let spaceGroteskMedium = "SpaceGrotesk-Medium"
        
        static let header = Font.custom(spaceGroteskBold, size: 22)
        static let body = Font.custom(spaceGroteskMedium, size: 16)
        
        static let titleLarge = Font.custom(spaceGroteskBold, size: 28)
        static let titleMedium = Font.custom(spaceGroteskBold, size: 22)
        static let titleSmall = Font.custom(spaceGroteskBold, size: 20)
        static let bodyLarge = Font.custom(spaceGroteskMedium, size: 17)
        static let bodyMedium = Font.custom(spaceGroteskMedium, size: 15)
        static let bodySmall = Font.custom(spaceGroteskMedium, size: 13)
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: Int) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
