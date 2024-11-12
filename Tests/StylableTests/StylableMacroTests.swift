//
//  StylableMacroTests.swift
//  Stylable
//
//  Created by Dave Coleman on 12/11/2024.
//


import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import StylableMacros

final class StylableMacroTests: XCTestCase {
  let testMacros: [String: Macro.Type] = [
    "Stylable": StylableMacro.self,
  ]
  
  func testMacroGeneratesModifierFunctions() throws {
    assertMacroExpansion(
            """
            @Stylable
            struct TestConfig {
                var title: String = ""
                var count: Int = 0
            }
            """,
            expandedSource: """
            struct TestConfig {
                var title: String = ""
                var count: Int = 0
            
                public func title(_ title: String) -> Self {
                    modified { $0.title = title }
                }
                
                public func count(_ count: Int) -> Self {
                    modified { $0.count = count }
                }
            }
            """,
            macros: testMacros
    )
  }
  
  func testMacroOnEmptyStruct() throws {
    assertMacroExpansion(
            """
            @Stylable
            struct EmptyConfig {
            }
            """,
            expandedSource: """
            struct EmptyConfig {
            }
            """,
            macros: testMacros
    )
  }
  
  func testMacroWithComplexTypes() throws {
    assertMacroExpansion(
            """
            @Stylable
            struct ComplexConfig {
                var optional: String? = nil
                var array: [Int] = []
                var dictionary: [String: Bool] = [:]
            }
            """,
            expandedSource: """
            struct ComplexConfig {
                var optional: String? = nil
                var array: [Int] = []
                var dictionary: [String: Bool] = [:]
            
                public func optional(_ optional: String?) -> Self {
                    modified { $0.optional = optional }
                }
                
                public func array(_ array: [Int]) -> Self {
                    modified { $0.array = array }
                }
                
                public func dictionary(_ dictionary: [String: Bool]) -> Self {
                    modified { $0.dictionary = dictionary }
                }
            }
            """,
            macros: testMacros
    )
  }
}
