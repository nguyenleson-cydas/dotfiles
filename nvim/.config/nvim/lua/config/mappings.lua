vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<space>x', ':.lua<CR>')
vim.keymap.set('v', '<space>x', ':lua<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- Move Lines
vim.keymap.set('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
vim.keymap.set('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
vim.keymap.set('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
vim.keymap.set('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

-- better indenting
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

vim.keymap.set('n', '<leader>yp', function()
  local path = vim.fn.expand '%'
  vim.fn.setreg('+', path)
  vim.notify('Copied relative path: ' .. path, vim.log.levels.INFO)
end, { desc = '[Y]ank [P]ath (relative)' })

vim.keymap.set('n', '<leader>yP', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  vim.notify('Copied absolute path: ' .. path, vim.log.levels.INFO)
end, { desc = '[Y]ank [P]ath (absolute)' })

vim.keymap.set('n', '<leader>pu', function()
  vim.pack.update()
end, { desc = '[P]ack [U]pdate' })

vim.keymap.set('n', '<leader>pc', function()
  local function get_folders(path)
    local folders = {}
    local entries = vim.fn.readdir(path)

    for _, entry in ipairs(entries) do
      local full_path = path .. '/' .. entry
      if vim.fn.isdirectory(full_path) == 1 then
        table.insert(folders, entry)
      end
    end

    return folders
  end
  local data_home = vim.fn.expand '~/.local/share'
  local pack_path = data_home .. '/nvim/site/pack/core/opt'
  local folders = get_folders(pack_path)
  vim.ui.select(folders, {
    prompt = 'Select a package to clean:',
  }, function(choice)
    if choice then
      vim.pack.del { choice }
      vim.notify('Deleted package: ' .. choice, vim.log.levels.INFO)
    else
      vim.notify('Package clean cancelled', vim.log.levels.INFO)
    end
  end)
end, { desc = '[P]ack [C]lean' })

vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move up half page and center' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move down half page and center' })
