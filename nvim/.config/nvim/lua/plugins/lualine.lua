vim.pack.add {
  'https://github.com/nvim-tree/nvim-web-devicons.git',
  'https://github.com/nvim-lualine/lualine.nvim.git',
}

require('lualine').setup {
  sections = {},
  inactive_sections = {},
  options = { theme = 'auto', component_separators = '', section_separators = '' },
  winbar = {
    lualine_c = {
      { 'filetype', icon_only = true, colored = true, padding = { left = 2, right = 0 } },
      { 'filename', path = 0, padding = { left = 1, right = 1 } },
      {
        function()
          return vim.b.repo_root_rel_dir or ''
        end,
        color = 'Comment',
      },
      {
        'diagnostics',
        symbols = { error = '󰅚 ', warn = '󰀪 ', info = '󰋽 ', hint = '󰌶 ' },
      },
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
      },
      {
        function()
          return '┊  ' .. vim.api.nvim_win_get_number(0)
        end,
        color = 'DevIconWindows',
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      { 'filetype', icon_only = true, colored = false, padding = { left = 2, right = 0 } },
      { 'filename', path = 0, padding = { left = 1, right = 1 } },
      {
        function()
          return vim.b.repo_root_rel_dir or ''
        end,
        color = { fg = '#576D74', bg = '#002C38', gui = 'italic' },
      },
      {
        'diagnostics',
        symbols = { error = '󰅚 ', warn = '󰀪 ', info = '󰋽 ', hint = '󰌶 ' },
        colored = false,
      },
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        colored = false,
      },
      {
        function()
          return '┊  ' .. vim.api.nvim_win_get_number(0)
        end,
        color = { fg = '#576D74', bg = '#002C38' },
      },
    },
  },
}

--  Flickering cursor from lualine update, credit: https://www.reddit.com/r/neovim/comments/1gwgl0k/flickering_cursor_from_lualine_update/
local function update_git_repo_name_async()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then
    vim.b.repo_root_rel_dir = ''
    return
  end

  local abs_path = vim.fn.fnamemodify(bufname, ':p')
  if abs_path == '' then
    vim.b.repo_root_rel_dir = ''
    return
  end

  -- Normalize paths for comparison (remove trailing slashes)
  abs_path = abs_path:gsub('/+$', '')
  local file_dir = vim.fn.fnamemodify(abs_path, ':h')
  if file_dir == '' then
    vim.b.repo_root_rel_dir = ''
    return
  end

  -- vim.system doesn't throw errors, it returns results via callback
  vim.system({ 'git', 'rev-parse', '--show-toplevel' }, {
    text = true,
    timeout = 2000,
    cwd = file_dir,
  }, function(obj)
    vim.schedule(function()
      if not obj or obj.code ~= 0 or not obj.stdout or obj.stdout == '' then
        vim.b.repo_root_rel_dir = ''
        return
      end

      local git_root = vim.trim(obj.stdout)
      git_root = git_root:gsub('/+$', '')

      -- Escape special characters for pattern matching
      local escaped_git_root = git_root:gsub('[%^%$%(%)%.%[%]%*%+%-%?]', '%%%0')
      local relative_path = abs_path:gsub('^' .. escaped_git_root, '')

      -- If file is not in this git repo (shouldn't happen with correct cwd, but check anyway)
      if relative_path == abs_path then
        vim.b.repo_root_rel_dir = ''
        return
      end
      relative_path = relative_path:gsub('^/', '')
      local dir_part = vim.fn.fnamemodify(relative_path, ':h')
      local repo_name = vim.fn.fnamemodify(git_root, ':t')
      local repo_info
      if dir_part == '.' then
        repo_info = repo_name
      else
        repo_info = repo_name .. '/' .. dir_part
      end

      vim.b.repo_root_rel_dir = repo_info
    end)
  end)
end

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    pcall(update_git_repo_name_async)
  end,
})
