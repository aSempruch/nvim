local M = {}

function M.run()
  local root = vim.fn.getcwd()
  -- When Neovim starts with `nvim .`, Oil owns the only buffer. Give neotest
  -- a real test file so its adapter can discover the project on first use.
  if vim.bo.filetype == 'oil' then
    local files = vim.fn.globpath(root .. '/tests', '**/test_*.py', false, true)
    if #files == 0 then files = vim.fn.globpath(root .. '/tests', '**/*_test.py', false, true) end
    if files[1] then vim.cmd.edit(vim.fn.fnameescape(files[1])) end
  end
  local neotest = require 'neotest'
  neotest.run.run(root)
  neotest.summary.open()
end

return M
