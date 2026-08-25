# Keymap Cheatsheet

Leader is `<space>`. Press it and wait — which-key pops up a menu of
everything below, grouped by prefix, so you don't have to memorize this
file. Treat it as a reference, not something to cram.

Built-in Neovim defaults (not redefined in this config) are marked
**[builtin]** — see `:help lsp-defaults` for the full list.

## Basics

**Exiting insert mode:** `<Esc>` is standard. `<C-[>` is identical (same
keycode, closer to home row). The real ninja move is remapping Caps Lock →
Escape at the OS level (macOS: System Settings → Keyboard → Keyboard
Shortcuts → Modifier Keys), since Caps Lock is otherwise useless and sits
right under your pinky. Avoid an insert-mode `jk`/`jj` mapping — it's a
workaround for skipping that remap, and it taxes normal typing.

**Key notation:** `<C-x>` means hold **Ctrl** and press `x` — a real
modifier key, pressed simultaneously (same pattern for `<A-x>`/`<M-x>` =
Alt/Option, `<S-x>` = Shift). `<leader>` is *not* a key — it's a stand-in
for whatever `mapleader` is set to (here, `<space>`), and leader combos are
**sequential**, not chorded: `<leader>ff` means tap Space, release, then
`f`, then `f` — three separate keystrokes. Other common notation from
`:help`: `<CR>` = Enter, `<BS>` = Backspace, `<Tab>`.

## Motion fundamentals

Core vim motions — no plugin required. Everything after this section is
config-specific, built on top of these.

| Keys | Action |
|---|---|
| `h` / `l` | Left / right one character |
| `w` / `b` | Jump to start of next/previous word |
| `e` / `ge` | Jump to end of next/previous word |
| `0` / `^` / `$` | Start of line / first non-blank char / end of line |
| `f{char}` / `F{char}` | Jump to next/previous occurrence of `char` on the line |
| `t{char}` / `T{char}` | Jump to just before/after next/previous occurrence of `char` |
| `;` / `,` | Repeat the last `f`/`t`/`F`/`T`, same / opposite direction |
| `{` / `}` | Jump to previous/next blank-line-separated paragraph |
| `%` | Jump to the matching bracket/brace/paren |
| `/pattern` / `?pattern` | Search forward / backward, `<CR>` to confirm |
| `n` / `N` | Repeat last search, same / opposite direction |
| `*` / `#` | Search forward/backward for the word under the cursor |
| `H` / `M` / `L` | Jump to top/middle/bottom of the *visible screen* (not the file) |
| `zz` / `zt` / `zb` | Recenter the view on the current line (top/middle/bottom) |

See **Jump precisely** below for line-count jumps, scrolling, and
Flash/Harpoon — those build on top of these.

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
| `s` | Flash jump — type 1-2 chars, hit the labeled match (searches the whole visible window, not just the current line — doubles as a no-math vertical jump) |
| `S` | Flash jump to a treesitter node |
| `{count}j` / `{count}k` | Jump exactly N lines down/up — read N off the gutter (`relativenumber` is on) |
| `<C-d>` / `<C-u>` | Scroll half a screen down/up |
| `<C-f>` / `<C-b>` | Scroll a full screen down/up |
| `gg` / `G` | Jump to top/bottom of file |
| `ma` then `` `a `` | Set mark `a` at cursor, then jump back to it later from anywhere |
| `<leader>ha` | Harpoon: pin current file |
| `<leader>h1`..`<leader>h4` | Harpoon: jump straight to pinned file 1-4 |
| `<leader>hh` | Harpoon: open/reorder the pinned list |
| `<C-S-P>` / `<C-S-N>` | Harpoon: previous / next pinned file |

## Jumping in structured text (JSON/YAML/etc.)

| Keys | Action |
|---|---|
| `%` | Jump to the matching bracket/brace/paren — land on `{`, leap to its `}` |
| `[{` / `]}` | Jump out to the enclosing unmatched brace |
| `<leader>fs` | Fuzzy-jump to any key/field in the file (LSP symbols — works in JSON/YAML too) |

No dedicated "next top-level key" motion is set up yet. The idiomatic vim
tool for that is folds (`zj`/`zk` jump to the next/previous fold, `za`
toggles one) with treesitter-based folding — not currently enabled globally
(only Kotlin buffers fold via kotlin.nvim). Ask if you want that wired up.

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
| `yy` / `p` / `P` | Yank line / paste below / paste above |
| `yyp` | Duplicate the current line (yank + paste in one breath) |
| `yaf` then `p` | Duplicate a whole block, e.g. a function (yank around function, paste below) |
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
| `<leader>gm` | Diff current branch against main (fetches first, PR-style) |
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
   thing depending on where you are.) The exact changed word/char within a
   line is already highlighted distinctly (Neovim's default `diffopt`
   includes `inline:char`) — no extra jump needed, just look at the line.
4. Move to the next file in the panel and repeat.
5. `<leader>gc` — close the diff view when done.

Reviewing a whole feature branch against `main` (what GitHub shows you when
you open a PR) works the same way — use `<leader>gm` instead of `<leader>go`.
It fetches `origin/main` first, then diffs against the merge-base of
`origin/main` and `HEAD` (triple-dot), so commits landed on `main` after you
branched — whether or not you'd fetched them yet — don't show up as noise.

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
