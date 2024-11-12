//
//  StylableConformance.swift
//  Stylable
//
//  Created by Dave Coleman on 12/11/2024.
//

//import SwiftCompilerPlugin
//import SwiftSyntax
//import SwiftSyntaxMacros
//import SwiftSyntaxBuilder


//public struct StyleConformanceMacro: MemberMacro {
//  public static func expansion(
//    of node: AttributeSyntax,
//    providingMembersOf declaration: some DeclGroupSyntax,
//    in context: some MacroExpansionContext
//  ) throws -> [DeclSyntax] {
//    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
//      throw CustomError.notAStruct
//    }
//    
//    let conformance = """
//        typealias StyleConfiguration = Self
//        
//        var config: StyleConfiguration {
//            get { self }
//            set { self = newValue }
//        }
//        """
//    
//    return [DeclSyntax(stringLiteral: conformance)]
//  }
//}
