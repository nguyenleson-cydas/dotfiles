-- Prevent loading twice
if vim.g.loaded_cursor_agent then
  return
end
vim.g.loaded_cursor_agent = true

-- Check Neovim version
if vim.fn.has("nvim-0.10") ~= 1 then
  vim.notify("cursor-agent.nvim requires Neovim >= 0.10", vim.log.levels.ERROR)
  return
end
