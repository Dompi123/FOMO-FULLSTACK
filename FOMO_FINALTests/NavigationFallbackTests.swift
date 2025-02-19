import XCTest
@testable import FOMO_FINAL
import SwiftUI

final class NavigationFallbackTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testiOS14Availability() {
        if #available(iOS 14, *) {
            XCTAssertNotNil(FallbackNavigationStack.self)
            XCTAssertNotNil(FallbackNavigationLink<EmptyView>.self)
            XCTAssertNotNil(FallbackNavigationView<EmptyView>.self)
        }
    }
    
    func testUIKitBridge() {
        #if compiler(<5.5)
        if #available(iOS 14, *) {
            XCTAssertTrue(FallbackNavigationStack.self is UIViewControllerRepresentable.Type)
            
            let stack = FallbackNavigationStack()
            XCTAssertNotNil(stack.makeUIViewController(context: .init()))
            
            let navController = stack.makeUIViewController(context: .init())
            XCTAssertTrue(navController.viewControllers.first is UIHostingController<ContentView>)
        }
        #endif
    }
    
    func testNavigationLinkBinding() {
        if #available(iOS 14, *) {
            let isActive = Binding<Bool>(get: { false }, set: { _ in })
            let link = FallbackNavigationLink(
                destination: EmptyView(),
                isActive: isActive
            ) {
                AnyView(Text("Test"))
            }
            
            XCTAssertNotNil(link.body)
            XCTAssertFalse(isActive.wrappedValue)
        }
    }
    
    func testNavigationViewContent() {
        if #available(iOS 14, *) {
            let view = FallbackNavigationView {
                Text("Test Content")
            }
            
            XCTAssertNotNil(view.body)
            XCTAssertNotNil(view.content)
        }
    }
} 