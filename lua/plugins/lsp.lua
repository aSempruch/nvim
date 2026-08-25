-- Kotlin's language server (kotlin-lsp) is wired up separately in
-- plugins/kotlin.lua via kotlin.nvim, which needs to own its client
-- lifecycle. Everything else goes through the standard
-- mason -> mason-lspconfig -> nvim-lspconfig -> vim.lsp.enable() pipeline.
return {
  {
    'mason-org/mason.nvim',
    opts = {},
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      ensure_installed = {
        'lua_ls', -- editing this config
        'vtsls', 'eslint', -- dps-ui
        'jsonls', 'yamlls', 'html', 'cssls', 'bashls', -- both repos (k8s yaml, etc.)
        'kotlin_lsp', -- kotlin.nvim starts the client itself; see automatic_enable below
      },
      -- kotlin.nvim configures and starts kotlin_lsp itself; if
      -- mason-lspconfig also auto-enables it, the resulting client is
      -- missing the workspace/configuration handler kotlin-lsp needs and
      -- all inlay hints silently disappear. Install it once yourself with
      -- `:MasonInstall kotlin-lsp`.
      automatic_enable = { exclude = { 'kotlin_lsp' } },
    },
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('config-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method 'textDocument/inlayHint' then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
          end
        end,
      })
    end,
  },
}
