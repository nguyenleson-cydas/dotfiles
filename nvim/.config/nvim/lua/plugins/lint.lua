vim.pack.add { 'https://github.com/mfussenegger/nvim-lint.git' }

local lint = require 'lint'
local phpstan = lint.linters.phpstan
-- local sqlfluff = lint.linters.sqlfluff
local markdownlint = lint.linters['markdownlint-cli2']
phpstan.args = {
  'analyse',
  '--error-format=json',
  '--memory-limit=1G',
  '--no-progress',
}
-- sqlfluff.args = { 'lint', '--format', 'json', '--dialect', 'mysql', '-' }
markdownlint.args = { '--config', vim.fn.expand '~/.markdownlint-cli2.yaml', '--' }
lint.linters_by_ft = {
  markdown = { 'markdownlint-cli2' },
  -- sql = { 'sqlfluff' },
  php = { 'phpstan' },
}
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})
