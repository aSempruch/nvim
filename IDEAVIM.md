# IdeaVim in PyCharm

The tracked [ideavimrc](ideavimrc) is the source for `~/.ideavimrc`. IdeaVim reads that home-directory path; on this Mac it is a symlink to this repository. The rc maps editor keys to PyCharm actions, uses vim-flash, and enables Which-Key.

## Set up a new Mac

1. Install PyCharm and clone this repository to `~/.config/nvim`.
2. Quit PyCharm. Run `scripts/setup-ideavim.sh --dry-run` to inspect what the script will do, then run `scripts/setup-ideavim.sh`. Set `PYCHARM_APP` to the app path if it is not `/Applications/PyCharm.app`.
3. Start PyCharm. The script installs the Marketplace plugins **IdeaVim** (`IdeaVIM`), **vim-flash** (`org.yelog.ideavim.flash`), and **Which-Key** (`eu.theblob42.idea.whichkey`). The rc's `set which-key` enables Which-Key after installation.
4. In PyCharm's **Settings → Editor → Vim**, assign `Ctrl-D` to Vim for scrolling. This shortcut routing is an IDE setting, not part of the rc.

The script refuses to replace an existing `~/.ideavimrc`. Merge or back up that file first. JetBrains [Backup and Sync](https://www.jetbrains.com/help/idea/sharing-your-ide-settings.html) can also install enabled plugins on a new IDE instance when you sign in and sync settings, but the repository setup script does not depend on an account.

After editing `ideavimrc`, run `:source ~/.ideavimrc` in PyCharm to reload it.
