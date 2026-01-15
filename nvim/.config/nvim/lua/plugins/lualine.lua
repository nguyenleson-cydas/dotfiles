vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim.git',
}

local function update_git_repo_name()
  local absolute_path = vim.fn.expand '%:p'
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error == 0 and git_root and git_root ~= '' then
    -- We're in a git repo, get path relative to git root
    vim.b.git_repo_name = vim.fn.fnamemodify(absolute_path, ':s?' .. git_root .. '/??')
  else
    -- Fallback to path relative to cwd
    vim.b.git_repo_name = vim.fn.fnamemodify(absolute_path, ':.')
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'TextChangedI' }, {
  callback = update_git_repo_name,
})

require('lualine').setup {
  options = { theme = 'auto', component_separators = '', section_separators = '' },
  tabline = {
    lualine_c = {
      {
        function()
          if vim.fn.tabpagenr '$' == 1 then
            return ''
          end
          local cur = vim.fn.tabpagenr()
          local total = vim.fn.tabpagenr '$'
          return string.format('%d/%d', cur, total)
        end,
        padding = { left = 1, right = 1 },
        color = { bg = '#001419', fg = '#B28500' },
      },
      { 'filetype', icon_only = true, colored = true, padding = { left = 1, right = 0 } },
      {
        function()
          local bufname = vim.api.nvim_buf_get_name(0)

          if bufname == '' then
            return '[No Name]'
          end

          local name = vim.b.git_repo_name or vim.fn.fnamemodify(bufname, ':.')
          return vim.bo.modified and (name .. ' [+]') or name
        end,
      },
      {
        'diagnostics',
      },
      {
        'diff',
      },
    },
    lualine_x = {
      {
        'lsp_status',
      },
    },
  },
  sections = {},
  inactive_sections = {},
}
