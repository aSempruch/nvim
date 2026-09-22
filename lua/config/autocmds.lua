-- Flash the yanked region briefly, like most other editors do.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('config-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reopen a file where you left off.
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore cursor to last known position',
  group = vim.api.nvim_create_augroup('config-restore-cursor', { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- A file can change indentation style during editing (for example, replacing
-- all tabs with spaces). Refresh buffer options before save formatters run.
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Detect current indentation before formatting',
  group = vim.api.nvim_create_augroup('config-detect-indent-on-save', { clear = true }),
  callback = function(args)
    local editorconfig = vim.b[args.buf].editorconfig or {}
    if not (editorconfig.indent_style or editorconfig.indent_size or editorconfig.tab_width) then
      -- Fall back to the global two-space defaults if the edited buffer no
      -- longer has enough indentation to infer a style.
      for _, option in ipairs({ 'expandtab', 'tabstop', 'shiftwidth', 'softtabstop' }) do
        vim.bo[args.buf][option] = vim.go[option]
      end
    end
    require('guess-indent').set_from_buffer(args.buf, true, true)
  end,
})
