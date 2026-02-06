local M = {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

function M.config()
  require("codecompanion").setup({
    opts = {
      language = "Português Brasileiro",
    },
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
                default = "gpt-5-mini",
              },
              max_completion_tokens = {
                default = 1024,
              },
            },
            env = {
              api_key = "NEOVIM_AI_API_KEY",
            },
          })
        end,
      },
    },
  })
end

return M
