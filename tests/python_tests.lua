-- Run: nvim --headless -u NONE -l tests/python_tests.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
local root = vim.fn.tempname()
vim.fn.mkdir(root .. '/tests', 'p')
vim.fn.writefile({}, root .. '/uv.lock')
local config, runner = nil, 'unittest'
package.loaded['neotest-python.base'] = {
  get_root = function() return root end,
  get_python_command = function() return { 'fallback-python' } end,
}
package.loaded['neotest-python'] = function(opts)
  config = opts
  return {
    build_spec = function(args)
      return { command = { 'python', 'adapter.py', '--runner', runner, '--', args.tree:data().id } }
    end,
  }
end
local adapter = require('config.python_tests').adapter()
local function spec(kind, path)
  return adapter.build_spec { tree = { data = function()
    return { type = kind, path = path, id = path }
  end } }
end
local suite = spec('dir', root)
assert(suite.command[#suite.command] == root .. '/tests')
assert(suite.cwd == root)
local file = spec('file', root .. '/tests/test_example.py')
assert(file.command[#file.command] == root .. '/tests/test_example.py')
runner = 'pytest'
local pytest = spec('dir', root)
assert(pytest.command[#pytest.command] == root)
runner = 'unittest'
vim.fn.writefile({}, root .. '/tests/__init__.py')
local package_suite = spec('dir', root)
assert(package_suite.command[#package_suite.command] == root)
if vim.fn.executable('uv') == 1 then
  assert(vim.deep_equal(config.python(root), { 'uv', 'run', '--project', root, 'python' }))
end
vim.fn.delete(root .. '/uv.lock')
assert(config.python(root)[1] == 'fallback-python')
vim.fn.delete(root, 'rf')
print('PASS: unittest discovery, package/pytest/file preservation, cwd and uv selection')
