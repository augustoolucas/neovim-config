local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
}

function M.config()
  require("snacks").setup {
    input = { enabled = true },
    picker = { enabled = true },
    terminal = { enabled = true },
    notifier = { enabled = true },
  }
end

return M
