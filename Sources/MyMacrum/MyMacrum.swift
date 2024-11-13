// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(
  module: "MyMacrumMacros",
  type: "StringifyMacro"
)

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
  /// Important: `module` corresponds to `targets: [.macro(name: "MyMacrumMacros"...)]`
  /// **Note the plural**
  module: "MyMacrumMacros",
  
  /// `type` corresponds to the name of the Macros struct, e.g.
  /// `public struct StringifyMacro: ExpressionMacro`
  type: "StyleConfigMacro"
)
