require('lazy').load { plugins = { 'octo.nvim', 'lualine.nvim' }, wait = true }

local progress = require 'config.octo_review_progress'
assert(not progress.is_test 'src/main/kotlin/Foo.kt')
assert(not progress.is_test 'build.gradle.kts')
assert(progress.is_test 'src/test/kotlin/FooTest.kt')
assert(progress.is_test 'module/src/testFixtures/kotlin/Fixture.kt')
assert(progress.is_test 'module/src/integrationTest/kotlin/FooIT.kt')

vim.cmd 'tabnew'
local diff = vim.api.nvim_get_current_win()
vim.cmd 'split'
local panel = vim.api.nvim_get_current_win()
vim.bo[vim.api.nvim_win_get_buf(panel)].filetype = 'octo_panel'
vim.api.nvim_set_current_win(diff)

local layout = {
	selected_file_idx = 2,
	files = {
		{ path = 'app/src/main/kotlin/A.kt', viewed_state = 'VIEWED' },
		{ path = 'app/src/main/kotlin/B.kt', viewed_state = 'UNVIEWED' },
		{ path = 'app/build.gradle.kts', viewed_state = 'DISMISSED' },
		{ path = 'app/src/test/kotlin/ATest.kt', viewed_state = 'VIEWED' },
	},
}
require('octo.reviews').reviews[tostring(vim.api.nvim_get_current_tabpage())] = { layout = layout }

require('lualine').refresh { force = true, scope = 'tabpage', place = { 'statusline' } }
local line = vim.api.nvim_eval_statusline(vim.wo[panel].statusline, { winid = panel }).str
assert(line:find('viewed: main 1/3 · test 1/1', 1, true), 'missing viewed counts: ' .. line)
assert(line:find('file 2/4', 1, true), 'missing file position: ' .. line)

print 'Octo review progress: OK'
