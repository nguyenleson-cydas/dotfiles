vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim.git' }

local gitsigns = require 'gitsigns'

gitsigns.setup {}

vim.keymap.set('n', ']h', function()
  if vim.wo.diff then
    vim.cmd.normal { ']h', bang = true }
  else
    gitsigns.nav_hunk 'next'
  end
end, { desc = 'Next hunk' })

vim.keymap.set('n', '[h', function()
  if vim.wo.diff then
    vim.cmd.normal { '[h', bang = true }
  else
    gitsigns.nav_hunk 'prev'
  end
end, { desc = 'Previous hunk' })

vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })

vim.keymap.set('v', '<leader>hs', function()
  gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, { desc = 'Stage hunk' })

vim.keymap.set('v', '<leader>hr', function()
  gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, { desc = 'Reset hunk' })

vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })

vim.keymap.set('n', '<leader>hb', function()
  gitsigns.blame_line { full = true }
end, { desc = 'Blame line' })

vim.keymap.set('n', '<leader>hB', function()
  gitsigns.blame()
end, { desc = 'Blame buffer' })

vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' })

vim.keymap.set('n', '<leader>hD', function()
  gitsigns.diffthis '~'
end, { desc = 'Diff this ~' })

vim.keymap.set('n', '<leader>hQ', function()
  gitsigns.setqflist 'all'
end, { desc = 'Set qflist all' })
vim.keymap.set('n', '<leader>hq', gitsigns.setqflist, { desc = 'Set qflist' })

-- Toggles
vim.keymap.set('n', '<leader>ub', gitsigns.toggle_current_line_blame, { desc = 'Toggle current line blame' })
vim.keymap.set('n', '<leader>uW', gitsigns.toggle_word_diff, { desc = 'Toggle word diff' })
