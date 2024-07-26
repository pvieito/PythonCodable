// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "PythonCodable",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "PythonCodable",
            targets: ["PythonCodable"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pvieito/FoundationKit.git", branch: "master"),
        .package(url: "https://github.com/pvieito/PythonKit.git", branch: "master"),
        .package(url: "https://github.com/tattn/MoreCodable.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "PythonCodable",
            dependencies: ["PythonKit", "MoreCodable"],
            path: "PythonCodable"
        ),
        .testTarget(
            name: "PythonCodableTests",
            dependencies: ["PythonCodable", "PythonKit", "FoundationKit"],
            resources: [.process("Resources")]
        )
    ]
)
