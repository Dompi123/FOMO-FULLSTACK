import SwiftUI
import OSLog

struct PassesView: View {
    @StateObject private var viewModel = PassesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
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
                    List {
                        Section("Active Passes") {
                            ForEach(viewModel.activePasses) { pass in
                                PassRowView(pass: pass)
                            }
                        }
                        
                        if !viewModel.expiredPasses.isEmpty {
                            Section("Expired Passes") {
                                ForEach(viewModel.expiredPasses) { pass in
                                    PassRowView(pass: pass)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Passes")
            .task {
                await viewModel.loadPasses()
            }
        }
    }
}

struct PassRowView: View {
    let pass: Pass
    
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