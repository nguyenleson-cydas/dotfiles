vim.pack.add { 'https://github.com/folke/snacks.nvim.git' }

require('snacks').setup {
  bigfile = { enabled = true },
  input = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 10000,
  },
  picker = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = false },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  styles = {
    notification = {
      wo = { wrap = true }, -- Wrap notifications
    },
  },
}
vim.keymap.set('n', '<leader><space>', function()
  Snacks.picker.smart()
end, { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader>,', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>n', function()
  Snacks.picker.notifications()
end, { desc = 'Notification History' })
vim.keymap.set('n', '<leader>fb', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>ff', function()
  Snacks.picker.files()
end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', function()
  Snacks.picker.git_files()
end, { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>fr', function()
  Snacks.picker.recent()
end, { desc = 'Recent' })
vim.keymap.set('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification History' })
vim.keymap.set({ 'n', 'v' }, '<leader>gB', function()
  Snacks.gitbrowse()
end, { desc = 'Git Browse' })
vim.keymap.set('n', '<leader>un', function()
  Snacks.notifier.hide()
end, { desc = 'Dismiss All Notifications' })
vim.keymap.set({ 'n', 't' }, '<c-/>', function()
  Snacks.terminal()
end, { desc = 'Toggle Terminal' })
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>ul'
Snacks.toggle.inlay_hints():map '<leader>uh'
