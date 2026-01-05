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
  'copilot-language-server',

  -- linting
  'stylua',
  'prettierd',
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

vim.keymap.set('n', 'grd', function()
  Snacks.picker.lsp_definitions()
end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'grD', function()
  Snacks.picker.lsp_declarations()
end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'grr', function()
  Snacks.picker.lsp_references()
end, { nowait = true, desc = 'References' })
vim.keymap.set('n', 'gri', function()
  Snacks.picker.lsp_implementations()
end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'gy', function()
  Snacks.picker.lsp_type_definitions()
end, { desc = 'Goto T[y]pe Definition' })
vim.keymap.set('n', 'gai', function()
  Snacks.picker.lsp_incoming_calls()
end, { desc = 'C[a]lls Incoming' })
vim.keymap.set('n', 'gao', function()
  Snacks.picker.lsp_outgoing_calls()
end, { desc = 'C[a]lls Outgoing' })
vim.keymap.set('n', '<leader>ss', function()
  Snacks.picker.lsp_symbols()
end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = 'LSP Workspace Symbols' })
vim.keymap.set('n', 'K', function()
  vim.lsp.buf.hover {
    focus = true,
    focusable = true,
    wrap = true,
    wrap_at = 100,
    max_width = 100,
    border = 'rounded',
  }
end)

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    vim.lsp.inline_completion.enable(true)

    vim.keymap.set('i', '<M-CR>', function()
      vim.lsp.inline_completion.get()
    end, {
      desc = 'Accept the current inline completion',
    })
    vim.keymap.set('i', '<M-]>', function()
      vim.lsp.inline_completion.select()
    end, {
      desc = 'Show next inline completion',
    })

    vim.keymap.set('i', '<M-[>', function()
      vim.lsp.inline_completion.select { counter = -1 }
    end, {
      desc = 'Show previous inline completion',
    })
  end,
})
