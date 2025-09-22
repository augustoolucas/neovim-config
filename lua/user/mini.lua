local M = {
  'nvim-mini/mini.nvim',
  version = '*'
}

function M.config()
  require("mini.icons").setup()
end

return M
