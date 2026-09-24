require('lazy').load { plugins = { 'octo.nvim' }, wait = true }

vim.cmd 'tabnew'
local bufnr = vim.api.nvim_create_buf(false, true)
vim.b[bufnr].octo_diff_props = { path = 'Example.kt', split = 'RIGHT' }
vim.api.nvim_win_set_buf(0, bufnr)
assert(vim.fn.maparg('<leader>d', 'n', false, true).callback == nil)

print 'Octo wide diff disabled: OK'
