# How to add language support

## 1. Choose an LSP server

Find the server name on the [lspconfig server list](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md). Example: `rust_analyzer` for Rust.

## 2. Add to Mason auto-install

Edit `lua/user/mason.lua`, add the server to the `ensure_installed` list:

```lua
require("mason-lspconfig").setup {
  ensure_installed = {
    -- ... existing servers ...
    "rust_analyzer",   -- ← add here
  },
}
```

## 3. Add to LSP config

Edit `lua/user/lspconfig.lua`, add the server name to the `servers` table:

```lua
local servers = {
  -- ... existing servers ...
  "rust_analyzer",
}
```

That's it. The config loop automatically calls `vim.lsp.config()` and `vim.lsp.enable()` for every server in the list. The server gets the default `on_attach` (keymaps) and `capabilities` (snippet support).

## 4. Add tree-sitter parser (if needed)

Some languages need a tree-sitter parser for highlighting:

```vim
:TSInstall rust
```

## 5. Custom server settings (optional)

If the server needs custom settings, create `lua/user/lspsettings/rust_analyzer.lua`:

```lua
return {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}
```

The config loop auto-detects this file via `pcall(require, "user.lspsettings.rust_analyzer")` and merges it.

## 6. Add formatter/linter (optional)

For formatters not supported by the LSP, edit `lua/user/none-ls.lua`:

```lua
local sources = {
  -- ... existing sources ...
  null_ls.builtins.formatting.rustfmt,
}
```

And install the tool via Mason:

```lua
-- lua/user/none-ls.lua, in the mason-null-ls section
ensure_installed = {
  -- ... existing ...
  "rustfmt",
}
```

## 7. Restart Neovim

Mason will install the new server on startup. Lazy will load the updated config.
