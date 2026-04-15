#!/usr/bin/env bash
# docx2md installer — cross-platform one-liner
# Usage: curl -fsSL https://raw.githubusercontent.com/aspectstudio/docx2md/main/install.sh | bash

set -euo pipefail

BOLD="$(tput bold 2>/dev/null || echo '')"
GREEN="$(tput setaf 2 2>/dev/null || echo '')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '')"
RED="$(tput setaf 1 2>/dev/null || echo '')"
RESET="$(tput sgr0 2>/dev/null || echo '')"

DEST="${DEST:-/usr/local/bin}"
REPO="aspectstudio/docx2md"
BRANCH="main"
BIN_NAME="docx2md"

echo ""
echo "${BOLD}docx2md installer${RESET}"
echo "───────────────────"

# ── Check pandoc ──────────────────────────────────────────────────────────────
if ! command -v pandoc &>/dev/null; then
    echo "${YELLOW}⚠ pandoc is required but not installed.${RESET}"
    echo ""
    echo "Install it first:"
    echo "  macOS:   brew install pandoc"
    echo "  Ubuntu:  sudo apt install pandoc"
    echo "  Windows: choco install pandoc"
    echo "  More:    https://pandoc.org/installing.html"
    echo ""
    exit 1
fi
echo "${GREEN}✓${RESET} pandoc found"

# ── Download ──────────────────────────────────────────────────────────────────
TMPFILE="$(mktemp)"
trap 'rm -f "$TMPFILE"' EXIT

URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/${BIN_NAME}"

echo "Downloading ${URL}..."
if command -v curl &>/dev/null; then
    curl -fsSL "$URL" -o "$TMPFILE"
elif command -v wget &>/dev/null; then
    wget -q "$URL" -O "$TMPFILE"
else
    echo "${RED}Error:${RESET} curl or wget required"; exit 1
fi

chmod +x "$TMPFILE"

# ── Install ───────────────────────────────────────────────────────────────────
TARGET="${DEST}/${BIN_NAME}"

if [[ -w "$DEST" ]]; then
    mv "$TMPFILE" "$TARGET"
else
    echo ""
    echo "${DEST} is not writable. Trying with sudo..."
    sudo mkdir -p "$DEST"
    sudo mv "$TMPFILE" "$TARGET"
    sudo chmod +x "$TARGET"
fi

echo "${GREEN}✓${RESET} Installed to ${TARGET}"
echo ""

# ── Verify ────────────────────────────────────────────────────────────────────
if command -v docx2md &>/dev/null; then
    echo "${BOLD}Done!${RESET} Run ${BOLD}docx2md --help${RESET} to get started."
else
    echo "${YELLOW}⚠ ${DEST} may not be in your PATH.${RESET}"
    echo "  Add it with: export PATH=\"${DEST}:\$PATH\""
fi
echo ""
