local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
}

local function definition_vsplit()
  vim.lsp.buf.definition {
    on_list = function(options)
      if not options.items or #options.items == 0 then
        return
      end
      local item = options.items[1]
      vim.cmd "vsplit"
      vim.cmd("edit " .. item.filename)
      vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
    end,
  }
end

M.definition_vsplit = definition_vsplit

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua require('user.lspconfig').definition_vsplit()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover({ border = 'rounded' })<CR>", opts)
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  keymap(bufnr, "i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help({ border = 'rounded' })<CR>", opts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)

  if client:supports_method "textDocument/inlayHint" then
    vim.lsp.inlay_hint.enable(true, { bufnr })
  end
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr }, { bufnr })
end

function M.config()
  local wk = require "which-key"
  wk.add {
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
    {
      "<leader>lf",
      "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
      desc = "Format",
    },
    { "<leader>lh", "<cmd>lua require('user.lspconfig').toggle_inlay_hints()<cr>", desc = "Hints" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
    { "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
  }

  local icons = require "user.icons"

  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "ts_ls",
    "eslint",
    "pyright",
    "bashls",
    "jsonls",
    "yamlls",
    "ruff",
  }

  local default_diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
      },
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
    config = vim.tbl_extend("force", config or {}, { border = "rounded" })
    vim.lsp.handlers.hover(_, result, ctx, config)
  end
  vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
    config = vim.tbl_extend("force", config or {}, { border = "rounded" })
    vim.lsp.handlers.signature_help(_, result, ctx, config)
  end

  -- nvim-cmp uses deprecated stylize_markdown (legacy syntax). Monkey-patch it
  -- to use the Neovim 0.12 _normalize_markdown pipeline that preserves fences
  -- and delegates code block highlighting to treesitter.
  vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
    opts = opts or {}
    local w = vim.lsp.util._make_floating_popup_size(contents, opts) or 80
    local lines = vim.lsp.util._normalize_markdown(contents, { width = w })
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.bo[bufnr].filetype = "markdown"
    vim.treesitter.start(bufnr)
  end

  -- Set global LSP defaults: cmp capabilities + on_attach for all servers
  vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = M.on_attach,
  })

  for _, server in pairs(servers) do
    local opts = {}

    local require_ok, settings = pcall(require, "user.lspsettings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", opts, settings)
    end

    vim.lsp.config(server, opts)
    vim.lsp.enable(server)
  end
end

return M
