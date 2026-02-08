vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim.git',
}

local function update_git_repo_dir()
  local bufname = vim.api.nvim_buf_get_name(0)

  -- Edge cases: [No Name], terminal buffers, unsaved buffers
  if not bufname or bufname == '' then
    vim.b.git_repo_dir = ''
    return
  end

  -- Absolute directory of current buffer
  local abs_dir = vim.fn.fnamemodify(bufname, ':p:h')

  -- Helper: trim
  local function trim(s)
    return (s:gsub('^%s+', ''):gsub('%s+$', ''))
  end

  -- Compute path relative to a base dir using fnamemodify substitution
  local function rel_to(path, base)
    path = vim.fn.fnamemodify(path, ':p')
    base = vim.fn.fnamemodify(base, ':p')

    -- Normalize: remove trailing slash from base
    base = base:gsub('/+$', '')
    if base == '' then
      return nil
    end

    -- If path is exactly base or under base, strip prefix
    if path == base then
      return ''
    end

    local prefix = base .. '/'
    if path:sub(1, #prefix) == prefix then
      return path:sub(#prefix + 1)
    end

    return nil
  end

  -- Prefer git root for *this file's directory* (not CWD)
  local git_root = nil
  local res = vim.system({ 'git', '-C', abs_dir, 'rev-parse', '--show-toplevel' }, { text = true }):wait()
  if res.code == 0 and res.stdout then
    local out = trim(res.stdout)
    if out ~= '' then
      git_root = out
    end
  end

  local rel_dir = nil
  if git_root then
    rel_dir = rel_to(abs_dir, git_root)
  end

  -- Fallback: relative to current working directory
  if rel_dir == nil then
    rel_dir = vim.fn.fnamemodify(abs_dir, ':.')
    if rel_dir == '.' then
      rel_dir = ''
    end
  end

  vim.b.git_repo_dir = rel_dir
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'DirChanged' }, {
  callback = update_git_repo_dir,
})

require('lualine').setup {
  options = { theme = 'catppuccin', component_separators = '', section_separators = '' },
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
      },
      { 'filetype', icon_only = true, colored = true, padding = { left = 1, right = 0 } },
      {
        'filename',
      },
      {
        function()
          return vim.b.git_repo_dir or ''
        end,
        color = function()
          local ok, palettes = pcall(require, 'catppuccin.palettes')
          if ok then
            local c = palettes.get_palette()
            return { fg = c.overlay0 }
          end
          return { fg = '#6c7086' }
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
