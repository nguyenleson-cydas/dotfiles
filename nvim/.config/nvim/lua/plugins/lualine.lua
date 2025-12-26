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
      { 'filename', newfile_status = false, symbols = { unnamed = '[No Name]' }, padding = { left = 1, right = 1 } },
      {
        function()
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname == '' then
            return ''
          end
          local dir_abs = vim.fn.fnamemodify(bufname, ':p:h')
          local shortened = vim.fn.pathshorten(dir_abs)
          return '' .. ((shortened ~= '' and shortened) or dir_abs)
        end,
        color = 'Comment',
      },
      {
        function()
          return '┊'
        end,
        cond = function()
          local has_diag = vim.tbl_count(vim.diagnostic.get(0)) > 0
          local signs = vim.b.gitsigns_status_dict
          local has_diff = signs and ((signs.added or 0) + (signs.changed or 0) + (signs.removed or 0) > 0)
          return has_diag or has_diff
        end,
      },
      {
        'diagnostics',
        sections = { 'error', 'warn', 'info', 'hint' },
        symbols = { error = '󰅚 ', warn = '󰀪 ', info = '󰋽 ', hint = '󰌶 ' },
        colored = true,
      },
      {
        function()
          return '┊ '
        end,
        cond = function()
          local has_diag = vim.tbl_count(vim.diagnostic.get(0)) > 0
          local signs = vim.b.gitsigns_status_dict
          local has_diff = signs and ((signs.added or 0) + (signs.changed or 0) + (signs.removed or 0) > 0)
          return has_diag and has_diff
        end,
      },
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        colored = true,
        source = function()
          local s = vim.b.gitsigns_status_dict
          if not s then
            return nil
          end
          return { added = s.added, modified = s.changed, removed = s.removed }
        end,
      },
      {
        function()
          return ' ┊  ' .. vim.api.nvim_win_get_number(0)
        end,
        color = 'DevIconWindows',
      },
    },
  },
  inactive_winbar = {},
}
