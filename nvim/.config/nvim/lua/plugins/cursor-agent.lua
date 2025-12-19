return {
  dir = vim.fn.expand("~/.config/nvim/lua/plugins-local/cursor-agent.nvim"),
  config = function()
    require("cursor-agent").setup({
      window = {
        type = "split",
        width = "40%",
      },
    })
  end,
}
