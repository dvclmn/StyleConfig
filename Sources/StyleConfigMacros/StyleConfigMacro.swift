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

struct MacroProperties {
  let name: String
  let type: String
  let defaultValue: String?
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
      member -> MacroProperties? in
      
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
      
      /// Skip properties marked with `@Preset`
      let hasPresetWrapper = modifiers.contains { modifier in
        modifier.kind == .attribute &&
        modifier.trimmedDescription.contains("@Preset")
      }
      guard !hasPresetWrapper else {
        return nil
      }

      /// Extract default value if present
      let defaultValue = binding.initializer?.value.description

      return MacroProperties(
        name: identifier.identifier.text,
        type: type.description,
        defaultValue: defaultValue
      )
    }

    /// Generate modifier functions for each property
    return properties.map { property in
      
      let properties = MacroProperties(
        name: property.name,
        type: property.type,
        defaultValue: property.defaultValue
      )
      return generateModifierFunction(properties)
    }

  }  // END expansion

  private static func generateModifierFunction(_ properties: MacroProperties) -> DeclSyntax {

    let parameterDeclaration =
    properties.defaultValue != nil
    ? "_ \(properties.name): \(properties.type) =\(properties.defaultValue!)"
    : "_ \(properties.name): \(properties.type)"

    return """
      public func \(raw: properties.name)(\(raw: parameterDeclaration)) -> Self {
          var copy = self
          copy.\(raw: properties.name) = \(raw: properties.name)
          return copy
      }
      """
  }
}

enum CustomError: Error {
  case notAStruct
}
