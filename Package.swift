// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// Release: Swift помечает всё public `[no dead strip]`, и в бинарник приложения шло всё API пакета, даже то, что
/// оно не зовёт. Флаг снимает отметку — неиспользуемое public вычищает линковщик. Он верит, что все клиенты — в той же
/// линковке: так и есть — приложения линкуют пакет статически и только в цель приложения, тесты — в Debug
let internalize = SwiftSetting.unsafeFlags(["-Xfrontend", "-internalize-at-link"], .when(configuration: .release))

let package = Package(
  name: "Reusable",
  defaultLocalization: "en",

  platforms: [
    .macOS(.v26),
    .iOS(.v26)
  ],

  products: [
    .library(
      name: "JSON",
      targets: ["JSON"]
    ),
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
    .library(
      name: "LLM",
      targets: ["LLM"]
    ),
    .library(
      name: "Weather",
      targets: ["Weather"]
    ),
  ],

  // Declare external package dependencies here
  dependencies: [
    // .package(url: "https://github.com/exyte/SVGView.git", from: "1.0.0")
    .package(url: "https://github.com/swhitty/SwiftDraw.git", from: "0.29.0"),
  ],

  targets: [
    .target(
      name: "JSON",
      dependencies: [],
      swiftSettings: [internalize]
    ),
    .target(
      name: "Channel",
      dependencies: [],
      swiftSettings: [internalize]
    ),
    .target(
      name: "Intl",
      dependencies: [
        "JSON"
      ],
      resources: [
        .process("currency.json"),
        .process("Localizable.xcstrings")
      ],
      swiftSettings: [internalize]
    ),
    .target(
      name: "UI",
      dependencies: [],
      resources: [
        .process("Localizable.xcstrings")
      ],
      swiftSettings: [internalize]
    ),
    .target(
      name: "Fields",
      dependencies: ["Intl", "UI"],
      resources: [
        .process("Localizable.xcstrings")
      ],
      swiftSettings: [internalize]
    ),
    .target(
      name: "Bank",
      dependencies: [
        // .product(name: "SVGView", package: "SVGView"),
        .product(name: "SwiftDraw", package: "SwiftDraw"),
        "UI",
        "JSON"
      ],
      resources: [
        .copy("svg"),
        .process("bank.json")
      ],
      swiftSettings: [internalize]
    ),
    .target(
      name: "LLM",
      dependencies: [],
      resources: [
        // .process("Localizable.xcstrings")
      ],
      swiftSettings: [internalize]
    ),
    .target(
      name: "Weather",
      dependencies: [],
      resources: [
        // .process("Localizable.xcstrings")
      ],
      swiftSettings: [internalize]
    ),
    .testTarget(
      name: "ReusableTests",
      dependencies: [
        "JSON",
        "Channel",
        "Intl",
        "UI",
        "Bank",
        "LLM",
        "Weather"
      ],
      resources: [
        .process("fixture-people.json"),
        .process("fixture-missing-key.json"),
        .process("fixture-type-mismatch.json")
      ]
    ),
  ],

  swiftLanguageModes: [.v6]
)
