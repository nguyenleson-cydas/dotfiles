-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- User command to insert date/time timestamp
vim.api.nvim_create_user_command("InsertTimestamp", function()
  local line_count = vim.api.nvim_buf_line_count(0)
  local is_empty = line_count == 1 and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ""

  local date_time = tostring(os.date("## %Y-%m-%d %H:%M:%S"))

  if is_empty then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { date_time, "", "" })
    -- Move cursor to the third line for writing
    vim.api.nvim_win_set_cursor(0, { 3, 0 })
  else
    -- If file has content, append a new timestamped section at the end
    local last_line = vim.api.nvim_buf_get_lines(0, -2, -1, false)[1]
    -- Only add separator and timestamp if the last line is not empty
    if last_line ~= "" then
      vim.api.nvim_buf_set_lines(0, line_count, line_count, false, { "", "---", "", date_time, "", "" })
      -- Move cursor to the end
      vim.api.nvim_win_set_cursor(0, { line_count + 6, 0 })
    end
  end
end, { desc = "Insert timestamp header" })
