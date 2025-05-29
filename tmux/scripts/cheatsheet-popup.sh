#!/bin/zsh

local file
local -a exclude_dirs
local exclude_args=""
local dir=~/notes/cheatsheets

file=$(fd . "$dir" --type f | sed "s|^$dir/||" | fzf --tmux bottom,30,12 --style full) || exit 0

if [ -n "$file" ]; then
  local file_path="$dir/$file"
  tmux popup -E -w 65 -h 80% -x C -y C -T " Cheatsheet: $(basename "$file" | cut -d. -f1) " -- \
    zsh -c "bat --style=numbers,grid --paging=always \"$file_path\""
fi
