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
    .library(
      name: "Channel",
      targets: ["Channel"]
    ),
    .library(
      name: "Intl",
      targets: ["Intl"]
    ),
    .library(
      name: "UI",
      targets: ["UI"]
    ),
    .library(
      name: "Fields",
      targets: ["Fields"]
    ),
    .library(
      name: "Bank",
      targets: ["Bank"]
    ),
  ],

  // Declare external package dependencies here
  dependencies: [
    // .package(url: "https://github.com/exyte/SVGView.git", from: "1.0.0")
    .package(url: "https://github.com/swhitty/SwiftDraw.git", from: "0.25.1"),
  ],

  targets: [
    .target(
      name: "Channel",
      dependencies: []
    ),
    .target(
      name: "Intl",
      dependencies: [],
      resources: [
        .process("currency.json"),
        .process("Localizable.xcstrings")
      ]
    ),
    .target(
      name: "UI",
      dependencies: [],
      resources: [
        .process("Localizable.xcstrings")
      ]
    ),
    .target(
      name: "Fields",
      dependencies: ["Intl", "UI"],
      resources: [
        .process("Localizable.xcstrings")
      ]
    ),
    .target(
      name: "Bank",
      dependencies: [
        // .product(name: "SVGView", package: "SVGView"),
        .product(name: "SwiftDraw", package: "SwiftDraw"),
        "UI"
      ],
      resources: [
        .copy("svg"),
        .process("bank.json")
      ]
    ),
  ],

  swiftLanguageModes: [.v6]
)
