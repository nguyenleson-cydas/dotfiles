local uranus_root = vim.fn.expand("~/dev/intern/uranus/") -- change to your actual project path

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      php = function(bufnr)
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if vim.startswith(filepath, uranus_root) then
          return { "php_cs_fixer_uranus" }
        else
          -- Return nil or a different formatter for other projects
          return { "php_cs_fixer" }
        end
      end,
    },
    default_format_opts = {
      timeout_ms = 10000,
    },
    formatters = {
      php_cs_fixer_uranus = {
        command = "php",
        args = { vim.fn.expand("~/php-cs-fixer-v2.phar"), "fix", "$FILENAME", "--config=.php_cs.dist" },
        stdin = false,
      },
    },
  },
}
