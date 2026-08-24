-- Requires the `kotlin-lsp` mason package (JetBrains' official Analysis-API
-- based server, not the older community fwcd/kotlin-language-server).
-- Run `:MasonInstall kotlin-lsp` once after first launch.
return {
  {
    'AlexandrosAlexiou/kotlin.nvim',
    ft = { 'kotlin' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'stevearc/oil.nvim',
      'folke/trouble.nvim',
    },
    opts = {
      jvm_args = { '-Xmx4g' }, -- Gradle multi-module indexing wants headroom
      inlay_hints = { enabled = true },
      folding = { enabled = true },
      file_templates = { enabled = true },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'kotlin',
        group = vim.api.nvim_create_augroup('config-kotlin-keymaps', { clear = true }),
        callback = function(event)
          local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = event.buf, desc = desc }) end
          map('<leader>ko', '<cmd>KotlinOrganizeImports<CR>', 'Organize imports')
          map('<leader>kf', '<cmd>KotlinFormat<CR>', 'Format (IntelliJ rules)')
          map('<leader>ks', '<cmd>KotlinSymbols<CR>', 'Document outline')
          map('<leader>kw', '<cmd>KotlinWorkspaceSymbols<CR>', 'Workspace symbols')
          map('<leader>kt', '<cmd>KotlinTypeDefinition<CR>', 'Type definition')
          map('<leader>kc', '<cmd>KotlinCodeActions<CR>', 'Code actions')
          map('<leader>kh', '<cmd>KotlinIncomingCalls<CR>', 'Incoming calls')
          map('<leader>kH', '<cmd>KotlinOutgoingCalls<CR>', 'Outgoing calls')
          map('<leader>kn', '<cmd>KotlinNewFromTemplate<CR>', 'New from template')
        end,
      })
    end,
  },
}
