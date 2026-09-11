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

      -- `;` / `,` repeat the last move, whatever it was: the ]f/[f above,
      -- gitsigns' ]c/[c hunk jumps, diffview/Octo's ]q/[q next-file, and
      -- plain f/F/t/T (which must be re-mapped so the module sees them).
      -- See config/repeatable.lua for wrapping other motions.
      local rm = require 'nvim-treesitter-textobjects.repeatable_move'
      map({ 'n', 'x', 'o' }, ';', rm.repeat_last_move_next, { desc = 'Repeat last move forward' })
      map({ 'n', 'x', 'o' }, ',', rm.repeat_last_move_previous, { desc = 'Repeat last move backward' })

      -- Native structural motions do not register themselves with the
      -- repeatable-move module. Route every forward/backward navigation pair
      -- through it while preserving Vim's built-in motion and count handling.
      local function native_motion(key)
        return function() vim.cmd.normal { vim.v.count1 .. key, bang = true } end
      end
      local function map_native_pair(next_key, prev_key, target)
        local next_motion, prev_motion = require('config.repeatable').pair(
          native_motion(next_key), native_motion(prev_key))
        map('n', next_key, next_motion, { desc = 'Next ' .. target })
        map('n', prev_key, prev_motion, { desc = 'Previous ' .. target })
      end

      map_native_pair('}', '{', 'paragraph')
      map_native_pair(']]', '[[', 'section start')
      map_native_pair('][', '[]', 'section end')
      map_native_pair("]'", "['", 'line mark')
      map_native_pair(']`', '[`', 'mark')
      map_native_pair('])', '[(', 'unmatched parenthesis')
      map_native_pair(']}', '[{', 'unmatched brace')
      map_native_pair(']m', '[m', 'method start')
      map_native_pair(']M', '[M', 'method end')
      map_native_pair(']#', '[#', 'preprocessor conditional')
      map_native_pair(']*', '[*', 'C comment boundary')
      map_native_pair(']/', '[/', 'C comment boundary')
      map_native_pair(']s', '[s', 'misspelling')
      map_native_pair(']z', '[z', 'open fold boundary')
      map_native_pair(']c', '[c', 'diff change')

      -- Neovim supplies these directional bracket mappings as Lua callbacks.
      -- Preserve those callbacks so plugin-free buffers participate too;
      -- buffer-local plugin mappings can still override them where needed.
      local function map_existing_pair(next_key, prev_key)
        local next_map = vim.fn.maparg(next_key, 'n', false, true)
        local prev_map = vim.fn.maparg(prev_key, 'n', false, true)
        if type(next_map.callback) ~= 'function' or type(prev_map.callback) ~= 'function' then return end

        local next_motion, prev_motion = require('config.repeatable').pair(next_map.callback, prev_map.callback)
        map('n', next_key, next_motion, { desc = next_map.desc })
        map('n', prev_key, prev_motion, { desc = prev_map.desc })
      end

      map_existing_pair(']b', '[b')
      map_existing_pair(']q', '[q')
      map_existing_pair(']l', '[l')
      map_existing_pair(']a', '[a')
      map_existing_pair(']t', '[t')
      map_existing_pair(']d', '[d')
      map_existing_pair(']<C-Q>', '[<C-Q>')
      map_existing_pair(']<C-L>', '[<C-L>')
      map_existing_pair(']<C-T>', '[<C-T>')

      map({ 'n', 'x', 'o' }, 'f', rm.builtin_f_expr, { expr = true })
      map({ 'n', 'x', 'o' }, 'F', rm.builtin_F_expr, { expr = true })
      map({ 'n', 'x', 'o' }, 't', rm.builtin_t_expr, { expr = true })
      map({ 'n', 'x', 'o' }, 'T', rm.builtin_T_expr, { expr = true })
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
