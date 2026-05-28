# Plan: Install markview.nvim

## Overview

Install `OXY2DEV/markview.nvim` — a Markdown, HTML, LaTeX, Typst & YAML previewer for Neovim.

## Files to Create/Modify

### 1. Create `lua/user/markview.lua` (NEW)

Following the repo's `M` table pattern:

```lua
local M = {
  "OXY2DEV/markview.nvim",
  lazy = false,
}

function M.config()
  require("markview").setup {
    preview = {
      icon_provider = "devicons",
    },
  }
end

return M
```

Key decisions:
- `lazy = false` — plugin docs warn against lazy-loading
- `icon_provider = "devicons"` — repo already has `devicons.lua` configured
- No explicit dependencies — markview is self-contained

### 2. Modify `init.lua` — add spec

Add `spec "user.markview"` in alphabetical order among the other plugin specs.

### 3. Modify `lua/user/treesitter.lua` — add missing parsers

Required parsers status:
- `markdown` ✅ already installed
- `markdown_inline` ✅ already installed
- `yaml` ✅ already installed
- `html` ❌ missing
- `latex` ❌ missing
- `typst` ❌ missing
- `comment` ❌ missing

Add `"html"`, `"latex"`, `"typst"`, `"comment"` to the `ensure_installed` list.

## Verification

```bash
stylua lua/user/markview.lua --config-path .stylua.toml
```

After restart:
- Open `.md` file — markview renders preview inline
- `:Markview Toggle` — toggles preview
- `:checkhealth markview` — no issues
