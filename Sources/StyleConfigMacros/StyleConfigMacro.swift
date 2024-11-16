//
//  StylerMacro.swift
//  StyleConfig
//
//  Created by Dave Coleman on 13/11/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - Plugin
@main
struct StyleConfigPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StyleConfigMacro.self
  ]
}

public struct StyleConfigMacro: MemberMacro {
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
      
      // Check if the property has static/class modifier
      let modifiers = variable.modifiers
      let isStatic = modifiers.contains { modifier in
        modifier.name.tokenKind == .keyword(.static) ||
        modifier.name.tokenKind == .keyword(.class)
      }
      
      // Skip static/class properties
      guard !isStatic else {
        return nil
      }
      
      return (identifier.identifier.text, type.description)
    }

    /// Generate modifier functions for each property
    var declarations: [DeclSyntax] = []
    
    for property in properties {
      /// Generate the function declaration
      let functionDecl: DeclSyntax = """
            public func \(raw: property.name)(_ \(raw: property.name): \(raw: property.type)) -> Self {
                var copy = self
                copy.\(raw: property.name) = \(raw: property.name)
                return copy
            }
            """
      declarations.append(DeclSyntax(functionDecl))
    }
    
    return declarations
  }
}

enum CustomError: Error {
  case notAStruct
}
