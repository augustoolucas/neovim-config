local M = {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    require("chatgpt").setup()
    local home = vim.fn.expand("$HOME")
    require("chatgpt").setup({
        -- api_key_cmd = "gpg --decrypt " .. home .. "/Repos/neovim-config/openai.txt.gpg"
        api_key_cmd = "cat " .. home .. "/Repos/neovim-config/openai.txt"
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}

return M
