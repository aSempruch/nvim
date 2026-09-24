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
local listeners = {}
require('config.test_output').consumer { listeners = listeners }
local function complete(id, partial)
  local done
  require('nio').run(function()
    listeners.results('fixture', { [id] = { output = paths[id == 'first' and 1 or 2] } }, partial)
    done = true
  end)
  assert(vim.wait(3000, function() return done end, 20))
end
local function output_window()
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == 'neotest-output' then return w end
  end
end
local function output_text()
  local w = output_window()
  return w and table.concat(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(w), 0, -1, false), '\n') or ''
end
vim.cmd.wincmd('k')
local source_window = vim.api.nvim_get_current_win()
listeners.run('fixture', 'second')
complete('second', true)
assert(output_text():find('FIRST TEST OUTPUT', 1, true), 'Partial result replaced output')
complete('second', false)
assert(vim.wait(3000, function() return output_text():find('SECOND TEST OUTPUT', 1, true) end, 20))
assert(vim.api.nvim_get_current_win() == source_window, 'Automatic refresh stole focus')
assert(#vim.api.nvim_tabpage_list_wins(0) == 3)
-- A late result from an older run must not replace the latest run's output.
complete('first', false)
assert(output_text():find('SECOND TEST OUTPUT', 1, true))
vim.api.nvim_set_current_win(output_window())
vim.api.nvim_feedkeys('q', 'xt', false)
listeners.run('fixture', 'first')
complete('first', false)
assert(not output_window(), 'Completion reopened a closed pane')
for _, path in ipairs(paths) do vim.fn.delete(path) end
print('PASS: selected output, automatic refresh, preserved focus, partial/stale results, and closed pane')
