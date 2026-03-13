-- [[ Anti-spam discipline for h,j,k,l per buffer ]]
local nav_tracker = {}
local NAV_KEYS = { 'h', 'j', 'k', 'l', '+', '-' }
local SPAM_THRESHOLD = 10
local WARNING_THRESHOLD = 7
local SPAM_WINDOW_MS = 2000
local MIN_INTERVAL_MS = 90
local BLOCK_DURATION_MS = 5000
local CLEANUP_INTERVAL_MS = 300000
local EXEMPT_FILETYPES = { 'qf', 'help', 'man', 'nofile', 'prompt' }
local EXEMPT_BUFTYPES = { 'nofile', 'quickfix', 'help', 'prompt' }
local OPPOSITE_KEYS = {
  h = 'l',
  l = 'h',
  j = 'k',
  k = 'j',
  ['+'] = '-',
  ['-'] = '+',
}

local function should_exempt(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local filetype = vim.bo[bufnr].filetype
  for _, exempt in ipairs(EXEMPT_BUFTYPES) do
    if buftype == exempt then
      return true
    end
  end
  for _, exempt in ipairs(EXEMPT_FILETYPES) do
    if filetype == exempt then
      return true
    end
  end
  return false
end

local function get_nav_state(bufnr)
  if not nav_tracker[bufnr] then
    nav_tracker[bufnr] = { count = 0, last_time = 0, blocked_until = 0, last_key = nil, last_access = vim.loop.now() }
  end
  nav_tracker[bufnr].last_access = vim.loop.now()
  return nav_tracker[bufnr]
end

local function cleanup_old_states()
  local now = vim.loop.now()
  for bufnr, state in pairs(nav_tracker) do
    if not vim.api.nvim_buf_is_valid(bufnr) or (now - state.last_access) > CLEANUP_INTERVAL_MS then
      nav_tracker[bufnr] = nil
    end
  end
end

local function on_nav_press(key)
  local bufnr = vim.api.nvim_get_current_buf()

  if should_exempt(bufnr) then
    return key
  end

  local state = get_nav_state(bufnr)
  local now = vim.loop.now()

  if now % 10000 < 100 then
    cleanup_old_states()
  end

  if state.blocked_until and now < state.blocked_until then
    local remaining = math.ceil((state.blocked_until - now) / 1000)
    if remaining % 2 == 0 then
      vim.notify(string.format('🤠 Blocked for %ds more...', remaining), vim.log.levels.WARN)
    end
    return
  end

  if vim.v.count > 0 then
    state.count = 0
    state.last_time = now
    state.last_key = nil
    return key
  end

  if state.last_key and OPPOSITE_KEYS[state.last_key] == key then
    state.count = 0
  end

  if now - state.last_time < MIN_INTERVAL_MS then
    state.last_time = now
    state.last_key = key
    return key
  end

  if now - state.last_time > SPAM_WINDOW_MS then
    state.count = 0
  end

  state.count = state.count + 1
  state.last_time = now
  state.last_key = key

  if state.count >= SPAM_THRESHOLD then
    state.blocked_until = now + BLOCK_DURATION_MS
    vim.notify('🤠 Hold it Cowboy! Blocked for 5s', vim.log.levels.WARN)
    return
  elseif state.count >= WARNING_THRESHOLD then
    local remaining = SPAM_THRESHOLD - state.count
    vim.notify(string.format('⚠️ Slow down! %d more = block', remaining), vim.log.levels.INFO)
  end

  return key
end

for _, key in ipairs(NAV_KEYS) do
  vim.keymap.set('n', key, function()
    return on_nav_press(key)
  end, { expr = true, silent = true })
end
