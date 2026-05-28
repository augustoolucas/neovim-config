# Plan: Refatoração para Neovim 0.12 (abordagem conservadora)

**Branch:** `nvim-0.12-refactor` (a partir do main atual)
**Versão alvo:** Neovim >= 0.12.0
**Critério:** só substituir plugin por nativo quando equivalente ou melhor

---

## Resumo das mudanças

### 🔴 Plugins a remover (3)

| Plugin | Arquivo | Substituído por |
|--------|---------|-----------------|
| `numToStr/Comment.nvim` | `comment.lua` | Operador nativo `gc`/`gcc` (Neovim 0.10+), treesitter-aware |
| `RRethy/vim-illuminate` | `illuminate.lua` | `vim.lsp.buf.document_highlight()` com autocmd `CursorHold` |
| `mawkler/modicator.nvim` | `extras/modicator.lua` | Autocmd `ModeChanged` + `vim.api.nvim_set_hl()` |

### 🟡 Migração parcial (2)

| Plugin | Arquivo | Ação |
|--------|---------|------|
| `neovim/nvim-lspconfig` | `lspconfig.lua` | Migrar de `lspconfig.tsserver.setup()` para `vim.lsp.config()` puro (config já usa API nova 80%) |
| `nvim-treesitter/nvim-treesitter` | `treesitter.lua` | Remover plugin, usar `vim.treesitter` nativo + `:TSInstall` manual para parsers |

### 🟢 Simplificação (2)

| Plugin | Arquivo | Ação |
|--------|---------|------|
| `j-hui/fidget.nvim` | `extras/fidget.lua` | Substituir por `vim.lsp.status()` nativo para progresso LSP |
| `nvim-cmp` | `cmp.lua` | Manter, mas remover fonte `nvim_lsp` (redundante com `vim.lsp.completion` nativo se habilitado) |

---

## 1. Remover comment.lua → operador nativo `gc`

### O que muda
- O operador `gc`/`gcc` já é built-in desde Neovim 0.10
- Treesitter resolve commentstring por linguagem automaticamente
- Remove dependência do plugin `numToStr/Comment.nvim`

### Ações
- [ ] Deletar `lua/user/comment.lua`
- [ ] Remover `spec "user.comment"` do `init.lua`
- [ ] Remover mappings do which-key em `keymaps.lua` apontando para comandos do Comment.nvim
- [ ] Opcional: adicionar mapping which-key `{ "<leader>/", "gc", desc = "Toggle comment" }` (se ainda quiser o atalho)

---

## 2. Remover illuminate.lua → nativo `vim.lsp.buf.document_highlight()`

### O que muda
- Highlight de palavra sob cursor via LSP, sem plugin externo
- Usa autocmd `CursorHold` + `CursorMoved` (padrão comum)

### Ações
- [ ] Deletar `lua/user/illuminate.lua`
- [ ] Remover `spec "user.illuminate"` do `init.lua`
- [ ] Adicionar em `lua/user/autocmds.lua`:
  ```lua
  local lsp_highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    group = lsp_highlight_group,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = lsp_highlight_group,
    callback = vim.lsp.buf.clear_references,
  })
  ```

---

## 3. Remover extras/modicator.lua → autocmd nativo

### O que muda
- Cor do número da linha muda por modo (normal, insert, visual)
- Feito com `ModeChanged` + `vim.api.nvim_set_hl()` — 20 linhas de config

### Ações
- [ ] Deletar `lua/user/extras/modicator.lua`
- [ ] Remover `spec "user.extras.modicator"` do `init.lua`
- [ ] Adicionar em `lua/user/options.lua` (ou autocmds.lua):
  ```lua
  vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = function(args)
      local mode = args.match:match(":(%w+)") or "n"
      local colors = {
        n = "#61afef",
        i = "#98c379",
        v = "#e5c07b",
        V = "#e5c07b",
        ["\22"] = "#e5c07b",
        c = "#e06c75",
        R = "#c678dd",
      }
      local color = colors[mode] or colors.n
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = color })
    end,
  })
  ```

---

## 4. Migrar lspconfig.lua → vim.lsp.config() puro

### Status atual
A config já usa `vim.lsp.config()` + `vim.lsp.enable()` para alguns servidores (pyright, ruff). Mas ainda depende de `lspconfig` para:
- `lspconfig.util` (resolver root_dir)
- Configs padrão por servidor (tsserver, lua_ls, jsonls, etc.)
- `neodev.nvim` para config do lua_ls

### Ações
- [ ] Substituir `lspconfig.tsserver.setup {}` por `vim.lsp.config.tsserver = { ... }`
- [ ] Substituir `lspconfig.lua_ls.setup {}` por `vim.lsp.config.lua_ls = { ... }`
- [ ] Remover dependência de `neodev.nvim` (configurar lua_ls manualmente)
- [ ] Manter arquivo `lua/user/lspsettings/` para overrides por linguagem
- [ ] Remover `dep = { "neodev.nvim" }` do `lspconfig.lua`
- [ ] Manter `nvim-lspconfig`? Sim, como dependência leve (fornece configs padrão)

**Decisão conservadora:** Manter `nvim-lspconfig` como dependência (fornece `cmd`, `root_markers`, etc.), mas usar só `vim.lsp.config()` e `vim.lsp.enable()` — sem chamar `lspconfig[server].setup()`.

---

## 5. Migrar treesitter.lua → nativo

### O que muda
- Remove dependência de `nvim-treesitter/nvim-treesitter`
- Highlight e indentação via APIs nativas (`vim.treesitter.start()` já automático)
- Parser management via `:TSInstall` (já built-in no 0.12)

### O que se perde
- `ensure_installed` automático → precisa instalar parsers manualmente uma vez
- `:TSUpdate` → `:TSInstall` já atualiza

### Ações
- [ ] Substituir conteúdo de `lua/user/treesitter.lua`:
  ```lua
  -- Parsers instalados via :TSInstall <lang>
  -- Lista para referência: lua, markdown, markdown_inline, bash, python,
  --   yaml, html, latex, typst, comment
  --
  -- Highlight e indent habilitados por padrão no Neovim 0.12
  ```
- [ ] Remover `branch = "main"` e `build = ":TSUpdate"` (eram do nvim-treesitter)
- [ ] Executar `:TSInstall <lang>` para cada parser após primeiro boot
- [ ] Mantido como plugin spec vazio (ou apenas com comentários) para documentar parsers

---

## 6. Simplificar fidget.nvim → vim.lsp.status() nativo

### Ações
- [ ] Deletar `lua/user/extras/fidget.lua` (ou comentar)
- [ ] Remover `spec "user.extras.fidget"` do `init.lua`
- [ ] Adicionar em `lua/user/lspconfig.lua` (se ainda relevante):
  ```lua
  vim.lsp.handlers["$/progress"] = function(...) end  -- silencia, status já mostra
  ```
- [ ] O statusline (lualine) já mostra progresso LSP via componente `diagnostics`

---

## 7. (Opcional) Simplificar cmp.lua

O `vim.lsp.completion` nativo do 0.12 oferece completion LSP sem cmp. Mas o cmp tem 9 fontes que seriam perdidas.

**Decisão conservadora:** Manter cmp. Apenas documentar que a fonte `nvim_lsp` é redundante se `vim.lsp.completion.enable()` estiver ativo.

---

## O que NÃO muda (38 plugins mantidos)

Bons motivos para manter cada um (não há substituto nativo equivalente):

| Grupo | Plugins | Razão |
|-------|---------|-------|
| AI | codecompanion, opencode, minuet, copilot, tabnine | Sem equivalente nativo |
| UI | lualine, bufferline, nvimtree, alpha, whichkey, dressing, tabby, snacks | Nativo muito básico |
| LSP/formatter | mason, none-ls, neotest | Gerenciamento de ferramentas externas |
| Git | gitsigns, neogit, lazygit, gitlinker | Operações complexas de git |
| Editor | autopairs, telescope, harpoon, toggleterm, indentline, ufo, neoscroll, vim-smoothie, eyeliner, neotab, oil, bqf, navbuddy, bigfile, cellular-automaton, lab | Funcionalidades especializadas |
| Infra | lazy, mini (icons), navic, breadcrumbs, devicons | Gerenciamento de plugins e ícones |

---

## Ordem de implementação

1. Criar branch `nvim-0.12-refactor`
2. Commit 1: Remover comment.lua, illuminate.lua, modicator.lua + ajustar init.lua e autocmds
3. Commit 2: Migrar treesitter.lua para nativo
4. Commit 3: Remover fidget.nvim → LSP status nativo
5. Commit 4: Migrar lspconfig.lua para `vim.lsp.config()` puro
6. Commit 5 (opcional): Limpar cmp.lua (documentar redundância nvim_lsp)
7. Rodar stylua em todos os arquivos modificados
8. Testar: iniciar Neovim 0.12, verificar `:checkhealth`, abrir arquivos de código

---

## Novas dependências nativas do 0.12 usadas

| API Nativa | Substitui |
|------------|-----------|
| `gc`/`gcc` operators | Comment.nvim |
| `vim.lsp.buf.document_highlight()` | vim-illuminate |
| `ModeChanged` autocmd + `nvim_set_hl` | modicator.nvim |
| `vim.treesitter` (highlight/indent nativos) | nvim-treesitter |
| `vim.lsp.config()` / `vim.lsp.enable()` | lspconfig (parcial) |
| `vim.lsp.status()` | fidget.nvim |
