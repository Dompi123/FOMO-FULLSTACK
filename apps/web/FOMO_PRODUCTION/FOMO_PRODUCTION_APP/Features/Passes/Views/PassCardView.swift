import SwiftUI

struct PassCardView: View {
    let pass: Pass
    let isFullScreen: Bool
    @StateObject private var viewModel: PassPresentationViewModel
    
    init(pass: Pass, isFullScreen: Bool) {
        self.pass = pass
        self.isFullScreen = isFullScreen
        self._viewModel = StateObject(wrappedValue: PassPresentationViewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(pass.venueName)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(pass.type.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if !isFullScreen {
                    HStack {
                        Text("Use by \(pass.expiryDate.formatted(date: .numeric, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: pass.type == .drink ? 
                        [Color.pink, Color.pink.opacity(0.8)] :
                        [Color.blue, Color.blue.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(isFullScreen ? 0 : 12, corners: .allCorners)
            
            if isFullScreen {
                // Full screen additional content
                VStack(spacing: 24) {
                    // Pass holder info
                    VStack(spacing: 4) {
                        Text("Passholder")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(pass.holderName)
                            .font(.body)
                    }
                    
                    // Use by date
                    VStack(spacing: 4) {
                        Text("Use by")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(pass.expiryDate.formatted(date: .numeric, time: .shortened))
                            .font(.body)
                    }
                    
                    // Instructions
                    Text(pass.type == .drink ? 
                        "Show this screen to the bartender" :
                        "Show this screen to the doorman")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Action button
                    Button(action: {
                        Task {
                            await viewModel.verifyPass(pass)
                        }
                    }) {
                        Text(pass.type == .drink ? "I Am The Bartender" : "I Am The Doorman")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray4))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        // Show redemption instructions
                    }) {
                        Text("How to Redeem")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 24)
            }
        }
        .background(isFullScreen ? Color(.systemBackground) : Color.clear)
        .alert("Pass Used", isPresented: $viewModel.showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(pass.type == .drink ? 
                "Your drink pass has been redeemed" :
                "Your line skip pass has been validated")
        }
    }
}

// MARK: - Preview
#if DEBUG
struct PassCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PassCardView(pass: .mockDrinkPass, isFullScreen: false)
            PassCardView(pass: .mockLineSkipPass, isFullScreen: true)
        }
    }
}
#endif 