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
              reasoning_effort = {
                default = "low",
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

  -- Equaliza as larguras das janelas quando o CodeCompanion abrir (evita bagunçar o layout)
  local group = vim.api.nvim_create_augroup("CodeCompanionEqualize", { clear = true })
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    pattern = {"*CodeCompanion*"},
    callback = function()
      -- schedule para garantir que a janela já esteja criada antes de ajustar
      vim.schedule(function()
        vim.cmd("wincmd =")
      end)
    end,
  })
end

return M
