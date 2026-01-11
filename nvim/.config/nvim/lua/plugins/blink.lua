local hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'LuaSnip' and (kind == 'install' or kind == 'update') then
    vim.notify('Building LuaSnip jsregexp...', vim.log.levels.INFO)
    local obj = vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path }):wait()
    if obj.code == 0 then
      vim.notify('LuaSnip jsregexp built successfully.', vim.log.levels.INFO)
    else
      vim.notify('Error building LuaSnip jsregexp.', vim.log.levels.ERROR)
    end
  end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

vim.pack.add {
  'https://github.com/rafamadriz/friendly-snippets.git',
  {
    src = 'https://github.com/L3MON4D3/LuaSnip.git',
    version = vim.version.range '^2',
  },
  {
    src = 'https://github.com/saghen/blink.cmp.git',
    version = vim.version.range '^1',
  },
}

local group = vim.api.nvim_create_augroup('BlinkCmpLazyLoad', { clear = true })
vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
  pattern = '*',
  once = true,
  group = group,
  callback = function()
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snippets' } }
    require('blink-cmp').setup {
      sources = {
        per_filetype = {
          sql = { 'snippets', 'dadbod', 'buffer' },
          mysql = { 'snippets', 'dadbod', 'buffer' },
        },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          dadbod = { module = 'vim_dadbod_completion.blink' },
        },
      },
      snippets = { preset = 'luasnip' },
    }
  end,
})
