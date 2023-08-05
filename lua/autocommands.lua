vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
-- Automatically close tab/vim when nvim-tree is the last window in the tab
vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

--[[
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})
--]]

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
    callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd [[stopinsert]]
          vim.fn.chansend(vim.b.terminal_job_id, "exit\n")
        end)
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
  if vim.g.my_callback_has_run then
      return
  end

  local height = vim.api.nvim_win_get_height(0)
  local res = math.max(1, math.floor(height * 0.15))

  vim.cmd [[NvimTreeToggle]]
  vim.cmd [[wincmd l]]
  vim.cmd [[split]]
  vim.cmd [[term zsh]]
  vim.api.nvim_command("res " .. tostring(res))

  vim.g.my_callback_has_run = true
  vim.cmd [[wincmd p]]
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd "hi link illuminatedWord LspReferenceText"
    vim.cmd [[wincmd l]]
  end
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count >= 5000 then
      vim.cmd "IlluminatePauseBuf"
    end
  end,
})

vim.api.nvim_command("command! Z w | qa")
vim.api.nvim_command("cabbrev wqa Z")
