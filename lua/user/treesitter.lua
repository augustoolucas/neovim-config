local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  branch = "main",
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.config").setup {
    ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "python", "yaml" },
    highlight = { enable = true },
    indent = { enable = true },
  }
end

return M
