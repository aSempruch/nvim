return {
  { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font, opts = {} },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      spec = {
        { '<leader>f', group = 'Find' },
        { '<leader>g', group = 'Git' },
        { '<leader>h', group = 'Harpoon' },
        { '<leader>k', group = 'Kotlin' },
        { '<leader>x', group = 'Diagnostics/Trouble' },
        { '<leader>c', group = 'Code' },
        { '<leader>u', group = 'UI toggles' },
      },
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = { theme = 'catppuccin', icons_enabled = vim.g.have_nerd_font },
    },
  },

  {
    -- LSP progress spinner in the corner -- useful because kotlin-lsp can
    -- take a while to index a large Gradle multi-module project on attach.
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {},
  },

  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (workspace)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Diagnostics (buffer)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<CR>', desc = 'Symbols outline' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', desc = 'LSP references/definitions' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<CR>', desc = 'Location list' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix list' },
    },
  },

  {
    -- Dired-style file explorer: edit the filesystem like a normal buffer
    -- (rename/delete/create by editing text, then :w). Also a required
    -- dependency of kotlin.nvim (decompiled class-file viewing).
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { default_file_explorer = true },
    keys = {
      { '-', function() require('oil').open() end, desc = 'Open parent directory' },
    },
  },
}
