//
//  Errors.swift
//  Stylable
//
//  Created by Dave Coleman on 12/11/2024.
//


import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import StylableMacros

extension StylableMacroTests {
  
  func testMacroOnClass() throws {
    assertMacroExpansion(
        """
        @Stylable
        class InvalidConfig {
            var property: String = ""
        }
        """,
        expandedSource: """
        class InvalidConfig {
            var property: String = ""
        }
        """,
        diagnostics: [
          DiagnosticSpec(
            message: "@Stylable can only be applied to structs",
            line: 1,
            column: 1
          )
        ],
        macros: testMacros
    )
  }
  
}
