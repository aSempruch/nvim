local M = {}

function M.setup(neotest)
  local open = neotest.output.open
  local output_window
  neotest.output.open = function(opts)
    opts = vim.tbl_extend('force', {}, opts or {})
    -- Neotest otherwise only focuses an already-open output window, even
    -- when another test was selected. Close it so the requested output loads.
    local height = 15
    if output_window and vim.api.nvim_win_is_valid(output_window) then
      height = vim.api.nvim_win_get_height(output_window)
      if #vim.api.nvim_tabpage_list_wins(0) == 1 then
        vim.cmd('aboveleft vnew')
      end
      vim.api.nvim_win_close(output_window, true)
    end
    opts.open_win = function()
      vim.cmd('botright new')
      vim.cmd.resize(math.min(height, math.max(3, math.floor(vim.o.lines / 3))))
      output_window = vim.api.nvim_get_current_win()
      return output_window
    end
    open(opts)
  end
end

return M
