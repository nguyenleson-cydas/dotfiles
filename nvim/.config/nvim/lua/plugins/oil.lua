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
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
