return {
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    keys = {
      { '<leader>cf', function() require('conform').format { async = true } end, desc = 'Format buffer' },
    },
    opts = {
      -- Kotlin/Java are deliberately absent: kotlin-lsp does its own
      -- IntelliJ-rules formatting (:KotlinFormat), and running a second
      -- formatter over the same buffer just fights it.
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        markdown = { 'prettier' },
      },
      formatters = {
        stylua = {
          -- StyLua defaults to tabs, so pass the buffer style unless the
          -- project has its own StyLua configuration.
          prepend_args = function(_, ctx)
            local config = vim.fs.find({ '.stylua.toml', 'stylua.toml' }, { path = ctx.dirname, upward = true })
            if #config > 0 then return {} end

            local options = vim.bo[ctx.buf]
            local width = options.shiftwidth == 0 and options.tabstop or options.shiftwidth
            return {
              '--indent-type', options.expandtab and 'Spaces' or 'Tabs',
              '--indent-width', tostring(width),
            }
          end,
        },
        prettier = {
          -- Follow the buffer's detected indentation when no project
          -- Prettier config exists; project config still wins.
          prepend_args = function(_, ctx)
            local options = vim.bo[ctx.buf]
            local width = options.shiftwidth == 0 and options.tabstop or options.shiftwidth
            return {
              '--config-precedence', 'prefer-file',
              '--tab-width', tostring(width),
              options.expandtab and '--no-use-tabs' or '--use-tabs',
            }
          end,
        },
      },
      format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
    },
  },
}
