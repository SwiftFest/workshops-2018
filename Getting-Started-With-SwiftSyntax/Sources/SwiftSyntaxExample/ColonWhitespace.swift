// Copyright 2018 Google LLC.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftSyntax

/// Syntax Rewriting
///
/// SwiftSyntax provides a class called `SyntaxRewriter`, which will walk a Syntax tree and
/// perform transformations over the nodes.
///
/// By default, these transformations don't do anything. It's the subclass's job to
/// choose which nodes it wants to transform, perform the transformations, and return
/// the result.
///
/// Provided below is a `SyntaxRewriter` that ensures all colons in a file have exactly 0 spaces
/// before them and 1 space after.

public final class ColonWhitespace: SyntaxRewriter {
  public override func visit(_ token: TokenSyntax) -> Syntax {
    guard let next = token.nextToken else { return token }

    /// Colons own their trailing spaces, so ensure it only has 1 if there's
    /// another token on the same line.
    if token.tokenKind == .colon {
      return token.withTrailingTrivia(token.trailingTrivia.withOneTrailingSpace())
    }

    /// Otherwise, colon-adjacent tokens should have 0 spaces after.
    if next.tokenKind == .colon {
      return token.withTrailingTrivia(token.trailingTrivia.withoutSpaces())
    }
    return token
  }
}

extension Syntax {
  /// Performs a depth-first in-order traversal of the node to find the first
  /// node in its hierarchy that is a Token.
  var firstToken: TokenSyntax? {
    if let tok = self as? TokenSyntax { return tok }
    for child in children {
      if let tok = child.firstToken { return tok }
    }
    return nil
  }

  /// Recursively walks through the tree to find the next token semantically
  /// after this node.
  var nextToken: TokenSyntax? {
    var current: Syntax? = self

    // Walk up the parent chain, checking adjacent siblings after each node
    // until we find a node with a 'first token'.
    while let node = current {
      // If we've walked to the top, just stop.
      guard let parent = node.parent else { break }

      // If we're not the last child, search through each sibling until
      // we find a token.
      if node.indexInParent < parent.numberOfChildren {
        for idx in (node.indexInParent + 1)..<parent.numberOfChildren {
          let nextChild = parent.child(at: idx)

          // If there's a token, we're good.
          if let child = nextChild?.firstToken { return child }
        }
      }

      // If we've exhausted siblings, move up to the parent.
      current = parent
    }
    return nil
  }
}

extension Trivia {
  func withoutSpaces() -> Trivia {
    return Trivia(pieces: filter {
      if case .spaces = $0 { return false }
      if case .tabs = $0 { return false }
      return true
    })
  }
  /// Returns this set of trivia, with all spaces removed except for one at the
  /// end.
  func withOneTrailingSpace() -> Trivia {
    return withoutSpaces() + .spaces(1)
  }
}
