return {
  init_options = {
    disablePullDiagnostics = true,
    python = {
      pythonPath = vim.fn.exepath "python",
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        autoImportCompletions = true,
        typeCheckingMode = "basic",
      },
    },
  },
  settings = {
    python = {
      pythonPath = vim.fn.exepath "python",
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        autoImportCompletions = true,
        typeCheckingMode = "basic",
      },
    },
  },
}
