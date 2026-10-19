require('lazy').load { plugins = { 'octo.nvim' }, wait = true }

vim.cmd 'tabnew'
local files = { { path = 'a.kt' }, { path = 'b.kt' }, { path = 'c.kt' } }
local layout = {
	files = files,
	selected_file_idx = 1,
	file_panel = { is_open = function() return true end },
	set_current_file = function(self, file)
		for i, f in ipairs(self.files) do
			if f == file then self.selected_file_idx = i end
		end
	end,
}
require('octo.reviews').reviews[tostring(vim.api.nvim_get_current_tabpage())] = { layout = layout }

local maps = require 'octo.mappings'
for _, name in ipairs { 'select_next_entry', 'select_next_entry_quiet' } do
	layout.selected_file_idx = 2
	maps[name]()
	assert(layout.selected_file_idx == 3, name .. ' did not advance')
	maps[name]()
	assert(layout.selected_file_idx == 3, name .. ' wrapped past the last file')
end
for _, name in ipairs { 'select_prev_entry', 'select_prev_entry_quiet' } do
	layout.selected_file_idx = 2
	maps[name]()
	assert(layout.selected_file_idx == 1, name .. ' did not go back')
	maps[name]()
	assert(layout.selected_file_idx == 1, name .. ' wrapped past the first file')
end

print 'Octo file navigation stops at the ends: OK'
