import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


@main
struct StylablePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StylableMacro.self
  ]
}

public struct StylableMacro: ExtensionMacro {
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
    
    var extensionPartial: DeclSyntax = "public extension Stylable where StyleConfiguration == \(raw: structName)"

    // Add modifier functions
    for property in properties {
      extensionPartial += """
                
                func \(raw: property.name)(_ \(raw: property.name): \(raw: property.type)) -> Self {
                    modified { $0.\(raw: property.name) = \(raw: property.name) }
                }
            """
    }
    
    extensionPartial += "\n}"
    
    guard let extensionDecl = extensionPartial.as(ExtensionDeclSyntax.self) else {
      return []
    }
    
    return [extensionDecl]
    
  }
  
  //  public static func expansion(
  //    of node: AttributeSyntax,
  //    providingPeersOf declaration: some DeclSyntaxProtocol,
  //    in context: some MacroExpansionContext
  //  ) throws -> [DeclSyntax] {
  //
  //  }
}
enum CustomError: Error {
  case notAStruct
}



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
