#if os(Linux)
import SwiftSyntaxExampleTests
import XCTest

XCTMain([
  ColonWhitespaceTests.allTests,
  ErrorOnForceUnwrapTests.allTests,
].joined())
#endif