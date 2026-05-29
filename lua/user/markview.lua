local M = {
  "OXY2DEV/markview.nvim",
  ft = { "markdown", "html", "typst" },
}

function M.config()
  require("markview").setup {
    preview = {
      icon_provider = "devicons",
    },
  }
end

return M
