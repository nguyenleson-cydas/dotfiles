local hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
    if not ev.data.active then
      vim.cmd.packadd 'nvim-treesitter'
    end
    vim.notify('Updating Treesitter parsers...', vim.log.levels.INFO)
    vim.cmd 'TSUpdate'
    if vim.v.shell_error == 0 then
      vim.notify('Treesitter parsers updated successfully.', vim.log.levels.INFO)
    else
      vim.notify('Error updating Treesitter parsers.', vim.log.levels.ERROR)
    end
  end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter' }

require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath 'data' .. '/site',
}

require('nvim-treesitter').install { 'php', 'javascript', 'typescript', 'vue', 'css', 'scss', 'html', 'json' }

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local filetype = args.match
    local lang = vim.treesitter.language.get_lang(filetype)
    if vim.treesitter.language.add(lang) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.treesitter.start()
    end
  end,
})
