import SwiftUI

struct NavigationPreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("Test")
                .environmentObject(PreviewNavigationCoordinator.shared)
        }
    }
}
EOT 