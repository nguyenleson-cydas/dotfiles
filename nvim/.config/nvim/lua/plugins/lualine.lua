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
      { 'filename', path = 3, padding = { left = 1, right = 1 } },
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
    lualine_x = {
      {
        'lsp_status',
        icon = '', -- f013
        symbols = {
          -- Standard unicode symbols to cycle through for LSP progress:
          spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
          -- Standard unicode symbol for when LSP is done:
          done = '✓',
          -- Delimiter inserted between LSP names:
          separator = ' ',
        },
        -- List of LSP names to ignore (e.g., `null-ls`):
        ignore_lsp = {},
        -- Display the LSP name
        show_name = true,
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      { 'filename', path = 3, padding = { left = 1, right = 1 } },
    },
  },
}

