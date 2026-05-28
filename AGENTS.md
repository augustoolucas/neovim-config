# AGENTS: repository assistant rules

Purpose: concise instructions for agentic coding agents operating on this Neovim configuration repository.

---

## 1) Architecture overview

This repo uses **lazy.nvim** with a custom spec-collection pattern:

- `lua/user/launch.lua` — defines the global `LAZY_PLUGIN_SPEC = {}` table and the `spec(item)` helper:
  ```lua
  LAZY_PLUGIN_SPEC = {}
  function spec(item)
    table.insert(LAZY_PLUGIN_SPEC, { import = item })
  end
  ```
- `init.lua` — entry point; loads keymaps/launch/options/autocmds, then calls `spec "user.<plugin>"` for each plugin, finally calls `require "user.lazy"`:
  ```lua
  require "user.keymaps"
  require "user.launch"
  require "user.options"
  require "user.autocmds"
  spec "user.telescope"
  spec "user.cmp"
  -- ...
  require "user.lazy"
  ```
- `lua/user/lazy.lua` — bootstraps lazy.nvim (clones if missing) and calls:
  ```lua
  require("lazy").setup { spec = LAZY_PLUGIN_SPEC, ... }
  ```
- Each plugin file (`lua/user/*.lua`, `lua/user/extras/*.lua`) returns a lazy.nvim spec table `M`:
  ```lua
  local M = {
    "owner/repo",
    dependencies = { ... },
  }

  function M.config()
    -- ...
  end

  return M
  ```
- In practice, `function M.config() ... end` is the dominant style in this repo.

### How to add a new plugin

1. Create `lua/user/<plugin>.lua` returning a lazy spec table `M` (see any existing file as template).
2. Add `spec "user.<plugin>"` to `init.lua` (alphabetical order preferred).
3. If the plugin is optional/conditional, place it in `lua/user/extras/` and add `spec "user.extras.<plugin>"` in `init.lua`.
4. Run `stylua` on the new file.

---

## 2) Key files and directories

| Path | Purpose |
|---|---|
| `init.lua` | Entry point: loads core modules, calls `spec()` for plugins, boots lazy.nvim |
| `lua/user/launch.lua` | Defines globals `LAZY_PLUGIN_SPEC` and `spec()` |
| `lua/user/lazy.lua` | Bootstraps and configures lazy.nvim |
| `lua/user/options.lua` | `vim.opt` / `vim.g` / `vim.cmd` settings |
| `lua/user/keymaps.lua` | Global keybindings via `vim.keymap.set` |
| `lua/user/autocmds.lua` | Autocommands via `vim.api.nvim_create_autocmd` |
| `lua/user/icons.lua` | UI icons, git symbols, diagnostic signs used across plugins |
| `lua/user/*.lua` | Plugin spec files (one per plugin) |
| `lua/user/extras/*.lua` | Optional / conditional plugin specs |
| `lua/user/lspsettings/*.lua` | Per-language LSP overrides (jsonls, lua_ls) |
| `.stylua.toml` | Formatter config |
| `.luarc` | lua-language-server workspace settings |
| `README.md` | Project readme with installation instructions |
| `requirements.sh` | System dependency installer |
| `.gitignore` | Git ignore rules |

---

## 3) Formatting rules (enforced by `.stylua.toml`)

Run `stylua` on changed files before committing:

```sh
stylua <file> --config-path .stylua.toml
```

Key rules from `.stylua.toml`:

- **Max column width:** 120
- **Indent:** 2 spaces (no tabs)
- **Quote style:** prefer double quotes (`"foo"` over `'foo'`)
- **No call parentheses:** single string/table args omit parentheses:
  ```lua
  require "user.foo"       -- not require("user.foo")
  vim.cmd "set wrap"       -- not vim.cmd("set wrap")
  vim.opt.fillchars:append { stl = " " }
  ```
- **Line endings:** Unix (`\n`)

---

## 4) Code conventions

### Imports / requires

- Use `local` for modules referenced more than once:
  ```lua
  local wk = require "which-key"
  local lspconfig = require "lspconfig"
  ```
- Inline `require` for one-off calls (used throughout the repo):
  ```lua
  require "user.foo"
  ```
- Protect optional dependencies with `pcall` and fail gracefully:
  ```lua
  local ok, plugin = pcall(require, "plugin_name")
  if not ok then
    vim.notify("plugin_name not available", vim.log.levels.WARN)
    return
  end
  ```

### Naming

- **File names:** lowercase, no separators unless disambiguation needed (e.g., `lspconfig.lua`, `toggleterm.lua`, `none-ls.lua`, `vim-smoothie.lua`). Keep names short.
- **Variables/functions:** snake_case (`local status_ok = ...`, `lazypath`).
- **Module tables:** `M` for the exported lazy spec (universal pattern in this repo).

### Keymap pattern

Plugins that need keymaps should define them via `which-key` locally inside the `config()` function:

```lua
function M.config()
  local wk = require "which-key"
  wk.add {
    { "<leader>xx", "<cmd>SomeCommand<cr>", desc = "Description" },
  }
end
```

For global keymaps (not tied to a plugin), use `vim.keymap.set` in `lua/user/keymaps.lua`:
```lua
local keymap = vim.keymap.set
local opts = { silent = true }
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)
```

### Types & annotations

Lua is dynamically typed; use lightweight EmmyLua annotations for non-obvious function signatures:
```lua
---@param opts table
function M.setup(opts) end
```

### Error handling

- Avoid silent failures. Log warnings via `vim.notify(..., vim.log.levels.WARN)`.
- Do not raise unhandled errors in startup code that would break the editor.
- Prefer Neovim Lua API (`vim.api`, `vim.opt`, `vim.cmd`) over shelling out.

---

## 5) Commands reference

```sh
# Install system dependencies
./requirements.sh

# Install / sync plugins (headless)
nvim --headless -c "lua require('lazy').sync()" -c q

# Open interactively (let Lazy install + Tree-sitter parsers)
nvim

# Format a file
stylua lua/user/foo.lua --config-path .stylua.toml

# Format entire repo
stylua . --config-path .stylua.toml

# Lint (optional; install via: luarocks install luacheck)
luacheck . --std lua52

# Run a plenary test (if tests are added)
nvim --headless -c "lua require('plenary.test_harness').test_file('tests/foo_spec.lua', {minimal_init = true})" -c q
```

---

## 6) Safe-editing checklist

- Run `stylua` on changed files before committing.
- Use `pcall(require, ...)` for optional plugin imports; avoid changing global runtime state.
- If you modify `requirements.sh`, `lazy-lock.json`, or add/remove plugin specs, run a headless plugin sync and verify `nvim` starts without runtime errors.
- Keep commits small and focused. Include a concise message explaining *why*, not only *what*.
- Do not run destructive git commands (push, force-update, reset) without explicit approval.
- There are no repository unit tests. If you add tests, use `plenary` and place them in `tests/`.

---

If anything is unclear or you need to run a command that could be destructive, ask for explicit approval.
