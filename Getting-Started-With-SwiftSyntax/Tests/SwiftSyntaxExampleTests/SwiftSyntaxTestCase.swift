// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

// Note that swiftenv will create this but won't recreate it after an uninstall
let LATEST_TOOLCHAIN = "/Library/Developer/Toolchains/swift-latest.xctoolchain"
// Relative to the current user's home directory, can be absolute if desired
let REPOSITORY_PATH = "./workshops-2018/Getting-Started-With-SwiftSyntax"

/// This class works around some issues with SPM and XCode; specifically, XCode
/// doesn't leave enough information for tests to find the current toolchain
/// or the test resource directory (and SPM doesn't support resources yet.)
public class SwiftSyntaxTestCase: XCTestCase {
  func toolchainPath() -> String? {
    guard let path = ProcessInfo.processInfo.environment["TOOLCHAIN_DIR"] else {
      return LATEST_TOOLCHAIN
    }
    return path
  }

  override public func setUp() {
    super.setUp()
    guard FileManager.default.currentDirectoryPath == "/private/tmp" else {
      // If we're not in /private/tmp we're not being run in XCode.
      return
    }
    
    // Fix the toolchain path since it isn't passed to the test
    let oldPath = ProcessInfo().environment["PATH"]!
    let swiftcPath = "\(toolchainPath()!)/usr/bin"
    setenv("PATH", "\(swiftcPath):\(oldPath)", 1)
    
    // chdir out of /private/tmp to where the test resources are
    let homeURL = URL(fileURLWithPath: NSHomeDirectory())
    chdir(homeURL.path)
    chdir(REPOSITORY_PATH)
  }
}
