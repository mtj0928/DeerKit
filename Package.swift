// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeerKit",
    products: [
        .library(name: "DeerKit", targets: ["DeerKit"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "DeerKit", dependencies: []),
        .testTarget(name: "DeerKitTests", dependencies: ["DeerKit"]),
    ]
)
