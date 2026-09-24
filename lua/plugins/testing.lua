local next_failed, previous_failed = require('config.repeatable').pair(
  function() require('neotest').jump.next { status = 'failed' } end,
  function() require('neotest').jump.prev { status = 'failed' } end
)

return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
      'weilbith/neotest-gradle',
    },
    keys = {
      { '<leader>tt', function() require('neotest').run.run() end, desc = 'Run nearest test' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%:p')) end, desc = 'Run test file' },
      { '<leader>ta', function()
        local neotest = require 'neotest'
        neotest.run.run(vim.fn.getcwd())
        neotest.summary.open()
      end, desc = 'Run test suite (working directory)' },
      { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Run last test' },
      { '<leader>ts', function() require('config.buffers').toggle_test_summary() end, desc = 'Toggle test results' },
      { '<leader>to', function() require('neotest').output.open { enter = true } end, desc = 'Show test output' },
      { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Toggle test output panel' },
      { '<leader>tx', function() require('neotest').run.stop() end, desc = 'Stop test' },
      { ']t', next_failed, desc = 'Next failed test' },
      { '[t', previous_failed, desc = 'Previous failed test' },
    },
    opts = function()
      return {
        output = { open_on_run = false },
        consumers = { refresh_output = require('config.test_output').consumer },
        adapters = {
          -- Detect the project's virtualenv and prefer pytest when installed;
          -- fall back to unittest without changing the project's dependencies.
          require('config.python_tests').adapter(),
          -- Java/Kotlin JUnit tests run through the project's Gradle build.
          require('config.gradle_tests').adapter(),
        },
      }
    end,
    config = function(_, opts)
      local neotest = require 'neotest'
      neotest.setup(opts)
      require('config.test_output').setup(neotest)
    end,
  },
}
