vim.pack.add { 'https://github.com/xiyaowong/transparent.nvim' }
require('transparent').setup {
  transparency = true,
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
