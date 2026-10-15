if not require('config.features').kotlin_lsp then
  print 'kotlin-lsp download host: SKIP (kotlin_lsp feature disabled)'
  return
end

local registry = require 'mason-registry'
assert(registry.has_package 'kotlin-lsp', 'kotlin-lsp missing from the Mason registry cache')
local pkg = registry.get_package 'kotlin-lsp'

local function assert_official_host()
  for _, target in ipairs(pkg.spec.source.download) do
    for _, url in pairs(target.files) do
      assert(not url:find('download-cdn.jetbrains.com', 1, true), target.target .. ' still uses ' .. url)
    end
  end
end

assert_official_host()

-- A registry refresh swaps in a freshly decoded spec; the fix must reapply.
local reloaded = vim.deepcopy(pkg.spec)
for _, target in ipairs(reloaded.source.download) do
  for name, url in pairs(target.files) do
    target.files[name] = url:gsub('download%.jetbrains%.com', 'download-cdn.jetbrains.com')
  end
end
pkg:update(reloaded, pkg.registry)
registry:emit('update:success', {})
assert_official_host()

print 'kotlin-lsp download host: OK'
