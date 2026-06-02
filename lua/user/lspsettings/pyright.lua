return {
  settings = {
    python = {
      -- Use the active Python interpreter (respects activated venv)
      pythonPath = vim.fn.exepath "python",
      analysis = {
        autoImportCompletions = true,
        typeCheckingMode = "basic",
      },
    },
  },
}
