# Tools

## Formatting (none-ls)

None-ls bridges external CLI formatters into the LSP workflow so `vim.lsp.buf.format()` works uniformly.

### Active formatters

| Formatter | Filetypes | Tool | Mason-installed? |
|---|---|---|---|
| `prettier` | json, yaml, markdown | prettier | Yes |
| `shfmt` | shell scripts (auto-detected) | shfmt | Yes |

`shfmt` runs with `-i 4` (4-space indentation).

### Why ruff was removed

Ruff was previously configured as a none-ls formatter. Since ruff LSP now handles `textDocument/formatting` natively, the none-ls duplicate was removed. Python formatting goes through the ruff LSP server.

---

## Testing (neotest)

Test runner for Python with inline results.

### Adapter

Only `neotest-python` is active (non-Python adapters were removed during cleanup). Uses pytest by default.

DAP support: `justMyCode = false` so debugger can step into library code.

### Keymaps

| Key | Action |
|---|---|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run current file |
| `<leader>td` | Debug test |
| `<leader>ts` | Stop |
| `<leader>ta` | Attach |

---

## Terminal (toggleterm)

Three terminal types accessible via keymaps:

| Key | Type | Size |
|---|---|---|
| `<M-1>` | Horizontal | 20% of window |
| `<M-2>` | Vertical | 40% of window |
| `<M-3>` | Float | Default size |

### Dynamic sizing

Horizontal and vertical terminals use percentage-based sizing (floats like `0.2` = 20%). The `get_dynamic_terminal_size()` function converts percentages to actual rows/columns based on the current window size.

### Layout correction

When a horizontal terminal opens, if NvimTree is visible:
1. The terminal temporarily pushes NvimTree to the far left
2. NvimTree width is preserved and restored
3. All windows are equalized with `wincmd =`

Vertical terminals call `wincmd =` to equalize after opening (prevents the terminal from taking too much space).

### Terminal keymaps

| Key | Context | Action |
|---|---|---|
| `<ESC><ESC>` | Terminal | Exit terminal mode |
| `jk` / `kj` | Terminal | Exit terminal mode |
| `<M-h/j/k/l>` | Terminal | Navigate windows |
| `<C-\>` | Normal | Toggle terminal |

On `TermEnter`, terminals start in insert mode and set up window navigation keymaps.

### Features

- `hide_numbers = true` — no line numbers in terminal
- `start_in_insert = true` — ready to type immediately
- `close_on_exit = true` — terminal closes when the process exits
- `persist_size = false` — size recalculated each open
- `float_opts.border = "rounded"` — consistent with other floating windows
- Winbar shows terminal index number
