return {
  {
    'doums/darcula',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termguicolors = true
      vim.cmd.colorscheme 'darcula'
    end,
  },
}
