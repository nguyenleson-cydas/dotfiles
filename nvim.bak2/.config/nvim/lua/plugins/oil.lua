vim.pack.add { 'https://github.com/stevearc/oil.nvim.git' }
require('oil').setup {
  keymaps = {
    ['<CR>'] = 'actions.select',
    ['\\'] = { 'actions.parent', mode = 'n' },
    ['gv'] = { 'actions.select', opts = { vertical = true } },
    ['go'] = { 'actions.select', opts = { horizontal = true } },
    ['gs'] = { 'actions.change_sort', mode = 'n' },
    ['gx'] = 'actions.open_external',
    ['gh'] = { 'actions.toggle_hidden', mode = 'n' },
    ['gp'] = 'actions.preview',
  },
  use_default_keymaps = false,
}
vim.keymap.set('n', '\\', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
