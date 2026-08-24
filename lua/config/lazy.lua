-- Bootstraps lazy.nvim (cloning it on first run) and loads every plugin spec
-- under lua/plugins/*.lua.
--
-- Neovim 0.12 shipped its own built-in plugin manager (`vim.pack`), but it
-- has no event/filetype-based lazy loading -- lazy.nvim's DSL for that is
-- still the reason to reach for a third-party manager rather than core.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    { import = 'plugins' },
  },
  install = { colorscheme = { 'catppuccin' } },
  checker = { enabled = true, notify = false },
}
