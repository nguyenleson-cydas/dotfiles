vim.pack.add { 'https://github.com/xiyaowong/transparent.nvim' }
require('transparent').setup {
  tranfarency = true,
  exclude_groups = {
    'CursorLine',
  },
}
require('transparent').clear_prefix 'lualine'
require('transparent').clear_prefix 'Blink'
