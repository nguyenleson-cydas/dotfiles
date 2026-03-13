vim.pack.add { 'https://github.com/christoomey/vim-tmux-navigator.git' }

vim.keymap.set('n', '<C-h>', '<cmd><C-U>TmuxNavigateLeft<CR>', { silent = true, desc = 'Tmux/Vim navigate left' })
vim.keymap.set('n', '<C-j>', '<cmd><C-U>TmuxNavigateDown<CR>', { silent = true, desc = 'Tmux/Vim navigate down' })
vim.keymap.set('n', '<C-k>', '<cmd><C-U>TmuxNavigateUp<CR>', { silent = true, desc = 'Tmux/Vim navigate up' })
vim.keymap.set('n', '<C-l>', '<cmd><C-U>TmuxNavigateRight<CR>', { silent = true, desc = 'Tmux/Vim navigate right' })
vim.keymap.set('n', '<C-\\>', '<cmd><C-U>TmuxNavigatePrevious<CR>', { silent = true, desc = 'Tmux/Vim navigate previous' })
