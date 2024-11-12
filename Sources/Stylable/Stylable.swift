// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
//@freestanding(expression)
//public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "BaseMacros", type: "StringifyMacro")

//@attached(member)
//public macro Stylable() = #externalMacro(module: "StylableMacros", type: "StylableMacro")

@attached(peer)
public macro Stylable() = #externalMacro(module: "StylableMacros", type: "StylableMacro")

@attached(member)
public macro StyleConformance() = #externalMacro(module: "StylableMacros", type: "StyleConformanceMacro")
