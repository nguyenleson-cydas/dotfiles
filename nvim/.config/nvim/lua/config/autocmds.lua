-- Fix conceallevel for json files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown' },
  callback = function()
    vim.opt_local.wrap = false
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

-- Dynamic relative number
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.o.relativenumber = false
  end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    vim.o.relativenumber = true
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

-- Create an autocmd group specifically for managing custom highlights
vim.api.nvim_create_augroup('CustomHighlights', { clear = true })

-- Create an autocmd that runs on both VimEnter and ColorScheme events
vim.api.nvim_create_autocmd({ 'VimEnter', 'ColorScheme' }, {
  group = 'CustomHighlights',
  pattern = '*', -- Apply to all color schemes
  callback = function()
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#268BD2' })
    vim.api.nvim_set_hl(0, 'WhichkeyBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'SnacksPickerBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { link = 'FloatBorder' })
    vim.api.nvim_set_hl(0, 'StatusLine', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { link = 'Normal' })
  end,
})
