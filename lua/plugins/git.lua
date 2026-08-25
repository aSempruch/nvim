return {
	{
		-- Inline gutter signs for added/changed/deleted lines, hunk stage/reset,
		-- and blame -- this is IntelliJ's "changed lines in the gutter" gadget.
		'lewis6991/gitsigns.nvim',
		event = 'VeryLazy',
		opts = {
			on_attach = function(bufnr)
				local gs = require 'gitsigns'
				local map = function(mode, l, r, desc)
					vim.keymap.set(mode, l, r,
						{ buffer = bufnr, desc = desc })
				end

				map('n', ']c', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(gs.next_hunk)
					return '<Ignore>'
				end, 'Next hunk')
				map('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(gs.prev_hunk)
					return '<Ignore>'
				end, 'Previous hunk')

				map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
				map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
				map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
					'Stage hunk')
				map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
					'Reset hunk')
				map('n', '<leader>gS', gs.stage_buffer, 'Stage buffer')
				map('n', '<leader>gR', gs.reset_buffer, 'Reset buffer')
				map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
				map('n', '<leader>gb', function() gs.blame_line { full = true } end, 'Blame line')
			end,
		},
	},

	{
		-- Full-tapbage diff/history browser -- this is IntelliJ's "Compare
		-- with Branch" and "Show History for Selection", in one plugin.
		'sindrets/diffview.nvim',
		cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
		keys = {
			{ '<leader>go', '<cmd>DiffviewOpen<CR>',          desc = 'Diff against HEAD' },
			{
				'<leader>gm',
				function()
					-- A local `main` branch ref only moves when you explicitly update it
					-- and easily goes stale, which pulls other people's merged commits
					-- into the diff. Fetch the real tip first so the merge-base -- and
					-- therefore the diff -- only ever reflects your own branch.
					vim.system({ 'git', 'fetch', 'origin', 'main' }, { cwd = vim.fn.getcwd() },
						function(result)
							vim.schedule(function()
								if result.code ~= 0 then
									vim.notify(
										'git fetch origin main failed:\n' ..
										result.stderr, vim.log.levels.ERROR)
									return
								end
								vim.cmd 'DiffviewOpen origin/main...HEAD'
							end)
						end)
				end,
				desc = 'Diff against main (fetch first, PR-style)',
			},
			{ '<leader>gc', '<cmd>DiffviewClose<CR>',         desc = 'Close diffview' },
			{ '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'File history (current file)' },
			{ '<leader>gH', '<cmd>DiffviewFileHistory<CR>',   desc = 'File history (whole repo)' },
		},
		opts = {
			hooks = {
				-- Long lines wrapping would desync the left/right panes' line
				-- alignment, so keep diff panes nowrap regardless of the global
				-- default.
				diff_buf_read = function() vim.opt_local.wrap = false end,
			},
			file_panel = {
				win_config = { width = 80 },
			},
		},
	},
}
