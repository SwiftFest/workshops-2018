# Copyright 2018 Google LLC.
# SPDX-License-Identifier: Apache-2.0

# The swift package generator doesn't allow for overriding test build settings.
# This script overrides exactly one build setting after generation.

import subprocess

KEY = "LD_RUNPATH_SEARCH_PATHS"
VALUE = " ".join([
  "$(inherited)",
  "$(TOOLCHAIN_DIR)/usr/lib/swift/macosx",
  "@executable_path",
])

subprocess.check_call(["swift", "package", "generate-xcodeproj"])

with open("SwiftSyntaxExample.xcodeproj/project.pbxproj", "r+") as pbx:
  lines = pbx.readlines()
  pbx.seek(0)
  skip_until_semicolon = False
  for line in lines:
    if skip_until_semicolon:
      if ";" in line:
        skip_until_semicolon = False
      continue
    if KEY not in line:
      pbx.write(line)
      continue
    (prefix, suffix) = line.split(KEY, 1)
    if ";" not in suffix:
      skip_until_semicolon = True
    pbx.write("%s%s = \"%s\";\n" % (prefix, KEY, VALUE))
  pbx.truncate()