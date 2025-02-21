import SwiftUI

@MainActor
struct NavigationCompatibleView<Content: View>: View {
    @StateObject private var coordinator: PreviewNavigationCoordinator
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self._coordinator = StateObject(wrappedValue: PreviewNavigationCoordinator.shared)
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationBarItems(leading: backButton)
                .sheet(item: $coordinator.presentedSheet) { sheet in
                    switch sheet {
                    case .drinkMenu:
                        Text("Drink Menu")
                    case .checkout(let order):
                        Text("Checkout for order \(order.id)")
                    case .paywall(let venue):
                        Text("Paywall for venue \(venue.id)")
                    }
                }
        }
    }
    
    @ViewBuilder
    private var backButton: some View {
        if !coordinator.path.isEmpty {
            Button(action: {
                coordinator.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            }
        }
    }
}

#if DEBUG
struct NavigationCompatibleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationCompatibleView {
            Text("Test Content")
        }
    }
}
#endif 