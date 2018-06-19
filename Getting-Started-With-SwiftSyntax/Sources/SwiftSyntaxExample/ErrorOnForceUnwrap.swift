// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftSyntax

/// SwiftSyntax also provides a `DiagnosticEngine` that can be used to create
/// custom diagnostics from your Swift tool. These diagnostics will include
/// a location in the original file and can be errors, warnings, or notes.
///
/// These diagnostics can also choose to highlight or point to locations or
/// ranges in a source file as well. Eventually, these diagnostics could be
/// surfaced in an editor.
///
/// Provided below is a `SyntaxVisitor` that will emit an error diagnostic
/// on a provided diagnostic engine whenever a force unwrap is seen in a
/// source file.

/// Diagnoses all instances of force unwraps that appear in a file with an
/// error.
public class DiagnoseForceUnwraps: SyntaxVisitor {
  /// The diagnostic engine into which this visitor will emit diagnostics.
  public let engine: DiagnosticEngine

  /// The file this visitor is diagnosing.
  public let file: URL

  /// Creates a new DiagnoseForceUnwrap visitor that will emit diagnostics
  /// into the provided diagnostic engine.
  ///
  /// - Parameters
  ///   - file: The file in which the force unwraps appear.
  ///   - diagnosticEngine: The engine in which to emit diagnostics.
  public init(file: URL, diagnosticEngine: DiagnosticEngine) {
    self.file = file
    self.engine = diagnosticEngine
  }

  /// Visits all `ForcedValueExpr` nodes, which are the structure that
  /// represents the `!` operator.
  override public func visit(_ node: ForcedValueExprSyntax) {
    // Find the location of the exclamation mark in the provided source file.
    let location = node.exclamationMark.startLocation(in: file)

    // Add a diagnostic to the diagnostic engine pointing to the exclamation
    // mark.
    engine.diagnose(.noForceUnwrap, location: location) {
      // Add a highlight for the expression being force unwrapped.
      let expressionRange = node.expression.sourceRange(in: self.file)
      $0.highlight(expressionRange)
    }

    // Make sure to explicitly visit the force-unwrapped expression, because
    // otherwise we might miss nested unwraps.
    super.visit(node.expression)
  }
}

// MARK: - Custom Diagnostic Messages

/// New diagnostics are added as top-level members to the `Diagnostic.Message`
/// type. This is similar to the structure in `Notification.Name`, and ensures
/// that diagnostics are always namespaced.
/// `Diagnostic.Message` has two components: the diagnostic severity, which
/// can be error, warning, or note, and the diagnostic text, which is a string.
extension Diagnostic.Message {
  /// A diagnostic error that explains that force unwraps are banned.
  public static let noForceUnwrap =
    Diagnostic.Message(.error, "force unwrapping is not allowed")
}
