// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "PythonCodable",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "PythonCodable",
            targets: ["PythonCodable"]
        )
    ],
    dependencies: [
        .package(url: "git@github.com:pvieito/FoundationKit.git", .branch("master")),
        .package(url: "git@github.com:pvieito/PythonKit.git", .branch("master")),
        .package(url: "https://github.com/tattn/MoreCodable.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "PythonCodable",
            dependencies: ["PythonKit", "MoreCodable"],
            path: "PythonCodable"
        ),
        .testTarget(
            name: "PythonCodableTests",
            dependencies: ["PythonCodable", "PythonKit", "FoundationKit"]
        )
    ]
)
