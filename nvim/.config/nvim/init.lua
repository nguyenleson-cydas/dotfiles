-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  require("config.lazy")
  vim.keymap.set({ "n", "x" }, "<C-u>", function()
    local visibleRanges = require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
    local height = visibleRanges[1][2].line - visibleRanges[1][1].line
    for i = 1, height * 2 / 3 do
      vim.api.nvim_feedkeys("k", "n", false)
    end
    -- require('vscode').action("cursorMove", { args = { to= 'viewPortCenter' } })
  end)
  vim.keymap.set({ "n", "x" }, "<C-d>", function()
    local visibleRanges = require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
    local height = visibleRanges[1][2].line - visibleRanges[1][1].line
    for i = 1, height * 2 / 3 do
      vim.api.nvim_feedkeys("j", "n", false)
    end
    -- require('vscode').action("cursorMove", { args = { to= 'viewPortCenter' } })
  end)
  vim.keymap.set({ "n", "x" }, "<C-f>", function()
    local visibleRanges = require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
    local height = visibleRanges[1][2].line - visibleRanges[1][1].line
    for i = 1, height do
      vim.api.nvim_feedkeys("j", "n", false)
    end
  end)
  vim.keymap.set({ "n", "x" }, "<C-b>", function()
    local visibleRanges = require("vscode").eval("return vscode.window.activeTextEditor.visibleRanges")
    local height = visibleRanges[1][2].line - visibleRanges[1][1].line
    for i = 1, height do
      vim.api.nvim_feedkeys("k", "n", false)
    end
  end)
else
  require("config.lazy")
  require("phpstan").setup({ events = { "BufWritePost", "BufEnter" } })
end
