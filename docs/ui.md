# UI

## Colorscheme (onedark.nvim)

Dark theme from [navarasu/onedark.nvim](https://github.com/navarasu/onedark.nvim).

```lua
style = "dark",
highlights = {
  WinSeparator = { fg = "#191919" },
}
```

The `WinSeparator` highlight makes window borders nearly invisible. Colorscheme loads at startup (`lazy = false`, `priority = 1000`).

---

## Statusline (lualine)

Minimal statusline showing essential information:

```
[ branch ]  [ diagnostics ]               [ filetype ] [ progress ]
```

| Section | Content | Position |
|---|---|---|
| `lualine_a` | Empty | Far left |
| `lualine_b` | Git branch | Left |
| `lualine_c` | Diagnostic counts | Left |
| `lualine_x` | Filetype | Right |
| `lualine_y` | Progress (line %) | Right |
| `lualine_z` | Empty | Far right |

No component separators or section separators — clean look. Extensions for `quickfix` and `man` windows.

---

## Bufferline

Buffer tabs at the top with thin separators. Shows diagnostic counts per buffer and a close icon.

The NvimTree sidebar is offset, so bufferline starts after the file explorer. Diagnostics come from `nvim_lsp`.

---

## NvimTree (file explorer)

File explorer toggle with `<leader>e`. Key features:

- **Git icons** — staged, unstaged, renamed, deleted, untracked files with colored icons
- **Diagnostics** — LSP error/warning counts shown on files and folders
- **Sync root** — `sync_root_with_cwd = true` keeps the tree in sync with your working directory
- **Relative numbers** — line numbers in the tree are relative
- **Custom glyphs** — uses icons from `user.icons` (folders, chevrons, git symbols)
- **Special files** — orders `Cargo.toml`, `Makefile`, `README.md` first
- **Netrw hijack** — replaces built-in `netrw` with NvimTree

On startup, if a file is open, NvimTree calls `NvimTreeFindFile` to reveal the current file in the tree.

---

## Dashboard (alpha-nvim)

Startup screen shown on empty Neovim (`VimEnter`). Displays an ASCII art header and quick-action buttons:

| Key | Action |
|---|---|
| `f` | Find file (Telescope) |
| `n` | New file |
| `p` | Find project |
| `r` | Recent files |
| `t` | Find text (live grep) |
| `c` | Edit config (`~/.config/nvim/init.lua`) |
| `q` | Quit |

The footer shows your name. On `AlphaReady`, the statusline is hidden and restored on buffer unload.

---

## Indent guides (indent-blankline)

Shows vertical lines for each indentation level. The current scope (e.g., function body) gets highlighted indentation.

**Character:** `│` (LineMiddle from icons)

**Excluded filetypes:** help, dashboard, lazy, NvimTree, Trouble, text, alpha, toggleterm, mason. These don't benefit from indent guides.

**Excluded buftypes:** terminal, nofile, quickfix, prompt.

---

## Markdown preview (markview)

Live-renders Markdown, HTML, and Typst files with icons. Lazy-loads on `ft = { "markdown", "html", "typst" }`.

Uses `nvim-web-devicons` as the icon provider.

### Required tree-sitter parsers

Markview needs these parsers (install them once):
```
:TSInstall markdown markdown_inline html typst comment
```

---

## Which-key

Shows available keybindings when you press `<leader>` and pause. Configured groups:

| Prefix | Group |
|---|---|
| `<leader>b` | Buffers |
| `<leader>f` | Find (Telescope) |
| `<leader>g` | Git |
| `<leader>l` | LSP |
| `<leader>o` | OpenCode |
| `<leader>c` | CodeCompanion |
| `<leader>t` | Test (neotest) |
| `<leader>h` | Clear search highlights |

**Plugin presets disabled:** operators, motions, text_objects, windows, nav, z, g — too noisy. Spelling suggestions enabled (20 max).

**Window:** rounded border with 2-cell padding.

**Disabled in:** TelescopePrompt (conflicts with Telescope's own keymaps).

---

## Snacks.nvim

Multi-purpose utility plugin from folke. Enabled modules:

| Module | Purpose |
|---|---|
| `input` | Enhanced `vim.ui.input` with borders |
| `picker` | Fuzzy picker (used by OpenCode.nvim) |
| `terminal` | Enhanced terminal |
| `notifier` | Enhanced notifications |

Config is minimal — mostly default settings. OpenCode.nvim extends the picker with its own actions.

---

## Mode-sensitive cursorline (native, replaces modicator.nvim)

When you change Vim modes, the cursor line number changes color via `ModeChanged` autocmd:

| Mode | Color |
|---|---|
| Normal | Blue (`#388bfd`) |
| Insert | Green (`#98c379`) |
| Visual/Visual-line/Visual-block | Purple (`#c678dd`) |
| Command | Red (`#e06c75`) |
| Replace | Yellow (`#e5c07b`) |

On `Colorscheme` reload, the color resets to Normal blue.
