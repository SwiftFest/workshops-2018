// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftSyntax
import XCTest

@testable import SwiftSyntaxExample

public class ErrorOnForceUnwrapTests: XCTestCase {
  private class DiagnosticTrackingConsumer: DiagnosticConsumer {
    var registeredDiagnostics = [String]()
    func handle(_ diagnostic: Diagnostic) {
      registeredDiagnostics.append(diagnostic.message.text)
    }
    func finalize() {}
  }

  public func testHasForceUnwrap() throws {
    let sourceURL = URL(fileURLWithPath: "./TestResources/HasForceUnwrap.swift")
    let source = try SourceFileSyntax.parse(sourceURL)
    
    let engine = DiagnosticEngine()
    let consumer = DiagnosticTrackingConsumer()
    engine.addConsumer(DiagnosticTrackingConsumer())

    let diagnoseForceUnwraps = DiagnoseForceUnwraps(
      file: sourceURL,
      diagnosticEngine: engine
    )

    diagnoseForceUnwraps.visit(source)
    XCTAssertEqual(consumer.registeredDiagnostics.count, 1)
  }

  #if !os(macOS)
  static let allTests = [
    ErrorOnForceUnwrapTests.testHasForceUnwrap,
  ]
  #endif
}
