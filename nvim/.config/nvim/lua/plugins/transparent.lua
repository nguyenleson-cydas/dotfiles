vim.pack.add { 'https://github.com/xiyaowong/transparent.nvim' }
require('transparent').setup {
  exclude_groups = {
    'CursorLine',
  },
  extra_groups = {
    'NormalFloat',
    'FloatTitle',
    'SnacksPickerPreviewTitle',
  },
}
require('transparent').clear_prefix 'lualine'
require('transparent').clear_prefix 'Blink'

vim.g.transparent_enabled = true
