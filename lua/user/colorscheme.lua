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

  vim.schedule(function()
    local nf = vim.api.nvim_get_hl(0, { name = "NormalFloat" })
    if nf.fg then
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = nf.fg, bg = nf.bg })
    end
  end)
end

return M
