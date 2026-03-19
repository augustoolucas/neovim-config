local M = {
  "kdheepak/lazygit.nvim",
  event = "VeryLazy",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  keys = {
    { "<Esc>", "<Esc>", mode = { "n", "i", "v" }, silent = true },
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

function M.config()
  local wk = require "which-key"
  wk.add {
    { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
  }
end

return M
