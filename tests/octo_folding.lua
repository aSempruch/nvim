require('lazy').load { plugins = { 'octo.nvim' }, wait = true }
require('lazy').load { plugins = { 'kotlin.nvim' }, wait = true }
require('kotlin.autocommands').setup_folding { folding = { enabled = true } }

local get_client_by_id = vim.lsp.get_client_by_id
vim.lsp.get_client_by_id = function(client_id)
	if client_id == -1 then
		return {
			name = 'kotlin_lsp',
			server_capabilities = { foldingRangeProvider = true },
			supports_method = function() return false end,
		}
	end
	return get_client_by_id(client_id)
end

local function review_window(octo_review)
	local bufnr = vim.api.nvim_create_buf(false, true)
	if octo_review then
		vim.b[bufnr].octo_diff_props = { path = 'Example.kt', split = 'RIGHT' }
	end

	vim.cmd 'vnew'
	local winid = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(winid, bufnr)
	vim.api.nvim_set_option_value('diff', true, { win = winid })
	vim.api.nvim_set_option_value('foldmethod', 'diff', { win = winid })
	vim.api.nvim_set_option_value('foldlevel', 0, { win = winid })
	return bufnr, winid
end

local octo_bufnr, octo_winid = review_window(true)
vim.api.nvim_exec_autocmds('LspAttach', { buffer = octo_bufnr, data = { client_id = -1 } })
vim.wait(100, function()
	return vim.api.nvim_get_option_value('foldmethod', { win = octo_winid }) == 'diff'
end)
assert(vim.api.nvim_get_option_value('foldmethod', { win = octo_winid }) == 'diff')
assert(vim.api.nvim_get_option_value('foldlevel', { win = octo_winid }) == 0)

local regular_bufnr, regular_winid = review_window(false)
vim.api.nvim_exec_autocmds('LspAttach', { buffer = regular_bufnr, data = { client_id = -1 } })
vim.wait(20)
assert(vim.api.nvim_get_option_value('foldmethod', { win = regular_winid }) == 'expr')
assert(vim.api.nvim_get_option_value('foldlevel', { win = regular_winid }) == 99)

vim.lsp.get_client_by_id = get_client_by_id
