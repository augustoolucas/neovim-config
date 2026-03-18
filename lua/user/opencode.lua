local M = {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
        terminal = {},
      },
    },
  },
}

function M.config()
  local wk = require "which-key"
  ---@type opencode.Opts
  vim.g.opencode_opts = {
    -- Your configuration, if any; goto definition on the type or field for details
  }

  vim.o.autoread = true -- Required for `opts.events.reload`

  -- Recommended/example keymaps

  wk.add {
    {
      "<leader>o",
      group = "Opencode",
    },
    {
      "<leader>oa",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      desc = "Ask OpenCode...",
    },
    {
      "<leader>oe",
      function()
        require("opencode").select()
      end,
      desc = "Execute OpenCode Action...",
    },
    {
      "<leader>ot",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle OpenCode",
    },
    {
      "<leader>og",
      function()
        return require("opencode").operator "@this "
      end,
      desc = "Add range to opencode",
      mode = { "n", "x" },
      expr = true,
    },
    {
      "<leader>ol",
      function()
        return require("opencode").operator "@this " .. "_"
      end,
      desc = "Add line to opencode",
      mode = { "n" },
      expr = true,
    },
    {
      "<leader>ou",
      function()
        require("opencode").command "session.half.page.up"
      end,
      desc = "Scroll opencode up",
      mode = { "n" },
    },
    {
      "<leader>od",
      function()
        require("opencode").command "session.half.page.down"
      end,
      desc = "Scroll opencode down",
      mode = { "n" },
    },
  }

  -- increment/decrement (removido das keymaps antigas; use <leader>o+ / <leader>o-)
  wk.add {
    {
      "<leader>o+",
      "<C-a>",
      desc = "Increment under cursor",
      mode = { "n" },
    },
    {
      "<leader>o-",
      "<C-x>",
      desc = "Decrement under cursor",
      mode = { "n" },
    },
  }
end

return M
