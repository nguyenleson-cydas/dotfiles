return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    -- PHP Debug Adapter Configuration
    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js" },
    }

    -- PHP Debug Configurations
    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug (with local path mappings)",
        port = 9000,
        pathMappings = {
          ["/var/www/html/comet"] = "${workspaceFolder}",
        },
        log = false,
      },
    }
  end,
}
