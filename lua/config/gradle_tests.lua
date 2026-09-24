-- Adapt the upstream runner to modern Gradle's report-directory API.
local M = {}

function M.adapter()
  local adapter = vim.tbl_extend('force', {}, require('neotest-gradle'))
  local lib = require 'neotest.lib'

  adapter.build_spec = function(args)
    local position = args.tree:data()
    local root = adapter.root(position.path)
    local wrapper_root = lib.files.match_root_pattern('gradlew')(root)
    local executable = wrapper_root and (wrapper_root .. '/gradlew') or 'gradle'
    local init_script = require('nio').fn.tempname() .. '.gradle'
    -- Query the actual test task: respects custom build/report directories.
    lib.files.write(init_script, [[
gradle.projectsEvaluated {
  def p = gradle.rootProject.allprojects.find { it.projectDir == gradle.startParameter.currentDir }
  def t = p?.tasks?.findByName('test')
  if (t instanceof org.gradle.api.tasks.testing.Test) {
    println('NEOTEST_XML_DIR=' + t.reports.junitXml.outputLocation.get().asFile.absolutePath)
  }
}
]])
    local code, output = lib.process.run({ executable, '--project-dir', root,
      '--console=plain', '-q', '-I', init_script, 'help' }, { stdout = true, stderr = true })
    vim.uv.fs_unlink(init_script)
    local directory = (output.stdout or ''):match('NEOTEST_XML_DIR=([^\r\n]+)')
    assert(code == 0 and directory, 'Could not locate Gradle test XML reports: ' .. (output.stderr or output.stdout or ''))

    local command = { executable, '--project-dir', root, '--console=plain', 'test' }
    if position.type == 'test' or position.type == 'namespace' then
      vim.list_extend(command, { '--tests', position.id })
    elseif position.type == 'file' then
      for _, node in args.tree:iter() do
        if node.type == 'namespace' then
          vim.list_extend(command, { '--tests', node.id })
        end
      end
    end
    return { command = command, context = { test_resuls_directory = directory } }
  end

  local collect_results = adapter.results
  adapter.results = function(spec, result, tree)
    local results = collect_results(spec, result, tree)
    for _, test_result in pairs(results) do
      test_result.output = result.output
    end
    return results
  end
  return adapter
end

return M
