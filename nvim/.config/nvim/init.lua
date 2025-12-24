vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- [[ Setting options ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.winborder = 'rounded'
vim.o.laststatus = 3

vim.g.netrw_preview = 1
vim.g.netrw_winsize = 30
vim.g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro rnu'

vim.opt.conceallevel = 2
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]
vim.opt.spell = true
vim.opt.spelllang = { 'en_us', 'cjk' }

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'markdown' },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})
-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<space>x', ':.lua<CR>')
vim.keymap.set('v', '<space>x', ':lua<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-h>', '<cmd><C-U>TmuxNavigateLeft<CR>', { silent = true, desc = 'Tmux/Vim navigate left' })
vim.keymap.set('n', '<C-j>', '<cmd><C-U>TmuxNavigateDown<CR>', { silent = true, desc = 'Tmux/Vim navigate down' })
vim.keymap.set('n', '<C-k>', '<cmd><C-U>TmuxNavigateUp<CR>', { silent = true, desc = 'Tmux/Vim navigate up' })
vim.keymap.set('n', '<C-l>', '<cmd><C-U>TmuxNavigateRight<CR>', { silent = true, desc = 'Tmux/Vim navigate right' })
vim.keymap.set('n', '<C-\\>', '<cmd><C-U>TmuxNavigatePrevious<CR>', { silent = true, desc = 'Tmux/Vim navigate previous' })

vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- Move Lines
vim.keymap.set('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
vim.keymap.set('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
vim.keymap.set('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
vim.keymap.set('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

-- better indenting
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

vim.keymap.set('n', '\\', '<cmd>Explore %:p:h<CR>', { desc = 'Open file explorer in current file directory' })

vim.keymap.set('n', '<leader>yp', function()
  local path = vim.fn.expand '%'
  vim.fn.setreg('+', path)
  vim.notify('Copied relative path: ' .. path, vim.log.levels.INFO)
end, { desc = '[Y]ank [P]ath (relative)' })

vim.keymap.set('n', '<leader>yP', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.notify('Copied absolute path: ' .. path, vim.log.levels.INFO)
end, { desc = '[Y]ank [P]ath (absolute)' })

vim.keymap.set('n', '<leader>pu', function()
  vim.pack.update(nil, { force = true })
end, { desc = '[P]ack [U]pdate' })

vim.keymap.set('n', '<leader>pc', function()
  local function get_folders(path)
    local folders = {}
    local entries = vim.fn.readdir(path)

    for _, entry in ipairs(entries) do
      local full_path = path .. '/' .. entry
      if vim.fn.isdirectory(full_path) == 1 then
        table.insert(folders, entry)
      end
    end

    return folders
  end
  local data_home = vim.fn.expand '~/.local/share'
  local pack_path = data_home .. '/nvim/site/pack/core/opt'
  local folders = get_folders(pack_path)
  vim.ui.select(folders, {
    prompt = 'Select a package to clean:',
  }, function(choice)
    if choice then
      vim.pack.del { choice }
      vim.notify('Deleted package: ' .. choice, vim.log.levels.INFO)
    else
      vim.notify('Package clean cancelled', vim.log.levels.INFO)
    end
  end)
end, { desc = '[P]ack [C]lean' })

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

-- [[ Anti-spam discipline for h,j,k,l ]]

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Configure and install plugins ]]
vim.pack.add {
  'https://github.com/lewis6991/gitsigns.nvim.git',
  'https://github.com/folke/which-key.nvim.git',
  'https://github.com/nvim-lua/plenary.nvim.git',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim.git',
  'https://github.com/nvim-telescope/telescope.nvim.git',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim.git',
  'https://github.com/folke/lazydev.nvim.git',
  'https://github.com/j-hui/fidget.nvim.git',
  'https://github.com/rafamadriz/friendly-snippets.git',
  {
    src = 'https://github.com/L3MON4D3/LuaSnip.git',
    version = vim.version.range '^2',
  },
  {
    src = 'https://github.com/saghen/blink.cmp.git',
    version = vim.version.range '^1',
  },
  'https://github.com/neovim/nvim-lspconfig.git',
  'https://github.com/mason-org/mason.nvim.git',
  'https://github.com/mason-org/mason-lspconfig.nvim.git',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim.git',
  'https://github.com/stevearc/conform.nvim.git',
  'https://github.com/mfussenegger/nvim-lint.git',
  'https://github.com/folke/todo-comments.nvim.git',
  'https://github.com/nvim-mini/mini.nvim.git',
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter.git',
    version = 'master',
  },
  'https://github.com/craftzdog/solarized-osaka.nvim.git',
  'https://github.com/christoomey/vim-tmux-navigator.git',
  'https://github.com/NMAC427/guess-indent.nvim.git',
  'https://github.com/windwp/nvim-autopairs.git',
  'https://github.com/rcarriga/nvim-dap-ui.git',
  'https://github.com/theHamsta/nvim-dap-virtual-text.git',
  'https://github.com/nvim-neotest/nvim-nio.git',
  'https://github.com/mfussenegger/nvim-dap.git',
  'https://github.com/jay-babu/mason-nvim-dap.nvim.git',
  'https://github.com/zbirenbaum/copilot.lua.git',
}

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    -- visual mode
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [r]eset hunk' })
    -- normal mode
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git hunk [I]nline preview' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '~'
    end, { desc = 'git [D]iff against last commit' })
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git [W]ord diff' })
  end,
}

require('which-key').setup {
  delay = 0,
  icons = {
    mappings = vim.g.have_nerd_font,
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = '<C-…> ',
      M = '<M-…> ',
      D = '<D-…> ',
      S = '<S-…> ',
      CR = '<CR> ',
      Esc = '<Esc> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      NL = '<NL> ',
      BS = '<BS> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },

  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>p', group = 'Vim [P]ack' },
  },
}

require('telescope').setup {
  defaults = {
    mappings = {},
    pickers = {},
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sF', function()
  builtin.find_files {
    no_ignore = false,
    hidden = true,
  }
end, { desc = '[S]earch [^F]iles, respects .gitignore' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

require('fidget').setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer some lsp support methods only in specific files
    ---@return boolean
    local function client_supports_method(client, method, bufnr)
      return client:supports_method(method, bufnr)
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

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

  -- linting
  'stylua',
  'prettierd',
  'php-cs-fixer',
  'markdownlint',
  'sqlfluff',
}

vim.lsp.config('lua_ls', lua_ls_config)
vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)

require('mason').setup {}
require('mason-lspconfig').setup {}
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

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
      return { 'php-cs-fixer' }
    end,
  },
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
  },
}

local group = vim.api.nvim_create_augroup('BlinkCmpLazyLoad', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  once = true,
  group = group,
  callback = function()
    require('luasnip.loaders.from_vscode').lazy_load()
    require('blink-cmp').setup {
      keymap = {
        -- you will need to read `:help ins-completion`
        -- See :h blink-cmp-config-keymap for defining your own keymap
        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = {
          auto_show = false,
          auto_show_delay_ms = 500,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = { enabled = true },
    }
  end,
})

local function build_luasnip()
  local data_home = vim.fn.stdpath 'data' -- usually ~/.local/share/nvim
  local dir = data_home .. '/site/pack/core/opt/LuaSnip'

  if vim.fn.isdirectory(dir) == 0 then
    vim.notify('LuaSnip directory not found: ' .. dir, vim.log.levels.WARN)
    return
  end

  vim.notify('Building LuaSnip (make install_jsregexp)...', vim.log.levels.INFO)

  vim.system({ 'make', 'install_jsregexp' }, { cwd = dir }, function(res)
    if res.code == 0 then
      vim.schedule(function()
        vim.notify('LuaSnip build completed', vim.log.levels.INFO)
      end)
    else
      vim.schedule(function()
        vim.notify('LuaSnip build failed: ' .. (res.stderr or ''), vim.log.levels.ERROR)
      end)
    end
  end)
end

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('luasnip-build-on-pack-changed', { clear = true }),
  callback = function(ev)
    -- adjust this check if the name is different in your setup
    if ev.data and ev.data.name == 'LuaSnip' and ev.data.kind == 'update' then
      build_luasnip()
    end
  end,
})

require('todo-comments').setup { signs = false }
-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup { n_lines = 500 }

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

require('solarized-osaka').setup {}

vim.cmd [[colorscheme solarized-osaka]]

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'c',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'php',
    'php_only',
    'phpdoc',
    'css',
    'scss',
  },
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby' },
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  indent = { enable = true, disable = { 'ruby' } },
}

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle nvim-treesitter updates',
  group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
  callback = function(event)
    if event.data.kind == 'update' then
      local ok = pcall(vim.cmd, 'TSUpdate')
      if ok then
        vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
      else
        vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
      end
    end
  end,
})

require('guess-indent').setup {}
require('nvim-autopairs').setup {}

local lint = require 'lint'
local phpstan = lint.linters.phpstan
local sqlfluff = lint.linters.sqlfluff
phpstan.args = {
  'analyse',
  '--error-format=json',
  '--memory-limit=1G',
  '--no-progress',
}
sqlfluff.args = { 'lint', '--format', 'json', '--dialect', 'mysql', '-' }
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
  sql = { 'sqlfluff' },
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

require('nvim-dap-virtual-text').setup {}
require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = {
    'php',
  },
}
local dap = require 'dap'
local dapui = require 'dapui'
dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}
vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
local breakpoint_icons = vim.g.have_nerd_font
    and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
  or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
for type, icon in pairs(breakpoint_icons) do
  local tp = 'Dap' .. type
  local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
  vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close
dap.adapters.php = {
  type = 'executable',
  command = 'php-debug-adapter',
  args = {},
}
dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug (with local path mappings)',
    port = 9000,
    pathMappings = {
      ['/var/www/html/comet'] = '${workspaceFolder}',
    },
    log = false,
  },
}

vim.keymap.set('n', '<F5>', function()
  require('dap').continue()
end, { desc = 'Debug: Start/Continue' })

vim.keymap.set('n', '<F1>', function()
  require('dap').step_into()
end, { desc = 'Debug: Step Into' })

vim.keymap.set('n', '<F2>', function()
  require('dap').step_over()
end, { desc = 'Debug: Step Over' })

vim.keymap.set('n', '<F3>', function()
  require('dap').step_out()
end, { desc = 'Debug: Step Out' })

vim.keymap.set('n', '<leader>b', function()
  require('dap').toggle_breakpoint()
end, { desc = 'Debug: Toggle Breakpoint' })

vim.keymap.set('n', '<leader>B', function()
  require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })

vim.keymap.set('n', '<F7>', function()
  require('dapui').toggle()
end, { desc = 'Debug: See last session result.' })

-- accept = '<M-l>',
-- accept_word = false,
-- accept_line = false,
-- next = '<M-]>',
-- prev = '<M-[>',
-- dismiss = '<C-]>',
require('copilot').setup {
  suggestion = {
    auto_trigger = true,
  },
}

-- [[ Anti-spam discipline for h,j,k,l per buffer ]]
local nav_tracker = {}
local NAV_KEYS = { 'h', 'j', 'k', 'l', '+', '-' }
local SPAM_THRESHOLD = 10
local WARNING_THRESHOLD = 7
local SPAM_WINDOW_MS = 2000
local MIN_INTERVAL_MS = 90
local BLOCK_DURATION_MS = 5000
local CLEANUP_INTERVAL_MS = 300000
local EXEMPT_FILETYPES = { 'qf', 'help', 'man', 'nofile', 'prompt' }
local EXEMPT_BUFTYPES = { 'nofile', 'quickfix', 'help', 'prompt' }
local OPPOSITE_KEYS = {
  h = 'l',
  l = 'h',
  j = 'k',
  k = 'j',
  ['+'] = '-',
  ['-'] = '+',
}

local function should_exempt(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local filetype = vim.bo[bufnr].filetype
  for _, exempt in ipairs(EXEMPT_BUFTYPES) do
    if buftype == exempt then
      return true
    end
  end
  for _, exempt in ipairs(EXEMPT_FILETYPES) do
    if filetype == exempt then
      return true
    end
  end
  return false
end

local function get_nav_state(bufnr)
  if not nav_tracker[bufnr] then
    nav_tracker[bufnr] = { count = 0, last_time = 0, blocked_until = 0, last_key = nil, last_access = vim.loop.now() }
  end
  nav_tracker[bufnr].last_access = vim.loop.now()
  return nav_tracker[bufnr]
end

local function cleanup_old_states()
  local now = vim.loop.now()
  for bufnr, state in pairs(nav_tracker) do
    if not vim.api.nvim_buf_is_valid(bufnr) or (now - state.last_access) > CLEANUP_INTERVAL_MS then
      nav_tracker[bufnr] = nil
    end
  end
end

local function on_nav_press(key)
  local bufnr = vim.api.nvim_get_current_buf()

  if should_exempt(bufnr) then
    return key
  end

  local state = get_nav_state(bufnr)
  local now = vim.loop.now()

  if now % 10000 < 100 then
    cleanup_old_states()
  end

  if state.blocked_until and now < state.blocked_until then
    local remaining = math.ceil((state.blocked_until - now) / 1000)
    if remaining % 2 == 0 then
      vim.notify(string.format('🤠 Blocked for %ds more...', remaining), vim.log.levels.WARN)
    end
    return
  end

  if vim.v.count > 0 then
    state.count = 0
    state.last_time = now
    state.last_key = nil
    return key
  end

  if state.last_key and OPPOSITE_KEYS[state.last_key] == key then
    state.count = 0
  end

  if now - state.last_time < MIN_INTERVAL_MS then
    state.last_time = now
    state.last_key = key
    return key
  end

  if now - state.last_time > SPAM_WINDOW_MS then
    state.count = 0
  end

  state.count = state.count + 1
  state.last_time = now
  state.last_key = key

  if state.count >= SPAM_THRESHOLD then
    state.blocked_until = now + BLOCK_DURATION_MS
    vim.notify('🤠 Hold it Cowboy! Blocked for 5s', vim.log.levels.WARN)
    return
  elseif state.count >= WARNING_THRESHOLD then
    local remaining = SPAM_THRESHOLD - state.count
    vim.notify(string.format('⚠️ Slow down! %d more = block', remaining), vim.log.levels.INFO)
  end

  return key
end

for _, key in ipairs(NAV_KEYS) do
  vim.keymap.set('n', key, function()
    return on_nav_press(key)
  end, { expr = true, silent = true })
end

vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { link = 'NormalFloat' })
vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { link = 'NormalFloat' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
