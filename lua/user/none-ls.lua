local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim"
  },
}

function M.config()
  local null_ls = require "null-ls"

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, noremap = true, silent = true }
      -- Atalho para ver documentação flutuante (Hover)
      -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      -- Atalho para Ações de Código (Code Actions), crucial para o none-ls
      --vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      -- Adicione outros atalhos de LSP que você usa (gd, gr, etc.)
    end

  null_ls.setup {
    debug = false,
    sources = {
      formatting.stylua,
      formatting.prettier,
      formatting.isort,
      formatting.black,
      -- formatting.prettier.with {
      --   extra_filetypes = { "toml" },
      --   -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      -- },
      -- formatting.eslint,
      diagnostics.pylint,
      null_ls.builtins.completion.spell,
    },
    on_attach = on_attach,
  }
end

return M
