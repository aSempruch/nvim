return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    event = 'InsertEnter',
    opts = {
      keymap = { preset = 'default' }, -- <C-y> accept, <C-n>/<C-p> or <Up>/<Down> select, see :help blink-cmp-config-keymap
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        menu = { auto_show = true },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      signature = { enabled = true },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    },
  },
}
