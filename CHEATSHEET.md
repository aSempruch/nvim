# Keymap Cheatsheet

Leader is `<space>`. Press it and wait — which-key pops up a menu of
everything below, grouped by prefix, so you don't have to memorize this
file. Treat it as a reference, not something to cram.

Built-in Neovim defaults (not redefined in this config) are marked
**[builtin]** — see `:help lsp-defaults` for the full list.

## Find & navigate (Telescope) — `<leader>f`

| Keys | Action |
|---|---|
| `<leader>ff` | Find files by name |
| `<leader>fg` | Live grep across the project |
| `<leader>fc` | Grep word under cursor |
| `<leader>f/` | Fuzzy find inside current buffer |
| `<leader>fr` | Recently opened files |
| `<leader>fb` | Switch buffers |
| `<leader>fh` | Help tags |
| `<leader>fd` | Diagnostics (picker) |
| `<leader>fs` | Symbols in current file |
| `<leader>fw` | Symbols across the whole project |

Inside any picker: type to filter, `<C-n>`/`<C-p>` (or arrows) to move,
`<Enter>` to open, `<C-v>`/`<C-x>` to open in a vsplit/split, `<Esc>` to cancel.

## Jump precisely

| Keys | Action |
|---|---|
| `s` | Flash jump — type 1-2 chars, hit the labeled match |
| `S` | Flash jump to a treesitter node |
| `<leader>ha` | Harpoon: pin current file |
| `<leader>h1`..`<leader>h4` | Harpoon: jump straight to pinned file 1-4 |
| `<leader>hh` | Harpoon: open/reorder the pinned list |
| `<C-S-P>` / `<C-S-N>` | Harpoon: previous / next pinned file |

## LSP — mostly builtin

| Keys | Action |
|---|---|
| `gd` | Goto definition (custom — plain `gd` is vim's local-decl) |
| `gri` **[builtin]** | Goto implementation |
| `grr` **[builtin]** | References |
| `grt` **[builtin]** | Type definition |
| `grn` **[builtin]** | Rename |
| `gra` **[builtin]** | Code action |
| `gO` **[builtin]** | Document symbols |
| `K` **[builtin]** | Hover |
| `]d` / `[d` **[builtin]** | Next / previous diagnostic |
| `<leader>e` | Diagnostic float under cursor |
| `<leader>ui` | Toggle inlay hints |

## Code structure (treesitter textobjects)

| Keys | Action |
|---|---|
| `af` / `if` | Around / inside function |
| `ac` / `ic` | Around / inside class |
| `aa` / `ia` | Around / inside parameter |
| `]f` / `[f` | Next / previous function start |
| `<leader>ut` | Toggle sticky scroll context |

Use like any text object: `daf` deletes a function, `vic` selects inside a class, etc.

## Editing

| Keys | Action |
|---|---|
| `ys{motion}{char}` | Add surrounding pair |
| `ds{char}` | Delete surrounding pair |
| `cs{char1}{char2}` | Change surrounding pair |
| `<A-j>` / `<A-k>` | Move line (or visual selection) down/up |
| `<leader>p` (visual) | Paste over selection without clobbering register |
| `<leader>cf` | Format buffer |

## Git

| Keys | Action |
|---|---|
| `]c` / `[c` | Next / previous hunk |
| `<leader>gs` / `<leader>gr` | Stage / reset hunk (works on visual selection too) |
| `<leader>gS` / `<leader>gR` | Stage / reset whole buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>go` | Diff current file against HEAD |
| `<leader>gh` | File history (current file) |
| `<leader>gH` | File history (whole repo) |
| `<leader>gl` | Git log (picker) |
| `<leader>gB` | Git branches (picker) |

**Reviewing changes, IntelliJ-diff-viewer style:**

1. `<leader>go` — opens Diffview against HEAD: a file-tree panel of every
   changed file, plus a real side-by-side diff pane.
2. Pick a file in the panel to load its diff.
3. `]c` / `[c` — step hunk-by-hunk through that file. (Same two keys as the
   gutter navigation above — inside a diff view they fall back to vim's
   native diff-hunk jump instead of gitsigns, so it just does the right
   thing depending on where you are.)
4. Move to the next file in the panel and repeat.
5. `<leader>gc` — close the diff view when done.

For a quick one-off check without leaving your normal editing flow, skip
Diffview entirely: `]c`/`[c` to jump to a hunk in the buffer you're in, then
`<leader>gp` to preview it inline, `<leader>gs`/`<leader>gr` to stage/reset it.

## Diagnostics / outline (Trouble)

| Keys | Action |
|---|---|
| `<leader>xx` | Diagnostics — whole workspace |
| `<leader>xX` | Diagnostics — current buffer |
| `<leader>cs` | Symbols outline |
| `<leader>cl` | LSP references/definitions panel |
| `<leader>xL` / `<leader>xQ` | Location list / quickfix list |

## Files

| Keys | Action |
|---|---|
| `-` | Open parent directory in oil.nvim (edit the filesystem as text) |

## Kotlin (only active in `.kt` buffers)

| Keys | Action |
|---|---|
| `<leader>ko` | Organize imports |
| `<leader>kf` | Format (IntelliJ rules, via kotlin-lsp) |
| `<leader>ks` | Document outline |
| `<leader>kw` | Workspace symbols |
| `<leader>kt` | Type definition |
| `<leader>kc` | Code actions |
| `<leader>kh` / `<leader>kH` | Incoming / outgoing calls |
| `<leader>kn` | New file from template |

## Windows / misc

| Keys | Action |
|---|---|
| `<C-h/j/k/l>` | Move focus between splits |
| `<Esc><Esc>` (terminal mode) | Exit terminal mode |
| `<Esc>` | Clear search highlight |
