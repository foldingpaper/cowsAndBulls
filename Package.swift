// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "CowsAndBulls",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "CowsAndBullsCore",
            targets: ["CowsAndBullsCore"]
        ),
        .executable(
            name: "cows-and-bulls",
            targets: ["CowsAndBullsCLI"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CowsAndBullsCore",
            dependencies: []
        ),
        .executableTarget(
            name: "CowsAndBullsCLI",
            dependencies: ["CowsAndBullsCore"]
        ),
        .testTarget(
            name: "CowsAndBullsCoreTests",
            dependencies: ["CowsAndBullsCore"]
        )
    ]
)
