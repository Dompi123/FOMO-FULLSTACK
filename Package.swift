// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FOMO-API-Contracts",
    platforms: [
        .macOS(.v13),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "FOMOAPIContracts",
            targets: ["FOMOAPIContracts"]
        )
    ],
    targets: [
        .target(
            name: "FOMOAPIContracts",
            path: "Sources/FOMOAPIContracts"
        ),
        .executableTarget(
            name: "ContractGenerator",
            path: "Sources/ContractGenerator"
        )
    ]
) 