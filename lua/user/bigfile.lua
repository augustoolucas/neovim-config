-- lazy configuration of LunarVim/bigfile.nvim
local M = {
  "LunarVim/bigfile.nvim",
  event = "BufReadPre",
  opts = {
    filesize = 2,
  },
}

function M.config()
  require("bigfile").setup(M.opts)
end

return M
