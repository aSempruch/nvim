return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- load before anything else needs to check `vim.g.colors_name`
    opts = {
      flavour = 'mocha',
      -- Keep Catppuccin's plugin highlights, with colors closer to IntelliJ Darcula.
      color_overrides = {
        mocha = {
          rosewater = '#d2a6a1',
          flamingo = '#a9b7c6',
          pink = '#9876aa',
          mauve = '#cc7832',
          red = '#bc3f3c',
          maroon = '#c75450',
          peach = '#6897bb',
          yellow = '#ffc66d',
          green = '#6a8759',
          teal = '#629755',
          sky = '#a9b7c6',
          sapphire = '#6897bb',
          blue = '#ffc66d',
          lavender = '#9876aa',
          text = '#a9b7c6',
          subtext1 = '#a9b7c6',
          subtext0 = '#808080',
          overlay2 = '#808080',
          overlay1 = '#777777',
          overlay0 = '#606366',
          surface2 = '#5c6164',
          surface1 = '#4b5052',
          surface0 = '#3c3f41',
          base = '#2b2b2b',
          mantle = '#252525',
          crust = '#1f1f1f',
        },
      },
      styles = { comments = {} },
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
