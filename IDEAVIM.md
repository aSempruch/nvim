# IdeaVim in PyCharm

The tracked [ideavimrc](ideavimrc) is the source for `~/.ideavimrc`. IdeaVim reads that home-directory path; on this Mac it is a symlink to this repository. The rc maps editor keys to PyCharm actions, uses vim-flash, and enables Which-Key.

## Set up a new Mac

1. Install PyCharm and clone this repository to `~/.config/nvim`.
2. Quit PyCharm. Run `scripts/setup-ideavim.sh --dry-run` to inspect what the script will do, then run `scripts/setup-ideavim.sh`. Set `PYCHARM_APP` to the app path if it is not `/Applications/PyCharm.app`.
3. Start PyCharm. The script installs the Marketplace plugins **IdeaVim** (`IdeaVIM`), **vim-flash** (`org.yelog.ideavim.flash`), and **Which-Key** (`eu.theblob42.idea.whichkey`). The rc's `set which-key` enables Which-Key after installation.
4. `Ctrl-D` is routed to Vim for half-page scrolling in normal mode. Run and Debug use the Space mappings below.

The script refuses to replace an existing `~/.ideavimrc`. Merge or back up that file first. JetBrains [Backup and Sync](https://www.jetbrains.com/help/idea/sharing-your-ide-settings.html) can also install enabled plugins on a new IDE instance when you sign in and sync settings, but the repository setup script does not depend on an account.

After editing `ideavimrc`, run `:source ~/.ideavimrc` in PyCharm to reload it.
All Space leader shortcuts use `map`, covering normal, visual, select, and
operator-pending modes. The mappings invoke
the IDE action directly, keeping the selection available to actions such as Evaluate Expression.
The rc disables the key-sequence timeout, so an unfinished Space mapping waits
for the next key or Escape.
Which-Key labels use Nerd Font glyphs alongside text. The rc sets the
popup font to `JetBrainsMono Nerd Font`, which must be installed on a new Mac.
The installed plugin does not show IntelliJ action icons directly.

`Space fs` opens PyCharm's Find Symbol search (classes, methods, fields, and other symbols).
`Space fc` opens Find Class.

## Run and debug

`Space rr` runs the selected configuration and `Space dd` starts it in the debugger.
`Space rs` opens PyCharm's Run configuration chooser, which lists configurations
immediately. The top-right Run widget groups pinned configurations more clearly,
but no editor-invokable action was verified to open that pinned presentation.
`Space ra` opens Run Anything for typed searches.

During a debug session, `Space db` toggles a line breakpoint, `Space de`
evaluates an expression, `Space dn` steps over, `Space di` steps into, and
`Space do` steps out. `Space dc` runs to the cursor, and `Space dr` resumes to
the next breakpoint.

## Tool windows

From normal or visual mode in the editor, use `Space w` followed by:

| Key | Focus |
| --- | --- |
| `f` | Project files (Command-1) |
| `r` | Run |
| `d` | Debug |
| `t` | Terminal |
| `g` | Version control |
| `s` | Structure |

These activate PyCharm tool windows; they do not start a run or debug session.

## Editor splits

To move the current file into a new right-hand split without changing `vs`,
use **Find Action** (`Shift+Command+A`) and choose **Split and Move Right**.
The corresponding IdeaVim command is `:action MoveTabRight`.
