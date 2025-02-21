@testable import FOMO_FINAL
import SwiftUI

#if DEBUG
struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                PaywallView(venue: .mock)
                    .environmentObject(PaymentManager.preview)
                    .environmentObject(PreviewNavigationCoordinator.preview)
                    .environment(\.previewMode, true)
                    .previewDisplayName("Default")
            }
            
            NavigationView {
                PaywallView(venue: .mock)
                    .environmentObject(PaymentManager.preview)
                    .environmentObject(PreviewNavigationCoordinator.preview)
                    .environment(\.previewMode, true)
                    .preferredColorScheme(.dark)
                    .previewDisplayName("Dark Mode")
            }
            
            NavigationView {
                PaywallView(venue: .mock, initialState: .processing)
                    .environmentObject(PaymentManager.preview)
                    .environmentObject(PreviewNavigationCoordinator.preview)
                    .environment(\.previewMode, true)
                    .previewDisplayName("Processing State")
            }
            
            NavigationView {
                PaywallView(venue: .mock)
                    .environmentObject(PaymentManager.preview)
                    .environmentObject(PreviewNavigationCoordinator.preview)
                    .environment(\.previewMode, true)
                    .previewDevice("iPhone 15 Pro")
                    .previewDisplayName("iPhone 15 Pro")
            }
        }
    }
}
#endif 