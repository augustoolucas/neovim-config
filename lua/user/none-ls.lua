local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
}

function M.config()
  require('mason-null-ls').setup {
    ensure_installed = {
      'ruff',
      'prettier',
      'shfmt',
    }
  }

  local null_ls = require "null-ls"
  local sources = {
    require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
    require 'none-ls.formatting.ruff_format',
    null_ls.builtins.formatting.prettier.with { filetypes = { 'json', 'yaml', 'markdown' } },
    null_ls.builtins.formatting.shfmt.with { args = { '-i', '4' } },
  }

  local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, noremap = true, silent = true }
    end

  null_ls.setup {
    debug = false,
    sources = sources,
    on_attach = on_attach,

  }
end

return M
