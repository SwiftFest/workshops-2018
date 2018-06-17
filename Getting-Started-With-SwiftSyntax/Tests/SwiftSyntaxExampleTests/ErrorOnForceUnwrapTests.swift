// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import SwiftSyntax
import XCTest

@testable import SwiftSyntaxExample

public class ErrorOnForceUnwrapTests: XCTestCase {
  public func testHasForceUnwrap() {

  }

  #if !os(macOS)
  static let allTests = [
    ErrorOnForceUnwrapTests.testHasForceUnwrap,
  ]
  #endif
}
