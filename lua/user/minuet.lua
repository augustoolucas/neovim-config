local M = {
  "milanglacier/minuet-ai.nvim",
  dependencies = {
    'nvim-lua/plenary.nvim',
  }
}

function M.config()
  require('minuet').setup {
    provider = "openai",
    context_window = 512,
    notify = 'debug',
    provider_options = {
      openai = {
        model = "gpt-5-mini",
        api_key = "NEOVIM_AI_API_KEY",
        optional = {
          max_completion_tokens = 128,
          reasoning_effort = 'minimal',
        }
      },
    },
    virtualtext = {
      auto_trigger_ft = {'"'},
      keymap = {
        -- accept whole completion
        accept = '<A-A>',
        -- accept one line
        accept_line = '<A-a>',
        -- accept n lines (prompts for number)
        -- e.g. "A-z 2 CR" will accept 2 lines
        accept_n_lines = '<A-z>',
        -- Cycle to prev completion item, or manually invoke completion
        prev = '<A-[>',
        -- Cycle to next completion item, or manually invoke completion
        next = '<A-]>',
        dismiss = '<A-e>',
      },
    },
  }
end

return M
