local state = { buf = nil, win = nil }

local function current_daily_note_path()
  return vim.fn.expand '~/notes/main.md'
end

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
  local path = current_daily_note_path()

  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    local name = vim.api.nvim_buf_get_name(state.buf)
    if name == path then
      return state.buf
    end

    state.buf = nil
  end

  local buf = vim.api.nvim_create_buf(true, false)

  vim.api.nvim_buf_set_name(buf, path)

  vim.api.nvim_buf_call(buf, function()
    vim.cmd('silent! edit ' .. vim.fn.fnameescape(path))
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

vim.keymap.set('n', '<leader>t', toggle_daily_note, { desc = 'Toggle [T]asks (no focus)' })
