vim.pack.add { 'https://github.com/nvim-mini/mini.nvim.git' }

require('mini.basics').setup {
 options = {
    basic = false,
    extra_ui = true,
  },
  mappings = {
    option_toggle_prefix = '',
  },
}
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
require('mini.pairs').setup()
require('mini.extra').setup()
local hipatterns = require 'mini.hipatterns'
local hi_words = MiniExtra.gen_highlighter.words
hipatterns.setup {
  highlighters = {
    -- Highlight a fixed set of common words. Will be highlighted in any place,
    -- not like "only in comments".
    fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
    hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
    todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
    note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

    -- Highlight hex color string (#aabbcc) with that color as a background
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}
require('mini.misc').setup()
MiniMisc.setup_restore_cursor()
