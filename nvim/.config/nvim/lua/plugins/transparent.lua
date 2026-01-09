vim.pack.add { 'https://github.com/xiyaowong/transparent.nvim' }
require('transparent').setup {
  tranfarency = true,
  exclude_groups = {
    'CursorLine',
  },
  extra_groups = {
    'NormalFloat',
  },
}
require('transparent').clear_prefix 'lualine'
require('transparent').clear_prefix 'Blink'
require('transparent').clear_prefix 'SnacksPickerInput'

vim.api.nvim_set_hl(0, "CursorLine", {bg = "#103B3D"})
vim.api.nvim_set_hl(0, "FloatBorder", {fg = "#268BD2"})
vim.api.nvim_set_hl(0, "WhichkeyBorder", {link = "FloatBorder"})
vim.api.nvim_set_hl(0, "SnacksPickerBorder", {link = "FloatBorder"})
