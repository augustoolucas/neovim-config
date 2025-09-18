local M = {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

function M.config()
  require("codecompanion").setup({
    strategies = {
      chat = {
        adapter = "gemini"
      },
      inline = {
        adapter = "gemini"
      },
      cmd = {
        adapter = "gemini"
      },
    },
    adapters = {
      http = {
        opts = {
          show_model_choices = true,
        },
        qwen2 = function()
          return require("codecompanion.adapters").extend("ollama", {
            opts = {
              stream = true,
            },
            schema = {
              model = {
                default = "hf.co/unsloth/Qwen2.5-Coder-3B-Instruct-GGUF:Q4_K_M"
              },
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.0-flash",
              },
            },
            env = {
              api_key = "API_KEY",
            },
          })
        end,
        azure_openai = function()
          return require("codecompanion.adapters").extend("azure_openai", {
            schema = {
              model = {
                default = "YOUR_DEPLOYMENT_NAME",
              },
            },
            env = {
              api_key = "API_KEY",
              endpoint = "YOUR_AZURE_OPENAI_ENDPOINT",
            },
          })
        end,
      },
    },
  })
end

return M
