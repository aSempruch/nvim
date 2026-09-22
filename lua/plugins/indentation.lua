return {
  'NMAC427/guess-indent.nvim',
  opts = {
    -- Explicit project conventions take precedence over a buffer guess.
    override_editorconfig = false,
    on_tab_options = {
      expandtab = false,
      shiftwidth = 0,
      softtabstop = 0,
    },
  },
}
