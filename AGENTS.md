# AGENTS: repository assistant rules

Purpose: concise instructions for agentic coding agents operating on this Neovim configuration repository.

1) Quick commands (build / install / lint / test)

- Install system deps (recommended): follow `requirements.sh`:
  ```sh
  ./requirements.sh
  ```
- Install / sync plugins (headless):
  ```sh
  # install lazy.nvim then sync plugins (non-interactive)
  nvim --headless -c "lua require('lazy').sync()" -c q
  ```
- Open once interactively to let Lazy install and Tree-sitter parsers:
  ```sh
  nvim
  ```
- Format Lua files with stylua (project config is .stylua.toml):
  ```sh
  # format entire repo
  stylua . --config-path .stylua.toml

  # format a single file
  stylua lua/user/options.lua --config-path .stylua.toml
  ```
- Linting (recommended tools; not required by repo):
  ```sh
  # optional: install luacheck and run it (install via luarocks)
  luacheck . --std lua52
  ```
- Run a single Lua test (plenary / busted examples):
  ```sh
  # using plenary (neovim plugin) from the command line
  nvim --headless -c "lua require('plenary.test_harness').test_file('path/to/test_file.lua', {minimal_init = true})" -c q

  # using busted (if you add a tests/ directory and busted to dev deps)
  busted tests/some_spec.lua
  ```

Notes: this repo is a Neovim configuration (Lua). There is no build artifact step. Running `nvim` is the primary way to exercise changes.

2) Files and configuration of interest

- `.stylua.toml` — project formatting rules (column_width=120, 2-space indent, prefer double quotes)
- `.luarc` — LSP/workspace settings used by lua-language-server
- `requirements.sh` — helper to install system-level dependencies
- `lua/user/*.lua` — main configuration modules and plugin specs
- `lua/user/lazy.lua` — bootstraps `lazy.nvim`; headless sync uses `require('lazy').sync()`

3) Code style guidelines (enforceable rules for agents)

General
- Treat this repository as configuration code: clarity and safety first. Avoid drastic refactors unless requested.
- Keep commits small and focused. If you make multiple unrelated edits, split them into separate commits and explain why.

Formatting
- Use `stylua` w/ `.stylua.toml`. Run formatting before committing.
- Preferred max column: 120. Indent: 2 spaces. Quote style: prefer double quotes unless single is clearer for nested strings.

Imports / requires
- Use `local` for required modules when you will reference them more than once:
  ```lua
  local lspconfig = require("lspconfig")
  ```
- For short one-off calls that are obvious and used once, `require "mod"` inline is acceptable (existing repo uses this pattern).
- Protect optional requires with `pcall` and fail gracefully:
  ```lua
  local ok, plugin = pcall(require, "plugin_name")
  if not ok then
    return
  end
  ```

Naming conventions
- File/module names: use lower-case with hyphens for plugin-spec files (existing pattern: `none-ls.lua`, `neotest.lua`). Keep filenames short and descriptive.
- Lua variables & functions: snake_case (e.g. `setup_lsp`, `on_attach`) for local functions and variables.
- Module tables (exports) may use camelCase or PascalCase if they represent objects — be consistent per module.

Types & annotations
- Lua is dynamically typed; prefer lightweight inline EmmyLua annotations for public APIs that are consumed by LSP or other modules:
  ```lua
  ---@param opts table
  function M.setup(opts) end
  ```
- Use `---@return` and `---@param` when function signatures are non-obvious to help language servers.

Error handling
- Fail early and clearly. When a required dependency is missing, either `pcall(require, ...)` and return, or surface an informative message via `vim.notify` (non-blocking):
  ```lua
  local ok, mod = pcall(require, "mod")
  if not ok then
    vim.notify("mod not available: mod", vim.log.levels.WARN)
    return
  end
  ```
- Avoid silent failures. Log warnings for unexpected states; do not raise unhandled errors in startup code that would break the editor.

API usage
- Prefer using the Neovim Lua API (`vim.api`, `vim.opt`, `vim.cmd`) rather than shelling out when possible.
- When interacting with plugin APIs, read upstream docs and use the plugin's `setup{}` pattern where available.

Testing
- There are no repository unit tests by default. If you add tests use `plenary` (for Neovim runtime tests) or `busted` (for plain Lua).
- Keep tests isolated to a `tests/` or `lua/test/` directory and ensure they are runnable headless with the `plenary.test_harness` or `busted` CLI.

4) PR / commit guidance for agents
- When making changes, include a concise commit message that explains why, not only what.
- If you modify plugin versions or lockfiles (`lazy-lock.json`), run a headless sync and ensure no startup errors.
- Do not modify unrelated user files; keep changes scoped to the task.

5) Static analysis & developer tools
- Formatting: `stylua` (`.stylua.toml` present).
- Linting: `luacheck` is recommended; there is no `luacheck` config — be conservative with globals and annotate with `-- luacheck: ignore` when necessary.
- LSP: the repo relies on `lua-language-server` settings in `.luarc`.

6) Editor / automation rules
- This repo has no `.cursor` or `.cursorrules` directory and no GitHub Copilot instructions file at `.github/copilot-instructions.md`. If you add Cursor or Copilot rules, append them to this AGENTS.md and reference the file path.

7) Safe-editing checklist for automated agents (must follow)
- Run `stylua` on changed files before creating a commit.
- Use `pcall(require, ...)` for optional plugin imports and avoid changing user runtime globals.
- Do not run destructive git commands; only create commits when asked. If committing, include a short message describing intent.
- If you touch `requirements.sh`, `lazy-lock.json`, or plugin lists, run a headless plugin sync and verify `nvim` starts without runtime errors.

8) Common commands summary

- format a single file: `stylua path/to/file.lua --config-path .stylua.toml`
- format whole repo: `stylua . --config-path .stylua.toml`
- lint (optional): `luacheck .`
- install/sync plugins headless: `nvim --headless -c "lua require('lazy').sync()" -c q`
- run plenary test file: `nvim --headless -c "lua require('plenary.test_harness').test_file('tests/foo_spec.lua', {minimal_init = true})" -c q`

If anything here is unclear or you need to run a command that could be destructive (push, force-update, reset), ask for explicit approval.
