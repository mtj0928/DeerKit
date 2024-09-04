// swift-tools-version:5.10
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("StrictConcurrency")
]

let package = Package(
    name: "DeerKit",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v7), .visionOS(.v1), .tvOS(.v13)],
    products: [
        .library(name: "DeerKit", targets: [
            "DeerFoundation",
            "DeerSwift",
            "DeerSwiftUI",
            "DeerUserDefaults"
        ]),

        .library(name: "DeerFoundation", targets: ["DeerFoundation"]),
        .library(name: "DeerSwift", targets: ["DeerSwift"]),
        .library(name: "DeerSwiftUI", targets: ["DeerSwiftUI"]),
        .library(name: "DeerUserDefaults", targets: ["DeerUserDefaults"]),
    ],
    targets: [
        .target(name: "DeerFoundation", swiftSettings: swiftSettings),
        .target(name: "DeerSwift", swiftSettings: swiftSettings),
        .target(name: "DeerSwiftUI", swiftSettings: swiftSettings),
        .target(name: "DeerUserDefaults", swiftSettings: swiftSettings),

        // Test
        .testTarget(name: "DeerSwiftTests", dependencies: ["DeerSwift"]),
        .testTarget(name: "DeerUserDefaultsTests", dependencies: ["DeerUserDefaults"]),
    ]
)
