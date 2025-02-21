// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "scripts",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-format.git", from: "509.0.0")
    ],
    targets: [
        .target(
            name: "scripts",
            dependencies: [
                .product(name: "SwiftFormat", package: "swift-format")
            ]
        )
    ]
)
