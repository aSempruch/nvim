#!/usr/bin/env bash
set -euo pipefail

if [[ ${1:-} != "" && ${1:-} != "--dry-run" ]]; then
  printf 'Usage: %s [--dry-run]\n' "$0" >&2
  exit 2
fi

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_rc="$repo_dir/ideavimrc"
home_rc="$HOME/.ideavimrc"
pycharm_app="${PYCHARM_APP:-/Applications/PyCharm.app}"
plugin_ids=(IdeaVIM org.yelog.ideavim.flash eu.theblob42.idea.whichkey)

if [[ ! -f "$source_rc" ]]; then
  printf 'Missing IdeaVim config: %s\n' "$source_rc" >&2
  exit 1
fi
if [[ ! -d "$pycharm_app" ]]; then
  printf 'PyCharm app not found: %s (set PYCHARM_APP to its path)\n' "$pycharm_app" >&2
  exit 1
fi
if [[ -e "$home_rc" || -L "$home_rc" ]] && { [[ ! -L "$home_rc" ]] || [[ ! "$home_rc" -ef "$source_rc" ]]; }; then
  printf 'Refusing to replace existing %s; back it up or merge it first.\n' "$home_rc" >&2
  exit 1
fi

if [[ ${1:-} == "--dry-run" ]]; then
  printf 'Would link %s -> %s (if needed)\n' "$home_rc" "$source_rc"
  printf 'Would install PyCharm plugins: %s\n' "${plugin_ids[*]}"
  exit 0
fi

if [[ ! -L "$home_rc" ]]; then
  ln -s "$source_rc" "$home_rc"
fi

printf 'Installing IdeaVim, vim-flash, and Which-Key into %s\n' "$pycharm_app"
open -W -na "$pycharm_app" --args installPlugins "${plugin_ids[@]}"
printf 'Start PyCharm and reload ~/.ideavimrc after installation.\n'
