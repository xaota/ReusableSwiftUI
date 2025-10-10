// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reusable",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v26),
        .iOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UI",
            targets: ["UI"]
        ),
//        .library(
//            name: "MyPackage",
//            targets: ["MyPackage"]
//        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UI",
            // path: "Sources",
            dependencies: [],
            resources: [
                .process("Localizable.xcstrings")
            ]
        ),
//        .target(
//            name: "MyPackage",
//            dependencies: []
//        )
    ]
)
