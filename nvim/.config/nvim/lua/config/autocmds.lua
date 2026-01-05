vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'markdown' },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

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

vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

vim.api.nvim_create_autocmd({ 'WinEnter', 'VimResized', 'WinResized', 'WinNew', 'BufWinEnter' }, {
  callback = function()
    local width = vim.api.nvim_win_get_width(0)
    vim.wo.statusline = string.rep('─', width)
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
