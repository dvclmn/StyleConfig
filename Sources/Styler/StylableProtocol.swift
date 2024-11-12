//
//  StylableProtocol.swift
//  Styler
//
//  Created by Dave Coleman on 12/11/2024.
//

import Foundation


/// A protocol that defines an element that can be styled using a `StyleConfiguration`.
///
/// Types conforming to `Styler` can be modified using chainable
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
