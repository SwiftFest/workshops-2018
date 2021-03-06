// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import SwiftSyntax
import XCTest

@testable import SwiftSyntaxExample

public class ColonWhitespaceTests: XCTestCase {
  public func testFixesInvalidColonWhitespace() throws {
    let sourceURL = testResource("InvalidColonWhitespace.swift")
    let source = try SourceFileSyntax.parse(sourceURL)
    let expectedURL = testResource("InvalidColonWhitespace.expected.swift")
    let expected = try SourceFileSyntax.parse(expectedURL)

    let whitespaceFixer = ColonWhitespace()
    let rewritten = whitespaceFixer.visit(source)

    XCTAssertEqual(rewritten.description, expected.description)
  }

  public func testIgnoresValidColonWhitespace() throws {
    let sourceURL = testResource("InvalidColonWhitespace.expected.swift")
    let source = try SourceFileSyntax.parse(sourceURL)
    let originalDescription = source.description

    let whitespaceFixer = ColonWhitespace()
    let rewritten = whitespaceFixer.visit(source)

    XCTAssertEqual(rewritten.description, originalDescription)
  }

  #if !os(macOS)
  static let allTests = [
    ColonWhitespaceTests.testFixesInvalidColonWhitespace,
    ColonWhitespaceTests.testIgnoresValidColonWhitespace,
  ]
  #endif
}
