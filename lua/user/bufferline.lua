local M = {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

function M.config()
  require("bufferline").setup({
    options = {
      mode = "buffers",
      separator_style = "thin",
      diagnostics = "nvim_lsp",
      show_buffer_close_icons = true,
      show_close_icon = true,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "left",
          separator = true,
        },
      },
    },
  })
end

return M
