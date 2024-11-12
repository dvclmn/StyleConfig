//
//  StylableMacro.swift
//  Stylable
//
//  Created by Dave Coleman on 12/11/2024.
//


import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct StylableMacro: PeerMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw CustomError.notAStruct
    }
    
    let structName = structDecl.name.text
    
    // Get all the variable declarations
    let properties = structDecl.memberBlock.members.compactMap { member -> (name: String, type: String)? in
      guard let variable = member.decl.as(VariableDeclSyntax.self),
            let binding = variable.bindings.first,
            let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
            let type = binding.typeAnnotation?.type else {
        return nil
      }
      return (identifier.identifier.text, type.description)
    }
    
    // Generate the extension with the modifier functions
    var extensionDecl = """
        public extension Stylable where StyleConfiguration == \(structName) {
        
        """
    
    // Add modifier functions
    for property in properties {
      extensionDecl += """
                
                func \(property.name)(_ \(property.name): \(property.type)) -> Self {
                    modified { $0.\(property.name) = \(property.name) }
                }
            """
    }
    
    extensionDecl += "\n}"
    
    return [DeclSyntax(stringLiteral: extensionDecl)]
  }
}
enum CustomError: Error {
  case notAStruct
}


//public struct StylableMacro: MemberMacro {
//  public static func expansion(
//    of node: AttributeSyntax,
//    providingMembersOf declaration: some DeclGroupSyntax,
//    in context: some MacroExpansionContext
//  ) throws -> [DeclSyntax] {
//    
//    /// Ensure we're working with a struct
//    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
//      throw CustomError.notAStruct
//    }
//    
//    /// Get all the variable declarations
//    let properties = structDecl.memberBlock.members.compactMap { member -> (name: String, type: String)? in
//      guard let variable = member.decl.as(VariableDeclSyntax.self),
//            let binding = variable.bindings.first,
//            let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
//            let type = binding.typeAnnotation?.type else {
//        return nil
//      }
//      return (identifier.identifier.text, type.description)
//    }
//    
//    /// Generate modifier functions for each property
//    var declarations: [DeclSyntax] = []
//    
//    for property in properties {
//      /// Generate the function declaration
//      let functionDecl = """
//            public func \(property.name)(_ \(property.name): \(property.type)) -> Self {
//                modified { $0.\(property.name) = \(property.name) }
//            }
//            """
//      declarations.append(DeclSyntax(stringLiteral: functionDecl))
//    }
//    
//    return declarations
//  }
//}
//
