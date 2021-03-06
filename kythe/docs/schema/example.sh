#!/bin/bash -e

# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script verifies and formats a single Kythe example, which is expected
# to be piped in on standard input.
#
# Usage: example.sh asciidoc-backend asciidoc-style-name language test-label
#   where asciidoc-backend is the asciidoc target (currently ignored;
#                          we emit only HTML)
#      asciidoc-style-name is the asciidoc style used to invoke the filter
#                 language is the language passed to the filter
#                          (supported are C++ and Java)
#               test-label is the (potentially space-containing) short text
#                          label describing the test.

export SCHEMA_ROOT="$PWD/kythe/docs/schema"
CAMPFIRE_OUT="$PWD/campfire-out"
cd "$CAMPFIRE_OUT/doc/kythe/docs/schema"

export VERIFIER_BIN="$CAMPFIRE_OUT/bin/kythe/cxx/verifier/verifier"
export KINDEX_TOOL_BIN="$CAMPFIRE_OUT/bin/kythe/cxx/tools/kindex_tool"
export CXX_INDEXER_BIN="$CAMPFIRE_OUT/bin/kythe/cxx/indexer/cxx/indexer"
export JAVA_INDEXER_BIN="$CAMPFIRE_OUT/bin/kythe/java/com/google/devtools/kythe/analyzers/java/indexer"

export LANGUAGE="$3"
export LABEL="$4"

error() {
  echo "[ FAILED $1: $LABEL ]" >&2
  exit 1
}
export -f error

export TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT ERR INT

case "$LANGUAGE" in
  Java)
    "$SCHEMA_ROOT/example-java.sh" ;;
  C++)
    "$SCHEMA_ROOT/example-cxx.sh" ;;
  *)
    echo "ERROR: unsupported language specified for example: $LANGUAGE"
    exit 1 ;;
esac
