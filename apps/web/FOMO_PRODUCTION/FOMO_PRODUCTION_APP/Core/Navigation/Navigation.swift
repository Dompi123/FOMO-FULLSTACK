import SwiftUI

// Re-export all navigation types
@_exported import struct SwiftUI.NavigationPath
public typealias FOMOSheet = Sheet
public typealias FOMODestination = Destination
public typealias FOMONavigationCoordinator = NavigationCoordinator 

// MARK: - Navigation Types
public enum Sheet: Identifiable {
    case drinkMenu
    case checkout(order: DrinkOrder)
    case paywall(venue: Venue)
    
    public var id: String {
        switch self {
        case .drinkMenu: return "drinkMenu"
        case .checkout: return "checkout"
        case .paywall: return "paywall"
        }
    }
}

public enum Destination: Hashable {
    case drinkMenu
    case checkout(order: DrinkOrder)
    case paywall(venue: Venue)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .drinkMenu:
            hasher.combine("drinkMenu")
        case .checkout(let order):
            hasher.combine("checkout")
            hasher.combine(order.id)
        case .paywall(let venue):
            hasher.combine("paywall")
            hasher.combine(venue.id)
        }
    }
    
    public static func == (lhs: Destination, rhs: Destination) -> Bool {
        switch (lhs, rhs) {
        case (.drinkMenu, .drinkMenu):
            return true
        case (.checkout(let order1), .checkout(let order2)):
            return order1.id == order2.id
        case (.paywall(let venue1), .paywall(let venue2)):
            return venue1.id == venue2.id
        default:
            return false
        }
    }
}

// MARK: - Navigation Coordinator
@MainActor
public final class PreviewNavigationCoordinator: ObservableObject {
    public static let shared = PreviewNavigationCoordinator()
    
    @Published public var path = NavigationPath()
    @Published public var presentedSheet: Sheet?
    
    private init() {}
    
    public func navigate(to destination: Destination) {
        switch destination {
        case .drinkMenu:
            presentedSheet = .drinkMenu
        case .checkout(let order):
            presentedSheet = .checkout(order: order)
        case .paywall(let venue):
            presentedSheet = .paywall(venue: venue)
        }
    }
    
    public func goBack() {
        if !path.isEmpty {
            path.removeLast()
        } else {
            presentedSheet = nil
        }
    }
    
    public func dismissSheet() {
        presentedSheet = nil
    }
}

#if DEBUG
public extension PreviewNavigationCoordinator {
    static var preview: PreviewNavigationCoordinator {
        shared
    }
} 
#endif

// MARK: - Navigation View
@MainActor
public struct NavigationCompatibleView<Content: View>: View {
    @StateObject private var coordinator: PreviewNavigationCoordinator
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self._coordinator = StateObject(wrappedValue: PreviewNavigationCoordinator.shared)
        self.content = content()
    }
    
    public var body: some View {
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