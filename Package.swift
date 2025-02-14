// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "StyleConfig",
  platforms: [
    .iOS("17.0"),
    .macOS("14.0"),
  ],
  products: [
    .library(
      name: "StyleConfig",
      targets: ["StyleConfig"]
    ),
    .executable(
      name: "StyleConfigClient",
      targets: ["StyleConfigClient"]
    ),
  ],
  
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
  ],

  targets: [
    .macro(
      name: "StyleConfigMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),
    .target(name: "StyleConfig", dependencies: ["StyleConfigMacros"]),
    .executableTarget(name: "StyleConfigClient", dependencies: ["StyleConfig"]),
    .testTarget(
      name: "StyleConfigTests",
      dependencies: [
        "StyleConfigMacros",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
