-- Installs the CLI tools plugins shell out to but don't install themselves
-- (Telescope's rg/fd, nvim-treesitter's `tree-sitter build`) via Homebrew.
-- macOS + brew-present only: on Linux there's no single package manager to
-- assume, and the devcontainer provisions these itself (see
-- .devcontainer/post-start-scripts/080-bg-install-nvim.py in the dev repos).
if vim.fn.has 'mac' == 0 or vim.fn.executable 'brew' == 0 then
  return
end

-- Binary name -> brew formula. Note it's `tree-sitter-cli`, not
-- `tree-sitter`: that formula was split to ship only the runtime library.
local required = {
  rg = 'ripgrep',
  fd = 'fd',
  ['tree-sitter'] = 'tree-sitter-cli',
}

local missing = {}
for bin, formula in pairs(required) do
  if vim.fn.executable(bin) == 0 then
    table.insert(missing, formula)
  end
end

if #missing == 0 then
  return
end

vim.notify('Installing missing tools via Homebrew: ' .. table.concat(missing, ', ') .. '...', vim.log.levels.INFO)

local cmd = { 'brew', 'install' }
for _, formula in ipairs(missing) do
  table.insert(cmd, formula)
end

local result = vim.system(cmd, { text = true }):wait()
if result.code == 0 then
  vim.notify('Installed: ' .. table.concat(missing, ', '), vim.log.levels.INFO)
else
  vim.notify(
    'Failed to install ' .. table.concat(missing, ', ') .. ' via brew:\n' .. (result.stderr or ''),
    vim.log.levels.ERROR
  )
end
