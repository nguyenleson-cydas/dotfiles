---@class CursorAgentApi
local M = {}

local config = require("cursor-agent.config")

---@class CursorAgentRunOpts
---@field model string|nil Model to use
---@field chat_id string|nil Chat ID to resume
---@field workspace string|nil Workspace directory
---@field on_stdout fun(data: string)|nil Callback for stdout data
---@field on_stderr fun(data: string)|nil Callback for stderr data
---@field on_exit fun(code: number)|nil Callback when process exits

---@type vim.SystemObj|nil Current job
M.current_job = nil

---Build command arguments for cursor-agent
---@param prompt string
---@param opts CursorAgentRunOpts|nil
---@return string[]
local function build_cmd(prompt, opts)
  opts = opts or {}
  local cfg = config.get()

  local cmd = {
    cfg.cmd or "cursor-agent",
    "-p",
    "--force",
    "--output-format", "stream-json",
    "--stream-partial-output",
  }

  -- Workspace
  local workspace = opts.workspace or cfg.workspace or vim.fn.getcwd()
  table.insert(cmd, "--workspace")
  table.insert(cmd, workspace)

  -- Model
  local model = opts.model or cfg.model
  if model then
    table.insert(cmd, "--model")
    table.insert(cmd, model)
  end

  -- Resume chat
  if opts.chat_id then
    table.insert(cmd, "--resume")
    table.insert(cmd, opts.chat_id)
  end

  -- Prompt
  table.insert(cmd, prompt)

  return cmd
end

---Run cursor-agent with the given prompt
---@param prompt string
---@param opts CursorAgentRunOpts|nil
function M.run(prompt, opts)
  opts = opts or {}

  -- Stop existing job if running
  if M.current_job then
    M.stop()
  end

  local cmd = build_cmd(prompt, opts)

  -- Use vim.system for better async handling (Neovim 0.10+)
  if vim.system then
    local stdout_buffer = ""

    M.current_job = vim.system(cmd, {
      text = true,
      stdout = function(err, data)
        if err or not data then
          return
        end

        stdout_buffer = stdout_buffer .. data

        -- Process complete lines (JSON objects are newline-separated)
        while true do
          local newline_pos = stdout_buffer:find("\n")
          if not newline_pos then
            break
          end

          local line = stdout_buffer:sub(1, newline_pos - 1)
          stdout_buffer = stdout_buffer:sub(newline_pos + 1)

          if line ~= "" and opts.on_stdout then
            local ok, parsed = pcall(vim.json.decode, line)
            if ok and parsed then
              opts.on_stdout(parsed)
            end
          end
        end
      end,
      stderr = function(_, data)
        if data and opts.on_stderr then
          opts.on_stderr(data)
        end
      end,
    }, function(obj)
      M.current_job = nil
      if opts.on_exit then
        opts.on_exit(obj.code)
      end
    end)
  else
    -- Fallback for older Neovim: use synchronous call
    vim.notify("Running cursor-agent (sync mode)...", vim.log.levels.INFO)

    local result = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error

    -- Parse each line
    if opts.on_stdout then
      for line in result:gmatch("[^\n]+") do
        local ok, parsed = pcall(vim.json.decode, line)
        if ok and parsed then
          opts.on_stdout(parsed)
        end
      end
    end

    if opts.on_exit then
      opts.on_exit(exit_code)
    end
  end
end

---Stop the current cursor-agent job
function M.stop()
  if M.current_job then
    -- vim.system object has kill method
    M.current_job:kill(9)
    M.current_job = nil
  end
end

---Check if cursor-agent is currently running
---@return boolean
function M.is_running()
  return M.current_job ~= nil
end

---Create a new chat session
---@param callback fun(chat_id: string|nil)
function M.create_chat(callback)
  local cfg = config.get()
  vim.fn.jobstart({ cfg.cmd or "cursor-agent", "create-chat" }, {
    on_stdout = function(_, data, _)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            callback(line)
            return
          end
        end
      end
    end,
    on_exit = function(_, code, _)
      if code ~= 0 then
        callback(nil)
      end
    end,
    stdout_buffered = true,
  })
end

---List chat sessions
---Note: cursor-agent ls requires interactive terminal, not supported in headless mode
---@param callback fun(sessions: string[], error: string|nil)
function M.list_sessions(callback)
  -- cursor-agent ls requires interactive terminal (Ink library)
  -- This is a limitation of the CLI
  callback({}, "cursor-agent ls requires interactive terminal. Use :CursorNewChat to create a new session or :CursorResume <chat_id> with a known ID.")
end

---Check authentication status
---@param callback fun(status: string)
function M.status(callback)
  local cfg = config.get()
  local output = {}
  vim.fn.jobstart({ cfg.cmd or "cursor-agent", "status" }, {
    on_stdout = function(_, data, _)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(output, line)
          end
        end
      end
    end,
    on_exit = function(_, _, _)
      callback(table.concat(output, "\n"))
    end,
    stdout_buffered = true,
  })
end

return M
