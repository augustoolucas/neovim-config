local M = {
  "hat0uma/csvview.nvim",
  ft = { "csv", "tsv" },
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
}

local function try_enable()
  local ft = vim.bo.filetype
  if ft == "csv" or ft == "tsv" then
    pcall(vim.cmd.CsvViewEnable)
  end
end

function M.config()
  require("csvview").setup {
    parser = { comments = { "#", "//" } },
    view = {
      display_mode = "border",
      header_lnum = true,
    },
    keymaps = {
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      jump_next_row = { "<Enter>", mode = { "n", "v" } },
      jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
    },
  }

  try_enable()

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("CsvViewAutoEnable", {}),
    pattern = { "*.csv", "*.tsv" },
    callback = try_enable,
  })
end

return M
