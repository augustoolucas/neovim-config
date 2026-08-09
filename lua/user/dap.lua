local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
    "theHamsta/nvim-dap-virtual-text",
  },
}

function M.config()
  local dap = require "dap"
  local dapui = require "dapui"

  require("dapui").setup {}

  require("nvim-dap-virtual-text").setup { commented = true }

  local ok, dap_python = pcall(require, "dap-python")
  if ok then
    local setup_ok, setup_err = pcall(dap_python.setup, "python3")
    if not setup_ok then
      vim.notify("dap-python: " .. tostring(setup_err), vim.log.levels.WARN)
    end
  else
    vim.notify("dap-python not available. Install with: pip3 install debugpy", vim.log.levels.WARN)
  end

  -- Docker remote attach configuration
  local dap_configs = require("dap").configurations
  dap_configs.python = dap_configs.python or {}
  table.insert(dap_configs.python, {
    type = "python",
    request = "attach",
    connect = function()
      local host = vim.fn.input("Host [127.0.0.1]: ")
      host = host ~= "" and host or "127.0.0.1"
      local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
      return { host = host, port = port }
    end,
    name = "Docker: Remote Attach",
    pathMappings = function()
      local cwd = vim.fn.getcwd()
      local default_remote = "/app"
      local remote = vim.fn.input("Remote container path [" .. default_remote .. "]: ")
      remote = remote ~= "" and remote or default_remote
      return {
        {
          localRoot = cwd,
          remoteRoot = remote,
        },
      }
    end,
  })

  -- DAP signs
  vim.fn.sign_define("DapBreakpoint", { text = "󰝥", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DapStopped", {
    text = "",
    texthl = "DiagnosticSignWarn",
    linehl = "Visual",
    numhl = "DiagnosticSignWarn",
  })

  -- Auto open/close dap-ui
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  -- Keymaps via which-key under <leader>d
  local wk = require "which-key"
  wk.add {
    { "<leader>db", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() dap.continue() end, desc = "Continue / Start" },
    { "<leader>do", function() dap.step_over() end, desc = "Step Over" },
    { "<leader>di", function() dap.step_into() end, desc = "Step Into" },
    { "<leader>dO", function() dap.step_out() end, desc = "Step Out" },
    { "<leader>dq", function() dap.terminate() end, desc = "Terminate Debugger" },
    { "<leader>du", function() dapui.toggle() end, desc = "Toggle UI" },
  }
end

return M
