# IdeaVim in PyCharm

The tracked [ideavimrc](ideavimrc) is the source for `~/.ideavimrc`. IdeaVim reads that home-directory path; on this Mac it is a symlink to this repository. The rc maps editor keys to PyCharm actions, uses vim-flash, and enables Which-Key.

## Set up a new Mac

1. Install PyCharm and clone this repository to `~/.config/nvim`.
2. Quit PyCharm. Run `scripts/setup-ideavim.sh --dry-run` to inspect what the script will do, then run `scripts/setup-ideavim.sh`. Set `PYCHARM_APP` to the app path if it is not `/Applications/PyCharm.app`.
3. Start PyCharm. The script installs the Marketplace plugins **IdeaVim** (`IdeaVIM`), **vim-flash** (`org.yelog.ideavim.flash`), and **Which-Key** (`eu.theblob42.idea.whichkey`). The rc's `set which-key` enables Which-Key after installation.
4. The rc routes `Ctrl-R` and `Ctrl-D` to PyCharm in every Vim mode. With PyCharm's default macOS keymap, these run and debug the context configuration. They replace IdeaVim's redo and half-page scroll shortcuts.

The script refuses to replace an existing `~/.ideavimrc`. Merge or back up that file first. JetBrains [Backup and Sync](https://www.jetbrains.com/help/idea/sharing-your-ide-settings.html) can also install enabled plugins on a new IDE instance when you sign in and sync settings, but the repository setup script does not depend on an account.

After editing `ideavimrc`, run `:source ~/.ideavimrc` in PyCharm to reload it.

## Run and debug

`Ctrl-R` and `Ctrl-D` use PyCharm's Run and Debug shortcuts, respectively.
`Space r` opens Run Anything: type a configuration name and press Enter to run it.
Hold Shift while choosing it to debug. The top-right Run widget is still useful
when you want to see pinned configurations grouped visually; the older
`Ctrl+Option+R` chooser does not show that grouping as clearly.

During a debug session, `Space db` toggles a line breakpoint, `Space de`
evaluates an expression, `Space dn` steps over to the next line, `Space dc`
runs to the cursor, and `Space dr` resumes to the next breakpoint.

## Editor splits

To move the current file into a new right-hand split without changing `vs`,
use **Find Action** (`Shift+Command+A`) and choose **Split and Move Right**.
The corresponding IdeaVim command is `:action MoveTabRight`.
