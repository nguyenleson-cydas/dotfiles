vim.pack.add { 'https://github.com/xiyaowong/transparent.nvim' }
require('transparent').setup {
  exclude_groups = {
    'CursorLine',
    'blinkcmpmenuselection',
  },
  extra_groups = {
    'NormalFloat',
    'FloatTitle',
    'SnacksPickerPreviewTitle',
    'SnacksPickerInputCursorLine',
  },
}
require('transparent').clear_prefix 'lualine'
require('transparent').clear_prefix 'Blink'
require('transparent').clear_prefix 'tabline'

vim.g.transparent_enabled = true
