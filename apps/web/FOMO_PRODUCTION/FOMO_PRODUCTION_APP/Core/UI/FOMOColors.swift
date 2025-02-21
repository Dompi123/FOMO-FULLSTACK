import SwiftUI

/// FOMO App color scheme
enum FOMOColors {
    /// Primary brand colors
    static let primary = Color("AccentColor")
    static let secondary = Color.red // Using system red instead of hex
    
    /// Semantic colors
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.yellow
    static let inactive = Color.gray
    
    /// UI State colors
    static let buttonEnabled = Color.blue
    static let buttonDisabled = Color.gray.opacity(0.5)
    static let background = Color(uiColor: .systemBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    
    /// Text colors
    static let primaryText = Color(uiColor: .label)
    static let secondaryText = Color(uiColor: .secondaryLabel)
} 