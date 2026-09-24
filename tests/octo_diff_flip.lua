require('lazy').load { plugins = { 'octo.nvim' }, wait = true }

vim.cmd 'tabnew'
local left = vim.api.nvim_get_current_win()
local old = vim.api.nvim_get_current_buf()
local old_lines = vim.tbl_map(function(i) return 'line ' .. i end, vim.fn.range(1, 100))
local new_lines = vim.deepcopy(old_lines)
table.insert(new_lines, 40, 'inserted line')
new_lines[51] = 'changed line 50'
vim.api.nvim_buf_set_lines(old, 0, -1, false, old_lines)
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
vim.api.nvim_buf_set_lines(new, 0, -1, false, new_lines)
vim.api.nvim_win_call(left, function() vim.cmd 'diffthis' end)
vim.api.nvim_win_call(right, function() vim.cmd 'diffthis' end)
layout.ready = true
assert(vim.wait(1000, function() return layout._config_wide_diff_initialized end))
assert(vim.api.nvim_get_current_win() == right)
assert(vim.api.nvim_win_get_width(right) > vim.api.nvim_win_get_width(left))
assert(vim.api.nvim_win_get_width(left) == 2)
vim.cmd.normal { '62G', bang = true }
assert(vim.api.nvim_win_get_cursor(right)[1] == 62)
assert(vim.api.nvim_win_get_cursor(left)[1] == 61)

local flip = vim.fn.maparg('<leader>d', 'n', false, true).callback
assert(type(flip) == 'function', 'Octo diff flip key was not installed')

flip()
assert(vim.api.nvim_get_current_win() == left)
assert(vim.api.nvim_win_get_width(left) > vim.api.nvim_win_get_width(right))
assert(vim.api.nvim_win_get_width(right) == 2)
assert(vim.api.nvim_win_get_cursor(left)[1] == 61)
vim.cmd.normal { '80G', bang = true }
assert(vim.api.nvim_win_get_cursor(right)[1] == 81)
local moved = false
vim.api.nvim_create_autocmd('WinEnter', {
	once = true,
	callback = function()
		if vim.api.nvim_get_current_win() == right then
			vim.api.nvim_win_set_cursor(right, { 71, 0 })
			moved = true
		end
	end,
})
vim.api.nvim_exec_autocmds('BufWinEnter', { buffer = new })
vim.wait(20)
assert(vim.api.nvim_win_get_width(left) > vim.api.nvim_win_get_width(right))
flip()
assert(vim.api.nvim_get_current_win() == right)
assert(moved, 'focus test did not move the target cursor')
assert(vim.api.nvim_win_get_cursor(right)[1] == 81)
assert(vim.api.nvim_get_option_value('diff', { win = left }))
assert(vim.api.nvim_get_option_value('diff', { win = right }))
assert(vim.api.nvim_get_option_value('scrollbind', { win = left }))
assert(vim.api.nvim_get_option_value('scrollbind', { win = right }))
assert(not vim.api.nvim_get_option_value('wrap', { win = left }))
assert(not vim.api.nvim_get_option_value('wrap', { win = right }))
vim.cmd 'wincmd ='
assert(math.abs(vim.api.nvim_win_get_width(left) - vim.api.nvim_win_get_width(right)) <= 1)

print 'Octo diff flip: OK'
