-- nvim-treesitter's aggregator repo (parser install + this Lua API) was
-- archived by its maintainer in April 2026 after finishing a full,
-- from-scratch rewrite targeting Neovim 0.12+. "Archived" means read-only
-- (no more commits, no issue tracker) -- it still clones and works exactly
-- as it does today, which is fine since we're pinned to 0.12 anyway. It
-- just means no future parser/grammar fixes land upstream. The two
-- downstream plugins below (-textobjects, -context) already ported to the
-- new API and are still actively maintained independently.
-- NB: 'gitcommit' is deliberately left out. Its generated parser.c is huge
-- and reliably OOM-kills `cc` on machines with less than ~4GB free RAM; add
-- it back yourself (`require('nvim-treesitter').install{'gitcommit'}`) if
-- yours can handle it.
local parsers = {
  'kotlin', 'java', 'groovy',
  'typescript', 'tsx', 'javascript', 'json', 'html', 'css',
  'yaml', 'bash', 'dockerfile', 'diff',
  'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        group = vim.api.nvim_create_augroup('config-treesitter-highlight', { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  {
    -- Structural text objects, e.g. `daf` (delete a function), `vic`
    -- (select inside a class) -- this is most of the "jump/act on code
    -- structure, not lines" muscle memory from an IDE.
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    -- Skip the plugin's own ftplugin-based default maps; we define ours below.
    init = function() vim.g.no_plugin_maps = true end,
    config = function()
      require('nvim-treesitter-textobjects').setup { select = { lookahead = true } }

      local select_mod = require 'nvim-treesitter-textobjects.select'
      local move_mod = require 'nvim-treesitter-textobjects.move'
      local select = function(obj) return function() select_mod.select_textobject(obj, 'textobjects') end end
      local map = vim.keymap.set

      map({ 'x', 'o' }, 'af', select '@function.outer', { desc = 'Select around function' })
      map({ 'x', 'o' }, 'if', select '@function.inner', { desc = 'Select inside function' })
      map({ 'x', 'o' }, 'ac', select '@class.outer', { desc = 'Select around class' })
      map({ 'x', 'o' }, 'ic', select '@class.inner', { desc = 'Select inside class' })
      map({ 'x', 'o' }, 'aa', select '@parameter.outer', { desc = 'Select around parameter/argument' })
      map({ 'x', 'o' }, 'ia', select '@parameter.inner', { desc = 'Select inside parameter/argument' })

      -- ]f / [f jump to the next/previous function start -- deliberately
      -- not ]c/[c, since gitsigns owns that pair for hunk navigation.
      map('n', ']f', function() move_mod.goto_next_start('@function.outer', 'textobjects') end, { desc = 'Next function' })
      map('n', '[f', function() move_mod.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'Previous function' })
    end,
  },

  {
    -- Pins the enclosing function/class signature to the top of the
    -- window as you scroll -- the same idea as IntelliJ's sticky lines.
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    opts = { max_lines = 3 },
    keys = {
      { '<leader>ut', function() require('treesitter-context').toggle() end, desc = 'Toggle sticky context' },
    },
  },
}
