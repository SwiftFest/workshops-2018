# SwiftSyntax Workshop

This package includes some example code to help get acquainted with the
SwiftSyntax API.

## For Attendees on 2018-06-19

Very recent snapshots are a bit harder to set up so please use the 2018-06-03
toolchain snapshot:

https://swift.org/builds/development/xcode/swift-DEVELOPMENT-SNAPSHOT-2018-06-03-a/swift-DEVELOPMENT-SNAPSHOT-2018-06-03-a-osx.pkg

## Structure

This project includes two examples:

- A Syntax Rewriter that fixes whitespace around colons.
- A Syntax Visitor that emits a diagnostic for all force unwraps in a project.

## Building

Before building the project, make sure you download and install the latest
`Trunk Development (master)` toolchain from
[swift.org](https://swift.org/download/).

Make sure this toolchain is selected in Xcode before building the project.

This project is built with the Swift Package Manager. We recommend generating
an Xcode project for this package, because it's easier to manage toolchains
in Xcode.

To do this, `cd` to the directory where you cloned the project, and run the
following command.

```swift
swift package generate-xcodeproj
```

This will generate an Xcode project that you can use to play with this example.

## Authors

Harlan Haskins ([@harlanhaskins](https://github.com/harlanhaskins))
Alexander Lash ([@abl](https://github.com/abl))
