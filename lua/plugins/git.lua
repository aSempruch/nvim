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

				-- In a real `:diffthis` window fall through to Vim's own ]c/[c;
				-- otherwise jump between gitsigns hunks. Wrapped so `;`/`,`
				-- repeat the jump (see config/repeatable.lua).
				local function hunk(direction)
					return function()
						if vim.wo.diff then
							local key = direction == 'next' and ']c' or '[c'
							vim.cmd.normal { vim.v.count1 .. key, bang = true }
						else
							gs.nav_hunk(direction, { count = vim.v.count1 })
						end
					end
				end
				local next_hunk, prev_hunk = require('config.repeatable').pair(hunk 'next', hunk 'prev')
				map('n', ']c', next_hunk, 'Next hunk')
				map('n', '[c', prev_hunk, 'Previous hunk')

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
		opts = function()
			local actions = require 'diffview.actions'
			-- Wrapped so `;`/`,` repeat next/prev-file (see config/repeatable.lua).
			local next_file, prev_file = require('config.repeatable').pair(
				actions.select_next_entry, actions.select_prev_entry)
			return {
				hooks = {
					-- Long lines wrapping would desync the left/right panes' line
					-- alignment, so keep diff panes nowrap regardless of the global
					-- default.
					diff_buf_read = function() vim.opt_local.wrap = false end,
				},
				file_panel = {
					win_config = { width = 80 },
				},
				keymaps = {
					-- Match Octo's PR-review next/prev-file bindings so the same
					-- muscle memory works in a plain diffview.
					view = {
						[']q'] = next_file,
						['[q'] = prev_file,
					},
					file_panel = {
						[']q'] = next_file,
						['[q'] = prev_file,
					},
				},
			}
		end,
	},

	{
		-- In-editor status/stage/commit UI (magit-style) -- the CLI is still
		-- fine for a quick `git commit`, but this covers interactive staging
		-- and writing a commit message without leaving the buffer.
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
		},
		cmd = 'Neogit',
		keys = {
			{ '<leader>gg', '<cmd>Neogit<CR>', desc = 'Git status (Neogit)' },
		},
		opts = {
			integrations = { diffview = true },
		},
	},

	{
		-- GitHub PR/issue review from inside buffers: PR description,
		-- inline review threads, and approve/request-changes. Auth is
		-- delegated to the `gh` CLI, so `gh auth login` is the only setup
		-- needed -- no separate token to manage.
		'pwntester/octo.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		cmd = 'Octo',
		keys = {
			{ '<leader>gi', '<cmd>Octo pr list<CR>', desc = 'List PRs' },
			{
				'<leader>gv',
				function()
					-- Octo's own `Octo pr` (view) has no create fallback -- it just
					-- errors with "No pr found for current branch" -- so check
					-- ourselves first and route to `pr create` when there isn't one.
					vim.system({ 'gh', 'pr', 'view', '--json', 'number' }, { cwd = vim.fn.getcwd() },
						function(result)
							vim.schedule(function()
								if result.code == 0 and vim.trim(result.stdout or '') ~= '' then
									vim.cmd 'Octo pr'
								else
									vim.cmd 'Octo pr create'
								end
							end)
						end)
				end,
				desc = 'Open PR for current branch (create if none exists)',
			},
		},
		config = function()
			require('octo').setup {
				-- Back the PR side of review diffs with the checked-out file so
				-- language servers can provide hints, navigation, and diagnostics.
				use_local_fs = true,
				mappings = {
					review_diff = {
						-- `next_hunk`/`prev_hunk` aren't built-in Octo actions -- they're
						-- defined below on `octo_maps`, the same way this config wires
						-- up any other custom mapping callback.
						next_hunk = { lhs = ']c', desc = 'move to next hunk (or next file)' },
						prev_hunk = { lhs = '[c', desc = 'move to previous hunk (or previous file)' },
					},
				},
			}

			-- Octo only lets you configure the *lhs* of its review mappings; the
			-- callbacks come from its internal `octo.mappings` table, which it
			-- looks up by name each time it binds a review buffer. Swap the
			-- next/prev-file and next/prev-comment entries there for repeatable
			-- versions so `;`/`,` work in PR reviews too (see config/repeatable.lua).
			local octo_maps = require 'octo.mappings'
			local select_next_entry = octo_maps.select_next_entry
			local select_prev_entry = octo_maps.select_prev_entry
			octo_maps.select_next_entry, octo_maps.select_prev_entry =
				require('config.repeatable').pair(select_next_entry, select_prev_entry)
			octo_maps.next_comment, octo_maps.prev_comment =
				require('config.repeatable').pair(octo_maps.next_comment, octo_maps.prev_comment)

			-- kotlin.nvim switches a newly attached Kotlin window to LSP expression
			-- folds. In a review that overrides Octo's diff folds on only the local
			-- (right) side, so the two panes stop lining up. Restore Octo's window
			-- settings after every LspAttach callback has finished.
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('config-octo-diff-folds', { clear = true }),
				callback = function(args)
					if not vim.b[args.buf].octo_diff_props then
						return
					end

					vim.schedule(function()
						if not vim.api.nvim_buf_is_valid(args.buf) then
							return
						end
						for _, winid in ipairs(vim.fn.win_findbuf(args.buf)) do
							if vim.api.nvim_get_option_value('diff', { win = winid }) then
								vim.api.nvim_set_option_value('foldmethod', 'diff', { win = winid })
								vim.api.nvim_set_option_value('foldlevel', 0, { win = winid })
							end
						end
					end)
				end,
				desc = 'Keep Octo review diff folds aligned after LSP attach',
			})

			-- Review-diff buffers are synthetic (`octo://...`), so gitsigns never
			-- attaches to them and never gets a chance to fall through to the
			-- next/previous file the way ]q/[q do (see the gitsigns on_attach
			-- above). Wire ]c/[c here instead: try the native diff-hunk jump, and
			-- only once a press fails to move the cursor *twice in a row* --
			-- i.e. you're already sitting at the last/first hunk and pressed
			-- again -- fall through to the next/previous file. The first no-op
			-- press is left alone so it still reads as "no more hunks here",
			-- same as plain Vim ]c/[c.
			local function octo_diff_hunk(direction)
				local key = direction == 'next' and ']c' or '[c'
				local at_boundary_var = direction == 'next' and 'octo_at_last_hunk' or 'octo_at_first_hunk'
				return function()
					local bufnr = vim.api.nvim_get_current_buf()
					local before = vim.api.nvim_win_get_cursor(0)
					vim.cmd.normal { key, bang = true }
					local after = vim.api.nvim_win_get_cursor(0)

					if before[1] ~= after[1] or before[2] ~= after[2] then
						vim.b[bufnr][at_boundary_var] = false
					elseif vim.b[bufnr][at_boundary_var] then
						vim.b[bufnr][at_boundary_var] = false
						-- This file jump is part of the hunk motion. Use Octo's raw
						-- callback so it does not replace the repeat history with ]q/[q.
						local entry_jump = direction == 'next' and select_next_entry or select_prev_entry
						entry_jump()
					else
						vim.b[bufnr][at_boundary_var] = true
					end
				end
			end
			octo_maps.next_hunk, octo_maps.prev_hunk =
				require('config.repeatable').pair(octo_diff_hunk 'next', octo_diff_hunk 'prev')

			-- Checkout the current PR into an isolated worktree under /tmp
			-- (instead of switching branches in this repo) and jump straight
			-- into Octo's side-by-side review for it.
			local worktree_root = '/tmp/octo-worktrees'
			local function checkout_pr_worktree()
				local buffer = require('octo.utils').get_current_buffer()
				if not buffer or not buffer:isPullRequest() then
					vim.notify('Octo: not in a PR buffer', vim.log.levels.ERROR)
					return
				end

				local pr_number = buffer.number
				local repo_root = vim.trim(vim.fn.system 'git rev-parse --show-toplevel')
				if vim.v.shell_error ~= 0 then
					vim.notify('git rev-parse --show-toplevel failed', vim.log.levels.ERROR)
					return
				end
				local repo_name = vim.fn.fnamemodify(repo_root, ':t')
				local worktree_path = string.format('%s/%s-pr-%d', worktree_root, repo_name, pr_number)

				local function start_review_in_worktree()
					vim.schedule(function()
						-- `Octo review` (no subcommand) starts a fresh review or
						-- resumes a pending one for the viewer, and either way
						-- opens its own tab (`tab split`) for the layout,
						-- inheriting whatever directory is current when it
						-- fires -- so `tcd` here rather than pre-opening a tab
						-- ourselves, which just leaves a blank one behind it.
						vim.cmd('tcd ' .. vim.fn.fnameescape(worktree_path))
						vim.cmd 'Octo review'
					end)
				end

				-- `gh pr checkout` updates the local branch via a fetch-style ref
				-- update rather than a plain `git checkout`, so re-running it
				-- against a worktree that already has the branch checked out
				-- fails with "already used by worktree" -- git's checked-out-ref
				-- guard doesn't exempt the current worktree the way `git checkout
				-- <branch>` does. If the worktree already has a branch checked
				-- out, skip `gh pr checkout` and just fast-forward it to the
				-- PR's latest commit instead.
				local function refresh_existing_checkout(branch)
					vim.system({ 'git', 'fetch', 'origin', branch }, { cwd = worktree_path }, function(fetch_result)
						if fetch_result.code ~= 0 then
							vim.schedule(function()
								vim.notify('git fetch failed:\n' .. fetch_result.stderr, vim.log.levels.ERROR)
							end)
							return
						end
						vim.system({ 'git', 'reset', '--hard', 'FETCH_HEAD' }, { cwd = worktree_path },
							function(reset_result)
								if reset_result.code ~= 0 then
									vim.schedule(function()
										vim.notify('git reset failed:\n' .. reset_result.stderr, vim.log.levels.ERROR)
									end)
									return
								end
								start_review_in_worktree()
							end)
					end)
				end

				local function checkout_in_worktree()
					vim.system({ 'git', 'branch', '--show-current' }, { cwd = worktree_path }, function(branch_result)
						if branch_result.code ~= 0 then
							vim.schedule(function()
								vim.notify('git branch --show-current failed:\n' .. branch_result.stderr,
									vim.log.levels.ERROR)
							end)
							return
						end

						local current_branch = vim.trim(branch_result.stdout or '')
						if current_branch ~= '' then
							refresh_existing_checkout(current_branch)
							return
						end

						vim.system({ 'gh', 'pr', 'checkout', tostring(pr_number) }, { cwd = worktree_path },
							function(result)
								if result.code ~= 0 then
									vim.schedule(function()
										vim.notify('gh pr checkout failed:\n' .. result.stderr, vim.log.levels.ERROR)
									end)
									return
								end
								start_review_in_worktree()
							end)
					end)
				end

				if vim.fn.isdirectory(worktree_path) == 1 then
					checkout_in_worktree()
					return
				end

				vim.fn.mkdir(worktree_root, 'p')
				vim.system({ 'git', 'worktree', 'add', '--detach', worktree_path }, { cwd = repo_root },
					function(result)
						if result.code ~= 0 then
							vim.schedule(function()
								vim.notify('git worktree add failed:\n' .. result.stderr, vim.log.levels.ERROR)
							end)
							return
						end
						checkout_in_worktree()
					end)
			end

			vim.api.nvim_create_autocmd('FileType', {
				pattern = 'octo',
				callback = function(args)
					vim.keymap.set('n', '<leader>pw', checkout_pr_worktree,
						{ buffer = args.buf, desc = 'Checkout PR into worktree + start review' })
				end,
			})

			-- Octo's own `gf` in a review diff always does `:edit` in the
			-- diff pane itself. Override it to open in a new tab instead,
			-- leaving the diff/review layout intact behind it.
			local function goto_file_new_tab()
				local octo_utils = require 'octo.utils'
				local bufnr = vim.api.nvim_get_current_buf()
				if not octo_utils.in_diff_window(bufnr) then
					return
				end
				local _, path = octo_utils.get_split_and_path(bufnr)
				if not path then
					return
				end
				local line = vim.api.nvim_win_get_cursor(0)[1]
				local full_path = octo_utils.path_join { vim.fn.getcwd(), path }
				if vim.fn.filereadable(full_path) == 0 then
					local git_root = vim.trim(vim.fn.system 'git rev-parse --show-toplevel')
					full_path = octo_utils.path_join { git_root, path }
				end
				vim.cmd 'tabnew'
				vim.cmd('edit ' .. vim.fn.fnameescape(full_path))
				vim.api.nvim_win_set_cursor(0, { line, 0 })
			end

			vim.api.nvim_create_autocmd('BufWinEnter', {
				callback = function(args)
					if vim.b[args.buf].octo_diff_props then
						vim.keymap.set('n', 'gf', goto_file_new_tab,
							{ buffer = args.buf, desc = 'Go to file (new tab)' })
					end
				end,
			})
		end,
	},
}
