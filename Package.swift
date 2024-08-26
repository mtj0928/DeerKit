// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "DeerKit",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v7)],
    products: [
        .library(name: "DeerUserDefaults", targets: ["DeerUserDefaults"]),
        .library(name: "DeerFoundation", targets: ["DeerFoundation"]),
    ],
    targets: [
        .target(name: "DeerFoundation", dependencies: []),
        .target(name: "DeerUserDefaults", dependencies: []),
        .testTarget(name: "DeerUserDefaultsTests", dependencies: ["DeerUserDefaults"]),
    ]
)
