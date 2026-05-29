# LSP Configuration

## Overview

This config registers 11 LSP servers via the native Neovim 0.12 API (`vim.lsp.config()` + `vim.lsp.enable()`). The legacy `nvim-lspconfig` plugin remains only as a dependency for its server default configurations — all setup logic uses the new API.

## Server list

| Server | Language | Mason auto-install? | Highlights |
|---|---|---|---|
| `lua_ls` | Lua | Yes | LuaJIT runtime, workspace library, third-party checks disabled |
| `pyright` | Python | Yes | Type checking, DAP support via neotest |
| `ruff` | Python | Yes | Diagnostics, formatting, import sorting — replaces ruff in none-ls |
| `ts_ls` | TypeScript/JS | Yes | tsserver-based |
| `eslint` | TypeScript/JS | Yes | ESLint LSP for linting |
| `cssls` | CSS | Yes | vscode-css-languageserver |
| `html` | HTML | Yes | vscode-html-languageserver |
| `jsonls` | JSON | Yes | SchemaStore support (via schemastore.nvim) |
| `yamlls` | YAML | Yes | Schema validation |
| `bashls` | Bash | Yes | bash-language-server |
| `ruff` | Python | Yes | Diagnostics + formatting |

## How servers are configured

```lua
-- lua/user/lspconfig.lua (simplified)

local servers = {
  "lua_ls", "cssls", "html", "ts_ls", "eslint",
  "pyright", "bashls", "jsonls", "yamlls", "ruff",
}

for _, server in pairs(servers) do
  local opts = {
    on_attach = M.on_attach,
    capabilities = M.common_capabilities(),
  }

  -- Merge per-server settings from lua/user/lspsettings/<server>.lua
  local require_ok, settings = pcall(require, "user.lspsettings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", settings, opts)
  end

  vim.lsp.config(server, opts)
  vim.lsp.enable(server)
end
```

### `on_attach`

Fires when the LSP client successfully attaches to a buffer. Sets 6 buffer-local keymaps:

| Key | Action | Mode |
|---|---|---|
| `gd` | Go to definition | Normal |
| `gD` | Go to declaration | Normal |
| `K` | Hover (documentation popup) | Normal |
| `gI` | Go to implementation | Normal |
| `gr` | Telescope lsp_references (preview) | Normal |
| `gl` | Diagnostic float | Normal |
| `<C-k>` | Signature help | Insert |

These are set per-buffer via `vim.api.nvim_buf_set_keymap`, so they don't leak to buffers without LSP.

### `common_capabilities()`

Tells each LSP server what features Neovim supports:

```lua
function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end
```

`snippetSupport = true` allows LSP servers to return snippet placeholders in completions (e.g., `func(${1:arg})`), which LuaSnip expands.

### Per-server settings

Two servers have custom settings in `lua/user/lspsettings/`:

**`lua_ls.lua`** — Configures the Lua language server:
- `runtime.version = "LuaJIT"` (Neovim uses LuaJIT)
- `runtime.special.spec = "require"` (treats `spec` as equivalent to `require`)
- `diagnostics.globals = { "vim", "spec" }` (prevents undefined-global warnings)
- `workspace.library` includes Neovim runtime and user config
- Disables telemetry

**`jsonls.lua`** — Configures the JSON language server:
- `schemas` loaded from `schemastore.nvim` for auto-completion of JSON config files

### Mason integration

`mason.lua` ensures these servers are auto-installed:

```lua
ensure_installed = {
  "lua_ls", "cssls", "html", "ts_ls",
  "pyright", "bashls", "jsonls",
  "eslint", "yamlls", "ruff",
}
```

If a server is missing from this list, `vim.lsp.enable()` will silently fail.

## Diagnostic configuration

```lua
vim.diagnostic.config {
  signs = {
    values = {
      { name = "DiagnosticSignError",   text = icons.diagnostics.Error },
      { name = "DiagnosticSignWarn",    text = icons.diagnostics.Warning },
      { name = "DiagnosticSignHint",    text = icons.diagnostics.Hint },
      { name = "DiagnosticSignInfo",    text = icons.diagnostics.Information },
    },
  },
  virtual_text = false,       -- Don't show inline text (avoids buffer shift)
  update_in_insert = false,   -- Don't update while typing (performance)
  underline = true,           -- Underline the problematic code
  severity_sort = true,       -- Errors before warnings before hints
  float = {
    border = "rounded",
    source = "always",        -- Show which server produced the diagnostic
  },
}
```

Key decision: **`virtual_text = false`** prevents diagnostic messages from shifting your code when errors appear. Diagnostics are visible in the gutter (signs), nvim-tree (file-level), and lualine (statusline count).

## Hover and signature help borders

Neovim 0.12 deprecated `vim.lsp.with()`, which was used to add borders to floating windows. The replacement uses manual wrapper functions:

```lua
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  config = vim.tbl_extend("force", config or {}, { border = "rounded" })
  vim.lsp.handlers.hover(_, result, ctx, config)
end
```

Both `textDocument/hover` and `textDocument/signatureHelp` are wrapped this way.

## Document highlight

The native LSP document highlight replaces the removed `vim-illuminate` plugin. When the cursor stays on a symbol for `updatetime` (100ms), all occurrences are highlighted:

```lua
-- autocmds.lua
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local clients = vim.lsp.get_clients { bufnr = 0 }
    for _, c in ipairs(clients) do
      if c:supports_method "textDocument/documentHighlight" then
        vim.lsp.buf.document_highlight()
        break
      end
    end
  end,
})
```

The capability check prevents errors on servers that don't support it (e.g., `jsonls`). Highlights clear on `CursorMoved`.

## Inlay hints

Inlay hints show type annotations and parameter names inline. Toggle with `<leader>lh`.

```lua
-- Enabled per-buffer in on_attach
if client:supports_method "textDocument/inlayHint" then
  vim.lsp.inlay_hint.enable(true, { bufnr })
end
```

## Which-key LSP bindings

| Key | Action | Description |
|---|---|---|
| `<leader>la` | Code action | Quick-fix menu, import suggestions |
| `<leader>lf` | Format | Format buffer with `vim.lsp.buf.format()` |
| `<leader>lh` | Toggle hints | Enable/disable inlay hints |
| `<leader>li` | Info | Show LSP client info |
| `<leader>lj` | Next diagnostic | Jump to next error/warning |
| `<leader>lk` | Prev diagnostic | Jump to previous error/warning |
| `<leader>ll` | CodeLens | Run code lens action |
| `<leader>lq` | Quickfix | Send diagnostics to quickfix list |
| `<leader>lr` | References | Telescope lsp_references with file preview |
| `<leader>lR` | Rename | Rename symbol across project |
