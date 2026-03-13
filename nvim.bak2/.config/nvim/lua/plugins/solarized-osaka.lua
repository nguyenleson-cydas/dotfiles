vim.pack.add { 'https://github.com/craftzdog/solarized-osaka.nvim.git' }

require('solarized-osaka').setup {
  transparent = true,
  sidebars = 'transparent', -- style for sidebars, see below
  floats = 'transparent', -- style for floating windows
}

-- vim.cmd [[colorscheme solarized-osaka]]
