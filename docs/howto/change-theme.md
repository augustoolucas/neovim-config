# How to change the theme

## Install a new colorscheme

1. Create a new file `lua/user/colorscheme.lua` with the new plugin:

```lua
local M = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
}

function M.config()
  require("tokyonight").setup {
    style = "night",
  }
  vim.cmd.colorscheme "tokyonight"
end

return M
```

2. Restart Neovim.

## Keep onedark, add it as an option

If you want to keep onedark but test others:

1. Edit `lua/user/colorscheme.lua` to support multiple themes.
2. Use `:Telescope colorscheme` to preview interactively.
3. When satisfied, update the `require(...).load()` or `vim.cmd.colorscheme(...)` call to set the new default.

## Customize onedark

Edit `lua/user/colorscheme.lua`:

```lua
require("onedark").setup {
  highlights = {
    WinSeparator = { fg = "#191919" },
    -- Add custom overrides here
    Comment = { fg = "#5c6370", italic = true },
  },
  style = "dark",
}
```

Available highlight groups: run `:highlight` in Neovim to see current values, then override in the `highlights` table.

## Add transparency

```lua
require("onedark").setup {
  transparent = true,
  style = "dark",
}
```

This makes the background transparent (uses terminal background). Pair with a compositor like picom for glass effects.
