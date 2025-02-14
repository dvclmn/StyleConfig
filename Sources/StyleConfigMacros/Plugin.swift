//
//  Plugin.swift
//  StyleConfig
//
//  Created by Dave Coleman on 14/2/2025.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct StyleConfigPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StyleConfigMacro.self
  ]
}
