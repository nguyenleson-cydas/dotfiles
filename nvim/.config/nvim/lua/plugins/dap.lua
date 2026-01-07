vim.pack.add {
  'https://github.com/nvim-neotest/nvim-nio.git',
  'https://github.com/mfussenegger/nvim-dap.git',
  'https://github.com/rcarriga/nvim-dap-ui.git',
  'https://github.com/theHamsta/nvim-dap-virtual-text.git',
  'https://github.com/jay-babu/mason-nvim-dap.nvim.git',
}

require('nvim-dap-virtual-text').setup {}
require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = {
    'php',
  },
}
local dap, dapui = require 'dap', require 'dapui'
dapui.setup {}
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
dap.adapters.php = {
  type = 'executable',
  command = 'php-debug-adapter',
  args = {},
}
dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug (with local path mappings)',
    port = 9000,
    pathMappings = {
      ['/var/www/html/comet'] = '${workspaceFolder}',
    },
    log = false,
  },
}

vim.keymap.set('n', '<F5>', function()
  require('dap').continue()
end, { desc = 'Debug: Start/Continue' })

vim.keymap.set('n', '<S-F5>', function()
  require('dap').terminate()
end, { desc = 'Debug: Stop' })

vim.keymap.set('n', '<C-S-F5>', function()
  require('dap').restart()
end, { desc = 'Debug: Restart' })

vim.keymap.set('n', '<F6>', function()
  require('dap').pause()
end, { desc = 'Debug: Pause' })

vim.keymap.set('n', '<F10>', function()
  require('dap').step_over()
end, { desc = 'Debug: Step Over' })

vim.keymap.set('n', '<F11>', function()
  require('dap').step_into()
end, { desc = 'Debug: Step Into' })

vim.keymap.set('n', '<S-F11>', function()
  require('dap').step_out()
end, { desc = 'Debug: Step Out' })

vim.keymap.set('n', '<F9>', function()
  require('dap').toggle_breakpoint()
end, { desc = 'Debug: Toggle Breakpoint' })

vim.keymap.set('n', '<F7>', function()
  require('dapui').toggle()
end, { desc = 'Debug: See last session result.' })
