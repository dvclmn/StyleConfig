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
    let properties = structDecl.memberBlock.members.compactMap {
      member -> (name: String, type: String, defaultValue: String?)? in
      guard let variable = member.decl.as(VariableDeclSyntax.self),
        let binding = variable.bindings.first,
        let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
        let type = binding.typeAnnotation?.type
      else {
        return nil
      }


      /// Check if the property has static/class modifier, as these should be skipped
      let modifiers = variable.modifiers
      let isStatic = modifiers.contains { modifier in
        modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
      }

      /// Skip static/class properties
      guard !isStatic else {
        return nil
      }

      /// Extract default value if present
      let defaultValue = binding.initializer?.value.description

      return (identifier.identifier.text, type.description, defaultValue)
    }

    /// Generate modifier functions for each property

    return properties.map { property in
      generateModifierFunction(
        name: property.name,
        type: property.type,
        defaultValue: property.defaultValue
      )
    }

    //    var declarations: [DeclSyntax] = []
    //    for property in properties {
    //
    //      /// Generate the function declaration with optional default value
    //      let functionDecl: DeclSyntax
    //      if let defaultValue = property.defaultValue {
    //        functionDecl = """
    //                    public func \(raw: property.name)(_ \(raw: property.name): \(raw: property.type) = \(raw: defaultValue)) -> Self {
    //                        var copy = self
    //                        copy.\(raw: property.name) = \(raw: property.name)
    //                        return copy
    //                    }
    //                    """
    //      } else {
    //        functionDecl = """
    //                    public func \(raw: property.name)(_ \(raw: property.name): \(raw: property.type)) -> Self {
    //                        var copy = self
    //                        copy.\(raw: property.name) = \(raw: property.name)
    //                        return copy
    //                    }
    //                    """
    //      }
    //      declarations.append(DeclSyntax(functionDecl))
    //
    //    } // END loop over properties
    //    return declarations
  }  // END expansion

  private static func generateModifierFunction(
    name: String,
    type: String,
    defaultValue: String? = nil
  ) -> DeclSyntax {
    let parameterDeclaration =
      defaultValue != nil
      ? "_ \(name): \(type) =\(defaultValue!)"
      : "_ \(name): \(type)"

    return """
      public func \(raw: name)(\(raw: parameterDeclaration)) -> Self {
          var copy = self
          copy.\(raw: name) = \(raw: name)
          return copy
      }
      """
  }
}

enum CustomError: Error {
  case notAStruct
}
