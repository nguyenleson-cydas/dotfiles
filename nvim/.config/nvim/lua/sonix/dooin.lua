local date = os.date '%Y-%m-%d'
local daily_note_path = vim.fn.expand '~/notes/daily/' .. date .. '.md'

local state = {
  buf = nil,
  win = nil,
}

local function create_floating_win(buf)
  local width = math.floor(vim.o.columns / 3)
  local height = math.floor(vim.o.lines / 3)

  local config = {
    relative = 'editor',
    width = width,
    height = height,
    row = 1,
    col = math.floor(vim.o.columns - width),
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, false, config)

  return win
end

local function ensure_todo_buf()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    return state.buf
  end

  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, daily_note_path)

  vim.api.nvim_buf_call(buf, function()
    vim.cmd('silent! edit ' .. vim.fn.fnameescape(daily_note_path))
  end)

  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].swapfile = false

  state.buf = buf
  return buf
end

local function toggle_daily_note()
  -- If window exists → hide it
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
    return
  end

  -- Otherwise open it (without focus)
  local buf = ensure_todo_buf()
  state.win = create_floating_win(buf)
end

vim.keymap.set('n', '<leader>dn', toggle_daily_note, { desc = 'Toggle [D]aily [N]ote (no focus)' })
