---@class CursorAgent
local M = {}

local config = require("cursor-agent.config")
local chat = require("cursor-agent.chat")
local window = require("cursor-agent.window")
local api = require("cursor-agent.api")

---Setup the plugin
---@param opts CursorAgentConfig|nil
function M.setup(opts)
  config.setup(opts)
  M.create_commands()
  M.create_keymaps()
end

---Create user commands
function M.create_commands()
  -- Main chat command
  vim.api.nvim_create_user_command("CursorChat", function(args)
    if args.args and args.args ~= "" then
      chat.send(args.args)
    else
      window.open()
    end
  end, {
    nargs = "*",
    desc = "Open Cursor Agent chat or send a message",
  })

  -- Ask with visual selection
  vim.api.nvim_create_user_command("CursorAsk", function(args)
    local prompt = args.args
    
    -- Get selected code if range is provided
    local selected_code = ""
    if args.line1 and args.line2 and args.line1 ~= args.line2 then
      local lines = vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, false)
      local selection = table.concat(lines, "\n")
      local filename = vim.fn.expand("%:t")
      local filetype = vim.bo.filetype
      selected_code = string.format("```%s\n%s\n```\n\n", filetype ~= "" and filetype or "", selection)
    end
    
    -- Open chat window
    window.open()
    
    -- If prompt provided, prepend selected code and send
    if prompt ~= "" then
      if selected_code ~= "" then
        prompt = selected_code .. prompt
      end
      chat.send(prompt)
    else
      -- No prompt, just insert code into input area for user to edit
      if selected_code ~= "" then
        window.insert_to_input(selected_code)
      else
        -- No selection, just open chat
        window.ensure_input_line()
      end
    end
  end, {
    nargs = "*",
    range = true,
    desc = "Ask Cursor Agent about visual selection",
  })

  -- Quick actions
  vim.api.nvim_create_user_command("CursorExplain", function(args)
    chat.quick_action("explain", args.line1, args.line2)
  end, {
    range = true,
    desc = "Explain selected code",
  })

  vim.api.nvim_create_user_command("CursorFix", function(args)
    chat.quick_action("fix", args.line1, args.line2)
  end, {
    range = true,
    desc = "Fix selected code",
  })

  vim.api.nvim_create_user_command("CursorRefactor", function(args)
    chat.quick_action("refactor", args.line1, args.line2)
  end, {
    range = true,
    desc = "Refactor selected code",
  })

  vim.api.nvim_create_user_command("CursorTest", function(args)
    chat.quick_action("test", args.line1, args.line2)
  end, {
    range = true,
    desc = "Generate tests for selected code",
  })

  vim.api.nvim_create_user_command("CursorImprove", function(args)
    chat.quick_action("improve", args.line1, args.line2)
  end, {
    range = true,
    desc = "Suggest improvements for selected code",
  })

  -- Window management
  vim.api.nvim_create_user_command("CursorToggle", function()
    window.toggle()
  end, {
    desc = "Toggle Cursor Agent window",
  })

  vim.api.nvim_create_user_command("CursorClear", function()
    window.clear()
  end, {
    desc = "Clear Cursor Agent chat",
  })

  -- Session management
  vim.api.nvim_create_user_command("CursorNewChat", function()
    chat.new_chat()
  end, {
    desc = "Create new Cursor Agent chat session",
  })

  vim.api.nvim_create_user_command("CursorResume", function(args)
    if args.args and args.args ~= "" then
      chat.resume(args.args)
    else
      -- Resume latest session (no args)
      chat.resume(nil)
    end
  end, {
    nargs = "?",
    desc = "Resume a Cursor Agent chat session (latest if no ID provided)",
  })

  vim.api.nvim_create_user_command("CursorHistory", function()
    chat.list_sessions()
  end, {
    desc = "List Cursor Agent chat sessions",
  })

  -- Stop generation
  vim.api.nvim_create_user_command("CursorStop", function()
    chat.stop()
  end, {
    desc = "Stop current Cursor Agent generation",
  })

  -- Model selection
  vim.api.nvim_create_user_command("CursorModel", function(args)
    if args.args and args.args ~= "" then
      -- Set model
      local model = args.args
      if config.set_model(model) then
        vim.notify("Model set to: " .. model, vim.log.levels.INFO)
      else
        vim.notify(
          "Invalid model: " .. model .. "\nAvailable: " .. table.concat(config.available_models, ", "),
          vim.log.levels.ERROR
        )
      end
    else
      -- Show model picker
      vim.ui.select(config.available_models, {
        prompt = "Select model:",
        format_item = function(item)
          if item == config.get_model() then
            return item .. " (current)"
          end
          return item
        end,
      }, function(choice)
        if choice then
          config.set_model(choice)
          vim.notify("Model set to: " .. choice, vim.log.levels.INFO)
        end
      end)
    end
  end, {
    nargs = "?",
    complete = function()
      return config.available_models
    end,
    desc = "Set or select Cursor Agent model",
  })

  -- Auth commands
  vim.api.nvim_create_user_command("CursorStatus", function()
    api.status(function(status)
      vim.notify(status, vim.log.levels.INFO)
    end)
  end, {
    desc = "Check Cursor Agent authentication status",
  })

  vim.api.nvim_create_user_command("CursorLogin", function()
    vim.fn.jobstart({ "cursor-agent", "login" }, {
      on_exit = function(_, code, _)
        if code == 0 then
          vim.notify("Login successful", vim.log.levels.INFO)
        else
          vim.notify("Login failed", vim.log.levels.ERROR)
        end
      end,
    })
  end, {
    desc = "Login to Cursor Agent",
  })

  vim.api.nvim_create_user_command("CursorLogout", function()
    vim.fn.jobstart({ "cursor-agent", "logout" }, {
      on_exit = function(_, code, _)
        if code == 0 then
          vim.notify("Logout successful", vim.log.levels.INFO)
        else
          vim.notify("Logout failed", vim.log.levels.ERROR)
        end
      end,
    })
  end, {
    desc = "Logout from Cursor Agent",
  })
end

---Create default keymaps
function M.create_keymaps()
  local cfg = config.get()
  
  -- Only create keymaps if enabled
  if not cfg.enable_default_keymaps then
    return
  end

  local chat_module = require("cursor-agent.chat")
  local window_module = require("cursor-agent.window")

  -- Helper function to get visual selection range
  local function get_visual_range()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    return start_line, end_line
  end

  -- Normal mode keymaps
  vim.keymap.set("n", "<leader>ac", "<cmd>CursorChat<cr>", { desc = "Cursor Chat" })
  vim.keymap.set("n", "<leader>at", "<cmd>CursorToggle<cr>", { desc = "Cursor Toggle" })
  vim.keymap.set("n", "<leader>as", "<cmd>CursorStop<cr>", { desc = "Cursor Stop" })
  vim.keymap.set("n", "<leader>an", "<cmd>CursorNewChat<cr>", { desc = "Cursor New Chat" })
  vim.keymap.set("n", "<leader>ah", "<cmd>CursorHistory<cr>", { desc = "Cursor History" })

  -- Visual mode keymaps for asking about selection
  vim.keymap.set("v", "<leader>aa", function()
    local start_line, end_line = get_visual_range()
    
    -- Get selected code
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local selection = table.concat(lines, "\n")
    local filename = vim.fn.expand("%:t")
    local filetype = vim.bo.filetype
    local selected_code = string.format("```%s\n%s\n```\n\n", filetype ~= "" and filetype or "", selection)

    -- Open chat window and insert code into input area
    window_module.open()
    window_module.insert_to_input(selected_code)
  end, { desc = "Cursor Ask" })

  -- Visual mode keymaps for quick actions
  vim.keymap.set("v", "<leader>ae", function()
    local start_line, end_line = get_visual_range()
    chat_module.quick_action("explain", start_line, end_line)
  end, { desc = "Cursor Explain" })

  vim.keymap.set("v", "<leader>af", function()
    local start_line, end_line = get_visual_range()
    chat_module.quick_action("fix", start_line, end_line)
  end, { desc = "Cursor Fix" })

  vim.keymap.set("v", "<leader>ar", function()
    local start_line, end_line = get_visual_range()
    chat_module.quick_action("refactor", start_line, end_line)
  end, { desc = "Cursor Refactor" })

  vim.keymap.set("v", "<leader>ax", function()
    local start_line, end_line = get_visual_range()
    chat_module.quick_action("test", start_line, end_line)
  end, { desc = "Cursor Test" })

  vim.keymap.set("v", "<leader>ai", function()
    local start_line, end_line = get_visual_range()
    chat_module.quick_action("improve", start_line, end_line)
  end, { desc = "Cursor Improve" })
end

-- Export submodules for advanced usage
M.chat = chat
M.window = window
M.api = api
M.config = config

return M
