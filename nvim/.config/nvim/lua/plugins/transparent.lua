return {
  "xiyaowong/transparent.nvim",
  config = function()
    vim.cmd("TransparentEnable")
    vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, { "Pmenu", "NormalFloat", "Float" })
    require("transparent").clear_prefix("Blink")
  end,
}
