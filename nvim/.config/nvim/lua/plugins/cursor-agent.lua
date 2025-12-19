return {
  dir = "~/learning/cursor-agent-nvim",
  config = function()
    require("cursor-agent").setup({
      window = {
        type = "split", -- "float" hoặc "split"
        width = "40%",
      },
    })
  end,
}
