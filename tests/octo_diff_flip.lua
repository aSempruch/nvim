require('lazy').load { plugins = { 'octo.nvim' }, wait = true }

vim.cmd 'tabnew'
local left = vim.api.nvim_get_current_win()
local old = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(old, 0, -1, false, { 'one', 'old', 'three' })
vim.cmd 'vsplit'
local right = vim.api.nvim_get_current_win()
vim.cmd 'split'
vim.cmd 'wincmd J'
vim.cmd 'resize 8'
local panel = vim.api.nvim_get_current_win()
vim.api.nvim_set_current_win(right)

local reviews = require 'octo.reviews'
local layout = setmetatable({
	tabpage = vim.api.nvim_get_current_tabpage(),
	left_winid = left, right_winid = right, ready = false, files = {},
	file_panel = { winid = panel },
}, { __index = require('octo.reviews.layout').Layout })
reviews.reviews[tostring(vim.api.nvim_get_current_tabpage())] = {
	layout = layout,
}
local new = vim.api.nvim_create_buf(false, true)
vim.b[new].octo_diff_props = { path = 'Example.kt', split = 'RIGHT' }
vim.api.nvim_win_set_buf(right, new)
vim.api.nvim_buf_set_lines(new, 0, -1, false, { 'one', 'new', 'three', 'four' })
vim.api.nvim_win_call(left, function() vim.cmd 'diffthis' end)
vim.api.nvim_win_call(right, function() vim.cmd 'diffthis' end)
layout.ready = true
assert(vim.wait(1000, function() return layout._config_wide_diff_initialized end))
assert(vim.api.nvim_get_current_win() == right)
assert(vim.api.nvim_win_get_width(right) > vim.api.nvim_win_get_width(left))

local flip = vim.fn.maparg('<leader>d', 'n', false, true).callback
assert(type(flip) == 'function', 'Octo diff flip key was not installed')

flip()
assert(vim.api.nvim_get_current_win() == left)
assert(vim.api.nvim_win_get_width(left) > vim.api.nvim_win_get_width(right))
vim.api.nvim_exec_autocmds('BufWinEnter', { buffer = new })
vim.wait(20)
assert(vim.api.nvim_win_get_width(left) > vim.api.nvim_win_get_width(right))
flip()
assert(vim.api.nvim_get_current_win() == right)
assert(vim.api.nvim_get_option_value('diff', { win = left }))
assert(vim.api.nvim_get_option_value('diff', { win = right }))
assert(vim.api.nvim_get_option_value('scrollbind', { win = left }))
assert(vim.api.nvim_get_option_value('scrollbind', { win = right }))
assert(not vim.api.nvim_get_option_value('wrap', { win = left }))
assert(not vim.api.nvim_get_option_value('wrap', { win = right }))

print 'Octo diff flip: OK'
