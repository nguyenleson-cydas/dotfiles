---@class CursorAgentConfig
---@field cmd string Path to cursor-agent executable
---@field model string|nil Default model to use
---@field workspace string|nil Workspace directory (defaults to cwd)
---@field window CursorAgentWindowConfig Window configuration
---@field keymaps CursorAgentKeymaps Keymap configuration
---@field enable_default_keymaps boolean Enable default global keymaps (default: true)

---@class CursorAgentWindowConfig
---@field type "float"|"split" Window type
---@field width number|string Width (number for columns, string for percentage like "50%")
---@field height number|string Height (number for rows, string for percentage like "50%")
---@field position "right"|"left"|"top"|"bottom" Position for split windows
---@field border string Border style for float windows

---@class CursorAgentKeymaps
---@field send string Keymap to send message in chat buffer
---@field close string Keymap to close chat window
---@field clear string Keymap to clear chat buffer
---@field stop string Keymap to stop current generation

local M = {}

-- Available models from cursor-agent
M.available_models = {
  "auto",
  "composer-1",
  "sonnet-4.5",
  "sonnet-4.5-thinking",
  "opus-4.5",
  "opus-4.5-thinking",
  "opus-4.1",
  "gemini-3-pro",
  "gemini-3-flash",
  "gpt-5.2",
  "gpt-5.2-high",
  "gpt-5.1",
  "gpt-5.1-high",
  "gpt-5.1-codex",
  "gpt-5.1-codex-high",
  "gpt-5.1-codex-max",
  "gpt-5.1-codex-max-high",
  "grok",
}

---@type CursorAgentConfig
M.defaults = {
  cmd = "cursor-agent", -- Can be full path like "/Users/xxx/.local/bin/cursor-agent"
  model = "auto", -- Default model
  workspace = nil, -- Use cwd
  enable_default_keymaps = true, -- Enable default global keymaps
  window = {
    type = "float",
    width = "80%",
    height = "80%",
    position = "right",
    border = "rounded",
  },
  keymaps = {
    send = "<CR>",
    close = "q",
    clear = "<C-x>", -- Changed to avoid conflict with motion keys (h/j/k/l) and tmux navigator
    stop = "<C-c>",
  },
}

---@type CursorAgentConfig
M.options = {}

---@param opts CursorAgentConfig|nil
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

---@return CursorAgentConfig
function M.get()
  return M.options
end

---Set the model
---@param model string
---@return boolean success
function M.set_model(model)
  -- Validate model
  local valid = false
  for _, m in ipairs(M.available_models) do
    if m == model then
      valid = true
      break
    end
  end

  if not valid then
    return false
  end

  M.options.model = model
  return true
end

---Get current model
---@return string|nil
function M.get_model()
  return M.options.model
end

return M
