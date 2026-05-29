# Neovim Configuration

Personal Neovim IDE configuration optimized for Python development with AI-assisted coding.

## Prerequisites

- **Neovim 0.12+** (uses native `vim.lsp.config()`, `vim.treesitter`, `vim.snippet`)
- **Git**
- **A Nerd Font** ([getnf](https://github.com/ronniedroid/getnf) recommended) for icons

## Installation

### 1. Install Neovim 0.12+

Download the latest stable tarball from [neovim/neovim releases](https://github.com/neovim/neovim/releases):

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
mkdir -p ~/.local
tar xzf nvim-linux-x86_64.tar.gz -C ~/.local
ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
```

Ensure `~/.local/bin` is in your `PATH`.

### 2. System dependencies

Run the requirements script (Ubuntu/Debian):

```sh
./requirements.sh
```

Or install manually:

```sh
sudo apt install -y git curl wget build-essential cmake
sudo apt install -y nodejs npm python3 python3-pip python3-venv ripgrep fd-find
sudo apt install -y shfmt

python3 -m venv ~/.neovim-venv
~/.neovim-venv/bin/pip install pynvim

npm i -g neovim tree-sitter-cli
```

### 3. Clone the config

```sh
git clone https://github.com/<your-username>/<repo>.git ~/.config/nvim
```

### 4. First run

Open Neovim:

```sh
nvim
```

**lazy.nvim** will install all plugins automatically. Tree-sitter parsers for Python, Lua, Bash, Markdown, JSON, YAML, and web languages will be installed on first use via `:TSInstall`.

### 5. Environment variables

These are required for AI features. Add to your shell profile (`~/.bashrc`, `~/.zshrc`):

```sh
# AI completions (minuet-ai.nvim)
export OPENCODE_GO_API_KEY="<your-key>"

# OpenAI features (codecompanion.nvim)
export PERSONAL_OPENAI_API_KEY="<your-key>"

# Python provider
export PYTHON3_HOST_PROG="$HOME/.neovim-venv/bin/python3"
```

## Features

### LSP & Completion
- **nvim-lspconfig** with native `vim.lsp.config()` / `vim.lsp.enable()` API (Neovim 0.12)
- **nvim-cmp** — completion engine with LuaSnip, LSP, buffer, path, and calc sources
- **Mason** — automated LSP server installation and management

### AI
- **CodeCompanion** — OpenAI chat, inline editing, and actions
- **Minuet** — AI-powered code completions via OpenCode Go
- **OpenCode.nvim** — OpenCode CLI integration with snacks picker

### UI
- **onedark.nvim** — colorscheme
- **lualine.nvim** — statusline with branch, diagnostics, filetype, progress
- **bufferline.nvim** — buffer tabs with diagnostic indicators
- **nvim-tree.lua** — file explorer with git status and diagnostics
- **alpha-nvim** — startup dashboard with quick actions
- **indent-blankline.nvim** — indentation guides with scope highlighting
- **markview.nvim** — markdown/html/typst document preview
- **which-key.nvim** — keymap discovery popup

### Navigation & Search
- **Telescope.nvim** — fuzzy finder (files, grep, buffers, LSP references, git branches)
- **Harpoon** — quick file bookmarking
- **nvim-navic** + **breadcrumbs.nvim** — LSP code context in winbar

### Git
- **gitsigns.nvim** — inline git diff signs, blame, hunk navigation and staging
- **lazygit.nvim** — terminal-based git UI integration

### Terminal
- **toggleterm.nvim** — horizontal, vertical, and floating terminal windows

### Formatting & Linting
- **none-ls.nvim** — prettier (JSON, YAML, Markdown), shfmt (shell)
- **Ruff LSP** — Python diagnostics, formatting, and import organization

### Testing
- **neotest** + **neotest-python** — pytest runner with inline results

### Extras
- **vim-smoothie** — smooth scrolling for `Ctrl-D`/`Ctrl-U`/`Ctrl-F`/`Ctrl-B`
- **nvim-autopairs** — treesitter-aware auto bracket/quote pairing
- **snacks.nvim** — enhanced input, picker, terminal, and notifications
- **bigfile.nvim** — disables features for files >2MB to maintain performance

## Keybindings

Leader key: `<Space>`

| Prefix | Group |
|--------|-------|
| `<leader>f` | Find (Telescope files, grep, buffers) |
| `<leader>g` | Git (hunks, blame, lazygit) |
| `<leader>l` | LSP (code actions, format, rename, diagnostics) |
| `<leader>c` | CodeCompanion (chat, inline, actions) |
| `<leader>o` | OpenCode (ask, select, toggle) |
| `<leader>t` | Test (neotest run, file, debug, stop) |
| `<leader>e` | File Explorer (nvim-tree toggle) |
| `<leader>b` | Buffers |

Press `<leader>` and wait to see all available keybindings via which-key.

Additional global keymaps:

| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Window navigation |
| `Ctrl+Arrows` | Window resize |
| `Shift+h/l` | Previous/next buffer |
| `Shift+q` | Close buffer |
| `jk` / `kj` (insert) | Escape |
| `Alt+j/k` | Move line up/down |

## Language Support

### Python
- `pyright` — LSP (type checking, completions, hover)
- `ruff` — LSP (diagnostics, formatting, import sorting)
- `neotest-python` — pytest test runner with debugpy DAP
- `ruff_format` via LSP code actions

### Lua
- `lua_ls` — LSP with Neovim runtime library
- Per-project diagnostics and EmmyLua annotations

### Web
- `ts_ls` — TypeScript/JavaScript LSP
- `eslint` — ESLint diagnostics
- `cssls` — CSS LSP
- `html` — HTML LSP
- `prettier` — JSON, YAML, Markdown formatting

### Shell
- `bashls` — Bash LSP
- `shfmt` — shell script formatting (via none-ls)

### Config files (JSON, YAML)
- `jsonls` — JSON LSP with SchemaStore support
- `yamlls` — YAML LSP
- `prettier` — formatting

### Markdown
- `markview.nvim` — live preview with icons
- `prettier` — formatting
- Native tree-sitter highlighting

## Health Check

Open Neovim and run:

```
:checkhealth
```

Verify that all providers (Python, Node), LSP servers, and tree-sitter parsers report OK.

## Troubleshooting

**LSP servers not starting?**
```
:Mason
```
Install missing servers manually from the Mason UI.

**Tree-sitter errors?**
```
:TSInstall python lua bash markdown json yaml html css typescript
```

**Plugins not loading?**
```
:Lazy sync
```

**Icons showing as boxes?**
Install a Nerd Font and configure your terminal to use it.
