local o = vim.o

-- Leader key
vim.g.mapleader = ' '

-- General
o.confirm = true -- Ask for confirmation instead of erroring
o.mouse = 'a' -- Enable mouse for all available modes
o.timeoutlen = 300 -- Time to wait for a mapped sequence to complete
o.undofile = true -- Enable persistent undo (see also `:h undodir`)
o.backup = false -- Don't store backup while overwriting the file
o.writebackup = false -- Don't store backup while overwriting the file

vim.cmd 'filetype plugin indent on' -- Enable all filetype plugins

-- Appearance
o.termguicolors = true -- Enable 24-bit RGB color support
o.number = true -- Show line numbers
o.relativenumber = true -- Show relative line numbers
o.cursorline = true -- Highlight current line
o.signcolumn = 'yes' -- Always show sign column (otherwise it will shift text)
o.ruler = false -- Don't show cursor position in command line
o.showmode = false -- Don't show mode in command line
o.laststatus = 0 -- Don't show status line
o.winborder = 'rounded' -- Use rounded borders for windows
o.pumblend = 0 -- Popup menu transparency
o.winblend = 0 -- Window transparency
o.fillchars = 'eob: ' -- Don't show `~` outside of buffer
o.breakindent = true -- Indent wrapped lines to match line start
o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
o.wrap = false -- Display long lines as just one line
o.conceallevel = 2 -- Hide certain text (e.g., markdown syntax)

-- Editing
o.expandtab = true -- Use spaces instead of tabs
o.tabstop = 2 -- Number of spaces that a <Tab> counts for
o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
o.shiftround = true -- Round indent to multiple of 'shiftwidth'
o.smartindent = true -- Make indenting smart
o.virtualedit = 'block' -- Allow going past the end of line in visual block mode
o.formatoptions = 'qjl1' -- Don't autoformat comments

-- Search
o.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
o.smartcase = true -- Don't ignore case when searching if pattern has upper case
o.incsearch = true -- Show search results while typing
o.infercase = true -- Infer letter cases for a richer built-in keyword completion

-- Completion
o.completeopt = 'menuone,noselect' -- Customize completions

-- Folding
o.foldlevel = 99 -- Don't fold by default

-- Spelling
o.spell = true -- Enable spell checking
vim.opt.spelllang = { 'en_us', 'cjk' } -- Set spell languages

-- Scrolling
o.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor
o.splitbelow = true -- Horizontal splits will be below
o.splitright = true -- Vertical splits will be to the right
o.splitkeep = 'screen' -- Reduce scroll during window split

-- Clipboard
o.clipboard = 'unnamedplus' -- Use system clipboard

-- Terminal
vim.cmd [[let &t_Cs = "\e[4:3m"]] -- Start underline
vim.cmd [[let &t_Ce = "\e[4:0m"]] -- End underline

-- Neovim version dependent
vim.opt.shortmess:append 'WcC' -- Reduce command line messages
