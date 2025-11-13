return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      -- pyright will be automatically installed with mason and loaded with lspconfig
      -- pyright = {},
      vtsls = {
        settings = {
          typescript = {
            tsserver = {
              maxTsServerMemory = 12288, -- Sets the memory limit to 8GB (8192 MB)
            },
          },
        },
      },
    },
  },
}
