---@class CursorAgentChat
local M = {}

local api = require("cursor-agent.api")
local window = require("cursor-agent.window")

---@type string|nil Current chat ID
M.current_chat_id = nil

---@type boolean Whether we're currently streaming a response
M.is_streaming = false

---@type string Current streaming buffer
M.stream_buffer = ""

-- ============================================================================
-- Helper Functions (must be defined before use)
-- ============================================================================

---Hash a string to create a safe directory name
---@param str string
---@return string
local function hash_path(str)
  -- Simple hash function using djb2 algorithm (compatible with LuaJIT)
  local hash = 5381
  for i = 1, #str do
    local byte = string.byte(str, i)
    hash = ((hash * 33) + byte) % (2^32)
  end
  -- Convert to hex string (8 chars)
  return string.format("%08x", hash)
end

---Get current working directory
---@return string
local function get_cwd()
  return vim.fn.getcwd()
end

---Get data directory for cursor-agent (per workspace)
---@return string
local function get_data_dir()
  local cwd = get_cwd()
  -- Hash the cwd to create a safe directory name
  local cwd_hash = hash_path(cwd)
  local base_dir = vim.fn.stdpath("data") .. "/cursor-agent"
  local data_dir = base_dir .. "/workspaces/" .. cwd_hash
  vim.fn.mkdir(data_dir, "p")
  -- Store cwd mapping for reference (optional, for debugging)
  local mapping_file = base_dir .. "/workspace_mappings.json"
  local mappings = {}
  local f = io.open(mapping_file, "r")
  if f then
    local content = f:read("*a")
    f:close()
    if content and content ~= "" then
      local ok, data = pcall(vim.json.decode, content)
      if ok and type(data) == "table" then
        mappings = data
      end
    end
  end
  mappings[cwd_hash] = cwd
  local f_write = io.open(mapping_file, "w")
  if f_write then
    f_write:write(vim.json.encode(mappings))
    f_write:close()
  end
  return data_dir
end

---Get path to sessions index file
---@return string
local function get_sessions_file()
  return get_data_dir() .. "/sessions.json"
end

---Get path to chat messages file for a session
---@param chat_id string
---@return string
local function get_chat_file(chat_id)
  local chats_dir = get_data_dir() .. "/chats"
  vim.fn.mkdir(chats_dir, "p")
  -- Sanitize chat_id for filename
  local safe_id = chat_id:gsub("[^%w%-]", "_")
  return chats_dir .. "/" .. safe_id .. ".json"
end

---@class SessionInfo
---@field id string Chat ID
---@field created_at number Timestamp
---@field last_used number Timestamp
---@field title string|nil First prompt as title

---Load sessions index
---@return SessionInfo[]
local function load_sessions()
  local file = get_sessions_file()
  local f = io.open(file, "r")
  if not f then
    return {}
  end

  local content = f:read("*a")
  f:close()

  if not content or content == "" then
    return {}
  end

  local ok, data = pcall(vim.json.decode, content)
  if ok and type(data) == "table" then
    return data
  end
  return {}
end

---Save sessions index
---@param sessions SessionInfo[]
local function save_sessions(sessions)
  local file = get_sessions_file()
  local f = io.open(file, "w")
  if f then
    f:write(vim.json.encode(sessions))
    f:close()
  end
end

---Add or update session in index
---@param chat_id string
---@param title string|nil
local function update_session(chat_id, title)
  local sessions = load_sessions()
  local now = os.time()

  -- Find existing session
  local found = false
  for _, session in ipairs(sessions) do
    if session.id == chat_id then
      session.last_used = now
      if title and not session.title then
        session.title = title
      end
      found = true
      break
    end
  end

  -- Add new session
  if not found then
    table.insert(sessions, 1, {
      id = chat_id,
      created_at = now,
      last_used = now,
      title = title,
    })
  end

  -- Sort by last_used (most recent first)
  table.sort(sessions, function(a, b)
    return (a.last_used or 0) > (b.last_used or 0)
  end)

  -- Keep only last 20 sessions
  while #sessions > 20 do
    local removed = table.remove(sessions)
    -- Also remove chat file
    if removed then
      os.remove(get_chat_file(removed.id))
    end
  end

  save_sessions(sessions)
end

---@class ChatMessage
---@field role "user"|"assistant"
---@field content string
---@field timestamp number

---Load chat messages for a session
---@param chat_id string
---@return ChatMessage[]
local function load_chat_messages(chat_id)
  local file = get_chat_file(chat_id)
  local f = io.open(file, "r")
  if not f then
    return {}
  end

  local content = f:read("*a")
  f:close()

  if not content or content == "" then
    return {}
  end

  local ok, data = pcall(vim.json.decode, content)
  if ok and type(data) == "table" then
    return data
  end
  return {}
end

---Save chat messages for a session
---@param chat_id string
---@param messages ChatMessage[]
local function save_chat_messages(chat_id, messages)
  local file = get_chat_file(chat_id)
  local f = io.open(file, "w")
  if f then
    f:write(vim.json.encode(messages))
    f:close()
  end
end

---Append a message to chat history
---@param chat_id string
---@param role "user"|"assistant"
---@param content string
local function append_message(chat_id, role, content)
  local messages = load_chat_messages(chat_id)
  table.insert(messages, {
    role = role,
    content = content,
    timestamp = os.time(),
  })
  save_chat_messages(chat_id, messages)

  -- Update session title with first user message
  if role == "user" and #messages == 1 then
    local title = content:sub(1, 50)
    if #content > 50 then
      title = title .. "..."
    end
    update_session(chat_id, title)
  end
end

-- ============================================================================
-- Formatting Functions
-- ============================================================================

---Format user message
---@param prompt string
---@return string[]
local function format_user_message(prompt)
  return {
    "",
    "## 🧑 User",
    "",
    prompt,
    "",
  }
end

---Format assistant message header
---@return string[]
local function format_assistant_header()
  return {
    "## 🤖 Assistant",
    "",
  }
end

---Format loading indicator
---@return string[]
local function format_loading()
  return { "", "⏳ Thinking..." }
end

---Format error message
---@param err string
---@return string[]
local function format_error(err)
  return {
    "",
    "## ❌ Error",
    "",
    err,
    "",
  }
end

---Display chat history in window
---@param chat_id string
local function display_chat_history(chat_id)
  local messages = load_chat_messages(chat_id)

  if #messages == 0 then
    window.append({ "(No previous messages)", "" })
    return
  end

  for _, msg in ipairs(messages) do
    if msg.role == "user" then
      window.append(format_user_message(msg.content))
    else
      window.append(format_assistant_header())
      window.append(vim.split(msg.content, "\n", { plain = true }))
      window.append({ "", "---" })
    end
  end
end

-- ============================================================================
-- Response Parsing
-- ============================================================================

---@class ParsedResponse
---@field text string|nil Text content
---@field type "delta"|"full"|"tool_start"|"tool_end"|"system"|"error"|nil Response type
---@field tool_info table|nil Tool call information

---Track all displayed text to avoid duplicates
---@type table<string, boolean>
local displayed_texts = {}

---Parse streaming JSON response from cursor-agent
---@param data table Parsed JSON data
---@return ParsedResponse
local function parse_response(data)
  local result = { text = nil, type = nil, tool_info = nil }

  -- System init message
  if data.type == "system" and data.subtype == "init" then
    result.type = "system"
    result.text = string.format("🤖 Model: %s", data.model or "unknown")
    return result
  end

  -- Thinking messages (for models like Auto that show reasoning)
  if data.type == "thinking" then
    if data.subtype == "delta" and data.text and data.text ~= "" then
      -- Skip if already displayed
      if displayed_texts[data.text] then
        return result
      end
      displayed_texts[data.text] = true
      result.text = data.text
      result.type = "thinking"
      return result
    end
    -- Skip thinking completed or empty deltas
    return result
  end

  -- Assistant text (streaming deltas)
  -- Note: Streaming deltas have timestamp_ms, final full message does NOT
  -- We only want the streaming deltas, skip the final duplicate message
  if data.type == "assistant" and data.message and data.message.content then
    -- Skip final full message (no timestamp_ms)
    if not data.timestamp_ms then
      return result
    end

    local content = data.message.content
    if type(content) == "table" and #content > 0 then
      local first = content[1]
      if first.type == "text" and first.text then
        -- Skip if already displayed (avoid duplicates)
        if displayed_texts[first.text] then
          return result
        end
        displayed_texts[first.text] = true
        result.text = first.text
        result.type = "delta"
        return result
      end
    end
  end

  -- Tool calls
  if data.type == "tool_call" then
    result.tool_info = {}

    if data.subtype == "started" then
      result.type = "tool_start"

      -- Extract tool type and info
      if data.tool_call then
        if data.tool_call.writeToolCall then
          local args = data.tool_call.writeToolCall.args or {}
          result.tool_info.tool = "write"
          result.tool_info.path = args.path
          result.text = string.format("📝 Writing: %s", args.path or "unknown")
        elseif data.tool_call.readToolCall then
          local args = data.tool_call.readToolCall.args or {}
          result.tool_info.tool = "read"
          result.tool_info.path = args.path
          result.text = string.format("📖 Reading: %s", args.path or "unknown")
        elseif data.tool_call.bashToolCall then
          local args = data.tool_call.bashToolCall.args or {}
          result.tool_info.tool = "bash"
          result.tool_info.command = args.command
          result.text = string.format("🔧 Running: %s", args.command or "unknown")
        elseif data.tool_call.listDirToolCall then
          local args = data.tool_call.listDirToolCall.args or {}
          result.tool_info.tool = "listdir"
          result.tool_info.path = args.path
          result.text = string.format("📁 Listing: %s", args.path or "unknown")
        elseif data.tool_call.searchFilesToolCall then
          result.tool_info.tool = "search"
          result.text = "🔍 Searching files..."
        elseif data.tool_call.grepToolCall then
          local args = data.tool_call.grepToolCall.args or {}
          result.tool_info.tool = "grep"
          result.text = string.format("🔍 Grep: %s", args.pattern or "unknown")
        else
          result.tool_info.tool = "unknown"
          result.text = "🔧 Running tool..."
        end
      end
      return result
    elseif data.subtype == "completed" then
      result.type = "tool_end"

      if data.tool_call then
        if data.tool_call.writeToolCall and data.tool_call.writeToolCall.result then
          local res = data.tool_call.writeToolCall.result.success
          if res then
            result.text = string.format("   ✅ Created %d lines (%d bytes)", res.linesCreated or 0, res.fileSize or 0)
          end
        elseif data.tool_call.readToolCall and data.tool_call.readToolCall.result then
          local res = data.tool_call.readToolCall.result.success
          if res then
            result.text = string.format("   ✅ Read %d lines", res.totalLines or 0)
          end
        elseif data.tool_call.bashToolCall and data.tool_call.bashToolCall.result then
          result.text = "   ✅ Command completed"
        else
          result.text = "   ✅ Done"
        end
      end
      return result
    end
  end

  -- Final result
  if data.type == "result" then
    if data.is_error or data.subtype == "error" then
      result.type = "error"
      -- Extract error message from various possible fields
      local error_msg = data.error or data.result or data.message or "Unknown error"
      if type(error_msg) == "table" then
        error_msg = error_msg.message or error_msg.error or vim.json.encode(error_msg)
      end

      -- Add helpful context for common errors
      if error_msg:match("resource_exhausted") then
        error_msg = error_msg
          .. "\n\n💡 This usually means:\n- Rate limit exceeded\n- API quota exhausted\n- Try again later or switch to a different model"
      elseif error_msg:match("ConnectError") then
        error_msg = error_msg .. "\n\n💡 Connection error. Check your internet connection and try again."
      end

      result.text = string.format("\n---\n❌ Error: %s", error_msg)
      return result
    elseif data.subtype == "success" then
      result.type = "full"
      result.text = string.format("\n---\n✅ Completed in %dms", data.duration_ms or 0)
      return result
    end
  end

  return result
end

-- ============================================================================
-- Main Functions
-- ============================================================================

---Remove all loading indicators from buffer
local function remove_loading_indicators()
  local buf = window.get_or_create_buf()
  local line_count = vim.api.nvim_buf_line_count(buf)
  
  -- Collect all lines to keep (excluding loading indicators)
  local lines_to_keep = {}
  local skip_next_empty = false
  
  for i = 1, line_count do
    local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1] or ""
    
    -- Skip loading indicator lines
    if line:match("^⏳ Thinking") then
      skip_next_empty = true
      -- Skip this line
    elseif skip_next_empty and (line == "" or line:match("^%s*$")) then
      -- Skip empty line after loading indicator
      skip_next_empty = false
    else
      skip_next_empty = false
      table.insert(lines_to_keep, line)
    end
  end
  
  -- Replace buffer content
  if #lines_to_keep > 0 then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines_to_keep)
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  end
end

---Send a message to cursor-agent
---@param prompt string
---@param opts { context?: string, chat_id?: string, skip_user_message?: boolean }|nil
function M.send(prompt, opts)
  opts = opts or {}

  -- If already streaming, ignore new requests to prevent spam
  if M.is_streaming then
    vim.notify("Already processing a request. Please wait...", vim.log.levels.WARN)
    return
  end

  -- Ensure we have a chat session
  local chat_id = opts.chat_id or M.current_chat_id
  if not chat_id then
    -- Create a new chat session automatically
    api.create_chat(function(new_id)
      if new_id then
        new_id = new_id:gsub("^%s*(.-)%s*$", "%1")
        M.current_chat_id = new_id
        update_session(new_id, nil)
        M.send(prompt, opts)
      else
        vim.notify("Failed to create chat session", vim.log.levels.ERROR)
      end
    end)
    return
  end

  -- Open window if not already open
  window.open()

  -- Add context to prompt if provided
  local full_prompt = prompt
  if opts.context then
    full_prompt = "Context:\n```\n" .. opts.context .. "\n```\n\n" .. prompt
  end

  -- Save user message to history
  append_message(chat_id, "user", full_prompt)
  update_session(chat_id, nil)

  -- Display user message (skip if already displayed)
  if not opts.skip_user_message then
    window.append(format_user_message(prompt))
  end

  -- Display loading indicator
  window.append(format_loading())

  -- Track streaming state
  M.is_streaming = true
  M.stream_buffer = ""
  displayed_texts = {} -- Reset duplicate tracker
  local thinking_text_buffer = "" -- Track thinking text to avoid duplicate with assistant
  local has_started_response = false
  local is_showing_thinking = false

  -- Run cursor-agent
  api.run(full_prompt, {
    chat_id = chat_id,
    on_stdout = function(data)
      vim.schedule(function()
        local response = parse_response(data)

        if response.type == "system" then
          -- Show model info
          if not has_started_response then
            has_started_response = true
            local buf = window.get_or_create_buf()
            local line_count = vim.api.nvim_buf_line_count(buf)
            vim.api.nvim_buf_set_lines(buf, line_count - 2, line_count, false, format_assistant_header())
          end
          if response.text then
            window.append({ response.text, "" })
          end
          return
        end

        if response.type == "thinking" and response.text then
          -- Show thinking process (for Auto model)
          if not has_started_response then
            has_started_response = true
            local buf = window.get_or_create_buf()
            local line_count = vim.api.nvim_buf_line_count(buf)
            vim.api.nvim_buf_set_lines(buf, line_count - 2, line_count, false, format_assistant_header())
            window.append({ "💭 *Thinking...*", "" })
            is_showing_thinking = true
          end

          -- Accumulate thinking text
          thinking_text_buffer = thinking_text_buffer .. response.text

          -- Display thinking text (dimmed/italic style via markdown)
          local lines = vim.split(response.text, "\n", { plain = true })
          if #lines == 1 then
            window.append_to_last_line(response.text)
          else
            window.append_to_last_line(lines[1])
            for i = 2, #lines do
              window.append({ lines[i] })
            end
          end
          return
        end

        if response.type == "delta" and response.text then
          -- If we're still showing thinking, check if this is duplicate
          if is_showing_thinking and thinking_text_buffer ~= "" then
            -- Check if this text is part of or matches thinking text
            local test_buffer = thinking_text_buffer .. response.text
            -- If the new text is just continuation of thinking, skip it
            if test_buffer:sub(1, #thinking_text_buffer) == thinking_text_buffer then
              -- This is still thinking text, continue accumulating but don't display as assistant
              thinking_text_buffer = test_buffer
              return
            end
            -- If response text exactly matches thinking text, skip
            if response.text == thinking_text_buffer or thinking_text_buffer:find(response.text, 1, true) == 1 then
              return
            end
            -- New content, switch to response mode
            window.append({ "", "---", "", "📝 *Response:*", "" })
            is_showing_thinking = false
            thinking_text_buffer = "" -- Clear thinking buffer
          end

          -- Remove loading indicator on first text response
          if not has_started_response then
            has_started_response = true
            local buf = window.get_or_create_buf()
            local line_count = vim.api.nvim_buf_line_count(buf)
            vim.api.nvim_buf_set_lines(buf, line_count - 2, line_count, false, format_assistant_header())
          end

          -- Append delta to stream buffer
          M.stream_buffer = M.stream_buffer .. response.text

          -- Split by newlines and update display
          local lines = vim.split(response.text, "\n", { plain = true })
          if #lines == 1 then
            window.append_to_last_line(response.text)
          else
            window.append_to_last_line(lines[1])
            for i = 2, #lines do
              window.append({ lines[i] })
            end
          end
          return
        end

        if response.type == "tool_start" and response.text then
          -- Show tool activity
          window.append({ "", response.text })
          return
        end

        if response.type == "tool_end" and response.text then
          -- Show tool result
          window.append({ response.text })
          return
        end

        if response.type == "full" and response.text then
          -- Final completion message
          window.append({ response.text })
          return
        end

        if response.type == "error" and response.text then
          window.append(format_error(response.text))
          return
        end
      end)
    end,
    on_stderr = function(err)
      vim.schedule(function()
        -- Only show significant errors
        if err and err ~= "" and not err:match("^%s*$") then
          -- Try to parse JSON error if possible
          local error_msg = err
          local ok, parsed = pcall(vim.json.decode, err)
          if ok and parsed then
            if parsed.error then
              error_msg = parsed.error
            elseif parsed.message then
              error_msg = parsed.message
            end
          end

          -- Add helpful context for common errors
          if error_msg:match("resource_exhausted") then
            error_msg = error_msg
              .. "\n\n💡 This usually means:\n- Rate limit exceeded\n- API quota exhausted\n- Try again later or switch to a different model"
          elseif error_msg:match("ConnectError") then
            error_msg = error_msg .. "\n\n💡 Connection error. Check your internet connection and try again."
          end

          window.append(format_error(error_msg))
        end
      end)
    end,
    on_exit = function(code)
      vim.schedule(function()
        -- Remove any remaining loading indicators
        remove_loading_indicators()
        M.is_streaming = false

        if not has_started_response then
          -- Remove loading indicator (already done above)
          if code ~= 0 then
            window.append(format_error("cursor-agent exited with code " .. code))
          end
        else
          -- Save assistant response to history
          if M.stream_buffer ~= "" and chat_id then
            append_message(chat_id, "assistant", M.stream_buffer)
          end
        end
        -- Separator is now added by the "result" message
      end)
    end,
  })
end

---Get selected code as formatted text for prompt
---@param start_line number|nil Line number to start (1-indexed, inclusive)
---@param end_line number|nil Line number to end (1-indexed, inclusive)
---@return string formatted_code
local function get_selected_code_text(start_line, end_line)
  -- If range not provided, try to get from visual mode or marks
  if not start_line or not end_line then
    -- Check if we're in visual mode
    local mode = vim.fn.mode()
    if mode:match("[vV]") then
      -- In visual mode, get selection directly
      start_line = vim.fn.line("v")
      end_line = vim.fn.line(".")
    else
      -- Not in visual mode, try to get from marks
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      start_line = start_pos[2]
      end_line = end_pos[2]
    end
  end

  -- Ensure valid range
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Validate range
  if start_line < 1 or end_line < 1 then
    return ""
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local selection = table.concat(lines, "\n")
  local filename = vim.fn.expand("%:t")
  local filetype = vim.bo.filetype

  -- Format as code block for prompt
  local code_text = string.format("```%s\n%s\n```", filetype ~= "" and filetype or "", selection)
  return code_text
end

---Send message with visual selection as context
---@param prompt string
---@param start_line number|nil Line number to start (1-indexed, inclusive)
---@param end_line number|nil Line number to end (1-indexed, inclusive)
function M.send_with_selection(prompt, start_line, end_line)
  -- If range not provided, try to get from visual mode or marks
  if not start_line or not end_line then
    -- Check if we're in visual mode
    local mode = vim.fn.mode()
    if mode:match("[vV]") then
      -- In visual mode, get selection directly
      start_line = vim.fn.line("v")
      end_line = vim.fn.line(".")
    else
      -- Not in visual mode, try to get from marks
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      start_line = start_pos[2]
      end_line = end_pos[2]
    end
  end

  -- Ensure valid range
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Validate range
  if start_line < 1 or end_line < 1 then
    vim.notify("No selection found", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local selection = table.concat(lines, "\n")

  -- Get current file info for context
  local filename = vim.fn.expand("%:t")
  local filetype = vim.bo.filetype

  -- Open window and display the selected code for user to see
  window.open()

  -- Determine action type from prompt for better display
  local action_type = ""
  if prompt:match("Explain") then
    action_type = "📖 Explaining"
  elseif prompt:match("Fix") then
    action_type = "🔧 Fixing"
  elseif prompt:match("Refactor") then
    action_type = "♻️ Refactoring"
  elseif prompt:match("test") then
    action_type = "🧪 Testing"
  elseif prompt:match("improve") then
    action_type = "✨ Improving"
  end

  -- Display user message with code
  local display_lines = {
    "",
    "## 🧑 User",
    "",
    prompt,
    "",
  }

  -- Add action-specific header if applicable
  if action_type ~= "" then
    table.insert(
      display_lines,
      string.format("**%s code** (`%s`, lines %d-%d):", action_type, filename, start_line, end_line)
    )
  else
    table.insert(display_lines, string.format("**Selected code** (`%s`, lines %d-%d):", filename, start_line, end_line))
  end

  table.insert(display_lines, "")
  table.insert(display_lines, "```" .. (filetype ~= "" and filetype or "") .. "")

  -- Add code lines
  for _, line in ipairs(lines) do
    table.insert(display_lines, line)
  end

  table.insert(display_lines, "```")
  table.insert(display_lines, "")

  window.append(display_lines)

  -- Prepare context for API
  local context = string.format("File: %s (%s)\n\n%s", filename, filetype, selection)

  -- Send with context (but don't display user message again since we already did)
  M.send(prompt, { context = context, skip_user_message = true })
end

---Send current buffer as context
---@param prompt string
function M.send_with_buffer(prompt)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  local filename = vim.fn.expand("%:t")
  local filetype = vim.bo.filetype

  local context = string.format("File: %s (%s)\n\n%s", filename, filetype, content)

  M.send(prompt, { context = context })
end

---Get visual selection range
---@return number start_line, number end_line
local function get_visual_range()
  -- Try multiple methods to get visual selection
  local start_line, end_line

  -- Method 1: Check if marks exist and are valid
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  if start_pos[2] > 0 and end_pos[2] > 0 then
    start_line = start_pos[2]
    end_line = end_pos[2]
  else
    -- Method 2: Try to get from current visual selection (if still in visual mode)
    local mode = vim.fn.mode()
    if mode:match("[vV]") then
      start_line = vim.fn.line("v")
      end_line = vim.fn.line(".")
    else
      -- Method 3: Use current line if no selection
      start_line = vim.fn.line(".")
      end_line = vim.fn.line(".")
    end
  end

  -- Ensure valid range
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  return start_line, end_line
end

---Quick actions with selection
---@param action "explain"|"fix"|"refactor"|"test"|"improve"
---@param start_line number|nil Line number to start (1-indexed, inclusive)
---@param end_line number|nil Line number to end (1-indexed, inclusive)
function M.quick_action(action, start_line, end_line)
  local prompts = {
    explain = "Explain this code in detail:",
    fix = "Fix any issues in this code:",
    refactor = "Refactor this code to be cleaner and more maintainable:",
    test = "Write unit tests for this code:",
    improve = "Suggest improvements for this code:",
  }

  local prompt = prompts[action]
  if prompt then
    -- If range not provided, get from visual selection
    if not start_line or not end_line then
      start_line, end_line = get_visual_range()
    end
    M.send_with_selection(prompt, start_line, end_line)
  end
end

---Start a new chat session
function M.new_chat()
  api.create_chat(function(chat_id)
    if chat_id then
      -- Trim whitespace
      chat_id = chat_id:gsub("^%s*(.-)%s*$", "%1")
      M.current_chat_id = chat_id
      update_session(chat_id, nil)
      window.clear()
      window.open()
      window.append({ "# 💬 New Chat Session", "", "Chat ID: `" .. chat_id .. "`", "", "---" })
      vim.notify("Created new chat: " .. chat_id, vim.log.levels.INFO)
    else
      vim.notify("Failed to create new chat", vim.log.levels.ERROR)
    end
  end)
end

---Resume a chat session
---@param chat_id string|nil
function M.resume(chat_id)
  if chat_id then
    -- Trim whitespace
    chat_id = chat_id:gsub("^%s*(.-)%s*$", "%1")
    M.current_chat_id = chat_id
    update_session(chat_id, nil)
    window.clear()
    window.open()
    window.append({ "# 💬 Resumed Chat Session", "", "Chat ID: `" .. chat_id .. "`", "", "---" })

    -- Display previous messages
    display_chat_history(chat_id)

    vim.notify("Resumed chat: " .. chat_id, vim.log.levels.INFO)
  else
    -- Resume latest from sessions
    local sessions = load_sessions()
    if #sessions > 0 then
      M.resume(sessions[1].id)
    else
      vim.notify("No chat history found. Use :CursorNewChat to create one.", vim.log.levels.WARN)
    end
  end
end

---List available chat sessions from local history
function M.list_sessions()
  local sessions = load_sessions()

  if #sessions == 0 then
    vim.notify("No chat sessions in history. Use :CursorNewChat to create one.", vim.log.levels.INFO)
    return
  end

  -- Use vim.ui.select for nice selection UI
  vim.ui.select(sessions, {
    prompt = "Select chat session to resume:",
    format_item = function(session)
      local label = session.id:sub(1, 8) .. "..."
      if session.title then
        label = label .. " - " .. session.title
      end
      if session.id == M.current_chat_id then
        label = label .. " (current)"
      end
      return label
    end,
  }, function(choice)
    if choice then
      M.resume(choice.id)
    end
  end)
end

---Stop current generation
function M.stop()
  if api.is_running() then
    api.stop()
    M.is_streaming = false
    window.append({ "", "⛔ Generation stopped", "" })
  end
end

return M
