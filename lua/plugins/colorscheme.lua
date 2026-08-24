return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- load before anything else needs to check `vim.g.colors_name`
    opts = {
      flavour = 'mocha',
      integrations = {
        treesitter = true,
        telescope = { enabled = true },
        gitsigns = true,
        which_key = true,
        blink_cmp = true,
        mason = true,
        native_lsp = { enabled = true },
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
