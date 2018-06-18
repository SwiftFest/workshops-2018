// swift-tools-version:4.2
// Copyright 2018 Google, Inc.
// SPDX-License-Identifier: Apache-2.0


import PackageDescription

let package = Package(
  name: "SwiftSyntaxExample",
  dependencies: [],
  targets: [
    .target(
      name: "SwiftSyntaxExample",
      dependencies: []
    ),
    .target(
      name: "SwiftSyntaxExampleRunner",
      dependencies: ["SwiftSyntaxExample"]
    ),
    .testTarget(
      name: "SwiftSyntaxExampleTests",
      dependencies: ["SwiftSyntaxExample"]),
  ]
)
