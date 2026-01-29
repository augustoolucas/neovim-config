local M = {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

local function get_gemini_api_key()
  local handle = io.popen("pass show gemini_api_key")
  if not handle then
    print("Could not execute 'pass show gemini_api_key'")
    return nil
  end
  local api_key = handle:read("*a")
  handle:close()
  if api_key then
    return string.sub(api_key, 1, string.len(api_key) - 1)
  else
    print("Could not read API key from app pass")
    return nil
  end
end

function M.config()
  require("codecompanion").setup({
    display = {
      inline = {
        layout = "vertical",
      }
    },
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
                default = "gemini-2.5-pro",
              },
            },
            env = {
              api_key = get_gemini_api_key(),
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
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "gpt-4.1",
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
