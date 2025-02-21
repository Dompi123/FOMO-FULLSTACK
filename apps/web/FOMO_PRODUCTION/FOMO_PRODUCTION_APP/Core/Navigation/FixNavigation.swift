#if compiler(<5.5)
import SwiftUI
import UIKit

@available(iOS 14, *)
struct FallbackNavigationStack: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: UIHostingController(rootView: ContentView()))
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

@available(iOS 14, *)
struct FallbackNavigationLink<Destination: View>: View {
    let destination: Destination
    let isActive: Binding<Bool>
    let label: () -> AnyView
    
    init(destination: Destination, isActive: Binding<Bool>, @ViewBuilder label: @escaping () -> AnyView) {
        self.destination = destination
        self.isActive = isActive
        self.label = label
    }
    
    var body: some View {
        Button(action: {
            isActive.wrappedValue = true
        }) {
            label()
        }
    }
}

@available(iOS 14, *)
struct FallbackNavigationView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
        }
    }
}
#endif 