vim.pack.add { 'https://github.com/folke/lazydev.nvim.git' }

require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}
