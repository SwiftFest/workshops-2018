// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftSyntax
import XCTest

@testable import SwiftSyntaxExample

public class ErrorOnForceUnwrapTests: SwiftSyntaxTestCase {
  private class DiagnosticTrackingConsumer: DiagnosticConsumer {
    var registeredDiagnostics = [String]()
    let diagnosticCount: Int

    public init(_ diagnosticCount: Int) {
      self.diagnosticCount = diagnosticCount
    }

    func handle(_ diagnostic: Diagnostic) {
      registeredDiagnostics.append(diagnostic.message.text)
    }

    func finalize() {
      XCTAssertEqual(registeredDiagnostics.count, diagnosticCount)
    }
  }

  public func testHasForceUnwrap() throws {
    let sourceURL = URL(fileURLWithPath: "./TestResources/HasForceUnwrap.swift")
    let source = try SourceFileSyntax.parse(sourceURL)
    
    let engine = DiagnosticEngine()
    let consumer = DiagnosticTrackingConsumer(1)
    engine.addConsumer(consumer)

    let diagnoseForceUnwraps = DiagnoseForceUnwraps(
      file: sourceURL,
      diagnosticEngine: engine
    )

    diagnoseForceUnwraps.visit(source)
  }

  public func testDoesNotHaveForceUnwrap() throws {
    let sourceURL = URL(fileURLWithPath: "./TestResources/DoesNotHaveForceUnwrap.swift")
    let source = try SourceFileSyntax.parse(sourceURL)
    
    let engine = DiagnosticEngine()
    let consumer = DiagnosticTrackingConsumer(0)
    engine.addConsumer(consumer)

    let diagnoseForceUnwraps = DiagnoseForceUnwraps(
      file: sourceURL,
      diagnosticEngine: engine
    )

    diagnoseForceUnwraps.visit(source)
  }

  #if !os(macOS)
  static let allTests = [
    ErrorOnForceUnwrapTests.testHasForceUnwrap,
    ErrorOnForceUnwrapTests.testDoesNotHaveForceUnwrap,
  ]
  #endif
}
