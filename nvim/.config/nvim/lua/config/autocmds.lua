-- Fix conceallevel for json files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      if mark[1] > 1 then
        vim.api.nvim_win_set_cursor(0, mark)
        vim.schedule(function()
          vim.cmd 'normal! zz'
        end)
      end
    end
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
