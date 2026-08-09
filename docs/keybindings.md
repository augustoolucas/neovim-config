# Keybindings Reference

Leader key: `<Space>`

## Global

| Key | Mode | Action |
|---|---|---|
| `<leader>h` | Normal | Clear search highlights |
| `<leader>bd` | Normal | Close buffer, keep window |
| `jk` / `kj` | Insert, Visual | Escape |
| `jk` / `kj` | Terminal | Exit terminal mode |
| `<C-h/j/k/l>` | Normal | Navigate windows |
| `<C-Up/Down>` | Normal | Resize window height ±2 |
| `<C-Left/Right>` | Normal | Resize window width ±2 |
| `<S-h>` | Normal | Previous buffer |
| `<S-l>` | Normal | Next buffer |
| `<S-q>` | Normal | Close current buffer |
| `<A-j>` | Normal, Insert | Move line down |
| `<A-k>` | Normal, Insert | Move line up |
| `<A-j>` | Visual | Move selected lines down |
| `<A-k>` | Visual | Move selected lines up |

---

## `<leader>f` — Find (Telescope)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>ft` | Live grep (search text) |
| `<leader>fb` | Git branches |
| `<leader>bb` | Switch buffer |
| `<leader>fl` | Resume last search |
| `<leader>fr` | Recent files |

---

## `<leader>g` — Git

| Key | Plugin | Action |
|---|---|---|
| `<leader>gg` | LazyGit | Open LazyGit |
| `<leader>gj` | Gitsigns | Next hunk |
| `<leader>gk` | Gitsigns | Previous hunk |
| `<leader>gp` | Gitsigns | Preview hunk |
| `<leader>gr` | Gitsigns | Reset hunk |
| `<leader>gR` | Gitsigns | Reset buffer |
| `<leader>gs` | Gitsigns | Stage hunk |
| `<leader>gu` | Gitsigns | Undo stage hunk |
| `<leader>gl` | Gitsigns | Blame line |
| `<leader>gd` | Gitsigns | Diff against HEAD |

---

## `<leader>l` — LSP

| Key | Action |
|---|---|
| `<leader>la` | Code action |
| `<leader>lf` | Format buffer |
| `<leader>lh` | Toggle inlay hints |
| `<leader>li` | LSP info |
| `<leader>lj` | Next diagnostic |
| `<leader>lk` | Previous diagnostic |
| `<leader>ll` | CodeLens action |
| `<leader>lq` | Diagnostics to quickfix |
| `<leader>lr` | References (Telescope with preview) |
| `<leader>lR` | Rename symbol |

### Buffer-local LSP keymaps

| Key | Mode | Action |
|---|---|---|
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to definition in vertical split |
| `gI` | Normal | Go to implementation |
| `gr` | Normal | Telescope lsp_references (preview) |
| `K` | Normal | Hover documentation |
| `gl` | Normal | Diagnostic float |
| `<C-k>` | Insert | Signature help |

---

## `<leader>c` — CodeCompanion

| Key | Action |
|---|---|
| `<leader>cc` | Toggle chat |
| `<leader>ca` | Actions menu |
| `<leader>ci` | Inline prompt |

---

## `<leader>o` — OpenCode

| Key | Action |
|---|---|
| `<leader>oa` | Ask OpenCode |
| `<leader>oe` | Execute action |
| `<leader>oo` | Toggle panel |
| `<leader>og` | Add range to OpenCode |
| `<leader>ol` | Add line to OpenCode |
| `<leader>ou` | Scroll session up |
| `<leader>od` | Scroll session down |

---

## `<leader>t` — Test (neotest)

| Key | Action |
|---|---|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run test file |
| `<leader>td` | Debug test |
| `<leader>ts` | Stop test |
| `<leader>ta` | Attach to test |

---

## `<leader>d` — Debug (nvim-dap)

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue / start debugging |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |
| `<leader>dq` | Terminate debug session |
| `<leader>du` | Toggle dap-ui |

---

## Other `<leader>` keys

| Key | Plugin | Action |
|---|---|---|
| `<leader>e` | NvimTree | Toggle file explorer |
| `<leader>h` | Core | Clear search highlights |
| `<leader>bd` | Core | Close buffer (keep window) |

---

## Misc plugin keys

| Key | Plugin | Mode | Action |
|---|---|---|---|
| `<S-m>` | Harpoon | Normal | Mark file |
| `<Tab>` | Harpoon | Normal | Toggle quick menu |
| `<M-1>` | Toggleterm | Normal, Terminal | Horizontal terminal |
| `<M-2>` | Toggleterm | Normal, Terminal | Vertical terminal |
| `<M-3>` | Toggleterm | Normal, Terminal | Float terminal |
| `<C-\>` | Toggleterm | Normal | Toggle last terminal |
| `<ESC><ESC>` | Toggleterm | Terminal | Exit terminal mode |

---

## Minuet AI completion

| Key | Mode | Action |
|---|---|---|
| `<A-A>` | Insert | Accept full completion |
| `<A-a>` | Insert | Accept one line |
| `<A-z>` | Insert | Accept N lines |
| `<A-[>` | Insert | Previous suggestion |
| `<A-]>` | Insert | Next suggestion |
| `<A-e>` | Insert | Dismiss suggestion |
