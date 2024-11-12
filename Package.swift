// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Styler",
    platforms: [.macOS(.v12), .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Styler",
            targets: ["Styler"]
        ),
        .executable(
            name: "StylerClient",
            targets: ["StylerClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "StylerMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "Styler", dependencies: [
          "StylerMacros",
        ]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "StylerClient", dependencies: ["Styler"]),

        // A test target used to develop the macro implementation.
//        .testTarget(
//            name: "StylerTests",
//            dependencies: [
//                "StylerMacros",
//                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
//            ]
//        ),
    ]
)
