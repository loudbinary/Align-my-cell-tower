// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlignMyCellTower",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AlignMyCellTower",
            targets: ["AlignMyCellTower"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        .target(
            name: "AlignMyCellTower",
            dependencies: []),
        .testTarget(
            name: "AlignMyCellTowerTests",
            dependencies: ["AlignMyCellTower"]),
    ]
)