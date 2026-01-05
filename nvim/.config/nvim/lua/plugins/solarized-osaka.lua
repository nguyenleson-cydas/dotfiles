vim.pack.add { 'https://github.com/craftzdog/solarized-osaka.nvim.git' }

require('solarized-osaka').setup {
  transparent = true,
}

vim.cmd [[colorscheme solarized-osaka]]
