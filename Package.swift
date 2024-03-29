// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeerKit",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v7)],
    products: [
        .library(name: "DeerUserDefaults", targets: ["DeerUserDefaults"]),
        .library(name: "DeerFoundation", targets: ["DeerFoundation"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "DeerFoundation", dependencies: []),
        .target(name: "DeerUserDefaults", dependencies: []),
        .testTarget(name: "DeerUserDefaultsTests", dependencies: ["DeerUserDefaults"]),
    ]
)
