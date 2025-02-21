import SwiftUI
import OSLog

struct ContentView: View {
    @EnvironmentObject private var navigationCoordinator: PreviewNavigationCoordinator
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                VenueListView()
                    .tabItem {
                        Label("Venues", systemImage: "building.2")
                    }
                    .tag(0)
                
                PassesView()
                    .tabItem {
                        Label("Passes", systemImage: "ticket")
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(2)
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $navigationCoordinator.presentedSheet) { sheet in
                switch sheet {
                case .drinkMenu:
                    DrinkMenuView()
                case .checkout(let order):
                    CheckoutView(order: order)
                case .paywall(let venue):
                    PaywallView(venue: venue)
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PreviewNavigationCoordinator.shared)
    }
}
#endif
