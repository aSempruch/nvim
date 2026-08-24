return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    cmd = 'Telescope',
    keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find files' },
      { '<leader>fr', function() require('telescope.builtin').oldfiles() end, desc = 'Recent files' },
      { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Grep in project' },
      { '<leader>fb', function() require('telescope.builtin').buffers() end, desc = 'Buffers' },
      { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Help tags' },
      { '<leader>fd', function() require('telescope.builtin').diagnostics() end, desc = 'Diagnostics' },
      { '<leader>fc', function() require('telescope.builtin').grep_string() end, desc = 'Grep word under cursor' },
      { '<leader>f/', function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Fuzzy find in buffer' },
      { '<leader>fs', function() require('telescope.builtin').lsp_document_symbols() end, desc = 'Document symbols' },
      { '<leader>fw', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, desc = 'Workspace symbols' },
      { '<leader>gl', function() require('telescope.builtin').git_commits() end, desc = 'Git log' },
      { '<leader>gB', function() require('telescope.builtin').git_branches() end, desc = 'Git branches' },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },
}
