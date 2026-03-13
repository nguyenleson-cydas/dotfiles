-- =========================
-- 0) Basic options
-- =========================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.foldlevelstart = 99
-- インデント設定
vim.opt.autoindent = true -- 前の行のインデントを継承
vim.opt.smartindent = true -- 新しい行でインデントを自動挿入
vim.opt.tabstop = 2 -- タブ幅を4スペースに設定
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- インデントの幅を4スペースに設定
vim.opt.expandtab = true -- タブの代わりにスペースを使用
vim.opt.colorcolumn = '80,120'

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.fn.line '\'"' > 0 and vim.fn.line '\'"' <= vim.fn.line '$' then vim.cmd 'normal! g`"' end
  end,
})

-- =========================
-- 1) Bootstrap lazy.nvim
-- =========================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local repo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    repo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then error('Failed to clone lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- 2) Plugins
-- =========================
require('lazy').setup {
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'lua_ls', 'stylua' },
    },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      {
        'neovim/nvim-lspconfig',
        config = function()
          vim.lsp.config('lua_ls', {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' },
                },
                workspace = {
                  checkThirdParty = false,
                },
              },
            },
          })
        end,
      },
    },
  },
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }

      -- Auto-install parsers you need
      require('nvim-treesitter').install {
        'lua',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
        'vue',
        'css',
        'scss',
        'html',
        'php',
        'phpdoc',
        'php_only',
        'json',
        'yaml',
        'toml',
        'bash',
        'markdown',
        'markdown_inline',
        'sql',
      }

      -- Enable highlight + folds using built-in Neovim features
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local filetype = args.match
          local lang = vim.treesitter.language.get_lang(filetype)
          if vim.treesitter.language.add(lang) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldmethod = 'expr'
            vim.treesitter.start()
          end
        end,
      })
    end,
  },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        current_line_blame = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc }) end

          map('n', ']h', gs.next_hunk, 'Next hunk')
          map('n', '[h', gs.prev_hunk, 'Prev hunk')
          map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
          map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
          map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
          map('n', '<leader>hb', gs.blame_line, 'Blame line')
        end,
      }
    end,
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        '<leader>f',
        function() require('conform').format { async = true } end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run the first available formatter
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        vue = { 'prettierd', 'prettier', stop_after_first = true },
        php = { 'php_cs_fixer_v2' },
      },
      formatters = {
        php_cs_fixer_v2 = {
          command = 'php',
          args = { vim.fn.expand '~/bin/php-cs-fixer-v2.phar', 'fix', '$FILENAME', '--config=.php_cs.dist' },
          stdin = false,
        },
      },
    },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      keymap = { preset = 'default' },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'smartpde/telescope-recent-files' },
    },
    config = function()
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
      vim.keymap.set('n', '<leader>fr', function() require('telescope').extensions.recent_files.pick() end, { desc = 'Telescope help tags' })

      require('telescope').load_extension 'fzf'
    end,
  },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-sleuth' },
  {
    'nkxxll/ghostty-default-style-dark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('ghostty-default-style-dark').setup {
        transparent = true,
      }
      vim.cmd.colorscheme 'ghostty-default-style-dark'
    end,
  },
  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require 'lint'
      local phpstan = lint.linters.phpstan
      phpstan.args = {
        'analyse',
        '--error-format=json',
        '--memory-limit=1G',
        '--no-progress',
      }
      lint.linters_by_ft = {
        php = { 'phpstan' },
      }
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then lint.try_lint() end
        end,
      })
    end,
  },
}
