local M = {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

function M.config()
  require("codecompanion").setup({
    display = {
      inline = {
        layout = "vertical",
      }
    },
    strategies = {
      chat = {
        adapter = "openai"
      },
      inline = {
        adapter = "openai"
      },
      cmd = {
        adapter = "openai"
      },
    },
    adapters = {
      http = {
        opts = {
          show_model_choices = true,
        },
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "gpt-5.1",
              },
            },
            env = {
              api_key = "API_KEY",
            },
          })
        end,
      },
    },
  })
end

return M
