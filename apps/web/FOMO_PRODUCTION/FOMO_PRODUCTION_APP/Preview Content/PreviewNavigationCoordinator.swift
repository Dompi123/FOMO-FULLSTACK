import SwiftUI

@MainActor
public final class PreviewNavigationCoordinator: ObservableObject {
    public static let shared = PreviewNavigationCoordinator()
    
    @Published public private(set) var path = NavigationPath()
    @Published public private(set) var presentedSheet: Sheet?
    
    private init() {}
    
    public func push<V: View>(_ view: V) {
        path.append(view)
    }
    
    public func goBack() {
        path.removeLast()
    }
    
    public func presentSheet(_ sheet: Sheet) {
        presentedSheet = sheet
    }
    
    public func dismissSheet() {
        presentedSheet = nil
    }
}

public extension PreviewNavigationCoordinator {
    enum Sheet: Identifiable {
        case paywall(PricingTier)
        case checkout(DrinkOrder)
        
        public var id: String {
            switch self {
            case .paywall:
                return "paywall"
            case .checkout:
                return "checkout"
            }
        }
    }
    
    static var preview: PreviewNavigationCoordinator {
        let coordinator = PreviewNavigationCoordinator()
        return coordinator
    }
} 