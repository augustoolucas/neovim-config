# Concepts

This document explains the core components that make Neovim an IDE. Understanding these relationships helps you debug issues and extend the config.

## The Big Picture

```
 Neovim 0.12
   │
   ├── LSP (Language Server Protocol)
   │     └── Diagnostics, hover, go-to-def, references, rename, code actions
   │         (configured via vim.lsp.config() + nvim-lspconfig)
   │
   ├── Tree-sitter
   │     └── Syntax highlighting, folding, smart indentation
   │         (native Neovim 0.12 — no plugin needed)
   │
   ├── Completion (nvim-cmp)
   │     └── Aggregate engine: LSP + snippets + buffer + path + AI
   │
   └── Tools
         ├── Formatters (none-ls: prettier, shfmt)
         ├── Linters (none-ls + ruff LSP)
         └── Test runner (neotest-python)
```

## What happens when you open a Python file

```
File opened (.py)  →  FileType detected
                          │
     ┌────────────────────┼────────────────────┐
     ▼                    ▼                    ▼
  LSP client           Tree-sitter          nvim-cmp
  attaches pyright     parses syntax        registers
                      highlights+fold      LSP source
     │                    │                    │
     ▼                    ▼                    ▼
  diagnostics        colored code         completion menu
  appear as          appears              appears on type
  gutter signs
```

1. **LSP attaches** — `vim.lsp.config("pyright", ...)` registers the server. Mason had already installed it. The `on_attach` callback sets buffer-local keymaps (`gd`, `K`, etc.).
2. **Tree-sitter parses** — The Python grammar builds an AST. Highlights queries (`highlights.scm`) map nodes to colors. Folds are derived from the AST.
3. **Completion activates** — `nvim-cmp` sources include `nvim_lsp` (pyright suggestions) + `buffer` (words from open files) + `luasnip` (snippet expansions). `<C-n>`/`<C-p>` navigate.
4. **Formatting works** — `vim.lsp.buf.format()` calls `textDocument/formatting` on ruff LSP or none-ls sources.

## Component reference

### LSP (Language Server Protocol)

A JSON-RPC protocol between Neovim and external language analyzers. The server (e.g. `pyright`) runs as a separate process. Neovim sends document changes; the server sends back:

| Capability | What you get |
|---|---|
| Diagnostics | Red/yellow/blue signs in gutter |
| Hover | Type info on `K` |
| Go-to-definition | Jump with `gd` |
| References | Find all usages |
| Rename | Refactor safely |
| Code actions | Auto-fix, organize imports |
| Completion | Suggestions for what to type next |
| Document highlight | Highlight all occurrences of symbol under cursor |

Not every server supports every capability. `jsonls` has no `documentHighlight`, `ts_ls` has no `formatting`.

### Tree-sitter

A parser generator that builds incremental, error-tolerant syntax trees. Unlike regex-based highlighting, tree-sitter understands language structure. Neovim 0.10+ includes it natively.

What it gives us:
- **Accurate highlighting** even in broken code
- **Folding** by syntax (`foldmethod=expr` + `vim.treesitter.foldexpr()`)
- **Indentation** based on AST, not regex
- **Comment strings** (knows `//` vs `#` vs `--` per filetype)

This config uses only the native tree-sitter — the `nvim-treesitter` plugin was removed in the 0.12 migration.

### Completion (nvim-cmp)

`nvim-cmp` is a completion *aggregator*. It doesn't generate suggestions — it collects them from *sources*:

| Source | What | Example |
|---|---|---|
| `nvim_lsp` | LSP server completion | Method signatures, imports |
| `luasnip` | Snippet engine | `if` expands to full if-block |
| `buffer` | Words from open buffers | Variable names, strings |
| `path` | File system paths | `./src<tab>` → `./src/main.py` |
| `calc` | Math expressions | `13*7` → `91` |

AI completions (Minuet) work independently — they show virtual text suggestions before the completion menu.

### Mason

Mason is a package manager for LSP servers, linters, and formatters. It downloads and installs server binaries automatically.

In this config, `mason-lspconfig` ensures the servers in its list are installed. If a server is missing from the `ensure_installed` list, `vim.lsp.enable()` will fail silently — the server needs to be installed first.

### None-ls (formatters outside LSP)

Not all tools speak LSP. `prettier` and `shfmt` are CLI formatters. None-ls bridges them into the LSP workflow so `vim.lsp.buf.format()` works uniformly.

What's left in this config after cleanup:
- `prettier` — JSON, YAML, Markdown
- `shfmt` — Shell scripts

Ruff formatting was removed from none-ls because ruff LSP now handles it natively.
