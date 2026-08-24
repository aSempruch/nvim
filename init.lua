-- Entry point. Kept deliberately thin: leader keys must be set before lazy.nvim
-- loads any plugins, everything else just requires the modules that do the work.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Flip this off if your terminal font isn't a Nerd Font (see README.md).
vim.g.have_nerd_font = true

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.lazy')
