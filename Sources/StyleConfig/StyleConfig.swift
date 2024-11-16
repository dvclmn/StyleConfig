// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: arbitrary)
public macro StyleConfig() = #externalMacro(
  /// Important: `module` corresponds to `targets: [.macro(name: "StyleConfigMacros"...)]`
  /// **Note the plural**
  module: "StyleConfigMacros",
  
  /// `type` corresponds to the name of the Macros struct, e.g.
  /// `public struct StringifyMacro: ExpressionMacro`
  type: "StyleConfigMacro"
)
