import StyleConfig
import BaseComponents
import SwiftUI

@MainActor
@StyleConfig
struct ExampleConfiguration: Sendable {
  
  /// Add properties to be applied to your configurable view, and set reasonable defaults
  var colour: Color = .secondary
  var rounding: Double = 8
  var showCount: Bool = false
  
  /// Establish a 'base' static property. This will be used as a launchpad to string
  /// together multiple dot-seperated declarations.
  static let style = ExampleConfiguration()
  
  static var examplePreset = .style.colour(.green).rounding(14)
}
