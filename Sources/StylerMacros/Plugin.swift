import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


@main
public struct StylerPlugin: CompilerPlugin {
  public let providingMacros: [Macro.Type] = [
    StylerMacro.self
  ]
  
  public init() {}
}
