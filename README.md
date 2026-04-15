<div align="center">

# 📄 docx2md

**Convert Word documents to clean Markdown — from the command line.**

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Shellcheck](https://github.com/jschof1/docx2md/actions/workflows/test.yml/badge.svg)](https://github.com/jschof1/docx2md/actions/workflows/test.yml)
[![GitHub stars](https://img.shields.io/github/stars/jschof1/docx2md?style=social)](https://github.com/jschof1/docx2md/stargazers)

One dependency · Zero config · Works everywhere

[Install](#-install) · [Usage](#-usage) · [Why](#-why) · [Contributing](#contributing)

</div>

---

## ✨ What it does

`docx2md` wraps [pandoc](https://pandoc.org) with sensible defaults so you can convert `.docx` files to Markdown without memorizing flags.

```bash
docx2md report.docx
# ✓ report.docx → report.md
```

That's it. No config files, no build step, no Node.js runtime. One script, one dependency.

## 🚀 Install

### One-liner (macOS, Linux, WSL)

```bash
curl -fsSL https://raw.githubusercontent.com/jschof1/docx2md/main/install.sh | bash
```

### Or with git

```bash
git clone https://github.com/jschof1/docx2md.git
cd docx2md
sudo make install
```

### Or just download it

```bash
curl -fsSL https://raw.githubusercontent.com/jschof1/docx2md/main/docx2md -o /usr/local/bin/docx2md
chmod +x /usr/local/bin/docx2md
```

### Prerequisite

[`pandoc`](https://pandoc.org/installing.html) must be installed:

| Platform | Install |
|----------|---------|
| macOS | `brew install pandoc` |
| Ubuntu/Debian | `sudo apt install pandoc` |
| Fedora | `sudo dnf install pandoc` |
| Windows (WSL) | `sudo apt install pandoc` |
| Windows (native) | `choco install pandoc` |
| Arch | `sudo pacman -S pandoc` |

## 📖 Usage

### Basic

```bash
docx2md report.docx                    # → report.md
docx2md report.docx notes.md           # → notes.md (custom output name)
```

### Extract images

```bash
docx2md --images report.docx           # images extracted to ./images/
docx2md -i assets report.docx          # images extracted to ./assets/
```

### Batch convert

```bash
docx2md chapter1.docx chapter2.docx chapter3.docx
docx2md *.docx
```

### Pipe to other tools

```bash
docx2md -s report.docx | head -20      # preview first 20 lines
docx2md -s report.docx | wc -w         # word count
docx2md -s report.docx > output.md     # redirect to file
```

### All options

```
USAGE
    docx2md [OPTIONS] <input.docx...>
    docx2md <input.docx> [output.md]

OPTIONS
    -i, --images [DIR]    Extract images into DIR (default: images/)
    -s, --stdout          Write Markdown to stdout instead of a file
    -q, --quiet           Suppress all output except errors
    -w, --wrap MODE       Line wrapping: none (default), auto, or preserve
    -h, --help            Show this help message
    -V, --version         Show version number
```

## 🤔 Why

There are plenty of docx-to-markdown tools. Here's why this one exists:

- **Zero config** — no config files, no presets, no decisions to make
- **One dependency** — only [pandoc](https://pandoc.org), which you probably already have
- **Batch mode** — convert 50 docs in one command
- **Image extraction** — pull embedded images out with one flag
- **Pipes** — stdout mode works with `head`, `grep`, `wc`, and everything else
- **Portable** — pure bash, runs on macOS, Linux, WSL, anywhere with a shell
- **Fast** — no runtime, no daemon, no overhead

## 🗺️ How it compares

| | docx2md | [mattn/docx2md](https://github.com/mattn/docx2md) | [microsoft/markitdown](https://github.com/microsoft/markitdown) |
|---|---|---|---|
| Dependencies | pandoc | None (Go binary) | Python + packages |
| Install size | ~5 KB | ~3 MB | ~50 MB |
| Batch mode | ✅ | ❌ | ✅ |
| Image extraction | ✅ | ✅ | ✅ |
| Stdout / pipes | ✅ | ❌ | ✅ |
| Config needed | None | None | None |
| Language | Bash | Go | Python |

## 🧪 Development

```bash
git clone https://github.com/jschof1/docx2md.git
cd docx2md

# Run tests
make test

# Lint
make lint

# Install locally
make install

# Uninstall
make uninstall
```

## ❓ FAQ

**Does it convert `.doc` (old Word format)?**
Not directly. Convert to `.docx` first with `libreoffice --convert-to docx file.doc`, then use `docx2md`.

**What about tables, footnotes, and math?**
Pandoc handles all of these. Complex tables may need manual cleanup, but most convert cleanly.

**Why wrap pandoc? Isn't this just `pandoc -f docx -t markdown`?**
Yes, and that's the point. Nobody remembers those flags. `docx2md report.docx` is easier to type, easier to remember, and handles batch conversion and image extraction without reaching for the pandoc manual.

## Contributing

Contributions welcome. Please:

1. Fork the repo
2. Create a feature branch (`git checkout -b my-feature`)
3. Commit your changes
4. Open a pull request

Keep it simple — this tool's value is its simplicity.

## License

[MIT](LICENSE) — use it however you like.

---

<div align="center">

If this saved you time, consider giving it a ⭐

[⭐ Star on GitHub](https://github.com/jschof1/docx2md)

</div>
