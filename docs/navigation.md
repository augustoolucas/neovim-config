# Navigation

## Telescope (fuzzy finder)

Primary search and navigation tool. Uses `telescope-fzf-native` for fast fuzzy matching (C-based, much faster than Lua).

### Picker keybindings

| Key | Command | Theme | Description |
|---|---|---|---|
| `<leader>ff` | `find_files` | Default | Fuzzy find files |
| `<leader>ft` | `live_grep` | Dropdown (60%) | Search text in project |
| `<leader>fb` | `git_branches` | Default | Switch git branch |
| `<leader>bb` | `buffers` | Dropdown | Switch open buffer |
| `<leader>fl` | `resume` | — | Reopen last picker |
| `<leader>fr` | `oldfiles` | Default | Recent files |

### Normal-mode picker keymaps

| Key | Action |
|---|---|
| `<Esc>` | Close |
| `j` | Next item |
| `k` | Previous item |
| `q` | Close |

In the buffers picker, `dd` deletes the buffer under cursor.

### Search configuration

Live grep uses `rg` (ripgrep) with:
- `--smart-case` — case-insensitive unless uppercase is typed
- `--hidden` — include dotfiles
- `--glob=!.git/` — exclude `.git` directory
- No heading/filename/color output (parsed by Telescope)

### Dropdown themes

`live_grep`, `grep_string`, `buffers`, and LSP pickers (`lsp_references`, `lsp_definitions`, `lsp_declarations`, `lsp_implementations`) all use the dropdown theme — a floating window at the top center, 60% width.

---

## Harpoon

Quick file bookmarking. Mark files with `<S-m>` (Shift+M), open the menu with `<Tab>`.

The menu shows numbered file entries — press the number to jump instantly. Works per-project.

---

## LSP code context (navic + breadcrumbs)

**navic** provides LSP symbol context (e.g., `Class > method > loop`). Displayed in the winbar via lualine or a custom handler. Configured with:

- `auto_attach = true` — attaches to every LSP buffer automatically
- `click = true` — clicking a segment jumps to that symbol
- `separator = "  "` — chevron between segments
- `depth_limit = 0` — no nesting limit

**breadcrumbs** provides the winbar separator configuration (thin right-divider between segments). Without navic, breadcrumbs would show nothing — its content comes from the LSP client.

---

## Smooth scrolling (vim-smoothie)

Enables smooth animation for:
- `Ctrl-D` / `Ctrl-U` (half-page scroll down/up)
- `Ctrl-F` / `Ctrl-B` (full-page scroll down/up)

Simple plugin, no configuration needed. Loads on buffer events.

---

## Window management

Global keymaps for window navigation and resizing:

| Key | Action |
|---|---|
| `Ctrl+h` | Focus window left |
| `Ctrl+j` | Focus window below |
| `Ctrl+k` | Focus window above |
| `Ctrl+l` | Focus window right |
| `Ctrl+Up` | Decrease height |
| `Ctrl+Down` | Increase height |
| `Ctrl+Left` | Decrease width |
| `Ctrl+Right` | Increase width |
| `Shift+h` | Previous buffer |
| `Shift+l` | Next buffer |
| `Shift+q` | Close buffer |
| `<leader>bd` | Close buffer, keep window |

On `VimResized`, all windows are equalized (`tabdo wincmd =`).
