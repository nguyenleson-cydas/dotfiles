-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("phpstan").setup({ events = { "BufWritePost", "BufEnter" } })
