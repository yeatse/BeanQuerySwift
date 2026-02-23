#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GRAMMAR_DIR="$ROOT_DIR/Sources/BeanQuerySwift/Grammar"
OUT_DIR="$ROOT_DIR/Sources/BeanQuerySwift/Generated"
ANTLR_VERSION="4.13.2"
ANTLR_JAR="$ROOT_DIR/.build/tools/antlr-${ANTLR_VERSION}-complete.jar"

mkdir -p "$OUT_DIR" "$(dirname "$ANTLR_JAR")"

if [[ ! -f "$ANTLR_JAR" ]]; then
  curl -fsSL "https://www.antlr.org/download/antlr-${ANTLR_VERSION}-complete.jar" -o "$ANTLR_JAR"
fi

java -jar "$ANTLR_JAR" \
  -Dlanguage=Swift \
  -DaccessLevel=internal \
  -visitor \
  -no-listener \
  -message-format gnu \
  -o "$OUT_DIR" \
  "$GRAMMAR_DIR/BQLLexer.g4" \
  "$GRAMMAR_DIR/BQLParser.g4"

# Swift 6 strict concurrency workaround for ANTLR generated classes.
sed -i '' 's/^import Antlr4/@preconcurrency import Antlr4/' "$OUT_DIR/BQLLexer.swift"
sed -i '' 's/^import Antlr4/@preconcurrency import Antlr4/' "$OUT_DIR/BQLParser.swift"
sed -i '' 's/internal static var _decisionToDFA:/internal static let _decisionToDFA:/g' "$OUT_DIR/BQLLexer.swift"
sed -i '' 's/internal static var _decisionToDFA:/internal static let _decisionToDFA:/g' "$OUT_DIR/BQLParser.swift"

# Keep target tree clean from non-Swift generated artifacts.
rm -f "$OUT_DIR"/*.interp "$OUT_DIR"/*.tokens
