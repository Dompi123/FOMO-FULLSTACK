import SwiftUI
import Foundation

#if DEBUG
public struct PreviewPaymentStateKey: EnvironmentKey {
    public static let defaultValue: PaymentState = .ready
}

public struct PreviewModeKey: EnvironmentKey {
    public static let defaultValue: Bool = false
}

public extension EnvironmentValues {
    var previewPaymentState: PaymentState {
        get { self[PreviewPaymentStateKey.self] }
        set { self[PreviewPaymentStateKey.self] = newValue }
    }
    
    var previewMode: Bool {
        get { self[PreviewModeKey.self] }
        set { self[PreviewModeKey.self] = newValue }
    }
}
#endif 