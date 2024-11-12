//
//  Plugin.swift.swift
//  Styler
//
//  Created by Dave Coleman on 12/11/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


@main
public struct StylerPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StylerMacro.self
  ]
}
