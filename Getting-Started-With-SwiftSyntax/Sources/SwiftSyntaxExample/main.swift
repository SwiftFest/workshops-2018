// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftSyntax

func main() throws {
  // Ensure we are given a valid file path.
  guard let filePath = CommandLine.arguments.dropFirst().first else {
    fatalError("usage: SwiftSyntaxExample [file]")
  }

  // Create a new diagnostic engine.
  let engine = DiagnosticEngine()

  // Create a diagnostic consumer that prints diagnostics as they are emitted.
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

  // Print the rewritten file contents.
  print("Rewritten file:\n\(rewritten)")
}

do {
  try main()
} catch {
  print("error: \(error)")
  exit(-1)
}
