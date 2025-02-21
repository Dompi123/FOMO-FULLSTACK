import SwiftUI
import OSLog

struct VenueDetailView: View {
    let venue: Venue
    @State private var showPaywall = false
    @State private var showDrinkMenu = false
    @Environment(\.previewMode) private var previewMode
    @EnvironmentObject private var coordinator: PreviewNavigationCoordinator
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Venue Image
                AsyncImage(url: URL(string: venue.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 200)
                .clipped()
                
                VStack(alignment: .leading, spacing: 12) {
                    // Venue Info
                    Text(venue.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(venue.description)
                        .foregroundColor(.secondary)
                    
                    // Status and Rating
                    HStack {
                        Label(
                            venue.isOpen ? "Open" : "Closed",
                            systemImage: venue.isOpen ? "checkmark.circle.fill" : "xmark.circle.fill"
                        )
                        .foregroundColor(venue.isOpen ? .green : .red)
                        
                        Spacer()
                        
                        Label("\(venue.rating, specifier: "%.1f")", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    .padding(.vertical, 8)
                    
                    // Address
                    Label(venue.address, systemImage: "location.fill")
                        .foregroundColor(.secondary)
                    
                    // Wait Time
                    if venue.waitTime > 0 {
                        Label("\(venue.waitTime) min wait", systemImage: "clock")
                            .foregroundColor(.secondary)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            if previewMode {
                                coordinator.navigate(to: .paywall(venue: venue))
                            } else {
                                showPaywall = true
                            }
                        }) {
                            Text("Get Pass")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        Button(action: { showDrinkMenu = true }) {
                            Text("View Drink Menu")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) {
            PaywallView(venue: venue)
        }
        .sheet(isPresented: $showDrinkMenu) {
            DrinkMenuView()
        }
    }
}

#if DEBUG
struct VenueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VenueDetailView(venue: .preview)
        }
        .environmentObject(PreviewNavigationCoordinator.shared)
        .environment(\.previewMode, true)
        .environment(\.previewPaymentState, .ready)
    }
}
#endif 
