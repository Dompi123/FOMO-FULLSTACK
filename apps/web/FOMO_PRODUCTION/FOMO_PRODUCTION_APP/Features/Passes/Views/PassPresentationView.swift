import SwiftUI

struct PassPresentationView: View {
    let pass: Pass
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PassPresentationViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Pass card in full-screen mode
                PassCardView(pass: pass, isFullScreen: true)
                    .edgesIgnoringSafeArea(.horizontal)
                
                Spacer()
                
                // Bottom tab bar (matches design)
                HStack(spacing: 32) {
                    TabBarButton(
                        icon: "mappin.circle.fill",
                        text: "Venues",
                        isSelected: false
                    )
                    
                    TabBarButton(
                        icon: "ticket.fill",
                        text: "Passes",
                        isSelected: true
                    )
                    
                    TabBarButton(
                        icon: "person.circle.fill",
                        text: "Account",
                        isSelected: false
                    )
                }
                .padding(.bottom, 8)
                .background(Color(.systemBackground))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("My Passes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
            .alert("Pass Used", isPresented: $viewModel.showSuccessAlert) {
                Button("OK") { dismiss() }
            } message: {
                Text(pass.type == .drink ? 
                    "Your drink pass has been redeemed" :
                    "Your line skip pass has been validated")
            }
        }
    }
}

// MARK: - Supporting Views
private struct TabBarButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
            Text(text)
                .font(.caption2)
        }
        .foregroundColor(isSelected ? .blue : .gray)
    }
}

// MARK: - ViewModel
class PassPresentationViewModel: ObservableObject {
    @Published var showSuccessAlert = false
    
    func verifyPass(_ pass: Pass) async {
        do {
            // Call the API endpoint we updated earlier
            let result = try await PassService.shared.usePass(pass.id)
            
            if result.success {
                DispatchQueue.main.async {
                    self.showSuccessAlert = true
                }
            }
        } catch {
            print("Error verifying pass:", error)
        }
    }
}

#if DEBUG
struct PassPresentationView_Previews: PreviewProvider {
    static var previews: some View {
        PassPresentationView(pass: .mockDrinkPass)
        PassPresentationView(pass: .mockLineSkipPass)
    }
}
#endif 