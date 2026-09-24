-- Run: nvim --headless -u NONE -l tests/gradle_tests.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
local command, script, removed
local tree = {
  data = function() return { type = 'test', path = '/project with spaces/src/test/Test.kt', id = 'example.Test.a test' } end,
}
package.loaded['neotest-gradle'] = {
  root = function() return '/project with spaces' end,
  results = function() return { test = { status = 'failed', errors = { { message = 'failure', line = 5 } } } } end,
}
package.loaded.nio = { fn = { tempname = function() return '/tmp/neotest-report-check' end } }
package.loaded['neotest.lib'] = {
  files = {
    match_root_pattern = function() return function() return '/project with spaces' end end,
    write = function(_, contents) script = contents end,
  },
  process = {
    run = function(args)
      command = args
      return 0, { stdout = 'NEOTEST_XML_DIR=/custom reports/results\n' }
    end,
  },
}
local unlink = vim.uv.fs_unlink
vim.uv.fs_unlink = function(path) removed = path end
local adapter = require('config.gradle_tests').adapter()
local spec = adapter.build_spec { tree = tree }
assert(command[1] == '/project with spaces/gradlew')
assert(script:find('reports.junitXml.outputLocation', 1, true))
assert(removed == '/tmp/neotest-report-check.gradle')
assert(spec.context.test_resuls_directory == '/custom reports/results')
assert(spec.command[1] == '/project with spaces/gradlew')
assert(spec.command[#spec.command] == 'example.Test.a test')
local results = adapter.results(spec, { output = '/tmp/output' }, tree)
assert(results.test.output == '/tmp/output')
assert(results.test.errors[1].line == 5)
package.loaded['neotest.lib'].process.run = function() return 1, { stderr = 'Gradle failed' } end
local ok, err = pcall(adapter.build_spec, { tree = tree })
assert(not ok and err:find('Gradle failed', 1, true))
vim.uv.fs_unlink = unlink
print('PASS: Gradle report location, argument boundaries, failure output, and query errors')
