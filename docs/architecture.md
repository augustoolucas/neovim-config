# Architecture

How the config is structured, how plugins load, and how to navigate the codebase.

## Directory structure

```
~/.config/nvim/
├── init.lua              ← Entry point
├── lua/
│   └── user/
│       ├── launch.lua    ← Global LAZY_PLUGIN_SPEC table + spec() helper
│       ├── lazy.lua      ← lazy.nvim bootstrap + setup call
│       ├── options.lua   ← vim.opt / vim.g / vim.cmd settings
│       ├── keymaps.lua   ← Global keybindings (window nav, resize, etc.)
│       ├── autocmds.lua  ← Autocommands (formatoptions, highlight, ModeChanged)
│       ├── icons.lua     ← Unicode icon table (UI, git, diagnostics, LSP kind)
│       ├── *.lua         ← One file per plugin (29 files)
│       └── lspsettings/  ← Per-server LSP overrides (lua_ls, jsonls)
├── docs/                 ← Documentation (you are here)
├── requirements.sh       ← System dependency installer (Ubuntu/Debian)
├── .stylua.toml          ← Formatter config
└── .luarc                ← lua-language-server workspace config
```

## Plugin loading flow

```
init.lua
  │
  ├─ require "user.keymaps"        # Global keymaps first
  ├─ require "user.launch"         # Creates LAZY_PLUGIN_SPEC = {} and spec()
  ├─ require "user.options"        # vim.opt.* settings
  ├─ require "user.autocmds"       # Autocommands
  │
  ├─ spec "user.codecompanion"     # Adds { import = "user.codecompanion" }
  ├─ spec "user.colorscheme"       # to LAZY_PLUGIN_SPEC table
  ├─ spec "user.cmp"               #
  ├─ ... (29 plugins total)        #
  │
  └─ require "user.lazy"           # lazy.nvim.setup { spec = LAZY_PLUGIN_SPEC }
```

### The `spec()` helper

```lua
-- lua/user/launch.lua
LAZY_PLUGIN_SPEC = {}

function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = item })
end
```

`spec "user.telescope"` inserts `{ import = "user.telescope" }` into the table. lazy.nvim's `import` directive loads `lua/user/telescope.lua` as a module and expects it to return a lazy spec table.

### Plugin file template

Every plugin file in `lua/user/*.lua` follows this pattern:

```lua
local M = {
  "owner/repo",           -- GitHub repo
  event = "VeryLazy",     -- Load trigger (or "BufEnter", "InsertEnter", etc.)
  dependencies = {        -- Other plugins this one needs
    "dep/repo",
  },
}

function M.config()       -- Called after plugin loads
  require("plugin").setup {
    -- plugin-specific options
  }
end

return M
```

## What each plugin file contains

| File | Plugin | Purpose |
|---|---|---|
| `alpha.lua` | alpha-nvim | Startup dashboard with ASCII art and quick buttons |
| `autocmds.lua` | (core) | Global autocommands: formatoptions, yank highlight, LSP highlights, ModeChanged colors |
| `autopairs.lua` | nvim-autopairs | Auto-close brackets, quotes with tree-sitter awareness |
| `bigfile.lua` | bigfile.nvim | Disable features for files >2MB |
| `breadcrumbs.lua` | breadcrumbs.nvim | Winbar breadcrumb text (separator-only, content from navic) |
| `bufferline.lua` | bufferline.nvim | Buffer tabs at the top |
| `cmp.lua` | nvim-cmp | Completion engine with 5 sources + LuaSnip |
| `codecompanion.lua` | codecompanion.nvim | OpenAI chat, inline editing, actions |
| `colorscheme.lua` | onedark.nvim | Dark theme with custom highlights |
| `dap.lua` | nvim-dap | Python debugger (nvim-dap, dap-ui, dap-python, dap-virtual-text) |
| `devicons.lua` | nvim-web-devicons | Filetype icon provider |
| `gitsigns.lua` | gitsigns.nvim | Git diff signs, blame, hunk operations |
| `harpoon.lua` | harpoon | Quick file bookmarking |
| `icons.lua` | (static data) | Icon glyph table (used by all plugins) |
| `indentline.lua` | indent-blankline.nvim | Indentation guides with scope highlighting |
| `keymaps.lua` | (core) | Global keybindings (window nav, resize, line moves) |
| `launch.lua` | (core) | Defines `LAZY_PLUGIN_SPEC` and `spec()` |
| `lazy.lua` | lazy.nvim | Bootstraps lazy.nvim |
| `lazygit.lua` | lazygit.nvim | Git UI via floating terminal |
| `lspconfig.lua` | nvim-lspconfig | LSP server configuration with native API |
| `lualine.lua` | lualine.nvim | Statusline |
| `markview.lua` | markview.nvim | Markdown/HTML/Typst document preview |
| `mason.lua` | mason-lspconfig | LSP server installer |
| `mini.lua` | mini.icons | Alternative icon provider |
| `minuet.lua` | minuet-ai.nvim | AI code completions |
| `navic.lua` | nvim-navic | LSP code context provider for winbar |
| `neotest.lua` | neotest | Test runner (neotest-python adapter) |
| `none-ls.lua` | none-ls.nvim | External formatters (prettier, shfmt) |
| `nvimtree.lua` | nvim-tree.lua | File explorer sidebar |
| `opencode.lua` | opencode.nvim | OpenCode CLI integration |
| `options.lua` | (core) | vim.opt / vim.g settings |
| `snacks.lua` | snacks.nvim | Input, picker, terminal, notifier enhancements |
| `telescope.lua` | telescope.nvim | Fuzzy finder (files, grep, buffers, LSP) |
| `toggleterm.lua` | toggleterm.nvim | Terminal in horizontal/vertical/float splits |
| `vim-smoothie.lua` | vim-smoothie | Smooth scrolling |
| `whichkey.lua` | which-key.nvim | Keymap discovery popup |

## Key design decisions

### No nvim-treesitter plugin

Neovim 0.12 has tree-sitter built in. The `nvim-treesitter` plugin was removed — it was only needed for `ensure_installed` auto-parser-download. Parsers are now installed manually via `:TSInstall`.

### Native LSP API

All servers use `vim.lsp.config()` + `vim.lsp.enable()` (Neovim 0.11+). The deprecated `vim.lsp.with()` was replaced with manual wrapper functions. `nvim-lspconfig` is kept only for its server default configurations.

### Minimal nvim-cmp sources

Only 5 sources remain after cleanup: `nvim_lsp`, `luasnip`, `buffer`, `path`, `calc`. Copilot, Tabnine, and Emoji sources were removed.

### No extras directory

15 unused plugin configs were removed — they were never imported in `init.lua`. See git history if you need to restore one.
