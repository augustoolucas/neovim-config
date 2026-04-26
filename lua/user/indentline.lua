local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  -- Removemos a linha "commit = ..." para o Lazy baixar a versão mais atual (v3)
  main = "ibl",
}

function M.config()
  local icons = require "user.icons"

  -- Na versão 3, o nome do módulo mudou para 'ibl' e as opções foram simplificadas
  require("ibl").setup {
    indent = { 
      char = icons.ui.LineMiddle,
    },
    scope = { 
      enabled = true,
      char = icons.ui.LineMiddle,
    },
    exclude = {
      filetypes = {
        "help",
        "startify",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "text",
        "alpha",
        "toggleterm",
        "mason",
      },
      buftypes = { "terminal", "nofile", "quickfix", "prompt" },
    },
  }
end

return M
