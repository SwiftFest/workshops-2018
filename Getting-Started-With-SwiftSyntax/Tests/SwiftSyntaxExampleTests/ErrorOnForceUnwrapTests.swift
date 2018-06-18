// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftSyntax
import XCTest

@testable import SwiftSyntaxExample

public class ErrorOnForceUnwrapTests: SwiftSyntaxTestCase {
  public func testHasForceUnwrap() throws {
    let sourceURL = URL(fileURLWithPath: "./TestResources/HasForceUnwrap.swift")
    let source = try SourceFileSyntax.parse(sourceURL)
    
    let engine = DiagnosticEngine()

    let diagnoseForceUnwraps = DiagnoseForceUnwraps(
      file: sourceURL,
      diagnosticEngine: engine
    )

    diagnoseForceUnwraps.visit(source)
    XCTAssertEqual(engine.diagnostics.count, 1)
  }

  public func testDoesNotHaveForceUnwrap() throws {
    let sourceURL = URL(fileURLWithPath: "./TestResources/DoesNotHaveForceUnwrap.swift")
    let source = try SourceFileSyntax.parse(sourceURL)
    
    let engine = DiagnosticEngine()

    let diagnoseForceUnwraps = DiagnoseForceUnwraps(
      file: sourceURL,
      diagnosticEngine: engine
    )

    diagnoseForceUnwraps.visit(source)
    XCTAssert(engine.diagnostics.isEmpty)
  }

  #if !os(macOS)
  static let allTests = [
    ErrorOnForceUnwrapTests.testHasForceUnwrap,
    ErrorOnForceUnwrapTests.testDoesNotHaveForceUnwrap,
  ]
  #endif
}
