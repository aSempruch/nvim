-- nvim --headless -i NONE '+luafile tests/test_output.lua' '+qa!'
require('lazy').load { plugins = { 'neotest' } }
local neotest = require 'neotest'
local paths = { vim.fn.tempname(), vim.fn.tempname() }
vim.fn.writefile({ 'FIRST TEST OUTPUT' }, paths[1])
vim.fn.writefile({ 'SECOND TEST OUTPUT' }, paths[2])
-- Exercise neotest's actual output renderer with deterministic test results.
require('neotest.consumers.output') {
  get_position = function(_, id)
    return { data = function() return { id = id } end }, 'fixture'
  end,
  get_results = function()
    return {
      first = { output = paths[1] },
      second = { output = paths[2] },
    }
  end,
}
vim.cmd.vsplit()
local function show(id, expected, unexpected)
  neotest.output.open { position_id = id, enter = true }
  assert(vim.wait(3000, function()
    return vim.bo.filetype == 'neotest-output'
      and table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'):find(expected, 1, true)
  end, 20), 'Output did not update to ' .. id)
  local win = vim.api.nvim_get_current_win()
  assert(vim.api.nvim_win_get_config(win).relative == '', 'Output is floating')
  assert(vim.api.nvim_win_get_width(win) == vim.o.columns, 'Output does not span editor')
  assert(#vim.api.nvim_tabpage_list_wins(0) == 3, 'Output windows accumulated')
  if unexpected then
    assert(not table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'):find(unexpected, 1, true))
  end
  return win
end
show('first', 'FIRST TEST OUTPUT')
local win = show('second', 'SECOND TEST OUTPUT', 'FIRST TEST OUTPUT')
vim.api.nvim_feedkeys('q', 'xt', false)
assert(not vim.api.nvim_win_is_valid(win), 'q did not close output')
assert(#vim.api.nvim_tabpage_list_wins(0) == 2)
show('first', 'FIRST TEST OUTPUT', 'SECOND TEST OUTPUT')
for _, path in ipairs(paths) do vim.fn.delete(path) end
print('PASS: bottom output split, selected-test refresh, q, and reopening')
