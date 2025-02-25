import SwiftUI
import OSLog

struct PassesView: View {
    @StateObject private var viewModel = PassesViewModel()
    @State private var selectedPass: Pass?
    @State private var showingPassPresentation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let error = viewModel.error {
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                    } else if viewModel.passes.isEmpty {
                        ContentUnavailableView("No Passes", 
                            systemImage: "ticket",
                            description: Text("You don't have any passes yet. Visit a venue to purchase one!")
                        )
                    } else {
                        // Active Passes Section
                        if !viewModel.activePasses.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Active Passes")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(viewModel.activePasses) { pass in
                                    PassCardView(pass: pass, isFullScreen: false)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            selectedPass = pass
                                            showingPassPresentation = true
                                        }
                                }
                            }
                        }
                        
                        // Expired Passes Section
                        if !viewModel.expiredPasses.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Expired Passes")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(viewModel.expiredPasses) { pass in
                                    PassCardView(pass: pass, isFullScreen: false)
                                        .padding(.horizontal)
                                        .opacity(0.6)
                                }
                            }
                            .padding(.top, 24)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("My Passes")
            .task {
                await viewModel.loadPasses()
            }
            .fullScreenCover(isPresented: $showingPassPresentation, content: {
                if let pass = selectedPass {
                    PassPresentationView(pass: pass)
                }
            })
        }
    }
}

struct PassCardView: View {
    let pass: Pass
    let isFullScreen: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(pass.type.rawValue.capitalized)
                    .font(.headline)
                Spacer()
                StatusBadge(status: pass.status)
            }
            
            Text("Purchased: \(pass.purchaseDate.formatted(date: .abbreviated, time: .shortened))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("Expires: \(pass.expirationDate.formatted(date: .abbreviated, time: .shortened))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let status: PassStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(background)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
    
    private var background: Color {
        switch status {
        case .active:
            return .green
        case .expired:
            return .red
        case .used:
            return .gray
        }
    }
}

#if DEBUG
struct PassesView_Previews: PreviewProvider {
    static var previews: some View {
        PassesView()
    }
}
#endif 