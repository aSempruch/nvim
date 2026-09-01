-- Core, plugin-independent keymaps.
--
-- Neovim itself already binds a lot of what you'd expect to configure by
-- hand these days: `]d`/`[d`/`]D`/`[D` (diagnostic jump), `<C-w>d`
-- (diagnostic float), `grn` (rename), `gra` (code action), `grr`
-- (references), `gri` (implementation), `grt` (type definition), `gO`
-- (document symbols), `K` (hover), `<C-s>` in insert mode (signature help).
-- Those are NOT redefined here. See `:help lsp-defaults`.

local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- gd isn't one of the built-in defaults (gd is kept as plain-vim "goto
-- local declaration"), so it's worth reclaiming for LSP definition.
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto Definition' })

-- A comfier alias for the diagnostic float than the default <C-w>d.
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic under cursor' })

-- Window navigation without the <C-w> prefix.
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Exit terminal-mode with the same key that exits everything else.
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Move the current line/selection up or down, reindenting as it goes.
map('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Paste over a visual selection without clobbering the unnamed register
-- with the text that just got replaced.
map('v', '<leader>p', '"_dP', { desc = 'Paste over selection, keep register' })

-- <C-d>/<C-u> scroll a fixed 8 lines. (The 'scroll' option can't be used
-- for this: Vim silently resets it to half the window height whenever the
-- window is resized, so it gets clobbered during startup.) A count given
-- directly to <C-d>/<C-u> isn't subject to that reset.
map('n', '<C-d>', '8<C-d>', { desc = 'Scroll down 8 lines' })
map('n', '<C-u>', '8<C-u>', { desc = 'Scroll up 8 lines' })

-- Arrow keys scroll the view instead of moving the cursor: up/down mirror
-- <C-u>/<C-d> above, left/right pan horizontally by a half screen width.
map('n', '<Down>', '8<C-d>', { desc = 'Scroll down' })
map('n', '<Up>', '8<C-u>', { desc = 'Scroll up' })
map('n', '<Left>', 'zH', { desc = 'Scroll left' })
map('n', '<Right>', 'zL', { desc = 'Scroll right' })

map('n', '<leader>ui', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { desc = 'Toggle inlay hints' })
