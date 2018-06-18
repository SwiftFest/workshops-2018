# Copyright 2018 Google LLC.
# SPDX-License-Identifier: Apache-2.0
.PHONY: build test xcodeproj open-xcode
build:
	swift build -c debug

test:
	swift test

xcodeproj:
	swift package generate-xcodeproj --xcconfig-overrides Package.xcconfig

open-xcode: xcodeproj
	open ./SwiftSyntaxExample.xcodeproj
