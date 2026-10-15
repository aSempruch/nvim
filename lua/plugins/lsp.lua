-- Kotlin's language server (kotlin-lsp) is wired up separately in
-- plugins/kotlin.lua via kotlin.nvim, which needs to own its client
-- lifecycle. Everything else goes through the standard
-- mason -> mason-lspconfig -> nvim-lspconfig -> vim.lsp.enable() pipeline.
local ensure_installed = {
  'lua_ls', -- editing this config
  'pyright', -- Python
  'vtsls', 'eslint', -- dps-ui
  'jsonls', 'yamlls', 'html', 'cssls', 'bashls', -- both repos (k8s yaml, etc.)
}

if require('config.features').kotlin_lsp then
  table.insert(ensure_installed, 'kotlin_lsp')
end

return {
  {
    'mason-org/mason.nvim',
    opts = {},
    config = function(_, opts)
      require('mason').setup(opts)

      -- TEMPORARY: mason-registry's kotlin-lsp recipe downloads unsigned
      -- download-cdn.jetbrains.com URLs, which now 404 for every release;
      -- download.jetbrains.com redirects to signed CDN URLs. Delete this
      -- block (and tests/kotlin_lsp_download.lua) once
      -- https://github.com/mason-org/mason-registry/issues/17366 is fixed --
      -- the rewrite is a no-op by then. Reapplied on every registry refresh
      -- because a refresh replaces the package spec.
      if require('config.features').kotlin_lsp then
        local registry = require 'mason-registry'
        local function use_official_kotlin_lsp_host()
          if not registry.has_package 'kotlin-lsp' then return end
          for _, target in ipairs(registry.get_package('kotlin-lsp').spec.source.download) do
            for name, url in pairs(target.files) do
              target.files[name] = url:gsub('//download%-cdn%.jetbrains%.com/', '//download.jetbrains.com/')
            end
          end
        end
        use_official_kotlin_lsp_host()
        registry:on('update:success', use_official_kotlin_lsp_host)
      end
    end,
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      ensure_installed = ensure_installed,
      -- kotlin.nvim configures and starts kotlin_lsp itself; if
      -- mason-lspconfig also auto-enables it, the resulting client is
      -- missing the workspace/configuration handler kotlin-lsp needs and
      -- all inlay hints silently disappear.
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
