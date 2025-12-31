vim.pack.add { 'https://github.com/stevearc/conform.nvim.git' }

local projects_using_v2 = {
  vim.fn.expand '~/dev/intern/uranus/',
  vim.fn.expand '~/learning/cake-crud/',
}

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 10000,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters = {
    php_cs_fixer_v2 = {
      command = 'php',
      args = { vim.fn.expand '~/bin/php-cs-fixer-v2.phar', 'fix', '$FILENAME', '--config=.php_cs.dist' },
      stdin = false,
    },
    sql = {
      command = 'sh',
      args = {
        '-c',
        '/opt/homebrew/bin/sqlfluff fix --dialect mysql "$1" || true',
        'sh',
        '$FILENAME',
      },
      stdin = false,
      require_cwd = false,
    },
    ['markdown-toc'] = {
      condition = function(_, ctx)
        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
          if line:find '<!%-%- toc %-%->' then
            return true
          end
        end
      end,
    },
    ['markdownlint-cli2'] = {
      condition = function(_, ctx)
        local diag = vim.tbl_filter(function(d)
          return d.source == 'markdownlint'
        end, vim.diagnostic.get(ctx.buf))
        return #diag > 0
      end,
    },
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    sql = { 'sql' },
    vue = { 'prettierd', 'prettier', stop_after_first = true },
    php = function(bufnr)
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      for _, project_root in ipairs(projects_using_v2) do
        if vim.startswith(filepath, project_root) then
          return { 'php_cs_fixer_v2' }
        end
      end
      return { 'php_cs_fixer' }
    end,
    ['markdown'] = { 'prettier', 'markdownlint-cli2', 'markdown-toc' },
    ['markdown.mdx'] = { 'prettier', 'markdownlint-cli2', 'markdown-toc' },
  },
}
