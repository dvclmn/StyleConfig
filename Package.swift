// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "StyleConfig",
    platforms: [.macOS(.v14), .iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
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
        .package(url: "https://github.com/dvclmn/Stylable.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "StyleConfigMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "StyleConfig", dependencies: ["StyleConfigMacros", "Stylable"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "StyleConfigClient", dependencies: ["StyleConfig"]),

        // A test target used to develop the macro implementation.
//        .testTarget(
//            name: "StyleConfigTests",
//            dependencies: [
//                "StyleConfigMacros",
//                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
//            ]
//        ),
    ]
)
