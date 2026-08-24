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
