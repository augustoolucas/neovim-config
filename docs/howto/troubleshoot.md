# Troubleshooting

## LSP server not starting

**Symptom:** `:LspInfo` shows no client attached, no diagnostics.

**Check:**
1. Is the server installed?

   ```
   :Mason
   ```

   Missing servers show as "available" (not installed). Press `i` to install.

2. Is it in the Mason ensure_installed list?

   Check `lua/user/mason.lua`. If the server isn't listed, Mason won't auto-install it.

3. Is the server in the lspconfig servers list?

   Check `lua/user/lspconfig.lua` line 57. The server must be in the `servers` table.

4. Try manual start:

   ```
   :LspStart <server-name>
   ```

   Example: `:LspStart pyright`

---
## Tree-sitter errors

**Symptom:** `Query error` or missing syntax highlighting.

**Fix:** Reinstall the parser:

```
:TSInstall <language>
```

For multiple parsers:

```
:TSInstall python lua bash markdown json yaml html css typescript
```

---
## Icons showing as boxes or question marks

**Cause:** Terminal font doesn't include Nerd Font glyphs.

**Fix:** Install a Nerd Font.

```sh
git clone https://github.com/ronniedroid/getnf
cd getnf
./install.sh
```

Then configure your terminal to use the Nerd Font (e.g., "JetBrainsMono Nerd Font" or "FiraCode Nerd Font").

---
## Completion not showing

**Check:**
1. Is `nvim-cmp` loaded? `:Lazy check` — look for nvim-cmp.

2. Are sources installed? `:Lazy check` — look for cmp-nvim-lsp, cmp-buffer, cmp-path, cmp_luasnip.

3. Is LSP attached? `:LspInfo` — should show a client for the current filetype.

4. Try manual trigger: `<C-Space>` in insert mode.

---
## Minuet not generating completions

**Check:**
1. Environment variable: `echo $OPENCODE_GO_API_KEY` — should be set.

2. Check minuet logs: `notify = "debug"` is enabled, so messages appear on completion attempts.

3. Network: the OpenCode Go API endpoint is `https://opencode.ai/zen/go/v1/chat/completions`. If you're behind a proxy, configure `http_proxy` / `https_proxy`.

4. Timeout: `request_timeout = 20` (seconds). Slow connections may need higher values.

---
## CodeCompanion not working

**Check:**
1. Environment variable: `echo $PERSONAL_OPENAI_API_KEY` — should be set.

2. Check if the adapter is correct: `:lua print(vim.inspect(require('codecompanion').config))`.

---
## Plugin not loading

**Check:**
1. Is the spec file in `init.lua`? `spec "user.<name>"` must exist.

2. Is the file in `lua/user/<name>.lua`? Must return a valid lazy spec table `M`.

3. Manual load: `:Lazy load <plugin-name>`.

4. Check load trigger: if `event = "VeryLazy"`, the plugin loads after UIEnter. If `event = "BufEnter"`, it loads on first buffer. Use `lazy = false` to force startup load for debugging.

---
## Config file changes not taking effect

**Solution:** Restart Neovim or source the changed file:

```
:luafile lua/user/<file>.lua
```

For `init.lua` changes, restart Neovim.

---
## Python provider not found

**Symptom:** `:checkhealth` shows Python provider missing.

**Fix:**
1. Create venv: `python3 -m venv ~/.neovim-venv`
2. Install pynvim: `~/.neovim-venv/bin/pip install pynvim`
3. Set g:python3_host_prog (already set in `options.lua` line 56).
