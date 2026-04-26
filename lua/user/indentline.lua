local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
}

function M.config()
  local icons = require "user.icons"

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
