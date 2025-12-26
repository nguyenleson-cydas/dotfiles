vim.pack.add {
  'https://github.com/tpope/vim-dadbod.git',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
  'https://github.com/kristijanhusak/vim-dadbod-ui.git',
}

vim.keymap.set('n', '<leader>D', ':DBUIToggle<CR>', { desc = 'Toggle Dadbod UI' })
