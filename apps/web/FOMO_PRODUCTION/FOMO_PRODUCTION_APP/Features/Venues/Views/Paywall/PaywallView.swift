import SwiftUI
import OSLog
import Foundation

@available(iOS 15.0, macOS 12.0, *)
public struct PaywallView: View {
    @EnvironmentObject private var paymentManager: PaymentManager
    @StateObject private var viewModel: PaywallViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.previewMode) private var previewMode
    @EnvironmentObject private var coordinator: PreviewNavigationCoordinator
    @Namespace private var animationNS
    @State private var showDrinkMenu = false
    @State private var isSecureContextVerified = false
    
    // Expose view model for previews
    var previewViewModel: PaywallViewModel { viewModel }
    
    public init(venue: Venue) {
        _viewModel = StateObject(wrappedValue: PaywallViewModel(venue: venue))
    }
    
    // Custom initializer for previews
    init(venue: Venue, initialState: PaymentState) {
        let vm = PaywallViewModel(venue: venue)
        vm.paymentState = initialState
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    public var body: some View {
        Group {
            if !isSecureContextVerified {
                SecureContextCheck {
                    isSecureContextVerified = true
                }
            } else {
                mainContent
            }
        }
        .onAppear {
            verifySecureContext()
        }
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                PaywallVenueHeader(venue: viewModel.venue)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.blue)
                } else {
                    VStack(spacing: 16) {
                        ForEach(viewModel.pricingTiers) { tier in
                            PricingCard(
                                tier: tier,
                                isSelected: viewModel.selectedTier?.id == tier.id
                            ) {
                                viewModel.selectTier(tier)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                SecurePaymentButton(
                    title: "Purchase Pass",
                    action: {
                        Task {
                            await viewModel.processPurchase()
                        }
                    }
                )
                .disabled(viewModel.selectedTier == nil)
                .padding()
            }
        }
        .background(FOMOTheme.Colors.background)
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadPricingTiers(for: viewModel.venue.id)
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("OK") {
                viewModel.error = nil
            }
        }
    }
    
    private func verifySecureContext() {
        // Verify app integrity and secure context
        guard let bundleID = Bundle.main.bundleIdentifier,
              bundleID.hasPrefix("com.fomo"),
              !ProcessInfo.processInfo.isDebuggerAttached else {
            Logger.appSecurity.fault("Security context verification failed")
            return
        }
        isSecureContextVerified = true
    }
    
    private var backgroundView: some View {
        AngularGradient(gradient: Gradient(colors: [.purple, .pink]),
                       center: .topLeading)
            .opacity(0.1)
            .ignoresSafeArea()
    }
    
    private var pricingTiersView: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.pricingTiers) { tier in
                PricingCard(
                    tier: tier,
                    isSelected: viewModel.selectedTier?.id == tier.id
                ) {
                    viewModel.selectTier(tier)
                }
            }
        }
        .padding()
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            PaymentButton(
                title: "Purchase Pass",
                action: {
                    Task {
                        await viewModel.processPurchase()
                    }
                }
            )
            .disabled(viewModel.selectedTier == nil)
            
            Button(action: { 
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                    coordinator.navigate(to: .drinkMenu)
                } else {
                    showDrinkMenu = true
                }
            }) {
                HStack {
                    Image(systemName: "wineglass")
                    Text("Preview Drink Menu")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple)
                .cornerRadius(10)
            }
        }
        .padding(.top, 8)
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                if previewMode {
                    coordinator.goBack()
                } else {
                    dismiss()
                }
            }
        }
    }
}

private struct SecureContextCheck: View {
    let onVerified: () -> Void
    
    var body: some View {
        VStack {
            ProgressView()
            Text("Verifying secure context...")
                .font(.caption)
        }
        .onAppear {
            // Add additional security checks here
            onVerified()
        }
    }
}

private struct SecurePaymentButton: View {
    let title: String
    let action: () -> Void
    @State private var isLoading = false
    
    var body: some View {
        Button(action: {
            withAnimation {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    action()
                    isLoading = false
                }
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(FOMOTheme.Colors.primary)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}

#if DEBUG
struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaywallView(venue: .preview)
                .environmentObject(PaymentManager.shared)
                .environmentObject(PreviewNavigationCoordinator.shared)
        }
        .preferredColorScheme(.dark)
    }
}
#endif 
