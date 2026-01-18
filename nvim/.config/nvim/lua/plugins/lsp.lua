vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim.git',
  'https://github.com/neovim/nvim-lspconfig.git',
  'https://github.com/mason-org/mason.nvim.git',
  'https://github.com/mason-org/mason-lspconfig.nvim.git',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim.git',
}

local lua_ls_config = {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
}
local vue_language_server_path = vim.fn.trim(vim.fn.system 'echo "$(npm prefix -g)/lib/node_modules/@vue/language-server"')
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
local vtsls_config = {
  settings = {
    typescript = {
      tsserver = {
        maxTsServerMemory = 12288,
      },
    },
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = tsserver_filetypes,
}
local vue_ls_config = {}
local ensure_installed = {
  --lsp
  'lua-language-server',
  'html-lsp',
  'css-lsp',
  'vtsls',
  'vue-language-server',
  'intelephense',
  'dockerfile-language-server',
  --- Note: If the docker-compose-langserver doesn't startup when entering a `docker-compose.yaml` file, make sure that the filetype is `yaml.docker-compose`. You can set with: `:set filetype=yaml.docker-compose`.
  'docker-compose-language-service',
  'marksman',
  'tailwindcss',

  -- linting
  'stylua',
  'php-cs-fixer',
  'markdownlint-cli2',
  'markdown-toc',
  'sqlfluff',
  'hadolint',
  'prettier',
}

vim.lsp.config('lua_ls', lua_ls_config)
vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)

require('mason').setup {}
require('mason-lspconfig').setup {}
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

vim.keymap.set('n', '<leader>ss', function()
  Snacks.picker.lsp_symbols()
end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = 'LSP Workspace Symbols' })
