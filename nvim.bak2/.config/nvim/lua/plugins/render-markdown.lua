vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  enabled = false,
  render_modes = true,
  preset = 'obsidian',
  completions = { lsp = { enabled = true } },
  pipe_table = { preset = 'round' },
  code = {
    width = 'block',
  },
  checkbox = {
    enabled = false,
  },
}

vim.keymap.set('n', '<leader>m', require('render-markdown').toggle, { desc = 'Toggle render-markdown globally' })
