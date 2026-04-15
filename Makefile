# ── Install paths ─────────────────────────────────────────────────────────────
PREFIX ?= /usr/local/bin

# ── Phony targets ─────────────────────────────────────────────────────────────
.PHONY: install uninstall test lint clean

# ── Install ───────────────────────────────────────────────────────────────────
install: docx2md
	@mkdir -p $(PREFIX)
	@if [ -w $(PREFIX) ]; then \
		cp docx2md $(PREFIX)/docx2md && chmod +x $(PREFIX)/docx2md; \
	else \
		sudo cp docx2md $(PREFIX)/docx2md && sudo chmod +x $(PREFIX)/docx2md; \
	fi
	@echo "✓ Installed to $(PREFIX)/docx2md"

# ── Uninstall ─────────────────────────────────────────────────────────────────
uninstall:
	@if [ -w $(PREFIX)/docx2md ]; then \
		rm $(PREFIX)/docx2md; \
	else \
		sudo rm $(PREFIX)/docx2md; \
	fi
	@echo "✓ Removed $(PREFIX)/docx2md"

# ── Test ──────────────────────────────────────────────────────────────────────
test:
	@echo "Running shellcheck..."
	@shellcheck docx2md install.sh || echo "⚠ shellcheck not installed, skipping"
	@echo "Running conversion tests..."
	@bash tests/run.sh

# ── Lint ──────────────────────────────────────────────────────────────────────
lint:
	shellcheck docx2md install.sh

# ── Clean ─────────────────────────────────────────────────────────────────────
clean:
	rm -f tests/fixtures/*.md
	rm -rf tests/fixtures/images/
