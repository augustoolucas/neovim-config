local M = {}

function M.open_bottom_terminal()
  vim.cmd("split")
  vim.cmd("term bash")
  vim.cmd("wincmd J")
  vim.cmd("res " .. tostring(vim.o.lines * 0.15))
  vim.cmd("set wfh")
  vim.cmd("wincmd 10k")
  vim.cmd("wincmd 10h")
  vim.cmd("wincmd H")
  vim.cmd("vertical res 30")
  vim.cmd("wincmd 10l")
  vim.cmd("wincmd 10j")
  vim.cmd("wincmd =")
end

function M.close_bottom_terminal()
  vim.cmd("wincmd 10l")
  vim.cmd("wincmd 10j")
  vim.cmd("q")
  vim.cmd("wincmd =")
end

vim.api.nvim_create_user_command("OpenBottomTerminal", M.open_bottom_terminal, {})
vim.api.nvim_create_user_command("CloseBottomTerminal", M.close_bottom_terminal, {})

-- Opcional: Definir o atalho para o comando personalizado
vim.api.nvim_set_keymap('n', '<leader>ot', ':OpenBottomTerminal<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ct', ':CloseBottomTerminal<CR>', { noremap = true, silent = true })

return M
