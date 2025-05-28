#!/bin/zsh

set -e

local file
local -a exclude_dirs
local exclude_args=""

exclude_dirs=(
  .git
  public
  node_modules
  .ssh
  .npm
  .cache
  .local
)

for dir in $exclude_dirs; do
  exclude_args+=" --exclude $dir"
done

file=$(eval "fd --type f $exclude_args" | fzf) || return

[ -n "$file" ] && nvim "$file""$TMUX_PATH/scripts/vim-fzf-popup.sh"
