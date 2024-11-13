// The Swift Programming Language
// https://docs.swift.org/swift-book

///
/// ```
/// MacroName/
/// ├── Sources/
/// │   ├── MacroName/
/// │   │   └── MacroName.swift         // Contains @attached(member): Macro declaration
/// │   ├── MacroNameMacros/            // {Name}Macros (plural)
/// │   │   ├── MacroNameMacro.swift    // {Name}Macro (singular): Macro implementation
/// │   │   └── MacroNamePlugin.swift   // Compiler plugin (can also be in `MacroNameMacro.swift`)
/// │   └── MacroNameClient/
/// │       └── main.swift              // Internal use, for testing macro
///
/// ```
///
@attached(member, names: arbitrary)
public macro StyleConfig() = #externalMacro(
  /// Important: `module` corresponds to `targets: [.macro(name: "StyleConfigMacros"...)]`
  /// **Note the plural**
  module: "StyleConfigMacros",
  
  /// `type` corresponds to the name of the Macros struct, e.g.
  /// `public struct StringifyMacro: ExpressionMacro`
  type: "StyleConfigMacro"
)
