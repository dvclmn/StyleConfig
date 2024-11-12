//
//  Model.swift
//  Stylable
//
//  Created by Dave Coleman on 12/11/2024.
//

@MainActor
public protocol Stylable {
  associatedtype StyleConfiguration
  var config: StyleConfiguration { get set }
  func modified(_ transform: (inout StyleConfiguration) -> Void) -> Self
}

public extension Stylable {
  func modified(_ transform: (inout StyleConfiguration) -> Void) -> Self {
    var new = self
    transform(&new.config)
    return new
  }
  
  func config(_ newConfig: StyleConfiguration) -> Self {
    modified { $0 = newConfig }
  }
}
