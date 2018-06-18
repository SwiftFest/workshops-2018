// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

/// This class works around some issues with SPM and XCode; Test resource
/// support is not yet part of SPM.
public class SwiftSyntaxTestCase: XCTestCase {
  override public func setUp() {
    super.setUp()
    guard FileManager.default.currentDirectoryPath == "/private/tmp" else {
      // If we're not in /private/tmp we're not being run in XCode.
      return
    }

    let testFilePath = URL(fileURLWithPath: #file)
    let packageRoot = testFilePath.deletingLastPathComponent()
      .deletingLastPathComponent().deletingLastPathComponent()
    // This gives us the same behavior in XCode and SPM
    chdir(packageRoot.path)
  }
}
