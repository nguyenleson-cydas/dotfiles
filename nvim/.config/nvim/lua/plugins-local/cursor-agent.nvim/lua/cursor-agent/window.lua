---@class CursorAgentWindow
local M = {}

local config = require("cursor-agent.config")

---@type number|nil Chat buffer number
M.buf = nil

---@type number|nil Chat window number
M.win = nil

---Parse dimension (supports percentage like "80%" or absolute number)
---@param dim number|string
---@param total number
---@return number
local function parse_dimension(dim, total)
  if type(dim) == "string" and dim:match("%%$") then
    local percent = tonumber(dim:match("(%d+)%%"))
    return math.floor(total * percent / 100)
  end
  return tonumber(dim) or total
end

---Create or get the chat buffer
---@return number
function M.get_or_create_buf()
  if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
    return M.buf
  end

  M.buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer name safely (ignore if already exists)
  pcall(vim.api.nvim_buf_set_name, M.buf, "cursor-agent://chat")

  vim.bo[M.buf].buftype = "nofile"
  vim.bo[M.buf].bufhidden = "hide"
  vim.bo[M.buf].swapfile = false
  vim.bo[M.buf].filetype = "markdown"

  return M.buf
end

---Create a float window
---@return number
local function create_float_win()
  local cfg = config.get().window
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines - vim.o.cmdheight - 1

  local width = parse_dimension(cfg.width, editor_width)
  local height = parse_dimension(cfg.height, editor_height)

  local col = math.floor((editor_width - width) / 2)
  local row = math.floor((editor_height - height) / 2)

  local buf = M.get_or_create_buf()

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = cfg.border,
    title = " Cursor Agent ",
    title_pos = "center",
  })

  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].cursorline = true

  return win
end

---Create a split window
---@return number
local function create_split_win()
  local cfg = config.get().window
  local buf = M.get_or_create_buf()

  local cmd
  if cfg.position == "right" then
    cmd = "botright vsplit"
  elseif cfg.position == "left" then
    cmd = "topleft vsplit"
  elseif cfg.position == "top" then
    cmd = "topleft split"
  else
    cmd = "botright split"
  end

  vim.cmd(cmd)
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)

  -- Set window size
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines - vim.o.cmdheight - 1

  if cfg.position == "right" or cfg.position == "left" then
    local width = parse_dimension(cfg.width, editor_width)
    vim.api.nvim_win_set_width(win, width)
  else
    local height = parse_dimension(cfg.height, editor_height)
    vim.api.nvim_win_set_height(win, height)
  end

  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].cursorline = true

  return win
end

---Ensure input prompt line exists at the end
function M.ensure_input_line()
  local buf = M.get_or_create_buf()
  local line_count = vim.api.nvim_buf_line_count(buf)
  local last_line = vim.api.nvim_buf_get_lines(buf, line_count - 1, line_count, false)[1] or ""

  -- Add input prompt line if buffer is empty or last line is separator
  if line_count == 1 and last_line == "" then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "💬 Type your message and press Enter to send...", "" })
  elseif last_line:match("^%-%-%-") or last_line:match("^✅") or last_line:match("^❌") then
    -- Add input line after separator
    vim.api.nvim_buf_set_lines(
      buf,
      line_count,
      line_count,
      false,
      { "", "💬 Type your message and press Enter to send...", "" }
    )
  end
end

---Open the chat window
---@return number win Window handle
function M.open()
  -- If window already exists and is valid, focus it
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_set_current_win(M.win)
    M.ensure_input_line()
    -- Focus on input line
    local buf = M.get_or_create_buf()
    local line_count = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_win_set_cursor(M.win, { line_count, 0 })
    return M.win
  end

  local cfg = config.get().window

  if cfg.type == "float" then
    M.win = create_float_win()
  else
    M.win = create_split_win()
  end

  -- Setup keymaps for the window
  M.setup_keymaps()

  -- Ensure input line exists
  M.ensure_input_line()

  -- Focus on input line
  local buf = M.get_or_create_buf()
  local line_count = vim.api.nvim_buf_line_count(buf)
  vim.api.nvim_win_set_cursor(M.win, { line_count, 0 })

  return M.win
end

---Close the chat window
function M.close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
  M.win = nil
end

---Toggle the chat window
function M.toggle()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    M.close()
  else
    M.open()
  end
end

---Check if window is open
---@return boolean
function M.is_open()
  return M.win ~= nil and vim.api.nvim_win_is_valid(M.win)
end

---Clear the chat buffer
function M.clear()
  if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
    vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, {})
    -- Re-add input line
    M.ensure_input_line()
  end
end

---Remove input prompt line if exists
local function remove_input_line(buf)
  local line_count = vim.api.nvim_buf_line_count(buf)
  if line_count >= 2 then
    local second_last = vim.api.nvim_buf_get_lines(buf, line_count - 2, line_count - 1, false)[1] or ""
    local last = vim.api.nvim_buf_get_lines(buf, line_count - 1, line_count, false)[1] or ""
    -- Check if last 2 lines are input prompt
    if second_last:match("^💬 Type your message") and (last == "" or last:match("^%s*$")) then
      vim.api.nvim_buf_set_lines(buf, line_count - 2, line_count, false, {})
      return true
    end
  end
  return false
end

---Append text to the chat buffer
---@param text string|string[]
function M.append(text)
  local buf = M.get_or_create_buf()

  -- Remove input prompt line before appending
  remove_input_line(buf)

  -- Convert to array of lines, ensuring no newlines in individual lines
  local lines = {}
  if type(text) == "table" then
    for _, line in ipairs(text) do
      -- Split each line by newlines in case it contains embedded newlines
      for _, subline in ipairs(vim.split(tostring(line), "\n", { plain = true })) do
        table.insert(lines, subline)
      end
    end
  else
    lines = vim.split(tostring(text), "\n", { plain = true })
  end

  -- Get current line count
  local line_count = vim.api.nvim_buf_line_count(buf)
  local last_line = vim.api.nvim_buf_get_lines(buf, line_count - 1, line_count, false)[1] or ""

  -- If buffer is empty or last line is empty, set lines
  if line_count == 1 and last_line == "" then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  else
    -- Append to existing content
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, lines)
  end

  -- Re-add input prompt line
  M.ensure_input_line()

  -- Scroll to bottom if window is open
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    local new_line_count = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_win_set_cursor(M.win, { new_line_count, 0 })
  end
end

---Append text to the last line (for streaming)
---@param text string
function M.append_to_last_line(text)
  local buf = M.get_or_create_buf()
  local line_count = vim.api.nvim_buf_line_count(buf)
  local last_line = vim.api.nvim_buf_get_lines(buf, line_count - 1, line_count, false)[1] or ""

  -- Don't append to input prompt line
  if last_line:match("^💬 Type your message") then
    -- Insert before input prompt
    vim.api.nvim_buf_set_lines(buf, line_count - 1, line_count - 1, false, { text })
  else
    vim.api.nvim_buf_set_lines(buf, line_count - 1, line_count, false, { last_line .. text })
  end

  -- Scroll to bottom if window is open
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    local new_line_count = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_win_set_cursor(M.win, { new_line_count, 0 })
  end
end

---Insert text into input area (before input prompt)
---@param text string|string[] Text to insert
function M.insert_to_input(text)
  local buf = M.get_or_create_buf()
  local line_count = vim.api.nvim_buf_line_count(buf)
  
  -- Find input prompt line
  local input_line_idx = nil
  for i = line_count, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1] or ""
    if line:match("^💬 Type your message") then
      input_line_idx = i - 1
      break
    end
  end
  
  -- Convert text to lines
  local lines = type(text) == "table" and text or vim.split(text, "\n", { plain = true })
  
  if input_line_idx then
    -- Insert before input prompt
    vim.api.nvim_buf_set_lines(buf, input_line_idx, input_line_idx, false, lines)
    -- Focus on inserted text
    if M.win and vim.api.nvim_win_is_valid(M.win) then
      vim.api.nvim_win_set_cursor(M.win, { input_line_idx + #lines - 1, 0 })
    end
  else
    -- No input prompt, just append
    M.append(lines)
  end
end

---Get all text from input area (from last separator or start to input prompt)
---@param buf number Buffer number
---@return string
local function get_input_text(buf)
  local line_count = vim.api.nvim_buf_line_count(buf)
  if line_count == 0 then
    return ""
  end

  -- Get all lines from buffer
  local all_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local user_lines = {}

  -- Start from end and work backwards, collecting non-system lines
  for i = #all_lines, 1, -1 do
    local line = all_lines[i]

    -- Stop at separators or system messages
    if
      line == "---"
      or line:match("^## 🧑 User%s*$")
      or line:match("^## 🤖 Assistant%s*$")
      or line:match("^🤖 Model:")
      or line:match("^✅ Completed")
      or line:match("^## ❌")
    then
      break
    end

    -- Skip input prompt
    if not line:match("^💬") then
      table.insert(user_lines, 1, line) -- Insert at beginning to maintain order
    end
  end

  -- Remove trailing empty lines
  while #user_lines > 0 and (user_lines[#user_lines] == "" or user_lines[#user_lines]:match("^%s*$")) do
    table.remove(user_lines)
  end

  -- Remove leading empty lines
  while #user_lines > 0 and (user_lines[1] == "" or user_lines[1]:match("^%s*$")) do
    table.remove(user_lines, 1)
  end

  return table.concat(user_lines, "\n")
end

---Setup keymaps for the chat buffer
function M.setup_keymaps()
  local buf = M.get_or_create_buf()
  local keymaps = config.get().keymaps

  vim.keymap.set("n", keymaps.close, function()
    M.close()
  end, { buffer = buf, desc = "Close Cursor Agent" })

  vim.keymap.set("n", keymaps.clear, function()
    M.clear()
  end, { buffer = buf, desc = "Clear Cursor Agent chat" })

  vim.keymap.set("n", keymaps.stop, function()
    require("cursor-agent.chat").stop()
  end, { buffer = buf, desc = "Stop Cursor Agent generation" })

  -- Send message on Enter
  vim.keymap.set("n", keymaps.send, function()
    local input_text = get_input_text(buf)

    if input_text and input_text ~= "" and not input_text:match("^%s*$") then
      remove_input_line(buf)
      require("cursor-agent.chat").send(input_text)
      M.ensure_input_line()
    else
      vim.ui.input({ prompt = "💬 Prompt: " }, function(input)
        if input and input ~= "" then
          require("cursor-agent.chat").send(input)
        end
      end)
    end
  end, { buffer = buf, desc = "Send message" })

  -- Also support insert mode Enter
  vim.keymap.set("i", keymaps.send, function()
    -- Get current line
    local line = vim.api.nvim_get_current_line()
    -- Skip if it's the input prompt line
    if line:match("^💬 Type your message") then
      return
    end
    -- Exit insert mode
    vim.cmd("stopinsert")
    -- Get all input text
    local input_text = get_input_text(buf)
    -- Send if has content
    if input_text and input_text ~= "" and not input_text:match("^%s*$") then
      remove_input_line(buf)
      require("cursor-agent.chat").send(input_text)
      M.ensure_input_line()
    end
  end, { buffer = buf, desc = "Send message" })

  -- Stop generation in insert mode too
  vim.keymap.set("i", keymaps.stop, function()
    vim.cmd("stopinsert")
    require("cursor-agent.chat").stop()
  end, { buffer = buf, desc = "Stop Cursor Agent generation" })
end

return M
