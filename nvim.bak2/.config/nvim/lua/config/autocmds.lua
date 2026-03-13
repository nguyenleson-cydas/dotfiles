-- Fix conceallevel for json files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- show cursorline only in active window
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

vim.api.nvim_create_autocmd({ 'WinEnter', 'VimResized', 'WinResized', 'WinNew', 'BufWinEnter' }, {
  callback = function()
    local width = vim.api.nvim_win_get_width(0)
    vim.o.statusline = string.rep('─', width)
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Create an autocmd that runs on both VimEnter and ColorScheme events
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   group = vim.api.nvim_create_augroup('CustomHighlights', { clear = true }),
--   pattern = '*', -- Apply to all color schemes
--   callback = function()
--     vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#586E75' })
--     vim.api.nvim_set_hl(0, 'cursorline', { bg = '#103956' })
--     vim.api.nvim_set_hl(0, 'cursorlinenr', { fg = '#B58900', bold = true })
--     vim.api.nvim_set_hl(0, 'visual', { bg = '#1B6497' })
--     vim.api.nvim_set_hl(0, 'whichkeyborder', { link = 'floatborder' })
--     vim.api.nvim_set_hl(0, 'snackspickerborder', { link = 'floatborder' })
--     vim.api.nvim_set_hl(0, 'blinkcmpmenuborder', { link = 'floatborder' })
--     vim.api.nvim_set_hl(0, 'blinkcmpdocborder', { link = 'floatborder' })
--     vim.api.nvim_set_hl(0, 'blinkcmpmenuselection', { link = 'CursorLine' })
--     vim.api.nvim_set_hl(0, 'StatusLine', { link = 'Normal' })
--     vim.api.nvim_set_hl(0, 'StatusLineNC', { link = 'Normal' })
--   end,
-- })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('HighlightOnYank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = 'Highlight yanked text',
})
