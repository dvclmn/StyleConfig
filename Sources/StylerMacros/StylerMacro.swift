import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Was previously trying to create an extension on `Stylable`,
/// with the macro attached to a `ExampleConfiguration`,
/// which is an *unrelated* type, and doesn't work.
///
/// Now going to try defining the extension on the *View*, or type
/// that actually conforms to `Stylable`. This may mean I can
/// also conform the View (or LabelStyle etc) to `Stylable`,
/// as a further convenience.
///

public struct StylerMacro: ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
//    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
//      throw CustomError.notAStruct
//    }

//    // Create the inheritance clause from the protocols
//    let inheritanceClause = InheritanceClauseSyntax(
//      inheritedTypes: protocols.map {
//        InheritedTypeSyntax(type: $0)
//      }
//    )
//    
//    // Create the extension
//    let extensionDecl = ExtensionDeclSyntax(
//      extendedType: type,
//      inheritanceClause: inheritanceClause,
//      memberBlock: MemberBlockSyntax {
//        DeclSyntax(
//                    """
//                    var exampleString: String { "Yay" }
//                    """
//        )
//      }
//    )
    
    // Join the protocol names with commas
//    let protocolList = protocols.map { $0.trimmed.description }.joined(separator: ", ")
    
    // Create the extension
    let extensionDecl = try ExtensionDeclSyntax(
            """
            extension \(type.trimmed) {
                var exampleString: String { "Yay" }
            }
            """
    )
    
    return [extensionDecl]
  }
}


enum CustomError: Error {
  case notAStruct
}
