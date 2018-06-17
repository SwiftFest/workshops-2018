// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import SwiftSyntax
import XCTest

@testable import SwiftSyntaxExample

public class ColonWhitespaceTests: XCTestCase {
  public func testInvalidColonWhitespace() throws {
    let sourceURL = URL(fileURLWithPath: "./TestResources/InvalidColonWhitespace.swift")
    let source = try SourceFileSyntax.parse(sourceURL)
    let expectedURL = URL(fileURLWithPath: "./TestResources/InvalidColonWhitespace.expected.swift")
    let expected = try SourceFileSyntax.parse(expectedURL)
  }

  #if !os(macOS)
  static let allTests = [
    ColonWhitespaceTests.testInvalidColonWhitespace,
  ]
  #endif
}
