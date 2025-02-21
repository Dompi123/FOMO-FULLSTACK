import SwiftUI
import Foundation

#if DEBUG
@MainActor
final class PreviewCoordinator: ObservableObject {
    static let shared = PreviewCoordinator()
    
    @Published private(set) var performanceMonitor = PreviewPerformanceMonitor.shared
    @Published private(set) var previewState: PreviewState = .loading
    @Published private(set) var activePreview: PreviewSection = .colors
    
    private init() {
        Task {
            await loadPreviews()
        }
    }
    
    private func loadPreviews() async {
        previewState = .loading
        
        do {
            // Simulate preview loading
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Start performance monitoring
            performanceMonitor.startMonitoring()
            
            // Wait for initial security validation
            while performanceMonitor.securityStatus == .validating {
                try await Task.sleep(nanoseconds: 100_000_000)
            }
            
            // Only proceed if security validation passed
            guard performanceMonitor.securityStatus == .passed else {
                previewState = .error("Security validation failed")
                return
            }
            
            previewState = .ready
        } catch {
            previewState = .error(error.localizedDescription)
        }
    }
    
    func selectPreview(_ section: PreviewSection) {
        activePreview = section
    }
}

// MARK: - Supporting Types
extension PreviewCoordinator {
    enum PreviewState: Equatable {
        case loading
        case ready
        case error(String)
    }
    
    enum PreviewSection: String, CaseIterable {
        case colors = "Colors"
        case typography = "Typography"
        case layout = "Layout"
        case components = "Components"
        case security = "Security"
        case performance = "Performance"
        
        var icon: String {
            switch self {
            case .colors: return "paintpalette"
            case .typography: return "textformat"
            case .layout: return "rectangle.3.group"
            case .components: return "puzzlepiece"
            case .security: return "lock.shield"
            case .performance: return "gauge"
            }
        }
    }
}

// MARK: - Preview Support
struct PreviewCoordinatorView: View {
    @ObservedObject private var coordinator = PreviewCoordinator.shared
    
    var body: some View {
        NavigationView {
            Group {
                switch coordinator.previewState {
                case .loading:
                    ProgressView("Loading Previews...")
                        .progressViewStyle(.circular)
                        .font(FOMOTheme.Typography.bodyRegular)
                
                case .ready:
                    content
                
                case .error(let message):
                    VStack(spacing: FOMOTheme.Layout.gridSpacing) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundStyle(FOMOTheme.Colors.error)
                        
                        Text("Preview Error")
                            .font(FOMOTheme.Typography.headlineMedium)
                        
                        Text(message)
                            .font(FOMOTheme.Typography.bodyRegular)
                            .foregroundStyle(FOMOTheme.Colors.error)
                    }
                }
            }
            .navigationTitle("FOMO Preview")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SecurityBadge(status: coordinator.performanceMonitor.securityStatus)
                }
            }
        }
    }
    
    private var content: some View {
        HStack(spacing: 0) {
            // Sidebar
            VStack(spacing: FOMOTheme.Layout.gridSpacing) {
                ForEach(PreviewSection.allCases, id: \.self) { section in
                    Button {
                        coordinator.selectPreview(section)
                    } label: {
                        HStack {
                            Image(systemName: section.icon)
                            Text(section.rawValue)
                                .font(FOMOTheme.Typography.bodyRegular)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(FOMOTheme.Layout.gridSpacing)
                        .background(
                            coordinator.activePreview == section ?
                            FOMOTheme.Colors.accent.opacity(0.2) : Color.clear
                        )
                        .cornerRadius(FOMOTheme.Layout.cornerRadius)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                // Performance Monitor
                PerformanceMonitorView()
            }
            .frame(width: 200)
            .padding()
            .background(FOMOTheme.Colors.surface)
            
            // Preview Content
            ScrollView {
                switch coordinator.activePreview {
                case .colors:
                    ColorPreview()
                case .typography:
                    TypographyPreview()
                case .layout:
                    LayoutPreview()
                case .components:
                    ComponentPreview()
                case .security:
                    SecurityPreview()
                case .performance:
                    PerformancePreview()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(FOMOTheme.Colors.background)
        }
    }
}

// MARK: - Preview Components
private struct SecurityBadge: View {
    let status: PreviewPerformanceMonitor.SecurityStatus
    
    var body: some View {
        Label {
            Text(String(describing: status))
                .font(FOMOTheme.Typography.bodySmall)
        } icon: {
            Image(systemName: status.icon)
        }
        .foregroundStyle(status.color)
        .padding(6)
        .background(status.color.opacity(0.1))
        .cornerRadius(FOMOTheme.Layout.cornerRadius)
    }
}

private struct ColorPreview: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: FOMOTheme.Layout.gridSpacing) {
            ColorCard(name: "Background", color: FOMOTheme.Colors.background)
            ColorCard(name: "Surface", color: FOMOTheme.Colors.surface)
            ColorCard(name: "Accent", color: FOMOTheme.Colors.accent)
            ColorCard(name: "Success", color: FOMOTheme.Colors.success)
            ColorCard(name: "Warning", color: FOMOTheme.Colors.warning)
            ColorCard(name: "Error", color: FOMOTheme.Colors.error)
        }
        .padding()
    }
}

private struct ColorCard: View {
    let name: String
    let color: Color
    
    var body: some View {
        VStack(spacing: FOMOTheme.Layout.gridSpacing) {
            Rectangle()
                .fill(color)
                .frame(height: 100)
                .cornerRadius(FOMOTheme.Layout.cornerRadius)
            
            Text(name)
                .font(FOMOTheme.Typography.bodyRegular)
        }
    }
}

private struct TypographyPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: FOMOTheme.Layout.gridSpacing * 2) {
            Group {
                Text("Display")
                    .font(FOMOTheme.Typography.display)
                Text("Headline Large")
                    .font(FOMOTheme.Typography.headlineLarge)
                Text("Headline Medium")
                    .font(FOMOTheme.Typography.headlineMedium)
                Text("Headline Small")
                    .font(FOMOTheme.Typography.headlineSmall)
            }
            
            Divider()
            
            Group {
                Text("Body Large")
                    .font(FOMOTheme.Typography.bodyLarge)
                Text("Body Regular")
                    .font(FOMOTheme.Typography.bodyRegular)
                Text("Body Small")
                    .font(FOMOTheme.Typography.bodySmall)
            }
        }
        .padding()
    }
}

private struct LayoutPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: FOMOTheme.Layout.gridSpacing * 2) {
            Text("Grid Spacing")
                .font(FOMOTheme.Typography.headlineMedium)
            
            HStack(spacing: FOMOTheme.Layout.gridSpacing) {
                ForEach(0..<5) { _ in
                    Rectangle()
                        .fill(FOMOTheme.Colors.accent)
                        .frame(width: 50, height: 50)
                }
            }
            
            Divider()
            
            Text("Corner Radius")
                .font(FOMOTheme.Typography.headlineMedium)
            
            HStack(spacing: FOMOTheme.Layout.gridSpacing) {
                ForEach([8.0, 12.0, 16.0, 24.0], id: \.self) { radius in
                    Rectangle()
                        .fill(FOMOTheme.Colors.accent)
                        .frame(width: 80, height: 80)
                        .cornerRadius(radius)
                        .overlay(
                            Text("\(Int(radius))")
                                .font(FOMOTheme.Typography.bodySmall)
                                .foregroundStyle(.white)
                        )
                }
            }
        }
        .padding()
    }
}

private struct ComponentPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: FOMOTheme.Layout.gridSpacing * 2) {
            Text("Buttons")
                .font(FOMOTheme.Typography.headlineMedium)
            
            HStack(spacing: FOMOTheme.Layout.gridSpacing) {
                Button("Primary") {}
                    .buttonStyle(.borderedProminent)
                
                Button("Secondary") {}
                    .buttonStyle(.bordered)
            }
            
            Divider()
            
            Text("Cards")
                .font(FOMOTheme.Typography.headlineMedium)
            
            HStack(spacing: FOMOTheme.Layout.gridSpacing) {
                ForEach(["Basic", "Elevated"], id: \.self) { style in
                    VStack {
                        Text(style)
                            .font(FOMOTheme.Typography.bodyRegular)
                            .padding()
                            .frame(width: 150)
                            .background(FOMOTheme.Colors.surface)
                            .cornerRadius(FOMOTheme.Layout.cornerRadius)
                            .shadow(radius: style == "Elevated" ? 4 : 0)
                    }
                }
            }
        }
        .padding()
    }
}

private struct SecurityPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: FOMOTheme.Layout.gridSpacing * 2) {
            Text("Security Features")
                .font(FOMOTheme.Typography.headlineMedium)
            
            ForEach(["Secure Storage", "API Protection", "Payment Security"], id: \.self) { feature in
                HStack {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(FOMOTheme.Colors.success)
                    
                    Text(feature)
                        .font(FOMOTheme.Typography.bodyRegular)
                }
            }
        }
        .padding()
    }
}

private struct PerformancePreview: View {
    @ObservedObject private var monitor = PreviewPerformanceMonitor.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: FOMOTheme.Layout.gridSpacing * 2) {
            Text("Performance Metrics")
                .font(FOMOTheme.Typography.headlineMedium)
            
            ForEach(monitor.metrics) { metric in
                HStack {
                    Text(metric.name)
                        .font(FOMOTheme.Typography.bodyRegular)
                    
                    Spacer()
                    
                    Text("Threshold: \(metric.threshold)\(metric.unit)")
                        .font(FOMOTheme.Typography.bodySmall)
                        .foregroundStyle(.secondary)
                    
                    Text(metric.formattedValue)
                        .font(FOMOTheme.Typography.bodyRegular)
                        .foregroundStyle(metric.status.color)
                }
            }
        }
        .padding()
    }
}

#if DEBUG
struct PreviewCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewCoordinatorView()
    }
}
#endif 
#endif 