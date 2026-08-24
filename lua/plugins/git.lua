return {
  {
    -- Inline gutter signs for added/changed/deleted lines, hunk stage/reset,
    -- and blame -- this is IntelliJ's "changed lines in the gutter" gadget.
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local map = function(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(gs.next_hunk)
          return '<Ignore>'
        end, 'Next hunk')
        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(gs.prev_hunk)
          return '<Ignore>'
        end, 'Previous hunk')

        map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
        map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Stage hunk')
        map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Reset hunk')
        map('n', '<leader>gS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>gR', gs.reset_buffer, 'Reset buffer')
        map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>gb', function() gs.blame_line { full = true } end, 'Blame line')
      end,
    },
  },

  {
    -- Full-tapbage diff/history browser -- this is IntelliJ's "Compare
    -- with Branch" and "Show History for Selection", in one plugin.
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
    keys = {
      { '<leader>go', '<cmd>DiffviewOpen<CR>', desc = 'Diff against HEAD' },
      { '<leader>gc', '<cmd>DiffviewClose<CR>', desc = 'Close diffview' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'File history (current file)' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<CR>', desc = 'File history (whole repo)' },
    },
    opts = {},
  },
}
