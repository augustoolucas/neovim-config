vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "netrw",
    "Jaq",
    "qf",
    "git",
    "help",
    "man",
    "lspinfo",
    "oil",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "tsplayground",
    "",
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd "quit"
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "!vim" },
  callback = function()
    vim.cmd "checktime"
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.hl.on_yank { higroup = "Visual", timeout = 40 }
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    local status_ok, luasnip = pcall(require, "luasnip")
    if not status_ok then
      return
    end
    if luasnip.expand_or_jumpable() then
      vim.cmd [[silent! lua require("luasnip").unlink_current()]]
    end
  end,
})

local vcenter_group = vim.api.nvim_create_augroup("VCenterCursor", { clear = true })

-- Center Cursor
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "WinNew", "VimResized" }, {
  group = vcenter_group,
  pattern = "*",
  callback = function()
    vim.opt.scrolloff = math.floor(vim.fn.winheight(0) / 2)
  end,
})

-- LSP document highlight (replaces vim-illuminate)
local lsp_hl_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
  group = lsp_hl_group,
  callback = vim.lsp.buf.document_highlight,
})
vim.api.nvim_create_autocmd("CursorMoved", {
  group = lsp_hl_group,
  callback = vim.lsp.buf.clear_references,
})

-- Mode-sensitive cursor line number color (replaces modicator.nvim)
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function(args)
    local mode = args.match:match ":(%w+)" or "n"
    local colors = {
      n = "#388bfd",
      i = "#98c379",
      v = "#c678dd",
      V = "#c678dd",
      ["\22"] = "#c678dd",
      c = "#e06c75",
      R = "#e5c07b",
    }
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors[mode] or colors.n })
  end,
})

vim.api.nvim_create_autocmd({ "Colorscheme" }, {
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#388bfd" })
  end,
})
