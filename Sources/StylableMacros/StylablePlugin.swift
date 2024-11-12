//
//  StylablePlugin.swift
//  Stylable
//
//  Created by Dave Coleman on 12/11/2024.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct StylablePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StylableMacro.self
  ]
}
