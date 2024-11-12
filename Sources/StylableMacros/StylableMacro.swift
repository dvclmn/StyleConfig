import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct StylableMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    
    /// Ensure we're working with a struct
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw CustomError.notAStruct
    }
    
    /// Get all the variable declarations
    let properties = structDecl.memberBlock.members.compactMap { member -> (name: String, type: String)? in
      guard let variable = member.decl.as(VariableDeclSyntax.self),
            let binding = variable.bindings.first,
            let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
            let type = binding.typeAnnotation?.type else {
        return nil
      }
      return (identifier.identifier.text, type.description)
    }
    
    /// Generate modifier functions for each property
    var declarations: [DeclSyntax] = []
    
    for property in properties {
      /// Generate the function declaration
      let functionDecl = """
            public func \(property.name)(_ \(property.name): \(property.type)) -> Self {
                modified { $0.\(property.name) = \(property.name) }
            }
            """
      declarations.append(DeclSyntax(stringLiteral: functionDecl))
    }
    
    return declarations
  }
}

enum CustomError: Error {
  case notAStruct
}
