-- See `:help option-list` for the full reference.

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

-- Sync system clipboard on every yank/delete. Scheduled so it doesn't add
-- clipboard-tool startup latency to every `nvim` invocation.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10

-- Prompt to save instead of erroring when e.g. :q'ing a modified buffer.
vim.o.confirm = true
