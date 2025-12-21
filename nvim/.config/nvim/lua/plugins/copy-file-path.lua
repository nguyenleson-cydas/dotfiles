return {
  "h3pei/copy-file-path.nvim",
  config = function()
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>cp", "<cmd>CopyRelativeFilePath<cr>", opts)
  end,
}
