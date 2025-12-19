return {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup({
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
    })
    vim.keymap.set("n", "\\", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  lazy = false,
}
