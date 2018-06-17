// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import SwiftSyntax
import XCTest

@testable import SwiftSyntaxExample

public class ColonWhitespaceTests: XCTestCase {
  public func testInvalidColonWhitespace() {

  }

  #if !os(macOS)
  static let allTests = [
    ColonWhitespaceTests.testInvalidColonWhitespace,
  ]
  #endif
}
