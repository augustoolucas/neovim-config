local M = {
  "navarasu/onedark.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

M.name = "onedark"
function M.config()
  require("onedark").setup {
    highlights = {
      WinSeparator = { fg = "#191919" },
    },
    style = "dark",
  }
  require("onedark").load()
end

return M
