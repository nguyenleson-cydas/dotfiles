local hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'LuaSnip' and (kind == 'install' or kind == 'update') then
    vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path })
  end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

vim.pack.add {
  'https://github.com/zbirenbaum/copilot.lua.git',
  'https://github.com/rafamadriz/friendly-snippets.git',
  {
    src = 'https://github.com/L3MON4D3/LuaSnip.git',
    version = vim.version.range '^2',
  },
  {
    src = 'https://github.com/saghen/blink.cmp.git',
    version = vim.version.range '^1',
  },
  'https://github.com/giuxtaposition/blink-cmp-copilot.git',
}

require('copilot').setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
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
      keymap = {
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
        use_nvim_cmp_as_default = false,
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
        ghost_text = {
          enabled = true,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        per_filetype = {
          sql = { 'snippets', 'dadbod', 'buffer' },
          mysql = { 'snippets', 'dadbod', 'buffer' },
        },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          dadbod = { module = 'vim_dadbod_completion.blink' },
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = 'cmdline',
          ['<Right>'] = false,
          ['<Left>'] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ':'
            end,
          },
          ghost_text = { enabled = true },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    }
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    local c = require('solarized-osaka.colors').setup()
    vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { fg = c.base01, bg = c.none })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = c.base02, bg = c.bg_float })
    vim.api.nvim_set_hl(0, 'PmenuSel', { link = 'Visual' })
  end,
})
