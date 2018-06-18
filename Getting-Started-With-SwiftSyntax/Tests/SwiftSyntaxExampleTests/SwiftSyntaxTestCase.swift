// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

/// SPM uses paths relative to the package root; XCode launches tests in
/// /private/tmp. This function ensures we have the same behavior in both.
/// (This can be replaced once SPM supports test resources.)
internal func testResource(_ filename: String) -> URL {
  let testFilePath = URL(fileURLWithPath: #file)
  let packageRoot = testFilePath.deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
  let resourcesDir = packageRoot.appendingPathComponent("TestResources")
  return resourcesDir.appendingPathComponent(filename)
}
