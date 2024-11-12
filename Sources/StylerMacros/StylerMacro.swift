import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct StylerMacro: ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
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
    
    // Create function declarations
    let functionDecls: [DeclSyntax] = properties.map { property in
            """
            func \(raw: property.name)(_ \(raw: property.name): \(raw: property.type)) -> Self {
                modified { $0.\(raw: property.name) = \(raw: property.name) }
            }
            """
    }
    
    // Create the extension
    let extensionDecl = try ExtensionDeclSyntax(
            """
            extension Stylable where StyleConfiguration == \(raw: structName) {
                \(raw: functionDecls.map { "\($0)" }.joined(separator: "\n\n"))
            }
            """
    )
    
    return [extensionDecl]
  }
}


enum CustomError: Error {
  case notAStruct
}





//import SwiftSyntax
//import SwiftSyntaxBuilder
//import SwiftSyntaxMacros

//public struct StylableMacro: ExtensionMacro {
//  public static func expansion(
//    of node: AttributeSyntax,
//    attachedTo declaration: some DeclGroupSyntax,
//    providingExtensionsOf type: some TypeSyntaxProtocol,
//    conformingTo protocols: [TypeSyntax],
//    in context: some MacroExpansionContext
//  ) throws -> [ExtensionDeclSyntax] {
//    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
//      throw CustomError.notAStruct
//    }
//    
//    let structName = structDecl.name.text
//    
//    let whereClause = GenericWhereClauseSyntax {
//      GenericRequirementSyntax(
//        requirement: .sameType(
//          SameTypeRequirementSyntax(
//            leftType: TypeSyntax("StyleConfiguration"),
//            rightType: TypeSyntax(stringLiteral: structName)
//          )
//        )
//      )
//    }
//    
//    let memberBlock = MemberBlockSyntax {
//      for member in structDecl.memberBlock.members {
//        guard let variable = member.decl.as(VariableDeclSyntax.self),
//              let binding = variable.bindings.first,
//              let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
//              let type = binding.typeAnnotation?.type else {
//          continue
//        }
//        
//        DeclSyntax(
//                    """
//                    public func \(raw: identifier.identifier.text)(_ \(raw: identifier.identifier.text): \(type)) -> Self {
//                        modified { $0.\(raw: identifier.identifier.text) = \(raw: identifier.identifier.text) }
//                    }
//                    """
//        )
//      }
//    }
//    
//    let extension = ExtensionDeclSyntax(
//      extendedType: TypeSyntax("Stylable"),
//      genericWhereClause: whereClause,
//      memberBlock: memberBlock
//    )
//    
//    return [extension]
//  }
//}





//public struct StylableMacroReference: PeerMacro {
//  public static func expansion(
//    of node: AttributeSyntax,
//    providingPeersOf declaration: some DeclSyntaxProtocol,
//    in context: some MacroExpansionContext
//  ) throws -> [DeclSyntax] {
//    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
//      throw CustomError.notAStruct
//    }
//
//    let structName = structDecl.name.text
//
//    // Get all the variable declarations
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
//    // Generate the extension with the modifier functions
//    var extensionDecl = """
//        public extension Stylable where StyleConfiguration == \(raw: structName) {
//
//        """
//
//    // Add modifier functions
//    for property in properties {
//      extensionDecl += """
//
//                func \(raw: property.name)(_ \(raw: property.name): \(raw: property.type)) -> Self {
//                    modified { $0.\(raw: property.name) = \(raw: property.name) }
//                }
//            """
//    }
//
//    extensionDecl += "\n}"
//
//    return [DeclSyntax(stringLiteral: extensionDecl)]
//  }
//}
