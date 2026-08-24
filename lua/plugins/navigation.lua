return {
  {
    -- Press `s`, type 1-2 characters, jump straight to that spot on
    -- screen. This is the "ninja jump within a file" plugin.
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash jump' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash treesitter node' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter search' },
      { '<c-s>', mode = 'c', function() require('flash').toggle() end, desc = 'Toggle flash search' },
    },
  },

  {
    -- Pin a handful of files per-project and jump straight to them --
    -- the "ninja jump between projects/files" plugin. Marks follow the
    -- file even as its content changes, unlike plain marks.
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      local map = vim.keymap.set
      map('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon: add file' })
      map('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: quick menu' })
      for i = 1, 4 do
        map('n', '<leader>h' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon: goto file ' .. i })
      end
      map('n', '<C-S-P>', function() harpoon:list():prev() end, { desc = 'Harpoon: previous file' })
      map('n', '<C-S-N>', function() harpoon:list():next() end, { desc = 'Harpoon: next file' })
    end,
  },

  {
    -- `ys<motion><char>` add, `ds<char>` delete, `cs<char1><char2>`
    -- change a surrounding pair -- Neovim core has no equivalent.
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.surround').setup()
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
}
