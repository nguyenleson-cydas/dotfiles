vim.pack.add {
  'https://github.com/nvim-neotest/nvim-nio.git',
  'https://github.com/mfussenegger/nvim-dap.git',
  'https://github.com/rcarriga/nvim-dap-ui.git',
  'https://github.com/theHamsta/nvim-dap-virtual-text.git',
  'https://github.com/jay-babu/mason-nvim-dap.nvim.git',
}

require('nvim-dap-virtual-text').setup { virt_text_pos = 'inline' }
require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = {
    'php',
  },
}
local dap = require 'dap'
local dapui = require 'dapui'
dapui.setup {}
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open {}
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close {}
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close {}
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

local widgets = require 'dap.ui.widgets'

vim.keymap.set('n', '<leader>dB', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Breakpoint Condition' })

vim.keymap.set('n', '<leader>db', function()
  dap.toggle_breakpoint()
end, { desc = 'Toggle Breakpoint' })

vim.keymap.set('n', '<leader>dc', function()
  dap.continue()
end, { desc = 'Run/Continue' })

vim.keymap.set('n', '<leader>dC', function()
  dap.run_to_cursor()
end, { desc = 'Run to Cursor' })

vim.keymap.set('n', '<leader>dg', function()
  dap.goto_()
end, { desc = 'Go to Line (No Execute)' })

vim.keymap.set('n', '<leader>di', function()
  dap.step_into()
end, { desc = 'Step Into' })

vim.keymap.set('n', '<leader>dj', function()
  dap.down()
end, { desc = 'Down' })

vim.keymap.set('n', '<leader>dk', function()
  dap.up()
end, { desc = 'Up' })

vim.keymap.set('n', '<leader>dl', function()
  dap.run_last()
end, { desc = 'Run Last' })

vim.keymap.set('n', '<leader>do', function()
  dap.step_out()
end, { desc = 'Step Out' })

vim.keymap.set('n', '<leader>dO', function()
  dap.step_over()
end, { desc = 'Step Over' })

vim.keymap.set('n', '<leader>dP', function()
  dap.pause()
end, { desc = 'Pause' })

vim.keymap.set('n', '<leader>dr', function()
  dap.repl.toggle()
end, { desc = 'Toggle REPL' })

vim.keymap.set('n', '<leader>ds', function()
  dap.session()
end, { desc = 'Session' })

vim.keymap.set('n', '<leader>dt', function()
  dap.terminate()
end, { desc = 'Terminate' })

vim.keymap.set('n', '<leader>dw', function()
  widgets.hover()
end, { desc = 'Widgets' })

vim.keymap.set('n', '<leader>du', function()
  dapui.toggle {}
end, { desc = 'Dap UI' })

vim.keymap.set({ 'n', 'x' }, '<leader>de', function()
  dapui.eval()
end, { desc = 'Eval' })
