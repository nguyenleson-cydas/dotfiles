local Job = require("plenary.job")

local M = {}

local namespace = vim.api.nvim_create_namespace("pream90.phpstan")
local running_jobs = {}
local debounce_timer = nil

M.analyse = function()
  local current_buf = vim.api.nvim_get_current_buf()
  local file_path = vim.api.nvim_buf_get_name(current_buf)

  -- Skip if not a real file or already running for this buffer
  if file_path == "" or vim.fn.filereadable(file_path) ~= 1 then
    return
  end

  if running_jobs[current_buf] then
    return -- Already analyzing this buffer
  end

  running_jobs[current_buf] = true

  Job:new({
    command = "phpstan",
    args = {
      "analyse",
      "--error-format=json",
      "--memory-limit=1G",
      "--no-progress",
      file_path,
    },
    cwd = vim.fn.getcwd(),
    on_exit = vim.schedule_wrap(function(j, return_val)
      running_jobs[current_buf] = nil

      -- Check if buffer is still valid early
      if not vim.api.nvim_buf_is_valid(current_buf) then
        return
      end

      -- Clear diagnostics for current buffer only
      vim.diagnostic.set(namespace, current_buf, {})

      if return_val == 0 then
        return
      end

      local result = j:result()
      if not result or #result == 0 then
        return
      end

      -- Handle multi-line JSON output
      local json_str = table.concat(result, "")
      if json_str == "" then
        return
      end

      local ok, response = pcall(vim.json.decode, json_str)
      if not ok or not response or not response.files then
        return
      end

      for response_file_path, file_data in pairs(response.files) do
        -- Use the file path from response to get correct buffer
        local target_bufnr = vim.fn.bufnr(response_file_path)
        if target_bufnr ~= -1 and vim.api.nvim_buf_is_valid(target_bufnr) then
          local diagnostics = {}

          -- Safe iteration
          for _, message in ipairs(file_data.messages or {}) do
            local diagnostic = {
              lnum = (message.line or 1) - 1, -- Safe default
              col = 0,
              end_lnum = (message.line or 1) - 1,
              end_col = -1,
              message = message.message or "Unknown error",
              source = "phpstan",
              code = message.identifier,
              severity = message.ignorable and vim.diagnostic.severity.WARN or vim.diagnostic.severity.ERROR,
            }

            table.insert(diagnostics, diagnostic)
          end

          vim.diagnostic.set(namespace, target_bufnr, diagnostics)
        end
      end
    end),
    -- on_stderr = function(_, data)
    --   -- if data and data ~= "" then
    --   --   vim.notify("PHPStan: " .. data, vim.log.levels.WARN)
    --   -- end
    -- end,
  }):start()
end

M.analyse_debounced = function()
  if debounce_timer then
    debounce_timer:close()
  end

  debounce_timer = vim.defer_fn(function()
    M.analyse()
    debounce_timer = nil
  end, 500)
end

M.setup = function()
  local group = vim.api.nvim_create_augroup("PHPStan", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.php",
    callback = M.analyse,
    group = group,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.php",
    callback = M.analyse_debounced,
    group = group,
  })

  vim.api.nvim_create_autocmd("TextChanged", {
    pattern = "*.php",
    callback = M.analyse_debounced,
    group = group,
  })

  -- Commands
  vim.api.nvim_create_user_command("PHPStanAnalyse", M.analyse, {
    desc = "Run PHPStan analysis on current buffer",
  })

  vim.api.nvim_create_user_command("PHPStanClear", function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.set(namespace, bufnr, {})
  end, {
    desc = "Clear PHPStan diagnostics for current buffer",
  })
end

return M
