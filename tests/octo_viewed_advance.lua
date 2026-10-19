require('lazy').load { plugins = { 'octo.nvim' }, wait = true }

vim.cmd 'tabnew'
local function file(state)
	return {
		viewed_state = state,
		toggle_viewed = function(self) self.viewed_state = self.viewed_state == 'VIEWED' and 'UNVIEWED' or 'VIEWED' end,
	}
end
local files = { file 'UNVIEWED', file 'VIEWED', file 'DISMISSED' }
local layout
layout = {
	files = files,
	selected_file_idx = 1,
	file_panel = {
		get_file_at_cursor = function() return files[layout.selected_file_idx] end,
	},
	set_current_file = function(self, f)
		for i, candidate in ipairs(self.files) do
			if candidate == f then self.selected_file_idx = i end
		end
	end,
}
require('octo.reviews').reviews[tostring(vim.api.nvim_get_current_tabpage())] = { layout = layout }

local toggle_viewed = require('octo.mappings').toggle_viewed
toggle_viewed()
assert(files[1].viewed_state == 'VIEWED' and layout.selected_file_idx == 2, 'marking did not advance')
toggle_viewed()
assert(files[2].viewed_state == 'UNVIEWED' and layout.selected_file_idx == 2, 'unmarking moved on')
layout.selected_file_idx = 3
toggle_viewed()
assert(files[3].viewed_state == 'VIEWED' and layout.selected_file_idx == 3, 'marking the last file moved')

print 'Octo viewed toggle advances: OK'
