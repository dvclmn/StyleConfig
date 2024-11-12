// swift-tools-version: 5.10

import CompilerPluginSupport
import Foundation
import PackageDescription

let package = Package(
  name: "Stylable",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "Stylable",
      targets: ["Stylable"]
    ),
    .executable(
      name: "StylableClient",
      targets: ["StylableClient"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax", from: "510.0.3"),
  ],
  targets: [
    .macro(
      name: "StylableMacros",
      dependencies: [
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      ]
    ),
    .target(
      name: "Stylable",
      dependencies: ["StylableMacros"]
    ),
    .executableTarget(name: "StylableClient", dependencies: ["Stylable"]),
    
    .testTarget(
      name: "StylableTests",
      dependencies: [
        "StylableMacros",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
