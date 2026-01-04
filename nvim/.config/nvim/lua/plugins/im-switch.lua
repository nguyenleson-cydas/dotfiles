local hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'im-switch.nvim' and (kind == 'install' or kind == 'update') then
    if not ev.data.active then
      vim.cmd.packadd 'im-switch.nvim'
    end
    require('im-switch.build').setup()
  end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

vim.pack.add { 'https://github.com/drop-stones/im-switch.nvim' }

require('im-switch').setup {
  save_im_state_events = {},
  restore_im_events = {},
  macos = {
    enabled = true,
    default_im = 'com.apple.keylayout.ABC',
  },
}
