# Completion & AI

## Completion (nvim-cmp)

`nvim-cmp` is the completion engine. It aggregates suggestions from multiple sources and displays them in a popup menu.

### Sources

| Source | Repo | What it provides |
|---|---|---|
| `nvim_lsp` | cmp-nvim-lsp | LSP completion results (function signatures, imports, properties) |
| `luasnip` | cmp_luasnip | Snippet expansions from LuaSnip |
| `buffer` | cmp-buffer | Words from visible buffers (focused completion) |
| `path` | cmp-path | File system path completion |
| `calc` | (built-in) | Math expression evaluation |

The `buffer` source uses a custom `get_bufnrs` to only index buffers visible in any window — this keeps results relevant.

### Completion keymaps

| Key | Context | Action |
|---|---|---|
| `<C-Space>` | Insert, Command | Trigger completion |
| `<C-n>` | Insert, Select | Next item / expand snippet / jump forward |
| `<C-p>` | Insert, Select | Previous item / jump backward |
| `<C-b>` | Insert, Command | Scroll docs down |
| `<C-f>` | Insert, Command | Scroll docs up |
| `<Tab>` | Insert | Confirm selection |
| `<C-e>` | Insert | Abort / close menu |

### Formatting

Completion items are displayed with LSP kind icons (Function = ``, Class = ``, etc.) from `user.icons`. Source names are hidden from the menu column — only the icon and text are shown.

### Snippets (LuaSnip)

LuaSnip loads snippets from `rafamadriz/friendly-snippets` (a curated collection of VSCode-style snippets). Snippets are expanded with `<C-n>` and navigated with `<C-n>`/`<C-p>`. An autocmd on `CursorHold` unlinks the current snippet to prevent stale state.

---

## AI Completions (Minuet)

Minuet provides inline AI code suggestions using the OpenCode Go API.

### Configuration

```lua
provider = "openai_compatible",
model = "deepseek-v4-flash",
end_point = "https://opencode.ai/zen/go/v1/chat/completions",
api_key = "OPENCODE_GO_API_KEY",   -- Reads from environment variable
reasoning_effort = "low",
request_timeout = 20,               -- Higher for reasoning models
context_window = 1024,
stream = false,
```

### Virtual text keymaps

AI suggestions appear as dimmed virtual text after the cursor:

| Key | Action |
|---|---|
| `<A-A>` | Accept full completion |
| `<A-a>` | Accept one line |
| `<A-z>` | Accept N lines (prompts for count) |
| `<A-[>` | Previous suggestion |
| `<A-]>` | Next suggestion |
| `<A-e>` | Dismiss |

**Why `stream = false`:** The DeepSeek V4 Flash model is a reasoning model — it generates thinking tokens before the completion. Streaming doesn't work well with this pattern.

**Why `request_timeout = 20`:** Reasoning models take 5-10 seconds to produce content. Default 10s timeout caused failures.

### Auto-trigger

Completions auto-trigger on typing (except for `"` characters per `auto_trigger_ft`). You can also manually trigger with `<A-]>` or `<A-[>`.

---

## CodeCompanion (OpenAI Chat)

CodeCompanion provides ChatGPT-style interaction within Neovim using the OpenAI API.

### Modes

| Mode | Key | Description |
|---|---|---|
| Chat | `<leader>cc` | Toggle chat sidebar |
| Inline | `<leader>ci` | Inline prompt: select text + describe change |
| Actions | `<leader>ca` | Pre-built actions menu |

### Configuration

```lua
adapter = "openai",
model = "gpt-5.4-nano",
api_key = "PERSONAL_OPENAI_API_KEY",
language = "Português Brasileiro",
timeout = 60000,
```

All strategies (chat, inline, cmd) use the same OpenAI adapter. When the CodeCompanion window opens, an autocmd calls `wincmd =` to equalize window widths.

---

## OpenCode.nvim

OpenCode provides CLI-based AI coding assistance via the OpenCode backend, integrated with snacks.nvim for its picker UI.

### Keymaps

| Key | Description |
|---|---|
| `<leader>oa` | Ask OpenCode about `@this` (current context) |
| `<leader>oe` | Execute OpenCode action (picker menu) |
| `<leader>oo` | Toggle OpenCode panel |
| `<leader>og` | Add visual range to OpenCode |
| `<leader>ol` | Add current line to OpenCode |
| `<leader>ou` | Scroll OpenCode session up |
| `<leader>od` | Scroll OpenCode session down |

### Snacks integration

OpenCode uses snacks.nvim's picker for action selection. The `<A-a>` key in the snacks picker input sends selected text to OpenCode via `opencode.snacks_picker_send()`.

---

## When to use which AI tool

| Task | Tool |
|---|---|
| Inline code suggestions as I type | Minuet |
| Chat-like debugging or explanation | CodeCompanion |
| OpenCode-specific workflows | OpenCode.nvim |
| Quick code generation | Minuet (auto-trigger) |
| Multi-file refactoring discussion | CodeCompanion chat |
