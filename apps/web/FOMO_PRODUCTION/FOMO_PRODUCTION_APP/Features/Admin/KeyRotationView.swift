import SwiftUI
import OSLog

@MainActor
final class KeyRotationViewModel: ObservableObject {
    @Published private(set) var isRotating = false
    @Published private(set) var lastRotation: Date?
    @Published var error: Error?
    
    private let keychain = KeychainManager.shared
    private let logger = Logger(subsystem: "com.fomo", category: "KeyRotation")
    
    func rotateKeys() async {
        guard !isRotating else { return }
        isRotating = true
        
        do {
            try await keychain.rotateKeys()
            lastRotation = Date()
            logger.info("Key rotation completed successfully")
        } catch {
            self.error = error
            logger.error("Key rotation failed: \(error.localizedDescription)")
        }
        
        isRotating = false
    }
}

struct KeyRotationView: View {
    @StateObject private var viewModel = KeyRotationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                headerSection
                
                rotationButton
                
                if let lastRotation = viewModel.lastRotation {
                    Text("Last rotation: \(lastRotation.formatted())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Key Rotation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Error", isPresented: .init(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Button("OK") { viewModel.error = nil }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "key.fill")
                .font(.largeTitle)
                .foregroundColor(FOMOTheme.Colors.primary)
            
            Text("API Key Management")
                .font(.headline)
            
            Text("Rotate API keys to maintain security. This will invalidate all existing keys.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }
    
    private var rotationButton: some View {
        Button {
            Task {
                await viewModel.rotateKeys()
            }
        } label: {
            HStack {
                if viewModel.isRotating {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                }
                
                Text(viewModel.isRotating ? "Rotating..." : "Rotate API Keys")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(FOMOTheme.Colors.primary)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(viewModel.isRotating)
    }
}

#if DEBUG
struct KeyRotationView_Previews: PreviewProvider {
    static var previews: some View {
        KeyRotationView()
    }
}
#endif 