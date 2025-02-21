import SwiftUI

#if DEBUG
struct PreviewHost: View {
    @StateObject private var coordinator = PreviewCoordinator.shared
    
    var body: some View {
        NavigationView {
            Group {
                switch coordinator.previewState {
                case .loading:
                    ProgressView("Validating Security...")
                        .progressViewStyle(.circular)
                        .tint(FOMOTheme.Colors.accent)
                
                case .ready:
                    coordinator.showAllComponents()
                
                case .error(let error):
                    ContentUnavailableView(
                        "Preview Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error.localizedDescription)
                    )
                }
            }
            .navigationTitle("FOMO Design System")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SecurityBadge(status: coordinator.securityStatus)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

private struct SecurityBadge: View {
    let status: PreviewCoordinator.SecurityValidation
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .font(FOMOTheme.Typography.caption1)
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .clipShape(Capsule())
    }
    
    private var icon: String {
        switch status {
        case .pending:
            return "clock"
        case .validated:
            return "checkmark.shield"
        case .failed:
            return "xmark.shield"
        }
    }
    
    private var title: String {
        switch status {
        case .pending:
            return "Validating"
        case .validated:
            return "Secure"
        case .failed:
            return "Failed"
        }
    }
    
    private var color: Color {
        switch status {
        case .pending:
            return FOMOTheme.Colors.warning
        case .validated:
            return FOMOTheme.Colors.success
        case .failed:
            return FOMOTheme.Colors.error
        }
    }
}

// MARK: - Preview Provider
struct PreviewHost_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHost()
    }
}
#endif 