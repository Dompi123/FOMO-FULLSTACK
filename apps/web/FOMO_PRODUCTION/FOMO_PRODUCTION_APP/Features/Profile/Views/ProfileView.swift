import SwiftUI
import OSLog

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                } else {
                    Form {
                        if let profile = viewModel.profile {
                            Section("Personal Information") {
                                Text("Name: \(profile.firstName) \(profile.lastName)")
                                Text("Email: \(profile.email)")
                                Text("Username: \(profile.username)")
                            }
                            
                            Section("Membership") {
                                Text("Level: \(profile.membershipLevel.rawValue.capitalized)")
                            }
                            
                            Section("Preferences") {
                                Toggle("Notifications", isOn: .constant(profile.preferences.notificationsEnabled))
                                Toggle("Email Updates", isOn: .constant(profile.preferences.emailUpdatesEnabled))
                                
                                if !profile.preferences.preferredVenueTypes.isEmpty {
                                    Text("Preferred Venues: \(profile.preferences.preferredVenueTypes.joined(separator: ", "))")
                                }
                                
                                if !profile.preferences.dietaryRestrictions.isEmpty {
                                    Text("Dietary Restrictions: \(profile.preferences.dietaryRestrictions.joined(separator: ", "))")
                                }
                            }
                            
                            Section("Payment Methods") {
                                ForEach(profile.paymentMethods, id: \.id) { method in
                                    HStack {
                                        Text(method.type)
                                        Spacer()
                                        Text("••••\(method.lastFourDigits)")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .task {
                await viewModel.loadProfile()
            }
        }
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(PreviewNavigationCoordinator.shared)
            .environment(\.previewMode, true)
            .environment(\.previewPaymentState, .ready)
    }
}
#endif