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
      format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
    },
  },
}
