return {
  {
    'savq/melange-nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      -- Keep Melange's syntax colors, but use Darcula-like neutral surfaces.
      local grays = require('melange/palettes/dark').a
      grays.bg = '#2B2B2B'
      grays.float = '#333333'
      grays.sel = '#414141'
      vim.cmd.colorscheme 'melange'
    end,
  },
}
