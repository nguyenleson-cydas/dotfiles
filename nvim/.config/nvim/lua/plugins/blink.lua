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
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  once = true,
  group = group,
  callback = function()
    require('luasnip.loaders.from_vscode').lazy_load()
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

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    local c = require('solarized-osaka.colors').setup()
    vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { fg = c.base01, bg = c.none })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = c.base02, bg = c.bg_float })
    vim.api.nvim_set_hl(0, 'PmenuSel', { link = 'Visual' })
  end,
})
