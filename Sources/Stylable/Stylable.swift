// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
//@freestanding(expression)
//public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "StylableMacros", type: "StringifyMacro")

@attached(extension)
public macro Stylable() = #externalMacro(module: "StylableMacros", type: "StylableMacro")




/// A protocol that defines an element that can be styled using a `StyleConfiguration`.
///
/// Types conforming to `Stylable` can be modified using chainable
/// dot-syntax style modifications.
///
/// ## Example
/// ```swift
/// let style = CustomLabel.custom
///     .emphasis(.strong)
///     .size(.large)
///     .iconOnly
/// ```
///

public protocol Stylable {
  associatedtype StyleConfiguration
  var config: StyleConfiguration { get set }
  func modified(_ transform: (inout StyleConfiguration) -> Void) -> Self
}

public extension Stylable {
  
  /// Creates a new instance with modified configuration.
  ///
  /// This method is the foundation for the chainable modification pattern.
  ///
  /// - Parameter transform: A closure that modifies the configuration
  /// - Returns: A new instance with the modified configuration
  ///
  func modified(_ transform: (inout StyleConfiguration) -> Void) -> Self {
    var new = self
    transform(&new.config)
    return new
  }
  
  /// Pass in a whole specific config, from somewhere else, no changes
  //  func with(_ newConfig: StyleConfiguration) -> Self {
  //    modified { $0 = newConfig }
  //  }
  
  func with(_ newConfig: StyleConfiguration) -> Self {
    modified { $0 = newConfig }
  }
}
