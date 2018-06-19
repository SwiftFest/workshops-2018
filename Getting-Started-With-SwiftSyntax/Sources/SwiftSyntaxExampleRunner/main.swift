// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftSyntax
import SwiftSyntaxExample

func main() throws {
  // Ensure we are given a valid file path.
  guard let filePath = CommandLine.arguments.dropFirst().first else {
    print("usage: \(CommandLine.arguments.first!) [file]")
    return
  }

  // Create a new diagnostic engine.
  let engine = DiagnosticEngine()

  // Create a diagnostic consumer that prints diagnostics to stderr.
  engine.addConsumer(PrintingDiagnosticConsumer())

  // Parse the current source file.
  let testURL = URL(fileURLWithPath: filePath)
  let testFile = try SourceFileSyntax.parse(testURL)

  // Create a DiagnoseForceUnwraps visitor.
  let diagnoseForceUnwraps = DiagnoseForceUnwraps(
    file: testURL,
    diagnosticEngine: engine
  )

  // Diagnose all force unwraps in the file.
  diagnoseForceUnwraps.visit(testFile)

  // Create a colon whitespace fixer.
  let whitespaceFixer = ColonWhitespace()

  // Ask the whitespace fixer to rewrite the current file.
  let rewritten = whitespaceFixer.visit(testFile)

  // Print the rewritten file contents to stdout without adding a newline.
  print(rewritten, terminator:"")
}

do {
  try main()
} catch {
  FileHandle.standardError.write("\(error)".data(using: .utf8)!)
  exit(-1)
}
