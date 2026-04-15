#!/usr/bin/env bash
# Test suite for docx2md
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIXTURES="${SCRIPT_DIR}/fixtures"
DOCX2MD="${SCRIPT_DIR}/../docx2md"

PASS=0
FAIL=0

pass() { ((PASS++)) || true; echo "  ✓ $1"; }
fail() { ((FAIL++)) || true; echo "  ✗ $1"; }

cleanup() {
    rm -f "${FIXTURES}"/*.md
    rm -rf "${FIXTURES}/images"
}
trap cleanup EXIT

# ── Setup: create a minimal docx using pandoc ─────────────────────────────────
setup() {
    if ! command -v pandoc &>/dev/null; then
        echo "Skipping tests: pandoc not installed"
        exit 0
    fi

    # Create a simple docx from markdown
    mkdir -p "$FIXTURES"
    echo "# Test Document\n\nThis is a **test** paragraph.\n\n- Item 1\n- Item 2\n- Item 3\n\n## Section Two\n\nAnother paragraph with *italic* text." \
        | pandoc -f markdown -t docx -o "${FIXTURES}/sample.docx"

    echo "# Second Doc\n\nContent of the second document." \
        | pandoc -f markdown -t docx -o "${FIXTURES}/second.docx"
}

echo ""
echo "Running docx2md tests"
echo "─────────────────────"

setup

# ── Test 1: Basic conversion ──────────────────────────────────────────────────
TEST="Basic conversion"
if "$DOCX2MD" "${FIXTURES}/sample.docx" 2>/dev/null && [[ -f "${FIXTURES}/sample.md" ]]; then
    pass "$TEST"
else
    fail "$TEST"
fi

# ── Test 2: Custom output name ────────────────────────────────────────────────
TEST="Custom output name"
"$DOCX2MD" "${FIXTURES}/sample.docx" "${FIXTURES}/custom.md" 2>/dev/null
if [[ -f "${FIXTURES}/custom.md" ]]; then
    pass "$TEST"
else
    fail "$TEST"
fi

# ── Test 3: Stdout mode ──────────────────────────────────────────────────────
TEST="Stdout mode"
OUTPUT=$("$DOCX2MD" -s "${FIXTURES}/sample.docx" 2>/dev/null)
if [[ "$OUTPUT" == *"Test Document"* ]]; then
    pass "$TEST"
else
    fail "$TEST"
fi

# ── Test 4: Quiet mode ───────────────────────────────────────────────────────
TEST="Quiet mode"
OUTPUT=$("$DOCX2MD" -q "${FIXTURES}/sample.docx" 2>/dev/null)
if [[ -z "$OUTPUT" ]] && [[ -f "${FIXTURES}/sample.md" ]]; then
    pass "$TEST"
else
    fail "$TEST"
fi

# ── Test 5: Batch mode ───────────────────────────────────────────────────────
TEST="Batch mode"
"$DOCX2MD" -q "${FIXTURES}/sample.docx" "${FIXTURES}/second.docx" 2>/dev/null
if [[ -f "${FIXTURES}/sample.md" ]] && [[ -f "${FIXTURES}/second.md" ]]; then
    pass "$TEST"
else
    fail "$TEST"
fi

# ── Test 6: Version flag ─────────────────────────────────────────────────────
TEST="Version flag"
OUTPUT=$("$DOCX2MD" --version)
if [[ "$OUTPUT" == *"docx2md"* ]]; then
    pass "$TEST"
else
    fail "$TEST"
fi

# ── Test 7: Help flag ────────────────────────────────────────────────────────
TEST="Help flag"
OUTPUT=$("$DOCX2MD" --help)
if [[ "$OUTPUT" == *"USAGE"* ]]; then
    pass "$TEST"
else
    fail "$TEST"
fi

# ── Test 8: Missing file ─────────────────────────────────────────────────────
TEST="Missing file (should fail gracefully)"
if "$DOCX2MD" "${FIXTURES}/nonexistent.docx" 2>/dev/null; then
    fail "$TEST"
else
    pass "$TEST"
fi

# ── Test 9: Wrap option ──────────────────────────────────────────────────────
TEST="Wrap option"
if "$DOCX2MD" -w auto "${FIXTURES}/sample.docx" 2>/dev/null && [[ -f "${FIXTURES}/sample.md" ]]; then
    pass "$TEST"
else
    fail "$TEST"
fi

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"
echo ""

[[ $FAIL -eq 0 ]] && exit 0 || exit 1
