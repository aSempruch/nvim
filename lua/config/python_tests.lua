local M = {}

function M.adapter()
  local base = require 'neotest-python.base'
  local has_uv = vim.fn.executable('uv') == 1
  local adapter = require('neotest-python') {
    python = function(root)
      if vim.uv.fs_stat(root .. '/uv.lock') and has_uv then
        return { 'uv', 'run', '--project', root, 'python' }
      end
      return base.get_python_command(root)
    end,
  }
  local build_spec = adapter.build_spec
  adapter.build_spec = function(args)
    local position = args.tree:data()
    local spec = build_spec(args)
    local root = base.get_root(position.path) or vim.uv.cwd()
    spec.cwd = root
    local runner
    for i, value in ipairs(spec.command) do
      if value == '--runner' then runner = spec.command[i + 1] end
    end
    -- unittest does not descend into a tests/ directory without __init__.py.
    -- Match `python -m unittest discover -s tests` for that common layout.
    if runner == 'unittest' and position.type == 'dir' and position.path == root
      and vim.uv.fs_stat(root .. '/tests')
      and not vim.uv.fs_stat(root .. '/tests/__init__.py') then
      spec.command[#spec.command] = root .. '/tests'
    end
    return spec
  end
  return adapter
end

return M
