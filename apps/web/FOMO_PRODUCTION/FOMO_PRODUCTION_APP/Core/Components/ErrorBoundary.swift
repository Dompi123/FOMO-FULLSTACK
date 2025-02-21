import SwiftUI
import OSLog

struct ErrorBoundary<Content: View>: View {
    @State private var error: Error?
    let content: () -> Content
    
    var body: some View {
        Group {
            if let error = error {
                ErrorFallbackView(error: error)
            } else {
                content()
                    .onCatchError { error in
                        self.error = error
                    }
            }
        }
    }
}

struct ErrorFallbackView: View {
    let error: Error
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(FOMOTheme.Colors.vividPink)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(FOMOTheme.Colors.textSecondary)
            
            Button("Retry") {
                // Implement retry logic
            }
            .buttonStyle(.borderedProminent)
            .tint(FOMOTheme.Colors.vividPink)
        }
        .padding()
        .background(FOMOTheme.Colors.background)
    }
}

extension View {
    func onCatchError(_ handler: @escaping (Error) -> Void) -> some View {
        modifier(ErrorHandlerModifier(handler: handler))
    }
}

struct ErrorHandlerModifier: ViewModifier {
    let handler: (Error) -> Void
    
    func body(content: Content) -> some View {
        content
            .task {
                await handleErrors()
            }
    }
    
    @MainActor
    private func handleErrors() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {
            handler(error)
        }
    }
}
