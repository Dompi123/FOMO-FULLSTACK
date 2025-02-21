import SwiftUI
import OSLog

struct VenueListView: View {
    @StateObject private var viewModel = VenueListViewModel()
    @EnvironmentObject private var navigationCoordinator: PreviewNavigationCoordinator
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            } else if viewModel.filteredAndSortedVenues.isEmpty {
                ContentUnavailableView("No Venues",
                    systemImage: "building.2",
                    description: Text("There are no venues available at the moment.")
                )
            } else {
                List {
                    ForEach(viewModel.filteredAndSortedVenues) { venue in
                        NavigationLink(destination: VenueDetailView(venue: venue)) {
                            VenueRowView(venue: venue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Venues")
        .task {
            if viewModel.filteredAndSortedVenues.isEmpty {
                await viewModel.loadVenues()
            }
        }
        .refreshable {
            await viewModel.loadVenues()
        }
    }
}

#Preview {
    VenueListView()
}

// MARK: - Supporting Views
private struct VenueRowView: View {
    let venue: Venue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(venue.name)
                .font(.headline)
            
            Text(venue.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            HStack {
                Label("\(venue.currentCapacity)/\(venue.capacity)", systemImage: "person.2")
                    .foregroundColor(.secondary)
                Label("\(venue.waitTime) min", systemImage: "clock")
                    .foregroundColor(.secondary)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#if DEBUG
struct VenueListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VenueListView()
                .environmentObject(PreviewNavigationCoordinator.shared)
        }
    }
}
#endif
