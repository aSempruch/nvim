local M = {}

function M.toggle_test_summary()
  -- Neotest closes its panel with nvim_win_close(), which cannot close the
  -- last ordinary window. Restore an editing window before hiding that panel.
  local windows = vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_config(win).relative == ''
  end, vim.api.nvim_tabpage_list_wins(0))
  if #windows == 1 and vim.bo[vim.api.nvim_win_get_buf(windows[1])].filetype == 'neotest-summary' then
    vim.api.nvim_set_current_win(windows[1])
    vim.cmd('aboveleft vnew')
    vim.wo.winfixbuf = false
    vim.wo.winfixwidth = false
  end
  require('neotest').summary.toggle()
end

function M.close(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if vim.bo[buf].filetype == 'neotest-summary' then
    M.toggle_test_summary()
    return
  end
  require('mini.bufremove').delete(buf, false)
end

return M
