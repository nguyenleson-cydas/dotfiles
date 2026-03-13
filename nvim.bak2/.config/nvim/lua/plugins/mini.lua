vim.pack.add { 'https://github.com/nvim-mini/mini.nvim.git' }

require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
require('mini.pairs').setup()
require('mini.extra').setup()
local hipatterns = require 'mini.hipatterns'
hipatterns.setup {
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}
require('mini.misc').setup()
MiniMisc.setup_restore_cursor()
