-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "cjk" }
vim.opt.winborder = "rounded"
vim.g.lazyvim_php_lsp = "intelephense"
vim.g.trouble_lualine = false
vim.g.root_spec = { "cwd" }
