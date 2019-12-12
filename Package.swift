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
        .package(url: "https://github.com/pvieito/PythonKit.git", .branch("master")),
        .package(url: "https://github.com/pvieito/MoreCodable.git", .branch("patch-1"))
    ],
    targets: [
        .target(
            name: "PythonCodable",
            dependencies: ["PythonKit", "MoreCodable"],
            path: "PythonCodable"
        ),
        .testTarget(
            name: "PythonCodableTests",
            dependencies: ["PythonCodable", "PythonKit"]
        )
    ]
)
