local M = {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

function M.config()
  local wk = require "which-key"
  require("codecompanion").setup {
    opts = {
      language = "Português Brasileiro",
    },
    display = {
      inline = {
        layout = "vertical",
      },
    },
    strategies = {
      chat = {
        adapter = "openai",
      },
      inline = {
        adapter = "openai",
      },
      cmd = {
        adapter = "openai",
      },
    },
    adapters = {
      http = {
        opts = {
          show_model_choices = true,
          timeout = 60000,
        },
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "gpt-5.4-nano",
              },
              max_completion_tokens = {
                default = 2048,
              },
              reasoning_effort = {
                default = "xhigh",
              },
            },
            env = {
              api_key = "PERSONAL_OPENAI_API_KEY",
            },
          })
        end,
      },
    },
  }

  wk.add {
    {
      "<leader>c",
      group = "CodeCompanion",
    },
    {
      "<leader>cc",
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "Toggle CodeCompanionChat",
    },
    {
      "<leader>ca",
      "<cmd>CodeCompanionActions<cr>",
      desc = "CodeCompanion Actions",
    },
    {
      "<leader>ci",
      "<cmd>CodeCompanion<cr>",
      desc = "CodeCompanion Inline",
    },
  }
  -- Equaliza as larguras das janelas quando o CodeCompanion abrir (evita bagunçar o layout)
  local group = vim.api.nvim_create_augroup("CodeCompanionEqualize", { clear = true })
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    pattern = { "*CodeCompanion*" },
    callback = function()
      -- schedule para garantir que a janela já esteja criada antes de ajustar
      vim.schedule(function()
        vim.cmd "wincmd ="
      end)
    end,
  })
end

return M
