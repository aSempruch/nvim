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
| `<leader>gi` | List GitHub PRs (Octo) |
| `<leader>gv` | Open the PR for the current branch (Octo) |
| `<leader>gw` | (in an Octo PR buffer) Checkout PR into a `/tmp` worktree + start/resume review |

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

**Reviewing a GitHub PR (Octo + Diffview):**

Octo handles the GitHub side (listing PRs, checkout, posting reviews);
Diffview stays the tool for actually walking the diff, since it's the
richer diff UX and its `gf` opens real file buffers (LSP works). Auth is
your existing `gh` CLI login, no separate token needed.

1. `<leader>gi` — list open PRs.
2. `<C-o>` (in that picker) — checks out the highlighted PR's branch. (Or
   `<leader>gv` if you're already on the PR's branch and just want its
   Octo buffer — description, timeline, comments.)
3. `<leader>gm` — Diffview against `main`, PR-style (see above). Since
   you're now on the PR's branch, this is exactly the PR's diff.
4. `]c` / `[c` to step hunk-by-hunk, same as any other Diffview session.
5. To dig deeper on any line: `gf` opens the real file at that line in a
   normal buffer (your previous tabpage) — `gd`, `K`, etc. all work since
   it's a genuine file buffer, not a diff-pane object. `<C-w><C-f>` /
   `<C-w>gf` do the same in a split/new tab if you want the diff to stay
   visible.

To leave inline comments or submit an approval/request-changes instead of
just reading, use Octo's own review flow on that same checked-out branch:
`:Octo review start` opens Octo's comment-capable diff, `:Octo review
comment` on a line adds a comment, `:Octo review submit` posts it. Inside
that diff, `gf` opens the real file in a new tab (overridden from Octo's
default of `:edit`-ing it in the diff pane itself) so the review layout
stays intact behind it.

No pane-switching needed to move between files -- from the diff pane
itself: `]q`/`[q` next/previous changed file, `]Q`/`[Q` first/last,
`]u`/`[u` next/previous *unviewed* file (skips ones already marked
viewed). `<localleader>e` (`<space>e`) jumps focus into the file panel
instead if you'd rather browse visually.

**Same thing, but without touching this repo's checkout:**

`<leader>gw` from inside an Octo PR buffer (`<CR>` on a PR in `<leader>gi`'s
list first) does the checkout + review above, but into an isolated
worktree under `/tmp/octo-worktrees/<repo>-pr-<n>` instead of switching
branches here. It opens a new tab, `:tcd`s into the worktree, and lands you
straight in the review for it -- resuming a pending review you already
started on that PR if one exists, starting fresh otherwise. Since a git
worktree checkout never touches your current branch, this is the one to
use when you're mid-work on something else and just want to review a
colleague's PR.
Worktrees aren't auto-cleaned; `git worktree remove <path>` if it ever
piles up.

**Quick look at a PR diff with zero local git changes (no fetch, no
checkout):**

1. `<leader>gi` — list PRs.
2. `<CR>` on a PR (not `<C-o>`) — opens its Octo buffer via the GitHub API
   only; nothing local changes.
3. `<localleader>pd` (`<space>pd`) — dumps the full unified diff as a
   read-only scratch buffer, straight from `gh api .../pulls/<n>` (same
   thing as `gh pr diff <n>` in a terminal).

This is a flat diff buffer — no file-tree panel, no `]c`/`[c` hunk nav, no
`gf` (there's no real checked-out file to jump to). `<localleader>pf`
("list PR changed files") looks tempting for the same goal but don't use it
without checking out first — selecting a file there runs `:edit <file>`
against your *current* working tree, so without a checkout it silently
opens your own branch's version of that file, not the PR's.

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
