return {
  { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font, opts = {} },

  {
    -- File tabs represent buffers; native tabpages remain window layouts.
    'akinsho/bufferline.nvim',
    version = '*',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<S-h>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous file' },
      { '<S-l>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next file' },
    },
    opts = {
      options = {
        mode = 'buffers',
        always_show_bufferline = true,
        show_buffer_icons = vim.g.have_nerd_font,
        separator_style = 'thin',
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      spec = {
        { '<leader>f', group = 'Find' },
        { '<leader>g', group = 'Git' },
        { '<leader>h', group = 'Harpoon' },
        { '<leader>x', group = 'Diagnostics/Trouble' },
        { '<leader>c', group = 'Code' },
        { '<leader>u', group = 'UI toggles' },
        require('config.features').kotlin_lsp and { '<leader>k', group = 'Kotlin' } or nil,
      },
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = { theme = 'auto', icons_enabled = vim.g.have_nerd_font },
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
    -- Fzf-style filtering and a live file preview pane for the native
    -- quickfix window -- what `grr` (LSP references) populates.
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {},
  },

  {
    -- Dired-style file explorer: edit the filesystem like a normal buffer
    -- (rename/delete/create by editing text, then :w). Also a required
    -- dependency of kotlin.nvim (decompiled class-file viewing).
    'stevearc/oil.nvim',
    lazy = false, -- Claim directory buffers before netrw handles startup arguments.
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == '.DS_Store'
        end,
      },
    },
    keys = {
      { '-', function() require('oil').open() end, desc = 'Open parent directory' },
    },
  },

  {
    -- Renders markdown (headings, code blocks, tables, checkboxes, ...) in
    -- place using the treesitter parser -- no browser or external process.
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
      { '<leader>um', function() require('render-markdown').toggle() end, desc = 'Toggle rendered markdown' },
    },
  },
}
