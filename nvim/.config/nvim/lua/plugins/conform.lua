vim.pack.add { 'https://github.com/stevearc/conform.nvim.git' }

local projects_using_v2 = {
  vim.fn.expand '~/dev/intern/uranus/',
  vim.fn.expand '~/dev/work/uranus/',
  vim.fn.expand '~/learning/cake-crud/',
}

require('conform').setup {
  notify_on_error = true,
  notify_no_formatters = true,
}
require('conform').formatters_by_ft['lua'] = { 'stylua' }
require('conform').formatters_by_ft['javascript'] = { 'prettierd', 'prettier', stop_after_first = true }
require('conform').formatters_by_ft['sql'] = { 'sql' }
require('conform').formatters_by_ft['vue'] = { 'prettierd', 'prettier', stop_after_first = true }
require('conform').formatters_by_ft['php'] = function(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  for _, project_root in ipairs(projects_using_v2) do
    if vim.startswith(filepath, project_root) then
      return { 'php_cs_fixer_v2' }
    end
  end
  return { 'php_cs_fixer' }
end
require('conform').formatters_by_ft['markdown'] = { 'prettier', 'markdownlint-cli2', 'markdown-toc' }
require('conform').formatters_by_ft['markdown.mdx'] = { 'prettier', 'markdownlint-cli2', 'markdown-toc' }

require('conform').formatters['sql'] = function()
  return {
    command = 'sh',
    args = {
      '-c',
      '/opt/homebrew/bin/sqlfluff fix --dialect mysql "$1" || true',
      'sh',
      '$FILENAME',
    },
    stdin = false,
    require_cwd = false,
  }
end

require('conform').formatters['php_cs_fixer_v2'] = function()
  return {
    command = 'php',
    args = { vim.fn.expand '~/bin/php-cs-fixer-v2.phar', 'fix', '$FILENAME', '--config=.php_cs.dist' },
    stdin = false,
  }
end

require('conform').formatters['markdown-toc'] = function()
  return {
    condition = function(_, ctx)
      for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
        if line:find '<!%-%- toc %-%->' then
          return true
        end
      end
    end,
  }
end
require('conform').formatters['markdownlint-cli2'] = function()
  return {
    condition = function(_, ctx)
      local diag = vim.tbl_filter(function(d)
        return d.source == 'markdownlint'
      end, vim.diagnostic.get(ctx.buf))
      return #diag > 0
    end,
  }
end

vim.keymap.set('', '<leader>cf', function()
  require('conform').format({ async = false, timeout_ms = 10000, lsp_format = 'fallback' }, function(err)
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), 'v') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
      end
    end
  end)
end, { desc = 'Format code' })
