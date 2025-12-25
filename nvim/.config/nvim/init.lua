-- [[ Plugin Management with vim.pack ]]
vim.pack.add {
  'https://github.com/lewis6991/gitsigns.nvim.git',
  'https://github.com/folke/which-key.nvim.git',
  'https://github.com/nvim-lua/plenary.nvim.git',
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
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git',
    version = 'master',
  },
  'https://github.com/craftzdog/solarized-osaka.nvim.git',
  'https://github.com/christoomey/vim-tmux-navigator.git',
  'https://github.com/NMAC427/guess-indent.nvim.git',
  'https://github.com/rcarriga/nvim-dap-ui.git',
  'https://github.com/theHamsta/nvim-dap-virtual-text.git',
  'https://github.com/nvim-neotest/nvim-nio.git',
  'https://github.com/mfussenegger/nvim-dap.git',
  'https://github.com/jay-babu/mason-nvim-dap.nvim.git',
  'https://github.com/zbirenbaum/copilot.lua.git',
  'https://github.com/tpope/vim-dadbod.git',
  'https://github.com/folke/snacks.nvim.git',
}

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

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Configure and install plugins ]]
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

require('snacks').setup {
  bigfile = { enabled = true },
  input = { enabled = true },
  picker = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}

-- Top Pickers & Explorer
vim.keymap.set('n', '<leader><space>', function()
  Snacks.picker.smart()
end, { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader>,', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>:', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })
vim.keymap.set('n', '<leader>n', function()
  Snacks.picker.notifications()
end, { desc = 'Notification History' })
vim.keymap.set('n', '<leader>e', function()
  Snacks.explorer()
end, { desc = 'File Explorer' })

-- find
vim.keymap.set('n', '<leader>fb', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fc', function()
  Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Find Config File' })
vim.keymap.set('n', '<leader>ff', function()
  Snacks.picker.files()
end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', function()
  Snacks.picker.git_files()
end, { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>fp', function()
  Snacks.picker.projects()
end, { desc = 'Projects' })
vim.keymap.set('n', '<leader>fr', function()
  Snacks.picker.recent()
end, { desc = 'Recent' })

-- git
vim.keymap.set('n', '<leader>gb', function()
  Snacks.picker.git_branches()
end, { desc = 'Git Branches' })
vim.keymap.set('n', '<leader>gl', function()
  Snacks.picker.git_log()
end, { desc = 'Git Log' })
vim.keymap.set('n', '<leader>gL', function()
  Snacks.picker.git_log_line()
end, { desc = 'Git Log Line' })
vim.keymap.set('n', '<leader>gs', function()
  Snacks.picker.git_status()
end, { desc = 'Git Status' })
vim.keymap.set('n', '<leader>gS', function()
  Snacks.picker.git_stash()
end, { desc = 'Git Stash' })
vim.keymap.set('n', '<leader>gd', function()
  Snacks.picker.git_diff()
end, { desc = 'Git Diff (Hunks)' })
vim.keymap.set('n', '<leader>gf', function()
  Snacks.picker.git_log_file()
end, { desc = 'Git Log File' })

-- gh
vim.keymap.set('n', '<leader>gi', function()
  Snacks.picker.gh_issue()
end, { desc = 'GitHub Issues (open)' })
vim.keymap.set('n', '<leader>gI', function()
  Snacks.picker.gh_issue { state = 'all' }
end, { desc = 'GitHub Issues (all)' })
vim.keymap.set('n', '<leader>gp', function()
  Snacks.picker.gh_pr()
end, { desc = 'GitHub Pull Requests (open)' })
vim.keymap.set('n', '<leader>gP', function()
  Snacks.picker.gh_pr { state = 'all' }
end, { desc = 'GitHub Pull Requests (all)' })

-- Grep
vim.keymap.set('n', '<leader>sb', function()
  Snacks.picker.lines()
end, { desc = 'Buffer Lines' })
vim.keymap.set('n', '<leader>sB', function()
  Snacks.picker.grep_buffers()
end, { desc = 'Grep Open Buffers' })
vim.keymap.set('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function()
  Snacks.picker.grep_word()
end, { desc = 'Visual selection or word' })

-- search
vim.keymap.set('n', '<leader>s"', function()
  Snacks.picker.registers()
end, { desc = 'Registers' })
vim.keymap.set('n', '<leader>s/', function()
  Snacks.picker.search_history()
end, { desc = 'Search History' })
vim.keymap.set('n', '<leader>sa', function()
  Snacks.picker.autocmds()
end, { desc = 'Autocmds' })
vim.keymap.set('n', '<leader>sb', function()
  Snacks.picker.lines()
end, { desc = 'Buffer Lines' })
vim.keymap.set('n', '<leader>sc', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })
vim.keymap.set('n', '<leader>sC', function()
  Snacks.picker.commands()
end, { desc = 'Commands' })
vim.keymap.set('n', '<leader>sd', function()
  Snacks.picker.diagnostics()
end, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sD', function()
  Snacks.picker.diagnostics_buffer()
end, { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>sh', function()
  Snacks.picker.help()
end, { desc = 'Help Pages' })
vim.keymap.set('n', '<leader>sH', function()
  Snacks.picker.highlights()
end, { desc = 'Highlights' })
vim.keymap.set('n', '<leader>si', function()
  Snacks.picker.icons()
end, { desc = 'Icons' })
vim.keymap.set('n', '<leader>sj', function()
  Snacks.picker.jumps()
end, { desc = 'Jumps' })
vim.keymap.set('n', '<leader>sk', function()
  Snacks.picker.keymaps()
end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sl', function()
  Snacks.picker.loclist()
end, { desc = 'Location List' })
vim.keymap.set('n', '<leader>sm', function()
  Snacks.picker.marks()
end, { desc = 'Marks' })
vim.keymap.set('n', '<leader>sM', function()
  Snacks.picker.man()
end, { desc = 'Man Pages' })
vim.keymap.set('n', '<leader>sp', function()
  Snacks.picker.lazy()
end, { desc = 'Search for Plugin Spec' })
vim.keymap.set('n', '<leader>sq', function()
  Snacks.picker.qflist()
end, { desc = 'Quickfix List' })
vim.keymap.set('n', '<leader>sR', function()
  Snacks.picker.resume()
end, { desc = 'Resume' })
vim.keymap.set('n', '<leader>su', function()
  Snacks.picker.undo()
end, { desc = 'Undo History' })
vim.keymap.set('n', '<leader>uC', function()
  Snacks.picker.colorschemes()
end, { desc = 'Colorschemes' })

-- LSP
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

-- Terminal (cwd)
vim.keymap.set({ 'n', 't' }, '<leader>fT', function()
  Snacks.terminal()
end, { desc = 'Terminal (cwd)', noremap = true })

-- Terminal (Root Dir)
vim.keymap.set({ 'n', 't' }, '<leader>ft', function()
  Snacks.terminal(nil, { cwd = vim.fn.getcwd() })
end, { desc = 'Terminal (Root Dir)', noremap = true })

-- Toggle Terminal
vim.keymap.set({ 'n', 't' }, '<c-/>', function()
  Snacks.terminal()
end, { desc = 'Toggle Terminal', noremap = true })

-- which_key_ignore (Root Dir) — normal mode
vim.keymap.set({ 'n', 't' }, '<c-_>', function()
  Snacks.terminal(nil, { cwd = vim.fn.getcwd() })
end, { desc = 'which_key_ignore', noremap = true })

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
      return { 'php_cs_fixer' }
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

require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
require('mini.icons').setup()
require('mini.pairs').setup()

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
      local max_filesize = 1.5 * 1024 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  indent = { enable = true, disable = { 'ruby' } },
}

require('nvim-treesitter.configs').setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
        -- You can also use captures from other query groups like `locals.scm`
        ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = { query = '@class.outer', desc = 'Next class start' },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
        [']o'] = '@loop.*',
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        [']s'] = { query = '@local.scope', query_group = 'locals', desc = 'Next scope' },
        [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        [']d'] = '@conditional.outer',
      },
      goto_previous = {
        ['[d'] = '@conditional.outer',
      },
    },
  },
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
